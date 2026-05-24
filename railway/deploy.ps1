# Ayuda para desplegar en Railway (requiere railway login)
# Uso: .\railway\deploy.ps1

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $RepoRoot

Write-Host "=== Railway — ERPNext HRMS + rrhh_seleccion ===" -ForegroundColor Cyan
Write-Host ""

$whoami = railway whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "No hay sesion Railway. Ejecuta:" -ForegroundColor Yellow
    Write-Host "  railway login"
    Write-Host ""
    Write-Host "Luego:" -ForegroundColor Yellow
    Write-Host "  1. Publica la imagen (GitHub Actions: railway-image.yml)"
    Write-Host "  2. Importa railway/docker-compose.railway.yml en el dashboard"
    Write-Host "  3. Lee docs/rrhh/infra/deploy-railway.md"
    exit 1
}

Write-Host "Sesion: $whoami"
Write-Host ""
Write-Host "Pasos recomendados (dashboard):" -ForegroundColor Green
Write-Host "  1. New Project -> Empty"
Write-Host "  2. Arrastrar railway/docker-compose.railway.yml al canvas"
Write-Host "  3. Variables: MYSQL_ROOT_PASSWORD, FRAPPE_ADMIN_PASSWORD, ERPNext_HRMS_IMAGE"
Write-Host "  4. Volumen sites en todos los servicios Frappe (mismo mount path)"
Write-Host "  5. Dominio publico solo en 'frontend' puerto 8080"
Write-Host "  6. Ejecutar configurator -> create-site -> resto de servicios"
Write-Host ""
Write-Host "Documentacion completa: docs/rrhh/infra/deploy-railway.md"
Write-Host ""

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker no encontrado; omitiendo build local." -ForegroundColor Yellow
    exit 0
}

$build = Read-Host "Construir imagen local ahora? (s/N)"
if ($build -match '^[sSyY]') {
    git submodule update --init --recursive
    docker build -f railway/Dockerfile -t ghcr.io/nick130920/erpnext-hrms:railway .
    Write-Host "Imagen lista. Sube con: docker push ghcr.io/nick130920/erpnext-hrms:railway" -ForegroundColor Green
}
