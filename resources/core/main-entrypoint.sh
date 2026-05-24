#!/bin/bash
set -e

ASSETS_PATH="/home/frappe/frappe-bench/sites/assets"
BAKED_PATH="/home/frappe/frappe-bench/assets"

link_assets() {
  echo "Linking fresh assets to volume..."
  rm -rf "$ASSETS_PATH"
  mkdir -p "$(dirname "$ASSETS_PATH")"
  if ln -sfn "$BAKED_PATH" "$ASSETS_PATH" 2>/dev/null; then
    return 0
  fi
  echo "Symlink failed; copying baked assets into sites..."
  mkdir -p "$ASSETS_PATH"
  cp -a "$BAKED_PATH/." "$ASSETS_PATH/"
}

run_as_frappe() {
  if [ "$(id -u)" = "0" ] && command -v runuser >/dev/null 2>&1; then
    exec runuser -u frappe -- "$@"
  fi
  exec "$@"
}

if [ "$(id -u)" = "0" ]; then
  chown -R frappe:frappe /home/frappe/frappe-bench/sites 2>/dev/null || true
  link_assets
  chown -R frappe:frappe /home/frappe/frappe-bench/sites 2>/dev/null || true
  run_as_frappe "$@"
fi

link_assets
run_as_frappe "$@"
