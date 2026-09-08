<#
.SYNOPSIS
    Script PowerShell de Deploy Automatizado para MedQR em Windows
.DESCRIPTION
    Executa o build, orquestração e smoke test com validação de saúde do container
#>

param (
    [string]$ImageTag = "2.0.0",
    [string]$HealthCheckUrl = "http://localhost:3000/health"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " [DEPLOY POWERSHELL] Iniciando Entrega Contínua (CD) MedQR" -ForegroundColor Cyan
Write-Host " Versão: $ImageTag | Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Checar Docker
Write-Host "`n[ETAPA 1/4] Verificando Docker no sistema..." -ForegroundColor Yellow
docker --version
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker não está em execução ou não foi encontrado."
    exit 1
}

# 2. Orquestração com Compose
Write-Host "`n[ETAPA 2/4] Executando build e subindo containers..." -ForegroundColor Yellow
docker compose up -d --build --remove-orphans

# 3. Healthcheck
Write-Host "`n[ETAPA 3/4] Aguardando inicialização e validando endpoint /health..." -ForegroundColor Yellow
$attempts = 0
$maxAttempts = 12
$healthy = $false

do {
    Start-Sleep -Seconds 4
    $attempts++
    Write-Host "  -> Verificação $attempts de $maxAttempts..." -NoNewline
    try {
        $response = Invoke-RestMethod -Uri $HealthCheckUrl -Method Get -TimeoutSec 3 -ErrorAction SilentlyContinue
        if ($response.status -eq "UP") {
            Write-Host " [OK 200] Aplicação Saudável!" -ForegroundColor Green
            $healthy = $true
            break
        }
    } catch {
        Write-Host " [Aguardando]" -ForegroundColor DarkGray
    }
} while ($attempts -lt $maxAttempts)

# 4. Conclusão
if ($healthy) {
    Write-Host "`n==========================================================" -ForegroundColor Green
    Write-Host " [SUCESSO] Deploy do MedQR realizado com êxito!" -ForegroundColor Green
    Write-Host " URL: http://localhost:3000" -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green
} else {
    Write-Host "`n[FALHA] Falha no teste de integridade. Verifique os logs." -ForegroundColor Red
    docker compose logs
    exit 1
}
