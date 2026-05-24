# Instalar `rrhh_seleccion` en el sitio

La app se **copia en la imagen** durante el build de Docker:

- Imagen **layered**: [images/layered/Containerfile](../../../images/layered/Containerfile)
- Imagen **custom** (producción típica): [images/custom/Containerfile](../../../images/custom/Containerfile)

No hace falta añadir `rrhh_seleccion` a `apps.json` si usas este empaquetado (ERPNext + HRMS siguen viniendo de `apps.json`; la app local se `pip install -e` en el bench del builder).

Tras `install-app`, el hook `after_install` crea los roles RRHH, permisos vía **Custom DocPerm** y el **Desktop Icon** de la app (mosaico Desk), y vacía la caché de iconos.

### CSS / SVG con 404 o MIME `text/html` (no es hoja de estilo)

Eso significa que **nginx (contenedor `frontend` en `pwd.yml`) no encuentra el fichero** bajo `/home/frappe/frappe-bench/sites/assets/...` y devuelve HTML de error.

En este compose, **`sites` es volumen compartido**, pero la carpeta **`assets` del bench no**: cada contenedor tiene su propio `/home/frappe/frappe-bench/assets`. Un `bench build` solo en **`backend`** actualiza los assets del backend; el **frontend** (puerto 8080) sigue sirviendo una copia antigua sin `rrhh_seleccion`.

Después de instalar o cambiar la app, ejecuta el build **en ambos** (mismo sitio `frontend`):

```bash
docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bench --site frontend build --app rrhh_seleccion
docker compose --env-file pwd-hrms.env -f pwd.yml exec frontend bench --site frontend build --app rrhh_seleccion
docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bench --site frontend clear-cache
```

Luego **Ctrl+F5** en el navegador. En producción con una sola imagen actualizada (build de Docker que ya incluye `bench build`), no suele hacer falta duplicar.

### WebSocket `Invalid origin` (puerto 8080)

Suele ser **Socket.IO** comprobando el `Origin` frente al nombre del sitio. No afecta al listado de Desk; para corregirlo habría que alinear `host` / `X-Frappe-Site-Name` / configuración del sitio (tema aparte).

### `GET /undefined` en el menú lateral

Suele ser un ítem del **Navbar Settings** (menú desplegable) sin **icono** ni `icon_url`: el JS pinta `<img src="undefined">`. Revisa **Navbar Settings** y asigna icono a cada entrada personalizada, o quita la entrada.

## Tras levantar contenedores

Si actualizaste la imagen y aparece **App rrhh_seleccion not in apps.txt**, regenera la lista desde el bench del contenedor (el volumen `sites` puede conservar un `apps.txt` antiguo):

```bash
docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bash -c "cd /home/frappe/frappe-bench && ls -1 apps > sites/apps.txt"
```

```bash
docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bench --site frontend install-app rrhh_seleccion
docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bench --site frontend migrate
```

## Rebuild de imagen

```powershell
.\resources\build-pwd-with-hrms.ps1
docker compose --env-file pwd-hrms.env -f pwd.yml up -d --force-recreate backend frontend websocket scheduler queue-long queue-short
```

## Portal público

- Página informativa: `https://<sitio>/seleccion`
- API estado (invitado): `GET /api/method/rrhh_seleccion.api.consultar.consultar_estado?codigo_seguimiento=SEL-00001`

## Escritorio (mosaico en `/desk`)

El mosaico usa **`Desktop Icon`** (tipo App) además de `add_to_apps_screen` y **`app_home`** en `hooks.py` (Frappe arma `app_route` desde `app_home`). Tras instalar o actualizar la app, el hook `after_install` llama a `create_desktop_icons_from_installed_apps()`. Si no ves el icono: `bench --site <sitio> execute rrhh_seleccion.setup.after_install.create_roles`, **build en `backend` y `frontend`** (ver sección de assets arriba), `clear-cache` y **Ctrl+F5**. El **Workspace** está en `seleccion/workspace/...`.

## Roles creados por la app

`RRHH_Gestion`, `RRHH_Revision`, `RRHH_Contratacion`, `RRHH_Induccion` — se crean al instalar la app y reciben permisos base sobre Postulacion, Evaluacion Ocupacional, Inducciones y EPP. Ajusta detalle en **Role Permission Manager** si el cliente requiere segregación estricta por rol.
