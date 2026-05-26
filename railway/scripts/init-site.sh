#!/bin/bash
# Ejecutar una vez en servicio create-site (o manualmente en backend).
set -euo pipefail

cd /home/frappe/frappe-bench

: "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD required}"
: "${FRAPPE_ADMIN_PASSWORD:?FRAPPE_ADMIN_PASSWORD required}"

echo "==> Esperando MariaDB y Redis..."
wait-for-it -t 300 db:3306
wait-for-it -t 120 redis:6379

echo "==> Configuración global del bench..."
mkdir -p sites
if [ ! -f sites/common_site_config.json ]; then
  echo "{}" > sites/common_site_config.json
fi
ls -1 apps > sites/apps.txt
bench set-config -g db_host db
bench set-config -gp db_port 3306
bench set-config -g redis_cache redis://redis:6379/0
bench set-config -g redis_queue redis://redis:6379/1
bench set-config -g redis_socketio redis://redis:6379/1
bench set-config -gp socketio_port 9000

if [ -f sites/frontend/site_config.json ]; then
  echo "==> Sitio frontend ya existe."
  exit 0
fi

echo "==> Creando sitio frontend (ERPNext + HRMS)..."
bench new-site frontend \
  --mariadb-user-host-login-scope=% \
  --admin-password="${FRAPPE_ADMIN_PASSWORD}" \
  --db-root-username=root \
  --db-root-password="${MYSQL_ROOT_PASSWORD}" \
  --install-app erpnext \
  --install-app hrms \
  --set-default

echo "==> Instalando rrhh_seleccion..."
bench --site frontend install-app rrhh_seleccion
bench --site frontend migrate

RAILWAY_DOMAIN="${RAILWAY_PUBLIC_DOMAIN:-frontend-production-ba28.up.railway.app}"
if [ -n "${RAILWAY_DOMAIN}" ]; then
  echo "==> Dominio: ${RAILWAY_DOMAIN}"
  bench setup add-domain "${RAILWAY_DOMAIN}" --site frontend || true
fi

bench --site frontend clear-cache
echo "==> Sitio frontend listo."
