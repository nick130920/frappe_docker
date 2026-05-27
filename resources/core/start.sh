#!/bin/bash
set -e

# Railway / primer arranque: crear sitio si no existe (requiere MYSQL_ROOT_PASSWORD y FRAPPE_ADMIN_PASSWORD).
if [ -x /usr/local/bin/init-site.sh ] && [ ! -f /home/frappe/frappe-bench/sites/frontend/site_config.json ]; then
  echo "Sitio frontend no encontrado; ejecutando init-site.sh..."
  /usr/local/bin/init-site.sh
fi

if [ -x /usr/local/bin/ensure-domains.sh ]; then
  /usr/local/bin/ensure-domains.sh
fi

if [ -x /usr/local/bin/publish-site-config.sh ]; then
  /usr/local/bin/publish-site-config.sh || true
fi

# Asegurar assets de rrhh_seleccion en volumen (p. ej. icono desk tras deploy).
if [ ! -f /home/frappe/frappe-bench/sites/assets/rrhh_seleccion/images/seleccion-app.svg ]; then
  echo "Compilando assets rrhh_seleccion..."
  cd /home/frappe/frappe-bench && bench build --app rrhh_seleccion || true
fi

#Gunicorn defaults
GUNICORN_THREADS=${GUNICORN_THREADS:-4}
GUNICORN_WORKERS=${GUNICORN_WORKERS:-2}
GUNICORN_TIMEOUT=${GUNICORN_TIMEOUT:-120}

echo "Booting Gunicorn with $GUNICORN_WORKERS workers and $GUNICORN_THREADS threads..."

exec /home/frappe/frappe-bench/env/bin/gunicorn \
  --chdir=/home/frappe/frappe-bench/sites \
  --bind=0.0.0.0:8000 \
  --threads="$GUNICORN_THREADS" \
  --workers="$GUNICORN_WORKERS" \
  --worker-class=gthread \
  --worker-tmp-dir=/dev/shm \
  --timeout="$GUNICORN_TIMEOUT" \
  --preload \
  frappe.app:application
