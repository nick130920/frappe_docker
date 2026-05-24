# RRHH — Selección y despliegue

Índice del trabajo **Selección / preingreso** sobre Frappe HR. Está organizado en **tres capas** para no mezclar la extensión base, las funcionalidades nuevas y el stack Docker.

## Cómo está separado el trabajo

| Capa | Qué es | Dónde vive | Cambios típicos |
|------|--------|------------|-----------------|
| **1. Extensión (producto base)** | App Frappe que extiende HRMS **sin tocar** el código de `hrms` | [`resources/rrhh_seleccion/`](../../resources/rrhh_seleccion/) | Hooks, roles `RRHH_*`, DocTypes núcleo, permisos, integración `Job Applicant` |
| **2. Funcionalidades nuevas** | Épicas incrementales sobre la extensión | Misma app; ver [backlog](producto/backlog-funcionalidades.md) | Portal `/seleccion`, API consulta, workspace, branding, flujos por módulo |
| **3. Infra piloto / producción** | Imagen Docker, `pwd.yml`, scripts de build | Raíz del repo (`apps.json`, `pwd.yml`, `images/`, `resources/build-pwd-with-hrms.ps1`) | HRMS en imagen, copia de la app al build, compose piloto |

Detalle de ramas, PRs y repos: **[organizacion.md](organizacion.md)**.  
Clonar, submódulos y remotes: **[infra/repo-setup.md](infra/repo-setup.md)**.

## Documentación por carpeta

### Producto (negocio y calidad)

- [Ciclo de vida y trazabilidad RFT](producto/ciclo-vida-rft.md)
- [Criterios de aceptación (UAT)](producto/criterios-aceptacion.md)
- [Matriz taller cliente](producto/workshop-matriz.md)
- [Backlog de funcionalidades nuevas](producto/backlog-funcionalidades.md)

### Infra (HRMS + app en Docker / bench)

- [Configuración del repositorio](infra/repo-setup.md)
- [Despliegue en Railway](infra/deploy-railway.md)
- [Flujo configuración HRMS](infra/hrms-config-flow.md)
- [Validación piloto HRMS](infra/validate-pilot.md)
- [Instalar `rrhh_seleccion`](infra/install-seleccion.md)

### Operaciones

- [Checklist UAT piloto pwd](operaciones/uat-pwd-checklist.md)
- [Runbook producción](operaciones/production-runbook.md)

## Orden recomendado de lectura

1. [organizacion.md](organizacion.md) — cómo trabajar sin mezclar capas  
2. [infra/validate-pilot.md](infra/validate-pilot.md) — sitio HRMS listo  
3. [infra/install-seleccion.md](infra/install-seleccion.md) — app en el sitio  
4. [producto/ciclo-vida-rft.md](producto/ciclo-vida-rft.md) + [producto/criterios-aceptacion.md](producto/criterios-aceptacion.md) — pruebas y RFT  
