# Documentação de Planejamento e Automação Inicial - Fase 1
## Disciplina: DevOps na Prática

**Projeto:** MedQR - Pipeline de CI e Infraestrutura como Código (IaC)  
**Estudante:** Samuel Aiedo  
**Repositório GitHub:** `https://github.com/samuelaiedo/medqr-clinical-system`  

---

### 1. Documentação de Planejamento

#### 1.1. Descrição do Projeto, Objetivos e Requisitos
O **MedQR** é um sistema web e mobile voltado ao compartilhamento seguro de informações médicas de emergência para trabalhadores acidentados. O sistema permite o cadastro de fichas médicas vitais (tipo sanguíneo, alergias, medicamentos, contatos de emergência) e gera um QR Code único protegido por senha de acesso público para consulta rápida por socorristas.

**Objetivos da Fase 1 de DevOps:**
- Garantir a confiabilidade do código através da automação de builds e testes a cada modificação no código-fonte.
- Padronizar o ambiente de infraestrutura através do modelo de Infraestrutura como Código (IaC), permitindo provisionar a arquitetura em nuvem (VPC, Subnets, Segurança, Banco PostgreSQL e Storage S3) de forma reproduzível e declarativa.

**Requisitos de DevOps:**
1. **Controle de Versão:** Uso de Git/GitHub com branching model estruturado (`main`, `develop`, `feature/*`).
2. **Integração Contínua:** Workflow automatizado no GitHub Actions para validação sintática, testes e build.
3. **Infraestrutura Declarativa:** Provisionamento AWS automatizado via Terraform.

#### 1.2. Plano de Integração Contínua (CI)
O plano de CI é fundamentado no **GitHub Actions** com acionamento automático por eventos de `push` e `pull_request` nos branches `main` e `develop`.

**Estágios da Pipeline de CI:**
1. **Checkout & Environment Setup:** Baixa o código fonte e configura a versão do Node.js (v20.x) e o ambiente HashiCorp Terraform.
2. **Dependency Management:** Executa `npm ci` para instalar dependências exatas a partir do `package-lock.json`.
3. **Code Quality & Linting:** Roda linters estáticos (`npm run lint`) para assegurar que os padrões de código e boas práticas sintáticas sejam mantidos.
4. **Automated Testing:** Executa os testes unitários e de integração (`npm test`), interrompendo a pipeline imediatamente em caso de falha de teste.
5. **Build Automation:** Executa `npm run build` para garantir que o artefato final compila sem erros.
6. **IaC Validation:** Executa `terraform fmt -check` e `terraform validate` nos scripts de infraestrutura para evitar inconsistências nos ambientes de nuvem.

#### 1.3. Especificação Detalhada da Infraestrutura Necessária
A infraestrutura foi desenhada para a nuvem AWS (Amazon Web Services), seguindo o *AWS Well-Architected Framework*:

- **Rede (VPC & Subnets):**
  - 1 VPC isolada (`10.0.0.0/16`) com suporte a DNS e Hostnames.
  - 2 Subnets Públicas (`10.0.1.0/24` em `us-east-1a` e `10.0.2.0/24` em `us-east-1b`) para o Application Load Balancer / Serviço Web.
  - 2 Subnets Privadas (`10.0.10.0/24` e `10.0.11.0/24`) para isolar a camada de dados (PostgreSQL).
  - Internet Gateway (IGW) e Tabelas de Roteamento (*Route Tables*) para o tráfego público.
- **Camada de Aplicação (Web App):**
  - Security Group dedicado liberando portas HTTP (80), HTTPS (443) e porta da aplicação (3000).
- **Camada de Dados (Banco de Dados PostgreSQL):**
  - Instância gerada AWS RDS PostgreSQL (versão 15.4, classe `db.t3.micro`).
  - Isolação em Subnets Privadas com Security Group aceitando conexões na porta 5432 **exclusivamente** oriundas da camada Web.
- **Camada de Armazenamento (Storage):**
  - Bucket AWS S3 (`medqr-app-assets-storage-2026`) para hospedagem segura de imagens de QR Codes e assets estáticos.

---

### 2. Pipeline de Integração Contínua (CI)

#### 2.1. Configuração do Repositório
- **URL do Repositório:** `https://github.com/samuelaiedo/medqr-clinical-system`
- **Configuração de Segurança:** Proteção do branch `main`, exigindo que a pipeline de CI passe com 100% de sucesso antes de permitir o merge de Pull Requests.

#### 2.2. Implementação com GitHub Actions
Arquivo de workflow localizado em `.github/workflows/ci.yml`:
```yaml
name: MedQR Continuous Integration (CI) Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20.x'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint --if-present
      - run: npm test --if-present
      - run: npm run build --if-present

  terraform-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terraform fmt -check -recursive devops/terraform
      - run: |
          cd devops/terraform
          terraform init -backend=false
          terraform validate
```

---

### 3. Scripts de Infraestrutura como Código (IaC)

A automação da infraestrutura foi desenvolvida com **Terraform** e dividida em módulos no diretório `devops/terraform/`:

1. **`main.tf`:** Declaração do provedor `hashicorp/aws` versão `~> 5.0` e tags padrão (`Project: MedQR`, `Environment: production`).
2. **`variables.tf`:** Definição parametrizada de variáveis como `aws_region` (`us-east-1`), `vpc_cidr` (`10.0.0.0/16`), dados do banco (`db_name`, `db_username`).
3. **`vpc.tf`:** Definição completa dos recursos de rede (VPC, Subnets Públicas 1 e 2, Subnets Privadas 1 e 2, Internet Gateway e Route Tables).
4. **`resources.tf`:** Declaração dos Security Groups (`medqr-web-sg` e `medqr-db-sg`), da instância PostgreSQL RDS (`aws_db_instance.postgres`) e do Bucket AWS S3 (`aws_s3_bucket.medqr_assets`).

---

### 4. Evidências de Validação dos Scripts Terraform

Os scripts foram inicializados e validados localmente com sucesso:
- `terraform fmt`: Código formatado no padrão HCL.
- `terraform validate`: Sintaxe e dependências internas validadas com 0 erros.
