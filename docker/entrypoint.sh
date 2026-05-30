#!/usr/bin/env sh
set -eu

CONFIG_PATH="/app/SPT_Data/configs/http.json"

SPT_IP="${SPT_IP:-0.0.0.0}"
SPT_PORT="${SPT_PORT:-6969}"
SPT_BACKEND_IP="${SPT_BACKEND_IP:-127.0.0.1}"
SPT_BACKEND_PORT="${SPT_BACKEND_PORT:-6969}"

case "$SPT_PORT" in
  ''|*[!0-9]*)
    echo "SPT_PORT must be numeric, got: $SPT_PORT" >&2
    exit 1
    ;;
esac

case "$SPT_BACKEND_PORT" in
  ''|*[!0-9]*)
    echo "SPT_BACKEND_PORT must be numeric, got: $SPT_BACKEND_PORT" >&2
    exit 1
    ;;
esac

escape_sed_replacement() {
  printf '%s' "$1" | sed 's/[&\\]/\\&/g'
}

if [ -f "$CONFIG_PATH" ]; then
  ip_value="$(escape_sed_replacement "$SPT_IP")"
  backend_ip_value="$(escape_sed_replacement "$SPT_BACKEND_IP")"

  sed -i -E \
    -e 's/("ip"[[:space:]]*:[[:space:]]*")[^"]*(")/\1'"$ip_value"'\2/' \
    -e 's/("port"[[:space:]]*:[[:space:]]*)[0-9]+/\1'"$SPT_PORT"'/' \
    -e 's/("backendIp"[[:space:]]*:[[:space:]]*")[^"]*(")/\1'"$backend_ip_value"'\2/' \
    -e 's/("backendPort"[[:space:]]*:[[:space:]]*)[0-9]+/\1'"$SPT_BACKEND_PORT"'/' \
    "$CONFIG_PATH"
fi

mkdir -p /app/user

exec /app/SPT.Server.Linux "$@"
