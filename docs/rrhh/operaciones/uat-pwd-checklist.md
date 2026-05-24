# UAT piloto (`pwd.yml` + sitio `frontend`)

## Preparación

1. Imagen con `rrhh_seleccion` construida y contenedores recreados.
2. `bench --site frontend install-app rrhh_seleccion` + `migrate` ejecutados.
3. Maestros HR: Company, Department, Designation (ver [validate-pilot.md](../infra/validate-pilot.md)).

## Casos mínimos

| # | Acción | Resultado esperado |
|---|--------|---------------------|
| 1 | Crear Job Opening publicada | Visible en `/jobs` |
| 2 | Crear Job Applicant desde portal o Desk | Registro creado |
| 3 | Crear **Postulacion** enlazada al applicant, mismo opening y cédula duplicada activa | Error “Duplicado” |
| 4 | Segundo Job Applicant mismo email + opening (estado activo) | Error en validate |
| 5 | Cambiar `proceso_estado` en Postulacion | Fila en tabla historial |
| 6 | Entrega EPP `estado_entrega=confirmed`, luego Induccion Funcional `fase_practica_habilitada=1` | OK |
| 7 | Induccion Funcional `fase_practica_habilitada=1` sin EPP confirmado | Error validación |
| 8 | GET API consultar con código SEL- | JSON con estado y documentos (sin obs. interna) |

## Roles

- Asignar `RRHH_*` a usuarios de prueba y repetir permisos sobre DocTypes si aplica.

## Cierre

- Registrar hallazgos y adjuntar capturas en la plantilla [criterios-aceptacion.md](../producto/criterios-aceptacion.md).
