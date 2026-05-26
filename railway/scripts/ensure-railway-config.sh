#!/bin/bash
# Servicios sin volumen sites (websocket, queue, scheduler): escribir common_site_config.
set -e
cd /home/frappe/frappe-bench

export REDIS_HOST="${REDIS_HOST:-redis}"
export REDIS_CACHE="${REDIS_CACHE:-redis://${REDIS_HOST}:6379/0}"
export REDIS_QUEUE="${REDIS_QUEUE:-redis://${REDIS_HOST}:6379/1}"
export REDIS_SOCKETIO="${REDIS_SOCKETIO:-${REDIS_QUEUE}}"
export DB_HOST="${DB_HOST:-db}"
export DB_PORT="${DB_PORT:-3306}"
export SOCKETIO_PORT="${SOCKETIO_PORT:-9000}"

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

def env(name, default=""):
    return os.environ.get(name, default)

set_key("db_host", env("DB_HOST", "db"))
set_key("db_port", env("DB_PORT", "3306"), is_port=True)
set_key("redis_cache", env("REDIS_CACHE", "redis://redis:6379/0"))
set_key("redis_queue", env("REDIS_QUEUE", "redis://redis:6379/1"))
set_key("redis_socketio", env("REDIS_SOCKETIO", env("REDIS_QUEUE", "redis://redis:6379/1")))
set_key("socketio_port", env("SOCKETIO_PORT", "9000"), is_port=True)

path.write_text(json.dumps(cfg, indent=1) + "\n")
print("ensure-railway-config:", json.dumps(cfg))
PY
