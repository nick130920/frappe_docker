#!/bin/bash
set -e
cd /home/frappe/frappe-bench
mkdir -p sites
[ -f sites/common_site_config.json ] || echo "{}" > sites/common_site_config.json
ls -1 apps > sites/apps.txt
bench set-config -g db_host db
bench set-config -gp db_port 3306
bench set-config -g redis_cache redis://redis:6379/0
bench set-config -g redis_queue redis://redis:6379/1
bench set-config -g redis_socketio redis://redis:6379/1
bench set-config -gp socketio_port 9000
echo "configurator done"
