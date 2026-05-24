# Configuración flujo estándar HRMS (reclutamiento)

Orden recomendado para dejar operativo el núcleo **antes** de `rrhh_seleccion`.

## 1. Hiring Settings

**HR Settings** → sección Hiring (según versión):

- Activar controles de vacantes con Staffing Plan si la empresa los usa.

## 2. Maestros

1. **Company** (si no existe).  
2. **Department** por área.  
3. **Designation** por cargo.  
4. **Staffing Plan** (opcional) por compañía/ejercicio.

## 3. Job Opening

1. Nuevo Job Opening: título, Designation, Department.  
2. Estado **Open** → publicar en web: **Publish on website**.  
3. Cerrar: estado **Closed** (no se crean nuevos Job Applicant).

## 4. Job Portal

- URL pública: `https://<sitio>/jobs`.  
- El candidato aplica → se crea **Job Applicant** con Source *Website Listing*.

## 5. Interview Round

1. Crear **Interview Round** (nombre, Interview Type, entrevistadores, skillset esperado).  
2. Opcional: filtrar por Designation.

## 6. Interview

- Desde Job Applicant o Interview Round → **Interview** → programar → **Interview Feedback**.

## 7. Job Offer

- Tras selección: **Job Offer** contra Job Applicant → estados Awaiting Response / Accepted / Rejected.

## 8. Employee Onboarding

1. **Employee Onboarding Template** por Department/Designation con actividades (legal, IT, bienvenida).  
2. Tras contratación: **Employee Onboarding** enlazado a Job Applicant / Employee → genera **Project** y **Tasks** (según documentación HRMS).

## Integración con `rrhh_seleccion`

- `Postulacion` enlaza **1:1** con Job Applicant (campo `job_applicant`).  
- Estados de pipeline (`proceso_estado`) se sincronizan con hitos de Interview / Job Offer mediante hooks o actualización manual en primera versión.
