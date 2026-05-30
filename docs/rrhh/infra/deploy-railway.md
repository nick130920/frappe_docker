# Desplegar en Railway

Stack: **ERPNext + HRMS + `rrhh_seleccion`**, basado en `pwd.yml` pero adaptado a las limitaciones de Railway.

## Requisitos

- Cuenta en [Railway](https://railway.com)
- CLI: `npm i -g @railway/cli` y `railway login`
- Repos en GitHub: `nick130920/frappe_docker` (rama `rrhh/piloto-hrms`) con submódulo `rrhh_seleccion`
- Imagen Docker en GHCR: `ghcr.io/nick130920/erpnext-hrms:railway` (workflow `.github/workflows/railway-image.yml`)

## Limitaciones importantes

| Tema | Detalle |
|------|---------|
| **Volúmenes** | Railway permite **un volumen por servicio**. El compose de Railway usa solo `sites` (sin volumen `logs` aparte). |
| **Import compose** | Arrastra `railway/docker-compose.railway.yml` al canvas. Si falla, crea servicios a mano siguiendo la tabla abajo. |
| **Coste** | ~9 servicios (db, redis, backend, frontend, websocket, scheduler, queue, configurator, create-site). Revisa el plan y apaga el piloto cuando no lo uses. |
| **Build** | La imagen es pesada (~varios GB); el build en GitHub Actions tarda 20–40 min la primera vez. |

## Paso 1 — Publicar la imagen Docker

1. En GitHub, abre **Actions** → **Build ERPNext HRMS image for Railway** → **Run workflow** (o haz push a `rrhh/piloto-hrms`).
2. Cuando termine, en `https://github.com/nick130920?tab=packages` abre el paquete `erpnext-hrms` y ponlo **Public** (o configura credenciales GHCR en Railway).

## Paso 2 — Proyecto Railway

Proyecto CLI ya creado: **`rrhh-pwd-hrms`** (vinculado con `railway link -p …` desde este repo).

1. [Abrir proyecto](https://railway.com/project/14025ec2-fe3b-422e-a4ae-672bb7b156bc) en el dashboard.
2. **Importante:** tras añadir servicios por imagen, configura **Start Command** por servicio → [railway/RAILWAY-START-COMMANDS.md](../../../railway/RAILWAY-START-COMMANDS.md).
3. Alternativa: arrastra **`railway/docker-compose.railway.yml`** al canvas (si el import falla, los servicios ya pueden estar creados por CLI).

## Paso 3 — Variables de entorno

En el **proyecto** (compartidas) o por servicio, en **Variables → Raw Editor**:

```env
MYSQL_ROOT_PASSWORD=<secreto>
FRAPPE_ADMIN_PASSWORD=<secreto-admin-erp>
ERPNext_HRMS_IMAGE=ghcr.io/nick130920/erpnext-hrms:railway
```

Plantilla: [railway/railway.env.example](../../../railway/railway.env.example).

## Paso 4 — Volúmenes

En cada servicio que monta datos, **Settings → Volume** con esta ruta de montaje:

| Servicio Railway | Mount path |
|------------------|------------|
| `db` | `/var/lib/mysql` |
| `redis` | `/data` |
| `configurator`, `create-site`, `backend`, `frontend`, `websocket`, `scheduler`, `queue` | `/home/frappe/frappe-bench/sites` |

El volumen `sites` debe ser **el mismo volumen compartido** entre todos los servicios Frappe (en Railway: crea un volumen y asígnalo al mismo mount path en cada servicio, o usa la opción de volumen compartido del import compose).

## Paso 5 — Red pública

1. Servicio **`frontend`** → **Settings → Networking** → **Generate Domain** (puerto **8080**).
2. Servicios `db`, `redis`, `backend`, `websocket`, etc. **sin** dominio público (solo red privada).

## Paso 6 — Orden de arranque

1. `db` y `redis` en verde.
2. Ejecutar **`configurator`** una vez (debe terminar OK).
3. Ejecutar **`create-site`** una vez (crea sitio `frontend`, instala ERPNext, HRMS y `rrhh_seleccion`).
4. Levantar `backend`, `frontend`, `websocket`, `scheduler`, `queue`.

Si `create-site` ya corrió, no lo vuelvas a lanzar salvo que borres el volumen `sites`.

## Paso 7 — Dominio del sitio Frappe

El sitio se crea como **`frontend`**. En el servicio **frontend** (sin volumen `sites` compartido) define:

```bash
FRAPPE_SITE_NAME_HEADER=frontend
```

No uses `$host` en PowerShell al crear la variable (se expande al nombre de tu PC). Con eso nginx envía `X-Frappe-Site-Name: frontend` al backend.

Opcional: dominios extra en **backend** (`ensure-domains.sh` al arranque) o manualmente:

```bash
railway ssh --service backend
bench --site frontend setup add-domain tu-app.up.railway.app
bench --site frontend clear-cache
```

Usuario ERP: **Administrator** / contraseña = `FRAPPE_ADMIN_PASSWORD`.

## Servicios manuales

| Servicio | Tipo | Imagen / build |
|----------|------|----------------|
| db | Docker | `mariadb:11.8` |
| redis | Docker | `redis:6.2-alpine` |
| Resto Frappe | Docker | `ghcr.io/nick130920/erpnext-hrms:railway` |

Comandos y variables: copiar de `railway/docker-compose.railway.yml`.

## Build local de la imagen (alternativa a GHCR)

```powershell
cd c:\Users\namc1\frappe_docker
git submodule update --init --recursive
docker build -f railway/Dockerfile -t ghcr.io/nick130920/erpnext-hrms:railway .
docker push ghcr.io/nick130920/erpnext-hrms:railway
```

## Redespliegue (solo imagen GHCR)

No uses `railway up` ni `railway redeploy --from-source` en servicios creados por imagen Docker (dispara Railpack y falla). Usa:

```powershell
railway redeploy -s backend -y
```

Detalle: [railway/RAILWAY-DEPLOY.md](../../../railway/RAILWAY-DEPLOY.md).

## CLI útil

```bash
railway login
railway init
railway link
railway open
railway logs --service frontend
railway ssh --service backend
```

## Problemas frecuentes

- **401 al pull de GHCR**: paquete privado → hazlo público o añade `DOCKER_REGISTRY` credentials en Railway.
- **404 «tu-dominio.up.railway.app does not exist»**: en **frontend** falta `FRAPPE_SITE_NAME_HEADER=frontend` (ver paso 7).
- **websocket / queue crashed (Redis ECONNREFUSED)**: en esos servicios define `REDIS_HOST=redis` y `DB_HOST=db` (sin volumen `sites`; la imagen escribe `common_site_config` al arrancar). El **backend** publica `site_config` en Redis para **queue** y **scheduler**.
- **502 / sitio no encontrado**: revisa `BACKEND=backend.railway.internal:8000` y que el backend esté en línea.
- **create-site falla**: revisa que `configurator` escribió `sites/common_site_config.json` y que `MYSQL_ROOT_PASSWORD` coincide en `db` y `create-site`.
- **Assets 404**: en backend: `bench --site frontend build --app rrhh_seleccion` y `clear-cache`.

## Referencias

- [Guía Railway Docker Compose](https://docs.railway.com/guides/docker-compose)
- [Instalación local pwd](install-seleccion.md)
