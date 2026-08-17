#!/usr/bin/env bash
set -euo pipefail

# Cross-validate ssh_config against the docker-compose.yml SSH port mappings.
#
# Invariant 1 (no missing or stale entries): the set of host ports mapped to
# container port 22 across all docker-compose.yml files must equal the set of
# Port directives in ssh_config/config. Host ports are globally unique
# (check_ssh_ports.sh), so set equality is a sound invariant. Missing = an
# environment has no reachable alias; stale = an entry points at a port no
# environment listens on.
#
# Invariant 2 (no cross-wired aliases): a Port value may appear under at most
# one Host in ssh_config. Two Hosts sharing a port means one alias silently
# connects to the wrong environment (observed: dqd-docker-v19.03.13 pointed at
# cve-2020-15257's port 19317). Set equality cannot catch this — sets ignore
# duplicates — so it is checked separately.
#
# SKIP_SSH_CONFIG in an .env governs entry *generation* only; any environment
# that maps container port 22 must still be reachable through ssh_config.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(dirname "$script_dir")"
ssh_config="$project_dir/ssh_config/config"

if [ ! -f "$ssh_config" ]; then
    echo "ssh_config not found: $ssh_config" >&2
    exit 1
fi

compose_pairs="$(mktemp -t dqd-compose-ssh-ports.XXXXXX)"
ssh_pairs="$(mktemp -t dqd-sshcfg-ports.XXXXXX)"
trap 'rm -f "$compose_pairs" "$ssh_pairs"' EXIT

# Collect "<port>\t<rel_dir> (<image>)" for every ":22" mapping in every
# docker-compose.yml.
while IFS= read -r compose_file; do
    dir="$(dirname "$compose_file")"
    rel_dir="${dir#$project_dir/}"
    env_file="$dir/.env"
    image="unknown"

    if [ -f "$env_file" ]; then
        image="$(sed -n 's/^IMAGE=//p' "$env_file" | head -n1 | tr -d '"')"
        image="${image:-unknown}"
    fi

    while IFS= read -r port; do
        [ -n "$port" ] || continue
        printf '%s\t%s (%s)\n' "$port" "$rel_dir" "$image" >> "$compose_pairs"
    done < <(sed -nE 's/^[[:space:]]*-[[:space:]]*"?([0-9]+):22"?[[:space:]]*(#.*)?$/\1/p' "$compose_file")
done < <(find "$project_dir" -type f -name docker-compose.yml -not -path "$project_dir/.git/*" | sort)

# Collect "<port>\t<host>" from ssh_config, tracking the current Host block.
# The default "Host dqd-*" block declares no Port, so it contributes nothing.
awk '
/^[[:space:]]*Host[[:space:]]+/ { host = $2; next }
/^[[:space:]]*Port[[:space:]]+[0-9]+[[:space:]]*$/ { print $2 "\t" host }
' "$ssh_config" >> "$ssh_pairs"

if [ ! -s "$compose_pairs" ] || [ ! -s "$ssh_pairs" ]; then
    echo "No SSH port mappings found in compose files or ssh_config." >&2
    exit 1
fi

failed=0

# Invariant 2: duplicate Port across Hosts.
while IFS= read -r port; do
    [ -n "$port" ] || continue
    hosts="$(awk -F '\t' -v p="$port" '$1 == p {print "  - " $2}' "$ssh_pairs" | sort)"
    echo "duplicate ssh_config Port $port claimed by multiple Hosts:" >&2
    printf '%s\n' "$hosts" >&2
    failed=1
done < <(cut -f1 "$ssh_pairs" | sort | uniq -d)

# Invariant 1: port sets must match exactly.
while IFS= read -r port; do
    [ -n "$port" ] || continue
    owners="$(awk -F '\t' -v p="$port" '$1 == p {print "  - " $2}' "$compose_pairs")"
    echo "port $port is mapped to :22 in docker-compose.yml but has no ssh_config entry:" >&2
    printf '%s\n' "$owners" >&2
    failed=1
done < <(comm -23 <(cut -f1 "$compose_pairs" | sort -u) <(cut -f1 "$ssh_pairs" | sort -u))

while IFS= read -r port; do
    [ -n "$port" ] || continue
    hosts="$(awk -F '\t' -v p="$port" '$1 == p {print "  - " $2}' "$ssh_pairs")"
    echo "ssh_config Port $port is stale: no docker-compose.yml maps it to :22" >&2
    printf '%s\n' "$hosts" >&2
    failed=1
done < <(comm -13 <(cut -f1 "$compose_pairs" | sort -u) <(cut -f1 "$ssh_pairs" | sort -u))

if [ "$failed" -ne 0 ]; then
    exit 1
fi

count="$(cut -f1 "$ssh_pairs" | sort -u | wc -l | tr -d ' ')"
echo "OK: ssh_config is consistent with docker-compose.yml SSH mappings ($count ports)."
