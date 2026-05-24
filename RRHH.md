# RRHH — fork de frappe_docker

Este fork añade **HRMS + `rrhh_seleccion`** para piloto y producción.

## Repositorios

| Repo | URL | Contenido |
|------|-----|-----------|
| **Infra (este fork)** | `https://github.com/nick130920/frappe_docker` | Docker, `pwd.yml`, build HRMS |
| **App extensión** | `https://github.com/nick130920/rrhh_seleccion` | Submódulo en `resources/rrhh_seleccion` |
| **Upstream** | `https://github.com/frappe/frappe_docker` | Sincronizar cambios oficiales |

## Remotes Git

```bash
git remote -v
# origin    → nick130920/frappe_docker (tu fork)
# upstream  → frappe/frappe_docker
```

Actualizar desde upstream:

```bash
git fetch upstream
git merge upstream/main   # o rebase, según tu flujo
```

## Inicio rápido

1. Copiar `pwd-hrms.example.env` → `pwd-hrms.env`
2. `.\resources\build-pwd-with-hrms.ps1`
3. `docker compose --env-file pwd-hrms.env -f pwd.yml up -d`
4. Instalar app: [docs/rrhh/infra/install-seleccion.md](docs/rrhh/infra/install-seleccion.md)

## Documentación

- [docs/rrhh/README.md](docs/rrhh/README.md) — índice
- [docs/rrhh/organizacion.md](docs/rrhh/organizacion.md) — extensión vs funcionalidades vs infra
- [docs/rrhh/infra/repo-setup.md](docs/rrhh/infra/repo-setup.md) — clonar submódulos y desarrollo

## Clonar con la app

```bash
git clone --recurse-submodules https://github.com/nick130920/frappe_docker.git
cd frappe_docker
```

Si ya clonaste sin submódulos:

```bash
git submodule update --init --recursive
```
