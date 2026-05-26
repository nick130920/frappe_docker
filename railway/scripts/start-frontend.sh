#!/bin/bash
# Arranque nginx para Railway (red privada + puerto público).
set -e

export BACKEND="${BACKEND:-backend.railway.internal:8000}"
export SOCKETIO="${SOCKETIO:-websocket.railway.internal:9000}"
export FRAPPE_SITE_NAME_HEADER="${FRAPPE_SITE_NAME_HEADER:-\$host}"
export PORT="${PORT:-8080}"
export UPSTREAM_REAL_IP_ADDRESS="${UPSTREAM_REAL_IP_ADDRESS:-127.0.0.1}"
export UPSTREAM_REAL_IP_HEADER="${UPSTREAM_REAL_IP_HEADER:-X-Forwarded-For}"
export UPSTREAM_REAL_IP_RECURSIVE="${UPSTREAM_REAL_IP_RECURSIVE:-off}"
export PROXY_READ_TIMEOUT="${PROXY_READ_TIMEOUT:-120}"
export CLIENT_MAX_BODY_SIZE="${CLIENT_MAX_BODY_SIZE:-50m}"

echo "frontend: BACKEND=$BACKEND SOCKETIO=$SOCKETIO PORT=$PORT"
exec nginx-entrypoint.sh
