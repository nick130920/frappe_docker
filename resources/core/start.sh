#!/bin/bash
set -e

# Railway / primer arranque: crear sitio si no existe (requiere MYSQL_ROOT_PASSWORD y FRAPPE_ADMIN_PASSWORD).
if [ -x /usr/local/bin/init-site.sh ] && [ ! -f /home/frappe/frappe-bench/sites/frontend/site_config.json ]; then
  echo "Sitio frontend no encontrado; ejecutando init-site.sh..."
  /usr/local/bin/init-site.sh
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
