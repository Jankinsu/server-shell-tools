#!/usr/bin/env bash

# Keep this script safe for interactive shell startup: a non-critical failure
# must not prevent the user from getting a prompt.
set -u

CONFIG_FILE="${HOME:-}/.config/xm-server/node.conf"

NODE_ID="XM / NODE-00"
NODE_NAME="$(hostname 2>/dev/null || printf '%s' 'Unknown')"

if [ -r "$CONFIG_FILE" ]; then
    # shellcheck disable=SC1090
    . "$CONFIG_FILE"
fi

NODE_ID="${NODE_ID:-XM / NODE-00}"
NODE_NAME="${NODE_NAME:-$(hostname 2>/dev/null || printf '%s' 'Unknown')}"
HOST_NAME="$(hostname 2>/dev/null || printf '%s' 'Unknown')"

SYSTEM_NAME="Unknown"
if [ -r /etc/os-release ]; then
    . /etc/os-release
    SYSTEM_NAME="${PRETTY_NAME:-${NAME:-Unknown}}"
fi

KERNEL="$(uname -sr 2>/dev/null || printf '%s' 'Unknown')"

UPTIME="Unknown"
if command -v uptime >/dev/null 2>&1; then
    UPTIME="$(uptime -p 2>/dev/null || true)"
fi
if [ -z "$UPTIME" ] && [ -r /proc/uptime ]; then
    UPTIME_SECONDS="$(awk '{printf "%d", $1}' /proc/uptime 2>/dev/null || true)"
    if [ -n "${UPTIME_SECONDS:-}" ]; then
        UPTIME="${UPTIME_SECONDS}s"
    fi
fi
UPTIME="${UPTIME:-Unknown}"

LOAD="Unknown"
if [ -r /proc/loadavg ]; then
    LOAD="$(awk '{print $1 "  " $2 "  " $3}' /proc/loadavg 2>/dev/null || true)"
fi
LOAD="${LOAD:-Unknown}"

PUBLIC_IPV4="Unavailable"
PUBLIC_IPV6="Unavailable"
if command -v curl >/dev/null 2>&1; then
    PUBLIC_IPV4="$(curl -4 -fsS --connect-timeout 2 --max-time 2 https://api.ipify.org 2>/dev/null || true)"
    PUBLIC_IPV6="$(curl -6 -fsS --connect-timeout 2 --max-time 2 https://api6.ipify.org 2>/dev/null || true)"
fi
PUBLIC_IPV4="${PUBLIC_IPV4:-Unavailable}"
PUBLIC_IPV6="${PUBLIC_IPV6:-Unavailable}"

printf '\n'
printf '  \\   /\n'
printf '   \\ /\n'
printf '    X\n'
printf '   / \\\n'
printf '  /\\ /\\\n'
printf '\n'
printf '  XIAO MO\n'
printf '%s\n' '-- SERVER NODE --'
printf '\n'
printf '  %-12s %s\n' 'Host' "$HOST_NAME"
printf '  %-12s %s\n' 'Node' "$NODE_NAME"
printf '  %-12s %s\n' 'System' "$SYSTEM_NAME"
printf '  %-12s %s\n' 'Kernel' "$KERNEL"
printf '  %-12s %s\n' 'Uptime' "$UPTIME"
printf '  %-12s %s\n' 'Load' "$LOAD"
printf '  %-12s %s\n' 'Public IPv4' "$PUBLIC_IPV4"
printf '  %-12s %s\n' 'Public IPv6' "$PUBLIC_IPV6"
printf '\n'
printf '        [ %s ]\n' "$NODE_ID"
printf '\n'
