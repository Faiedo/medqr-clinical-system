# MedQR - Sistema para Compartilhamento de Informações Clínicas

Sistema corporativo para gerenciamento e compartilhamento seguro de informações médicas de emergência para trabalhadores acidentados via QR Code dinâmico e autenticação por senha pública.

---

## 🎯 Visão Geral do Projeto

Durante a jornada de trabalho, acidentes demandam atendimento médico ágil. Muitas vezes contatos de emergência e dados clínicos vitais (tipo sanguíneo, alergias, medicações em uso) estão desatualizados. 

O **MedQR** permite que o próprio trabalhador registre seus dados de saúde, gere um QR Code exclusivo para impressão no verso de seu crachá e defina uma senha de acesso público. Em caso de emergência médica, socorristas escaneiam o QR Code e utilizam a senha impressa no crachá para visualizar imediatamente os dados vitais do acidentado em uma interface otimizada para celulares.

---

## 🏗️ Estrutura do Repositório

```
docs-fac/
├── des-proj/                              # Disciplina Integradora de Desenvolvimento de Projetos
│   ├── app/                               # Aplicação Frontend com as 4 telas interativas
│   │   └── index.html                     # SPA interativa (Login, Formulário, Crachá QR, Socorrista)
│   ├── eap_diagram.png                    # Diagrama gráfico da EAP (4 níveis)
│   ├── der_diagram.png                    # Diagrama Entidade-Relacionamento do Banco de Dados
│   ├── roadmap_diagram.png                # Cronograma visual de entregas por Sprints
│   └── fase-1-documentacao-completa.md    # Documentação de Requisitos, User Stories e EAP
│
└── devops/                                # Disciplina DevOps na Prática
    ├── .github/workflows/
    │   └── ci.yml                         # Pipeline de Integração Contínua (GitHub Actions)
    ├── src/
    │   └── index.js                       # Módulo Core de validação clínica
    ├── tests/
    │   └── medqr.test.js                  # Suíte de testes automatizados unitários
    ├── terraform/                         # Infraestrutura como Código (IaC AWS)
    │   ├── main.tf                        # Provedor AWS e tags padrão
    │   ├── variables.tf                   # Variáveis de ambiente, região e banco
    │   ├── vpc.tf                         # VPC, Subnets Públicas/Privadas e Internet Gateway
    │   └── resources.tf                   # Security Groups, RDS PostgreSQL 15 e S3
    ├── package.json                       # Scripts npm (lint, test, build)
    └── fase-1-documentacao-completa.md    # Documentação de planejamento de CI e Nuvem
```

---

## 🧪 Como Executar os Testes Automatizados

```bash
cd devops
npm test
```

## 🚀 Pipeline de Integração Contínua (CI)

O workflow automatizado no **GitHub Actions** (`.github/workflows/ci.yml`) executa a cada push/pull request:
1. Setup do ambiente Node.js 20.x
2. Instalação de dependências (`npm ci`)
3. Verificação de linters (`npm run lint`)
4. Execução de testes automatizados (`npm test`)
5. Build dos artefatos da aplicação (`npm run build`)
6. Validação de sintaxe e formatação do Terraform (`terraform fmt` & `terraform validate`)

---

## 👨‍💻 Autor e Colaboração

* **Estudante:** Samuel Aiedo
* **Tutora Colaboradora:** `biancacamargomachado`
