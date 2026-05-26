#!/bin/bash
# Backend: publica site_config en Redis para queue/scheduler sin volumen sites.
set -e
cd /home/frappe/frappe-bench

SITE="${FRAPPE_SITE_NAME:-frontend}"
CFG="sites/${SITE}/site_config.json"
[ -f "$CFG" ] || exit 0

export REDIS_CACHE="${REDIS_CACHE:-redis://redis:6379/0}"

python3 <<PY
import json
import os
from pathlib import Path

import redis

site = os.environ.get("FRAPPE_SITE_NAME", "frontend")
cfg_path = Path(f"sites/{site}/site_config.json")
redis_url = os.environ["REDIS_CACHE"]
key = f"railway:site_config:{site}"

r = redis.from_url(redis_url)
r.set(key, cfg_path.read_text())
print(f"publish-site-config: {key} -> redis")
PY
