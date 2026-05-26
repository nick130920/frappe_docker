#!/bin/bash
# Frontend en Railway sin volumen compartido: solo proxy a backend + websocket.
set -e

export BACKEND_UPSTREAM="${BACKEND_UPSTREAM:-backend.railway.internal:8000}"
export SOCKETIO_UPSTREAM="${SOCKETIO_UPSTREAM:-websocket.railway.internal:9000}"
export NGINX_PORT="${PORT:-8080}"

echo "frontend-proxy: BACKEND=$BACKEND_UPSTREAM SOCKETIO=$SOCKETIO_UPSTREAM PORT=$NGINX_PORT"

envsubst '${NGINX_PORT} ${BACKEND_UPSTREAM} ${SOCKETIO_UPSTREAM}' \
  < /etc/nginx/conf.d/railway-proxy.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
