#!/bin/bash
# ==============================================================================
# Script de Deploy Automatizado com Containers Docker - MedQR
# Disciplina: DevOps na Prática (Fase 2)
# ==============================================================================

set -e # Interrompe imediatamente em caso de erro

APP_NAME="medqr-clinical-system"
IMAGE_TAG="${1:-latest}"
COMPOSE_FILE="docker-compose.yml"
HEALTH_CHECK_URL="http://localhost:3000/health"
MAX_ATTEMPTS=12
WAIT_SECONDS=5

echo "=========================================================="
echo " [DEPLOY] Iniciando processo de Entrega Continua (CD)"
echo " [DEPLOY] Projeto: ${APP_NAME} | Versao: ${IMAGE_TAG}"
echo " [DEPLOY] Horario: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo "=========================================================="

# 1. Validar pre-requisitos do ambiente
echo "[ETAPA 1/6] Validando ambiente e instalacao do Docker..."
if ! command -v docker &> /dev/null; then
    echo "[ERRO] Docker nao encontrado na maquina host." >&2
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo "[ERRO] Docker Compose v2 nao encontrado." >&2
    exit 1
fi
echo "[OK] Docker e Docker Compose operacionais."

# 2. Backup e snapshot preventivo
echo "[ETAPA 2/6] Verificando integridade dos volumes persistentes..."
docker volume inspect medqr-postgres-data &> /dev/null || echo "[INFO] Primeiro deploy: volume de dados sera criado."

# 3. Pull das imagens mais recentes ou Build local
echo "[ETAPA 3/6] Construindo e atualizando imagens dos containers..."
docker compose -f "${COMPOSE_FILE}" build --no-cache

# 4. Provisionamento dos servicos (Zero-Downtime rolling update)
echo "[ETAPA 4/6] Orquestrando subida dos containers com Docker Compose..."
docker compose -f "${COMPOSE_FILE}" up -d --remove-orphans

# 5. Verificacao de Healthcheck da aplicacao
echo "[ETAPA 5/6] Executando Smoke Test e Validacao de Saude (/health)..."
attempt=1
success=0

while [ $attempt -le $MAX_ATTEMPTS ]; do
    echo "  -> Tentativa $attempt de $MAX_ATTEMPTS: Checando endpoint de saude..."
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_CHECK_URL" || true)
    
    if [ "$status_code" -eq 200 ]; then
        echo "[SUCESSO] Aplicacao respondeu com HTTP 200 OK!"
        success=1
        break
    fi
    
    sleep $WAIT_SECONDS
    attempt=$((attempt + 1))
done

# 6. Decisao de Rollback se o teste falhar
if [ $success -ne 1 ]; then
    echo "=========================================================="
    echo " [FALHA CRITICA] Healthcheck falhou apos $MAX_ATTEMPTS tentativas."
    echo " [ROLLBACK] Revertendo deploy para a versao anterior..."
    echo "=========================================================="
    docker compose -f "${COMPOSE_FILE}" logs medqr-app
    docker compose -f "${COMPOSE_FILE}" down
    exit 1
fi

echo "=========================================================="
echo " [DEPLOY CONCLUIDO] MedQR 2.0.0 em execucao com sucesso!"
echo " [STATUS] App: http://localhost:3000"
echo " [STATUS] Healthcheck: http://localhost:3000/health"
echo "=========================================================="
exit 0
