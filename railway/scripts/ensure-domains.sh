#!/bin/bash
# Añade dominios Railway al sitio (idempotente). Ejecutar en backend con volumen sites.
set -e
cd /home/frappe/frappe-bench

[ -f sites/frontend/site_config.json ] || exit 0

# Repara dominios mal pegados (espacio) y fija default_site para Host público.
python3 <<'PY'
import json
import os
from pathlib import Path

site_cfg_path = Path("sites/frontend/site_config.json")
site_cfg = json.loads(site_cfg_path.read_text())
domains = site_cfg.get("domains") or []
if isinstance(domains, str):
    domains = [domains]

wanted: set[str] = set()
for d in domains:
    d = (d or "").strip()
    if not d or " " in d:
        continue
    wanted.add(d)

for key in ("RAILWAY_PUBLIC_DOMAIN",):
    v = (os.environ.get(key) or "").strip()
    if v and " " not in v:
        wanted.add(v)

for part in (os.environ.get("RAILWAY_EXTRA_DOMAINS") or "").split(","):
    part = part.strip()
    if part and " " not in part:
        wanted.add(part)

for d in (
    "frontend-production-ba28.up.railway.app",
    "backend-production-da76c.up.railway.app",
):
    wanted.add(d)

new_domains = sorted(wanted)
if new_domains != domains:
    site_cfg["domains"] = new_domains
    site_cfg_path.write_text(json.dumps(site_cfg, indent=1) + "\n")
    print("ensure-domains: site_config domains ->", new_domains)

common_path = Path("sites/common_site_config.json")
common = {}
if common_path.exists():
    common = json.loads(common_path.read_text())
if common.get("default_site") != "frontend":
    common["default_site"] = "frontend"
    common_path.write_text(json.dumps(common, indent=1) + "\n")
    print("ensure-domains: default_site=frontend")
PY

add_one() {
  local d="$1"
  [ -z "$d" ] && return 0
  echo "ensure-domain: $d"
  bench setup add-domain "$d" --site frontend 2>/dev/null || true
}

add_one "${RAILWAY_PUBLIC_DOMAIN:-}"
add_one "frontend-production-ba28.up.railway.app"
add_one "backend-production-da76c.up.railway.app"

if [ -n "${RAILWAY_EXTRA_DOMAINS:-}" ]; then
  echo "${RAILWAY_EXTRA_DOMAINS}" | tr ',' '\n' | while read -r d; do
    add_one "$(echo "$d" | xargs)"
  done
fi

bench --site frontend clear-cache 2>/dev/null || true
