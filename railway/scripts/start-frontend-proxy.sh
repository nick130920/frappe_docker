#!/bin/bash
# Frontend en Railway sin volumen compartido: solo proxy a backend + websocket.
set -e

# shellcheck source=resolve-railway-host.sh
. /usr/local/bin/resolve-railway-host.sh

_raw_backend="${BACKEND_UPSTREAM:-${BACKEND:-backend.railway.internal:8000}}"
_raw_socketio="${SOCKETIO_UPSTREAM:-${SOCKETIO:-websocket.railway.internal:9000}}"
export BACKEND_UPSTREAM="$(resolve_host_port "$_raw_backend")"
export SOCKETIO_UPSTREAM="$(resolve_host_port "$_raw_socketio")"
export NGINX_PORT="${PORT:-8080}"

echo "frontend-proxy: BACKEND=$BACKEND_UPSTREAM SOCKETIO=$SOCKETIO_UPSTREAM PORT=$NGINX_PORT"

envsubst '${NGINX_PORT} ${BACKEND_UPSTREAM} ${SOCKETIO_UPSTREAM}' \
  < /etc/nginx/conf.d/railway-proxy.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
