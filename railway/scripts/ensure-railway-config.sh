#!/bin/bash
# Servicios sin volumen sites (websocket, queue, scheduler): escribir common_site_config.
set -e
cd /home/frappe/frappe-bench

REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_CACHE="${REDIS_CACHE:-redis://${REDIS_HOST}:6379/0}"
REDIS_QUEUE="${REDIS_QUEUE:-redis://${REDIS_HOST}:6379/1}"
REDIS_SOCKETIO="${REDIS_SOCKETIO:-${REDIS_QUEUE}}"
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"
SOCKETIO_PORT="${SOCKETIO_PORT:-9000}"

mkdir -p sites
ls -1 apps > sites/apps.txt 2>/dev/null || true

python3 <<PY
import json
import os
from pathlib import Path

path = Path("sites/common_site_config.json")
cfg = {}
if path.exists():
    try:
        cfg = json.loads(path.read_text())
    except json.JSONDecodeError:
        cfg = {}

def set_key(key, value, is_port=False):
    if is_port:
        cfg[key] = int(value)
    else:
        cfg[key] = value

set_key("db_host", os.environ["DB_HOST"])
set_key("db_port", os.environ["DB_PORT"], is_port=True)
set_key("redis_cache", os.environ["REDIS_CACHE"])
set_key("redis_queue", os.environ["REDIS_QUEUE"])
set_key("redis_socketio", os.environ["REDIS_SOCKETIO"])
set_key("socketio_port", os.environ["SOCKETIO_PORT"], is_port=True)

path.write_text(json.dumps(cfg, indent=1) + "\n")
print("ensure-railway-config:", json.dumps(cfg))
PY
