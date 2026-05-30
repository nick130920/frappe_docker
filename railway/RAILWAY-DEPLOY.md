# Despliegue en Railway (imagen GHCR)

Los servicios Frappe usan **imagen Docker** (`ghcr.io/nick130920/erpnext-hrms:railway`), no build desde el repo en Railway.

## Publicar imagen nueva

1. Push a `rrhh/piloto-hrms` o ejecuta el workflow **Build ERPNext HRMS image for Railway** en GitHub Actions.
2. Espera a que termine el push a GHCR.

## Redesplegar (correcto)

```powershell
railway link -p rrhh-pwd-hrms -e production
railway redeploy -s backend -y
railway redeploy -s frontend -y
railway redeploy -s websocket -y
railway redeploy -s queue -y
railway redeploy -s scheduler -y
```

Esto **reutiliza la imagen configurada** en el servicio (pull del tag `railway`).

## No usar en servicios por imagen

| Comando | Problema |
|---------|----------|
| `railway up` | Sube el repo y dispara **Railpack** → falla con "No start command found" |
| `railway redeploy --from-source` | Igual: intenta build desde código, no solo pull de GHCR |
| `railway deployment up` | Equivalente a subir código |

Si un deploy falló con Railpack en los logs, el servicio sigue bien en **Settings → Source → Docker Image**; solo hay que redesplegar con `railway redeploy -s <nombre> -y` (sin `--from-source`).

## Variables útiles

- `ERPNext_HRMS_IMAGE=ghcr.io/nick130920/erpnext-hrms:railway` (referencia; la imagen activa se define en Source del servicio)
- **frontend:** `FRAPPE_SITE_NAME_HEADER=frontend`
- **websocket / queue / scheduler:** `REDIS_HOST=redis`, `DB_HOST=db`
