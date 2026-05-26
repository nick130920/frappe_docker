#!/bin/bash
# Añade dominios Railway al sitio (idempotente). Ejecutar en backend con volumen sites.
set -e
cd /home/frappe/frappe-bench

[ -f sites/frontend/site_config.json ] || exit 0

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
