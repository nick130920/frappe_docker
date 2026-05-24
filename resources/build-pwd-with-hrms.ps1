# Construye imagen ERPNext + HRMS para usar con pwd.yml y pwd-hrms.env
# Ejecutar desde la raíz del repo frappe_docker:
#   .\resources\build-pwd-with-hrms.ps1

$ErrorActionPreference = "Stop"
# Este script vive en resources/; la raíz del repo es el directorio padre.
$RepoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $RepoRoot

if (-not (Test-Path ".\apps.json")) {
    Write-Error "No se encuentra apps.json en la raíz del repositorio."
}

docker build `
    --no-cache `
    --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe `
    --build-arg=FRAPPE_BRANCH=version-16 `
    --secret=id=apps_json,src=apps.json `
    --tag=local/erpnext-hrms:16 `
    --file=images/layered/Containerfile `
    .

if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Imagen local/erpnext-hrms:16 lista. Siguiente paso:"
Write-Host "  docker compose --env-file pwd-hrms.env -f pwd.yml up -d"
Write-Host "Sitio ya existente (frontend): alinear DB y apps, luego HRMS:"
Write-Host "  docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bench --site frontend migrate"
Write-Host "  docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bench --site frontend install-app hrms"
Write-Host "  docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bench --site frontend install-app rrhh_seleccion"
Write-Host "Si falló una vez a medias: install-app hrms --force"
Write-Host "Tras instalar rrhh_seleccion: bench --site frontend migrate"
Write-Host "Assets (CSS/logo) en pwd.yml: nginx usa el contenedor FRONTEND; ejecuta build en backend Y frontend:"
Write-Host "  docker compose --env-file pwd-hrms.env -f pwd.yml exec backend bench --site frontend build --app rrhh_seleccion"
Write-Host "  docker compose --env-file pwd-hrms.env -f pwd.yml exec frontend bench --site frontend build --app rrhh_seleccion"
