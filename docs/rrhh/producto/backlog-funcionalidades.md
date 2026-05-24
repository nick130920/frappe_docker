# Backlog — funcionalidades nuevas (capa 2)

Funcionalidades **encima** de la extensión base `rrhh_seleccion`. No incluye cambios de Docker ni el scaffold inicial de la app.

Leyenda: `Hecho` | `En curso` | `Pendiente` | `Bloqueado`

| ID | Funcionalidad | Estado | Notas / criterio mínimo |
|----|---------------|--------|-------------------------|
| F-01 | Portal público `/seleccion` | Hecho | Página + estilos |
| F-02 | API `consultar_estado` (invitado) | Hecho | `rrhh_seleccion.api.consultar` |
| F-03 | DocTypes preingreso (documentos, evaluación, inducciones, EPP) | Hecho | Modelo; workflows cliente pendientes |
| F-04 | Historial y trazabilidad RN-10 / RF-18 | Hecho | Tabla `Historial Proceso` |
| F-05 | Workspace `seleccion_preingreso` + branding Desk | Hecho | CSS, icono, build assets backend+frontend |
| F-06 | Hooks `Job Applicant` (duplicados RN-01) | Hecho | `events/job_applicant.py` |
| F-07 | Workflows por estado de `Postulacion` | Pendiente | Definir con cliente en taller |
| F-08 | Permisos finos por `RRHH_*` | Pendiente | Tras matriz [workshop-matriz.md](workshop-matriz.md) |
| F-09 | Notificaciones email/SMS al postulante | Pendiente | — |
| F-10 | Integración firma / documentos externos | Pendiente | — |

## Plantilla para nuevas filas

```markdown
| F-XX | Título corto | Pendiente | CA: enlace a criterios-aceptacion.md § CA-… |
```

## Enlaces

- Extensión base: [README de la app](../../../resources/rrhh_seleccion/README.md)
- Criterios UAT: [criterios-aceptacion.md](criterios-aceptacion.md)
- Organización de capas: [organizacion.md](../organizacion.md)
