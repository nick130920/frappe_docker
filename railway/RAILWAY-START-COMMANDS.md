# Comandos de inicio en Railway (obligatorio)

Los servicios creados con **Docker Image** usan por defecto `start.sh` (Gunicorn). Configura el **Start Command** en cada servicio:

**Settings → Deploy → Start Command**

| Servicio | Start Command |
|----------|----------------|
| **backend** | `start.sh` |
| **frontend** | `nginx-entrypoint.sh` |
| **websocket** | `node /home/frappe/frappe-bench/apps/frappe/socketio.js` |
| **scheduler** | `bench schedule` |
| **queue** | `bench worker --queue long,default,short` |
| **configurator** | `bash -c 'ls -1 apps > sites/apps.txt && bench set-config -g db_host db && bench set-config -gp db_port 3306 && bench set-config -g redis_cache redis://redis:6379/0 && bench set-config -g redis_queue redis://redis:6379/1 && bench set-config -g redis_socketio redis://redis:6379/1 && bench set-config -gp socketio_port 9000'` |
| **create-site** | Ver `railway/config/create-site.toml` → `[deploy] startCommand` |

**frontend → Networking:** puerto público **8080** (no 8000).

**Variables compartidas** (Raw Editor a nivel proyecto o en create-site/backend):

```env
MYSQL_ROOT_PASSWORD=<tu-secreto>
MARIADB_ROOT_PASSWORD=<tu-secreto>
FRAPPE_ADMIN_PASSWORD=<admin-erp>
```

**Volumen compartido:** monta el mismo volumen `sites` en `/home/frappe/frappe-bench/sites` en: backend, frontend, configurator, create-site, websocket, scheduler, queue.

**Orden:** db + redis → configurator (1×) → create-site (1×) → resto.

**Dominio Frappe** (tras create-site):

```bash
railway ssh --service backend
bench --site frontend setup add-domain <tu-dominio>.up.railway.app
```
