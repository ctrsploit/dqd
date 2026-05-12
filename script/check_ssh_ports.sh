#!/usr/bin/env bash
set -euo pipefail

# Check that every docker-compose.yml short-form SSH mapping uses a unique host port.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(dirname "$script_dir")"
ports_file="$(mktemp -t dqd-ssh-ports.XXXXXX)"

trap 'rm -f "$ports_file"' EXIT

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
        printf '%s\t%s\t%s\n' "$port" "$rel_dir" "$image" >> "$ports_file"
    done < <(sed -nE 's/^[[:space:]]*-[[:space:]]*"?([0-9]+):22"?[[:space:]]*(#.*)?$/\1/p' "$compose_file")
done < <(find "$project_dir" -type f -name docker-compose.yml -not -path "$project_dir/.git/*" | sort)

if [ ! -s "$ports_file" ]; then
    echo "No SSH host port mappings found." >&2
    exit 1
fi

if ! sort -n "$ports_file" | awk -F '\t' '
function flush_group() {
    if (count > 1) {
        print "duplicate SSH host port " port ":" > "/dev/stderr"
        printf "%s", entries > "/dev/stderr"
        failed = 1
    }
}

BEGIN {
    port = ""
    count = 0
    entries = ""
    failed = 0
}

{
    if (port != "" && $1 != port) {
        flush_group()
        count = 0
        entries = ""
    }

    port = $1
    count++
    entries = entries sprintf("  - %s (%s)\n", $2, $3)
}

END {
    if (port != "") {
        flush_group()
    }
    exit failed
}
'; then
    exit 1
fi

count="$(wc -l < "$ports_file" | tr -d ' ')"
echo "OK: checked $count SSH host port mapping(s); all ports are unique."
