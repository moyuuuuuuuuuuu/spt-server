#!/usr/bin/env sh
set -eu

CONFIG_PATH=/app/SPT_Data/configs/http.json
SPT_IP="${SPT_IP:-0.0.0.0}"
SPT_PORT="${SPT_PORT:-6969}"
SPT_BACKEND_IP="${SPT_BACKEND_IP:-127.0.0.1}"
SPT_BACKEND_PORT="${SPT_BACKEND_PORT:-$SPT_PORT}"

for port in "$SPT_PORT" "$SPT_BACKEND_PORT"; do
    case "$port" in
        ''|*[!0-9]*) echo "Invalid port: $port" >&2; exit 1 ;;
    esac
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Port must be between 1 and 65535: $port" >&2
        exit 1
    fi
done

# Only accept host/IP characters so values remain valid JSON and sed replacements.
for host in "$SPT_IP" "$SPT_BACKEND_IP"; do
    case "$host" in
        ''|*[!a-zA-Z0-9.:_-]*) echo "Invalid host/IP: $host" >&2; exit 1 ;;
    esac
done

test -f "$CONFIG_PATH" || { echo "Missing $CONFIG_PATH" >&2; exit 1; }
sed -i -E \
    -e 's/("ip"[[:space:]]*:[[:space:]]*")[^"]*(")/\1'"$SPT_IP"'\2/' \
    -e 's/("port"[[:space:]]*:[[:space:]]*)[0-9]+/\1'"$SPT_PORT"'/' \
    -e 's/("backendIp"[[:space:]]*:[[:space:]]*")[^"]*(")/\1'"$SPT_BACKEND_IP"'\2/' \
    -e 's/("backendPort"[[:space:]]*:[[:space:]]*)[0-9]+/\1'"$SPT_BACKEND_PORT"'/' \
    "$CONFIG_PATH"

mkdir -p /app/user
exec /app/SPT.Server.Linux "$@"
