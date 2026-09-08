# ==============================================================================
# Dockerfile Multi-Stage para o MedQR - Sistema de Informações Clínicas
# Disciplina: DevOps na Prática (Fase 2)
# ==============================================================================

# ------------------------------------------------------------------------------
# Stage 1: Builder / Test Stage
# ------------------------------------------------------------------------------
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

# Copia arquivos de definicao de pacotes
COPY package*.json ./

# Instala dependencias para build e testes
RUN npm install

# Copia codigo fonte e testes
COPY src/ ./src/
COPY tests/ ./tests/

# Executa suite de testes automatizados dentro do container durante o build
RUN npm test

# ------------------------------------------------------------------------------
# Stage 2: Production Minimal Image
# ------------------------------------------------------------------------------
FROM node:20-alpine AS runner

LABEL maintainer="Samuel Aiedo <samuel.aiedo@fueltech.com.br>"
LABEL description="MedQR Clinical System - Production Container"
LABEL version="2.0.0"

# Instala utilitarios leves para seguranca e healthcheck
RUN apk add --no-cache dumb-init curl

# Define variaveis de ambiente de producao
ENV NODE_ENV=production \
    PORT=3000 \
    APP_DIR=/usr/src/app

WORKDIR ${APP_DIR}

# Cria usuario e grupo nao-root para execucao segura (Principio do Menor Privilegio)
RUN addgroup -g 1001 -S medqr && \
    adduser -u 1001 -S medqr -G medqr

# Copia manifestos e instala apenas dependencias de producao
COPY package*.json ./
RUN npm install --only=production && \
    npm cache clean --force

# Copia o codigo validado do estagio anterior
COPY --from=builder --chown=medqr:medqr /usr/src/app/src/ ./src/

# Ajusta permissoes do diretorio de trabalho
RUN chown -R medqr:medqr ${APP_DIR}

# Define o usuario nao-root
USER medqr

# Expe a porta da aplicacao
EXPOSE 3000

# Healthcheck nativo do Docker para checagem periodica de saude
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# dumb-init gerencia sinais POSIX (SIGTERM/SIGINT) para encerramento gracioso
ENTRYPOINT ["dumb-init", "--"]

# Comando padrao de inicializacao
CMD ["node", "src/index.js"]
