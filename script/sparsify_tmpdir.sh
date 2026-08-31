#!/usr/bin/env bash
# Pick a host filesystem with enough free space for virt-sparsify's temporary
# overlay and print a fresh temp directory on it (stdout).
#
# virt-sparsify copy mode ("virt-sparsify --compress in out") zeroes the
# guest's free space through a qcow2 overlay it creates in TMPDIR. The zero
# writes are not compacted, so the overlay transiently grows to roughly the
# guest's free space (~SIZE). When /tmp is too small the appliance hits ENOSPC
# and dies with:
#   virt-sparsify: error: exception: End_of_file
# (observed on GitHub-hosted runners: "Max needed: 10.0G.  Free: 10.0G.").
#
# Selection: the widest non-tmpfs filesystem among TMPDIR (if set), /mnt,
# /var/tmp, /tmp and the current directory. Requirement: SIZE + 1G headroom —
# virt-sparsify adds its own slack on top of the virtual size, and the
# container unpacks its appliance in the same directory.
#
# Usage: sparsify_tmpdir.sh <SIZE>    (SIZE syntax as in <ENV>/.env, e.g. 10G)
# Prints the created directory on stdout. Exits 1 with a per-filesystem
# free-space report when nothing fits.

set -euo pipefail

size_arg="${1:?usage: sparsify_tmpdir.sh <SIZE> (e.g. 10G)}"
headroom_kb=$((1024 * 1024))  # 1G

size_kb() {
    local n="${1%[gGmMkK]}" u="${1: -1}"
    case "$u" in
        [gG]) echo $((n * 1048576)) ;;
        [mM]) echo $((n * 1024)) ;;
        [kK]) echo "$n" ;;
        *)    return 1 ;;
    esac
}

base_kb="$(size_kb "$size_arg")" || {
    echo "error: unparsable SIZE '$size_arg' (expected e.g. 10G, 512M)" >&2
    exit 1
}
need_kb=$((base_kb + headroom_kb))

candidates=()
[ -n "${TMPDIR:-}" ] && candidates+=("$TMPDIR")
candidates+=(/mnt /var/tmp /tmp "$PWD")

best="" best_kb=0
report=()
declare -A seen_fs=()
for dir in "${candidates[@]}"; do
    # skip missing or unwritable candidates (e.g. root-owned /mnt on dev boxes)
    if [ ! -d "$dir" ] || [ ! -w "$dir" ]; then continue; fi
    # NB: -P/-T are mutually exclusive with --output; fstype comes via --output
    row="$(df --output=source,fstype,avail,target "$dir" 2>/dev/null | tail -n1)"
    # skip candidates df could not report (non-zero rc is masked by the pipe)
    [ "$(wc -w <<<"$row")" -ge 4 ] || continue
    fs="$(awk '{print $1}' <<<"$row")"
    fstype="$(awk '{print $2}' <<<"$row")"
    avail_kb="$(awk '{print $3}' <<<"$row")"
    case "$fstype" in
        tmpfs|devtmpfs|squashfs|overlay) continue ;;  # RAM-backed or pseudo
    esac
    # same filesystem reached via an earlier path: first path wins
    if [ -n "${seen_fs[$fs]:-}" ]; then continue; fi
    seen_fs[$fs]=1
    report+=("  $dir ($fstype): $((avail_kb / 1024))M free")
    if (( avail_kb > best_kb )); then
        best_kb=$avail_kb
        best="$dir"
    fi
done

if [ -z "$best" ] || (( best_kb < need_kb )); then
    echo "error: no filesystem with >= $((need_kb / 1024))M free for the virt-sparsify temp overlay (SIZE=$size_arg + 1G headroom). Candidates:" >&2
    if [ ${#report[@]} -gt 0 ]; then printf '%s\n' "${report[@]}" >&2; fi
    exit 1
fi

mktemp -d "${best%/}/sparsify-tmp.XXXXXX"
