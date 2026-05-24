# Runbook: paso a producción (compose.custom + HTTPS)

> Resumen operativo. Detalle de compose en [03-start-setup.md](../../02-setup/03-start-setup.md) y overrides en [overrides/](../../../overrides/).

## 1. Backup del piloto

```bash
docker compose --env-file pwd-hrms.env -f pwd.yml exec db mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --all-databases > backup-pilot.sql
docker run --rm -v frappe_docker_sites:/sites -v %cd%:/backup alpine tar czf /backup/sites-pilot.tgz -C /sites .
```

(Ajustar nombre del volumen `frappe_docker_sites` con `docker volume ls`.)

## 2. Imagen producción

- Construir imagen con `compose.custom` y variables `CUSTOM_IMAGE` / `CUSTOM_TAG` (mismo `Containerfile` layered o `custom` según política).
- Incluir `resources/rrhh_seleccion` en el build (misma técnica COPY que layered).

## 3. HTTPS y dominio

- Traefik: [compose.https.yaml](../../../overrides/compose.https.yaml) + `SITES_RULE`.
- O nginx-proxy + acme.

## 4. Secretos

- Sustituir passwords de ejemplo (`admin`) por secretos gestionados (Docker secrets o variables de entorno no versionadas).

## 5. Post-despliegue

```bash
bench --site <sitio> migrate
bench --site <sitio> clear-cache
```

## 6. Verificación

- `/jobs` y `/seleccion` responden 200 en HTTPS.
- API `consultar_estado` con rate limiting vía reverse proxy (recomendado).
