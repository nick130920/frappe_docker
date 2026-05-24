# Validación piloto HRMS (sitio `frontend`)

Checklist para confirmar que el stack `pwd.yml` + imagen `local/erpnext-hrms:16` (o `frappe/erpnext` + HRMS instalado) está listo antes de instalar `rrhh_seleccion`.

## 1. Servicios

```bash
docker compose --env-file pwd-hrms.env -f pwd.yml ps
```

- `backend`, `frontend`, `websocket`, `scheduler`, colas: estado `Up`.
- `db`: `healthy`.

## 2. Job Portal público

- Abrir `http://localhost:8080/jobs` (ajustar host/puerto si aplica).
- Debe cargar el portal de empleos de Frappe HR sin error 502.

## 3. Desk y módulos HR

- Login `Administrator` / contraseña del sitio.
- Menú: **Human Resources** visible.
- Rutas: Recruitment → Job Opening, Job Applicant, Interview.

## 4. Maestros mínimos

Crear o verificar (Setup / HR):

| Maestro        | Uso                          |
| -------------- | ------------------------------ |
| Company        | Obligatorio para Job Opening   |
| Department     | Job Opening                    |
| Designation    | Job Opening, Staffing Plan     |
| Staffing Plan  | Opcional según Hiring Settings |

## 5. Roles base

- `HR Manager`, `HR User` existen tras instalar HRMS.
- Los roles custom `RRHH_Gestion`, `RRHH_Revision`, etc. se crean al instalar `rrhh_seleccion` (fixtures).

## Resultado

- [ ] Portal `/jobs` OK  
- [ ] Desk HR accesible  
- [ ] Maestros mínimos creados  
- [ ] Listo para `bench --site frontend install-app rrhh_seleccion`
