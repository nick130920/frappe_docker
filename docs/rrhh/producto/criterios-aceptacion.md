# Criterios de aceptación (CA) — plantilla UAT

Use una fila por criterio. **Estado:** Pendiente / Pass / Fail / N/A.

| ID | Módulo | Precondiciones | Pasos (resumen) | Resultado esperado | Evidencia | RF/RN | Estado | QA |
|----|--------|----------------|-----------------|---------------------|-----------|-------|--------|-----|
| CA-VAC-01 | Vacantes | Rol gestión | Crear vacante con campos obligatorios | Registro creado | | RF-01 | Pendiente | |
| CA-VAC-02 | Vacantes | Vacante existente | Editar, publicar, pausar, cerrar | Estados coherentes | | RF-01 | Pendiente | |
| CA-VAC-03 | Vacantes | Publicada | Abrir enlace público | Formulario/listado accesible | | RF-01 | Pendiente | |
| CA-VAC-04 | Vacantes | Pausada/cerrada | Intentar nueva postulación | Bloqueo o mensaje | | RF-01 | Pendiente | |
| CA-VAC-05 | Vacantes | Listado | Filtrar y buscar | Resultados correctos | | RF-01 | Pendiente | |
| CA-VAC-06 | Vacantes | Con postulaciones | Intentar eliminar sin control | Imposible o requiere confirmación | | RN-09 | Pendiente | |
| CA-POST-01 | Postulación | Vacante publicada | Abrir formulario público sin login | Formulario carga | | RF-02 | Pendiente | |
| CA-POST-02 | Postulación | — | Completar campos mínimos RFT | Validación guarda | | RF-03 | Pendiente | |
| CA-POST-03 | Postulación | — | Marcar vehículo | Activa reglas documentos | | RN-02 | Pendiente | |
| CA-POST-04 | Postulación | — | Enviar incompleto / formato inválido | Rechazo | | RF-03 | Pendiente | |
| CA-POST-05 | Postulación | — | HV + foto | Obligatoriedad | | RF-04–05 | Pendiente | |
| CA-POST-06 | Postulación | — | Envío OK | Código SEL- y confirmación | | RF-17 | Pendiente | |
| CA-DOC-01 | Documentos | Postulación | Cargar docs política | Almacenados | | RF-05 | Pendiente | |
| CA-DOC-02 | Documentos | — | Tipos obligatorios lista RFT | Aceptados | | RF-05 | Pendiente | |
| CA-DOC-03 | Documentos | Vehículo | Licencias | Obligatorias | | RN-02 | Pendiente | |
| CA-DOC-04 | Documentos | — | Estudios opcionales | OK | | RN-03 | Pendiente | |
| CA-DOC-05 | Documentos | — | Archivo inválido/tamaño | Rechazo | | — | Pendiente | |
| CA-DOC-06 | Documentos | Vigencia bancaria | Fecha fuera de política | Rechazo | | RN-04 | Pendiente | |
| CA-REV-01 | Revisión | Rol revisión | Abrir expediente | Lista documentos | | RF-06 | Pendiente | |
| CA-REV-02 | Revisión | — | Marcar validado / corrección | Estados | | RF-06 | Pendiente | |
| CA-REV-03 | Revisión | — | Obs. interna | No visible portal | | RN-05 | Pendiente | |
| CA-REV-04 | Revisión | — | Obs. candidato | Visible API/portal | | RF-06 | Pendiente | |
| CA-REV-05 | Revisión | — | Avanzar revisión | Estado global actualizado | | RF-06 | Pendiente | |
| CA-REV-06 | Revisión | — | Cada validación | Fecha + responsable | | RN-10 | Pendiente | |
| CA-CONS-01 | Consulta | — | API código o cédula | JSON correcto | | RF-17 | Pendiente | |
| CA-CONS-02 | Consulta | — | Respuesta | Estado + docs observados | | RF-17 | Pendiente | |
| CA-CONS-03 | Consulta | — | Respuesta | Sin obs. internas | | RN-05 | Pendiente | |
| CA-CONS-04 | Consulta | — | Re-carga solo needs_correction | Restricción | | RN-06 | Pendiente | |
| CA-CONS-05 | Consulta | — | Tras corrección | Vuelve a revisión | | RF-07 | Pendiente | |
| CA-CONS-06 | Consulta | Postulación finalizada | Intentar corrección | Bloqueo | | RN-07 | Pendiente | |
| CA-DUP-01 | Duplicados | Misma vacante+cédula | Segunda Postulacion activa | Error | | RN-01 | Pendiente | |
| CA-DUP-02 | Duplicados | — | Mensaje claro | UX | | RN-01 | Pendiente | |
| CA-DUP-03 | Duplicados | Proceso cerrado | Nueva postulación | Permitido si aplica | | RN-01 | Pendiente | |
| CA-EXP-01 | Expediente | — | Vista única | Datos consolidados | | RF-08 | Pendiente | |
| CA-EXP-02 | Expediente | — | Resumen | Siguiente paso | | RF-08 | Pendiente | |
| CA-EXP-03 | Expediente | — | Historial | Fechas y responsables | | RF-18 | Pendiente | |
| CA-EXP-04 | Expediente | — | Enlaces | Docs y registros | | RF-08 | Pendiente | |
| CA-ENT-01 | Entrevista | — | Plantilla por cargo | CRUD plantilla | | RF-09 | Pendiente | |
| CA-ENT-02 | Entrevista | Plantilla | Preguntas reutilizables | Estructura | | RF-09 | Pendiente | |
| CA-ENT-03 | Entrevista | — | Iniciar con plantilla | Interview HRMS | | RF-09 | Pendiente | |
| CA-ENT-04 | Entrevista | — | Registrar respuestas/notas/puntaje | Guardado | | RF-09 | Pendiente | |
| CA-ENT-05 | Entrevista | — | Completar | Fecha + evaluador | | RF-09 | Pendiente | |
| CA-ENT-06 | Entrevista | — | Resultado | Impacta pipeline | | RF-09 | Pendiente | |
| CA-OCC-01 | Ocupacional | — | Generar solicitud | Doc Evaluacion | | RF-10 | Pendiente | |
| CA-OCC-02 | Ocupacional | — | IPS, canal, tipos | Campos llenos | | RF-10 | Pendiente | |
| CA-OCC-03 | Ocupacional | — | Adjunto solicitud | OK | | RF-10 | Pendiente | |
| CA-OCC-04 | Ocupacional | — | Resultado IPS | Registrado | | RF-10 | Pendiente | |
| CA-OCC-05 | Ocupacional | — | Clasificación | apt / not_apt / restricciones | | RF-11 | Pendiente | |
| CA-OCC-06 | Ocupacional | — | Expediente | Visible decisión | | RF-11 | Pendiente | |
| CA-DEC-01 | Decisión | Rol contratación | Registrar decisión | Guardado | | RF-12 | Pendiente | |
| CA-DEC-02 | Decisión | — | Opciones mínimas | continuar/espera/rechazo/contratación | | RF-12 | Pendiente | |
| CA-DEC-03 | Decisión | — | Justificación | Opcional | | RF-12 | Pendiente | |
| CA-DEC-04 | Decisión | — | Guardar | Estado consistente | | RF-12 | Pendiente | |
| CA-DEC-05 | Decisión | — | Auditoría | Fecha + responsable | | RF-18 | Pendiente | |
| CA-IND-ORG-01 | Ind. org. | — | Avance por candidato | Doc Induccion Org. | | RF-13 | Pendiente | |
| CA-IND-ORG-02 | Ind. org. | — | Ítems RFT | Campos/checklist | | RF-13 | Pendiente | |
| CA-IND-ORG-03 | Ind. org. | — | Estados ítem | pending/in_progress/completed | | RF-13 | Pendiente | |
| CA-IND-ORG-04 | Ind. org. | — | Registro | Fecha + responsable | | RF-13 | Pendiente | |
| CA-IND-ORG-05 | Ind. org. | — | Constancia | Adjunto | | RF-13 | Pendiente | |
| CA-IND-FUN-01 | Ind. fun. | — | Manual funciones | Campo | | RF-14 | Pendiente | |
| CA-IND-FUN-02 | Ind. fun. | — | Cronograma | Campo | | RF-14 | Pendiente | |
| CA-IND-FUN-03 | Ind. fun. | — | Teórica + práctica | Campos | | RF-14 | Pendiente | |
| CA-IND-FUN-04 | Ind. fun. | — | Material teórico | Adjunto | | RF-14 | Pendiente | |
| CA-IND-FUN-05 | Ind. fun. | — | Práctica | Obs + evidencias | | RF-15 | Pendiente | |
| CA-IND-FUN-06 | Ind. fun. | — | Expediente | Visible avance | | RF-14 | Pendiente | |
| CA-EPP-01 | EPP | — | Registrar entrega | Doc EPP | | RF-16 | Pendiente | |
| CA-EPP-02 | EPP | — | Ítems, fecha, responsable, constancia | Campos | | RF-16 | Pendiente | |
| CA-EPP-03 | EPP | Sin EPP confirmado | Habilitar práctica | Error hook | | RN-08 | Pendiente | |
| CA-EPP-04 | EPP | — | Expediente | Visible estado EPP | | RF-16 | Pendiente | |
| CA-SEG-01 | Seguridad | Usuario sin rol | Acciones críticas | Denegado | | RF-19 | Pendiente | |
| CA-SEG-02 | Seguridad | Candidato | Solo portal permitido | OK | | RF-19 | Pendiente | |
| CA-SEG-03 | Seguridad | API pública | Sin obs. internas | OK | | RN-05 | Pendiente | |
| CA-SEG-04 | Seguridad | — | Acción crítica | Usuario en log | | RN-10 | Pendiente | |
| CA-TRA-01 | Trazabilidad | — | Flujo completo | Timeline | | RF-18 | Pendiente | |
| CA-TRA-02 | Trazabilidad | — | Cambio estado | Fecha + responsable | | RF-18 | Pendiente | |
| CA-TRA-03 | Trazabilidad | — | Nueva info | Visible listas | | RF-20 | Pendiente | |
| CA-TRA-04 | Trazabilidad | — | Seguimiento | Sin Excel externo | | RF-20 | Pendiente | |
| CA-UI-01 | UI | Desk | Workspace/módulo Selección | Visible | | — | Pendiente | |
| CA-UI-02 | UI | Desk | DocTypes bajo módulo propio | OK | | — | Pendiente | |
| CA-UI-03 | UI | Desk | Expediente/branding | Distinto HRMS | | — | Pendiente | |
| CA-UI-04 | UI | Web | `/seleccion` | Sin shell Desk | | — | Pendiente | |
| CA-UI-05 | UI | Docs usuario | Diferencia módulos | Manual | | — | Pendiente | |

## Ejemplo Given / When / Then (CA-DUP-01)

- **Given** una vacante publicada y una Postulacion `SEL-00001` activa con cédula `123`.  
- **When** el sistema intenta crear otra Postulacion misma vacante y cédula en estado activo.  
- **Then** se rechaza con mensaje de duplicado y no persiste el segundo registro.

## Referencia

- Matriz RFT: [ciclo-vida-rft.md](ciclo-vida-rft.md)  
- UAT piloto: [../operaciones/uat-pwd-checklist.md](../operaciones/uat-pwd-checklist.md)
