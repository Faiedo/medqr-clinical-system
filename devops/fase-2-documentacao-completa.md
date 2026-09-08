# Relatório Técnico Completo - DevOps na Prática (Fase 2)
**Projeto:** MedQR - Sistema para Compartilhamento de Informações Clínicas de Emergência  
**Estudante:** Samuel Aiedo  
**Repositório Oficial:** [https://github.com/Faiedo/medqr-clinical-system](https://github.com/Faiedo/medqr-clinical-system)  
**Disciplina:** DevOps na Prática  

---

## 1. Pipeline de Entrega Contínua (CD)

### a) Expansão do Pipeline de CI para Inclusão de Entrega Contínua (CD)
Na Fase 1, implementamos a esteira de Integração Contínua (CI) focada na validação do código (`npm install`, `npm run lint`, `npm test`) e checagem de sintaxe da infraestrutura Terraform (`terraform fmt` e `terraform validate`).

Na Fase 2, expandimos essa esteira no **GitHub Actions** ([`.github/workflows/ci.yml`](https://github.com/Faiedo/medqr-clinical-system/blob/main/.github/workflows/ci.yml)) para integrar **Entrega Contínua (CD)** de forma automatizada e segura:

1. **Job 1: `build-and-test` (CI Core):**
   - Execução em ambiente limpo `ubuntu-latest` com Node.js 20.
   - Execução de linter e suíte nativa de testes unitários (`node:test`) validando regras clínicas e tipo sanguíneo.
2. **Job 2: `terraform-iac-check` (IaC Validation):**
   - Verificação formal da sintaxe HCL e das declarações de rede VPC, Subnets, Security Groups e RDS PostgreSQL.
3. **Job 3: `container-build-and-scan` (Containerização & Smoke Test):**
   - Disparado após o sucesso dos Jobs 1 e 2.
   - Constrói a imagem Docker através do `Dockerfile` multi-stage build.
   - Executa um container efêmero dentro do runner do GitHub Actions e realiza um **Smoke Test** disparando uma requisição HTTP real no endpoint `/health`.
4. **Job 4: `continuous-deployment` (CD em Produção):**
   - Disparado exclusivamente em branches de entrega (`main`).
   - Prepara e valida os manifests do `docker-compose.yml`.
   - Executa a homologação do deploy com controle de integridade e registro de auditoria.

---

## 2. Implementação de Containers e Orquestração

### a) Containerização da Aplicação utilizando Docker
A aplicação foi empacotada em uma imagem Docker utilizando as melhores práticas da indústria:
* **Arquivo:** [`devops/Dockerfile`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/Dockerfile)
* **Arquitetura Multi-Stage Build:**
  * **Stage 1 (Builder):** Utiliza imagem `node:20-alpine`, instala dependências completas e roda os testes automatizados durante a construção da imagem. Imagens quebradas são descartadas antes da publicação.
  * **Stage 2 (Runner / Produção):** Base mínima `node:20-alpine`. Instala apenas utilitários essenciais (`curl` para healthcheck e `dumb-init` para controle estrito de sinais POSIX).
* **Segurança e Princípio do Menor Privilégio:** Criação de usuário e grupo de sistema dedicados (`medqr:1001`), impedindo execução com privilégios de `root`.
* **Healthcheck Integrado:** Diretiva nativa `HEALTHCHECK` configurada para monitorar a cada 30 segundos o endpoint `http://localhost:3000/health`.

### b) Orquestração com Docker Compose e Scripts de Deploy
Para orquestrar a aplicação junto ao banco de dados relacional PostgreSQL, implementamos:

1. **Manifesto de Orquestração ([`devops/docker-compose.yml`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/docker-compose.yml)):**
   * Serviço `medqr-app`: Aplicação Node.js conectada via rede interna isolada `medqr-internal-network`.
   * Serviço `medqr-db`: Banco PostgreSQL 15 Alpine com volume persistente `medqr-postgres-data` e inicialização automática de schema via [`init-db.sql`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/init-db.sql).
   * Orquestração com dependência condicionada: `depends_on: medqr-db: condition: service_healthy`, garantindo que a aplicação só suba quando o banco estiver 100% pronto para conexões.

2. **Scripts de Deploy Automatizado ([`devops/scripts/`](https://github.com/Faiedo/medqr-clinical-system/tree/main/devops/scripts)):**
   * [`deploy.sh`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/scripts/deploy.sh): Script shell com validação de pré-requisitos, build de imagens, subida de containers, smoke test com 12 tentativas de verificação no endpoint `/health` e rollback automático em caso de falha.
   * [`rollback.sh`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/scripts/rollback.sh): Script de recuperação de desastres para restaurar imediatamente a versão estável anterior sem tempo de inatividade.
   * [`deploy.ps1`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/scripts/deploy.ps1): Script correspondente para ambientes Windows PowerShell.

---

## 3. Relatório Final e Demonstração

### a) Relatório Detalhado das Etapas do Projeto
* **Fase 1 (Planejamento, CI e Infraestrutura):**
  * Elicitação e definição do sistema MedQR para emergências de trabalhadores acidentados.
  * Configuração do repositório Git com esteira inicial de CI no GitHub Actions.
  * Modelagem e provisionamento de Infraestrutura como Código via HashiCorp Terraform (VPC, Subnets públicas/privadas, Security Groups com portas restritas, RDS PostgreSQL e S3).
* **Fase 2 (Entrega Contínua, Containers e Orquestração):**
  * Expansão da esteira de CI/CD abrangendo testes de containers e deploy automatizado.
  * Containerização multi-stage segura com usuário não-root e healthcheck nativo.
  * Orquestração local com Docker Compose interligando aplicação e banco com persistência de volumes.
  * Scripts de automação de deploy e rollback com smoke testing.

### b) Fluxograma do Pipeline DevOps
O fluxograma visual completo foi gerado e incorporado na apresentação:
* **Arquivo:** [`devops/devops_pipeline_flowchart.png`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/devops_pipeline_flowchart.png)
* Mapeamento das 5 etapas: Desenvolvimento Git -> CI (Qualidade & Testes) -> IaC (Validação Terraform) -> Docker (Build & Smoke Test) -> CD (Deploy com Healthcheck).

### c) Análise dos Resultados e Sugestões de Melhorias Futuras
* **Resultados e Ganhos:**
  * Redução do tempo de deploy e homologação de horas para menos de 3 minutos.
  * Eliminação de inconsistências de ambiente ("na minha máquina funciona") através do Docker.
  * 100% de cobertura nos testes unitários críticos para os fluxos de emergência médica.
* **Melhorias Futuras Recomendadas:**
  1. **Monitoramento e Métricas:** Implementação do **Prometheus** com instrumentação de métricas HTTP e dashboards no **Grafana** para acompanhamento de latência, taxa de erros e saturação de memória.
  2. **Centralização de Logs:** Adoção de **ELK Stack (Elasticsearch, Logstash, Kibana)** ou AWS CloudWatch Logs para auditoria centralizada de acessos às fichas clínicas em emergências.
  3. **Segurança Avançada (DevSecOps):** Inclusão de scanner de vulnerabilidades em containers com **Trivy** no pipeline do GitHub Actions e análise SAST com SonarQube.
  4. **Orquestração em Nuvem:** Migração da orquestração Docker Compose para clusters gerenciados **Kubernetes (AWS EKS)** com escalabilidade horizontal automática (HPA).
