# Configuración del repositorio

## Estructura

```text
frappe_docker/                    # fork nick130920 — capa infra
├── apps.json                     # ERPNext + HRMS en imagen
├── pwd.yml, pwd-hrms.env         # piloto (env local no se commitea)
├── images/                       # Containerfile copia submódulo
└── resources/
    └── rrhh_seleccion/           # submódulo → github.com/nick130920/rrhh_seleccion

rrhh_seleccion/                   # repo app — capa extensión + features
└── rrhh_seleccion/               # paquete Frappe
```

## Clonar desde cero

```bash
git clone --recurse-submodules https://github.com/nick130920/frappe_docker.git
cd frappe_docker
copy pwd-hrms.example.env pwd-hrms.env
```

## Trabajar solo en la app

```bash
cd resources/rrhh_seleccion
git checkout -b feature/mi-cambio
# editar, commit, push
git push -u origin feature/mi-cambio
```

En el repo padre, actualizar el puntero del submódulo cuando integres:

```bash
cd ../..
git add resources/rrhh_seleccion
git commit -m "chore: bump rrhh_seleccion submodule"
```

## Trabajar solo en infra (Docker)

Rama en el fork, sin tocar el submódulo salvo versión de imagen:

```bash
git checkout -b infra/mi-cambio
# pwd.yml, Containerfile, build script…
```

## Remotes del fork

| Remote | Uso |
|--------|-----|
| `origin` | Tu fork (`nick130920/frappe_docker`) — push de piloto/infra |
| `upstream` | `frappe/frappe_docker` — traer actualizaciones oficiales |

```bash
git fetch upstream
git checkout main
git merge upstream/main
```

## Crear el repo de la app en otra máquina

Si publicaste `rrhh_seleccion` en GitHub:

```bash
bench get-app https://github.com/nick130920/rrhh_seleccion
bench --site <sitio> install-app rrhh_seleccion
```

## Problemas frecuentes

**Carpeta `rrhh_seleccion` vacía tras clone**

```bash
git submodule update --init --recursive
```

**Cambios en submódulo no aparecen en Docker**

Reconstruir imagen: `.\resources\build-pwd-with-hrms.ps1` (el Containerfile copia el submódulo en build time).
