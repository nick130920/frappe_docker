#!/bin/bash
# No usar set -e global: fallos en assets no deben tumbar el contenedor antes del fallback.

ASSETS_PATH="/home/frappe/frappe-bench/sites/assets"
BAKED_PATH="/home/frappe/frappe-bench/assets"
SITES_DIR="/home/frappe/frappe-bench/sites"

link_assets() {
  echo "Linking fresh assets to volume..."
  mkdir -p "$(dirname "$ASSETS_PATH")" "$SITES_DIR"

  rm -rf "$ASSETS_PATH" 2>/dev/null || true

  if ln -sfn "$BAKED_PATH" "$ASSETS_PATH" 2>/dev/null && [ -e "$ASSETS_PATH" ]; then
    echo "Assets linked via symlink."
    return 0
  fi

  echo "Symlink failed; copying baked assets into sites..."
  mkdir -p "$ASSETS_PATH"
  if cp -a "$BAKED_PATH/." "$ASSETS_PATH/" 2>/dev/null; then
    echo "Assets copied."
    return 0
  fi

  echo "WARN: could not link or copy assets; continuing anyway."
  return 0
}

run_as_frappe() {
  if [ "$(id -u)" = "0" ] && command -v runuser >/dev/null 2>&1; then
    exec runuser -u frappe -- "$@"
  fi
  exec "$@"
}

# Railway: comando según nombre del servicio (sin editar Start Command en dashboard).
case "${RAILWAY_SERVICE_NAME:-}" in
  frontend)
    if [ -x /usr/local/bin/start-frontend-proxy.sh ]; then
      set -- /usr/local/bin/start-frontend-proxy.sh
    fi
    ;;
  configurator)
    if [ -x /usr/local/bin/run-configurator.sh ]; then
      set -- /usr/local/bin/run-configurator.sh
    fi
    ;;
  create-site)
    if [ -x /usr/local/bin/init-site.sh ]; then
      set -- /usr/local/bin/init-site.sh
    fi
    ;;
  websocket)
    set -- node /home/frappe/frappe-bench/apps/frappe/socketio.js
    ;;
  scheduler)
    set -- bench schedule
    ;;
  queue)
    set -- bench worker --queue long,default,short
    ;;
esac

if [ "$(id -u)" = "0" ]; then
  chown -R frappe:frappe "$SITES_DIR" 2>/dev/null || true
  link_assets
  chown -R frappe:frappe "$SITES_DIR" 2>/dev/null || true
  run_as_frappe "$@"
fi

link_assets
run_as_frappe "$@"
