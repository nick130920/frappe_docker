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

SITE="${FRAPPE_SITE_NAME:-frontend}"
SITE_CFG="sites/${SITE}/site_config.json"
if [ ! -f "$SITE_CFG" ]; then
  python3 <<PY
import os
from pathlib import Path

import redis

site = os.environ.get("FRAPPE_SITE_NAME", "frontend")
redis_url = os.environ.get("REDIS_CACHE", "redis://redis:6379/0")
key = f"railway:site_config:{site}"
cfg_path = Path(f"sites/{site}/site_config.json")

r = redis.from_url(redis_url)
raw = r.get(key)
if not raw:
    print(f"ensure-railway-config: no site_config in redis ({key})")
    raise SystemExit(0)

cfg_path.parent.mkdir(parents=True, exist_ok=True)
text = raw.decode() if isinstance(raw, bytes) else raw
cfg_path.write_text(text)
print(f"ensure-railway-config: restored {cfg_path} from redis")
PY
fi
