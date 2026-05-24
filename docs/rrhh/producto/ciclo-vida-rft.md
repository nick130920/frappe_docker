# Trazabilidad RFT ↔ implementación

Este documento enlaza el **Requerimiento Funcional Técnico** (RF-01…RF-20, RN-01…RN-10, actores y estados) con los artefactos del repositorio.

## Actores → roles

| Actor RFT | Rol Frappe |
|-----------|------------|
| Administrador / RRHH gestión | `RRHH_Gestion` (+ HR Manager típico) |
| RRHH revisión | `RRHH_Revision` |
| RRHH contratación | `RRHH_Contratacion` |
| RRHH inducción | `RRHH_Induccion` |
| Candidato | Invitado (portal `/seleccion`, API `consultar_estado`) |

Los roles `RRHH_*` se crean al instalar la app [`rrhh_seleccion`](../../../resources/rrhh_seleccion).

## RF → DocTypes / HRMS

| RF | Descripción breve | Implementación |
|----|-------------------|----------------|
| RF-01 | Vacantes y enlace público | HRMS Job Opening + portal `/jobs`; estados avanzados (draft/published/paused/closed) vía Custom Field futuro o convención con `status` nativo |
| RF-02 | Radicación oficial en sistema | Flujo Job Applicant + **Postulacion** |
| RF-03 | Formulario datos completos | Web Form (pendiente ampliación); campos base en Job Applicant |
| RF-04 | HV estructurada + adjunto | Postulacion + documentos |
| RF-05 | Documentos requeridos | Tabla hija **Documento Postulante** |
| RF-06 | Validación documental | Campos estado + observaciones en **Documento Postulante** |
| RF-07 | Corrección candidato | Portal + API (re-upload pendiente UI) |
| RF-08 | Expediente 360° | Lista **Postulacion** + enlaces a HRMS; Page expediente (evolutivo) |
| RF-09 | Entrevistas por cargo | HRMS Interview Round + Interview; plantilla custom futura |
| RF-10–11 | Evaluación ocupacional | **Evaluacion Ocupacional** |
| RF-12 | Decisión contratación | Campos `decision_final` + `proceso_estado` en **Postulacion** |
| RF-13 | Inducción organizacional | **Induccion Organizacional** + HRMS Employee Onboarding |
| RF-14–15 | Inducción funcional y evidencias | **Induccion Funcional** |
| RF-16 | Dotación / EPP | **Entrega Dotacion EPP** + validación RN-08 en hook |
| RF-17 | Consulta estado | API `rrhh_seleccion.api.consultar.consultar_estado` |
| RF-18 | Trazabilidad | Tabla **Historial Proceso** + versionado Frappe |
| RF-19 | Permisos | Roles RRHH + permisos HR Manager/User en DocTypes |
| RF-20 | Backoffice oportuno | Listas estándar + notificaciones (evolutivo) |

## RN → código

| RN | Implementación |
|----|------------------|
| RN-01 | `Postulacion.validate` + hook `Job Applicant.validate` (email+vacante) |
| RN-02–04 | Lógica documentos / vigencias (parametría pendiente en DocType **Parámetros** o `Singles`) |
| RN-05 | API solo devuelve `observacion_candidato` en documentos |
| RN-06–07 | Portal solo docs `needs_correction`; bloqueo si estado final (evolutivo) |
| RN-08 | `events/induccion_funcional.validate_practical_phase_requires_epp` |
| RN-09 | Hook futuro `Job Opening` on_trash |
| RN-10 | Historial en **Postulacion** vía `before_save` |

## Estados mínimos

- **Postulación** (`proceso_estado` en **Postulacion**): submitted, document_review, interview, occupational_exam, selected, rejected, hired.
- **Documento**: uploaded, approved, needs_correction.
- **Ocupacional** (`clasificacion`): pending, apt, not_apt, apt_with_restrictions.
- **Inducción org. / fun.**: not_started, in_progress, completed (campos en DocTypes correspondientes).
- **EPP** (`estado_entrega`): draft, confirmed.

## Documentación relacionada

- [Instalar rrhh_seleccion](../infra/install-seleccion.md)
- [Criterios de aceptación](criterios-aceptacion.md)
- [Validación piloto](../infra/validate-pilot.md)
- [Flujo configuración HRMS](../infra/hrms-config-flow.md)
