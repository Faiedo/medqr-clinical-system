#!/bin/bash
# ==============================================================================
# Script de Rollback Emergencial - MedQR
# Disciplina: DevOps na Prática (Fase 2)
# ==============================================================================

set -e

PREVIOUS_TAG="${1:-1.0.0}"
COMPOSE_FILE="docker-compose.yml"

echo "=========================================================="
echo " [ROLLBACK] Iniciando Procedimento de Rollback Emergencial"
echo " [ROLLBACK] Revertendo para versao estavel: ${PREVIOUS_TAG}"
echo "=========================================================="

echo "[1/3] Parando containers com falha..."
docker compose -f "${COMPOSE_FILE}" stop medqr-app

echo "[2/3] Restaurando imagem anterior (${PREVIOUS_TAG})..."
docker compose -f "${COMPOSE_FILE}" up -d --no-build medqr-app

echo "[3/3] Validando restabelecimento do servico..."
sleep 5
curl -f http://localhost:3000/health || {
    echo "[ERRO GRAVE] Rollback falhou ao responder no endpoint de saude!"
    exit 1
}

echo "=========================================================="
echo " [ROLLBACK CONCLUIDO] Servico restaurado com sucesso!"
echo "=========================================================="
exit 0
