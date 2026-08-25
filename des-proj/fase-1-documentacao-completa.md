# Documentação do Projeto - Fase 1
## Disciplina Integradora de Desenvolvimento de Projetos

**Tema Escolhido:** Tema 1 - Sistema para Compartilhamento de Informações Clínicas (MedQR)  
**Estudante:** Samuel Aiedo  
**Tutora Colaboradora (GitHub):** biancacamargomachado  

---

### 1. Requisitos do Sistema

#### 1.1. Requisitos Funcionais (RF)
- **RF01 - Cadastro de Usuário:** O sistema deve permitir que o trabalhador crie uma conta fornecendo e-mail e senha de acesso.
- **RF02 - Autenticação de Usuário:** O sistema deve permitir o login seguro do usuário cadastrado para acesso ao painel de gerenciamento.
- **RF03 - Cadastro de Ficha Clínica:** O sistema deve permitir o cadastro dos dados clínicos contendo obrigatoriamente os campos: Nome, Sobrenome, Sexo, Contato de Emergência, Tipo Sanguíneo, Alergias, Medicamentos Utilizados, Doenças e Cirurgias Realizadas.
- **RF04 - Definição de Senha de Acesso Público:** O sistema deve solicitar que o trabalhador defina uma senha de acesso público para resguardar a visualização de sua ficha de emergência.
- **RF05 - Geração de QR Code:** O sistema deve gerar automaticamente um QR Code associado a uma URL pública única para a ficha clínica do trabalhador.
- **RF06 - Visualização Pública da Ficha Médica:** O sistema deve disponibilizar uma página pública de emergência acessível pelo escaneamento do QR Code.
- **RF07 - Autenticação na Página Pública:** A página pública de emergência deve solicitar obrigatoriamente a senha de acesso público antes de exibir qualquer dado clínico do trabalhador.
- **RF08 - Exclusão Definitiva da Ficha:** O sistema deve permitir que o usuário exclua completamente o seu registro clínico. Após a exclusão, a URL pública e o QR Code associado devem ficar indisponíveis (retornando erro 404/Indisponível).
- **RF09 - Exportação e Impressão do Crachá:** O sistema deve gerar um modelo impresso do QR Code contendo a instrução e o espaço demarcado para anotação/impressão da senha pública de acesso (sem embutir a senha na codificação do QR Code).
- **RF10 - Validação dos Dados Clínicos:** O sistema deve aplicar validações em tempo de inserção para proibir o salvamento de fichas clínicas com campos obrigatórios vazios ou contatos inválidos.

#### 1.2. Requisitos Não Funcionais (RNF)
- **RNF01 - Criptografia e Segurança dos Dados:** As senhas da conta e as senhas de acesso público devem ser armazenadas utilizando algoritmos de hash seguros (bcrypt / Argon2).
- **RNF02 - Interface Responsiva (Mobile-First):** A página pública de visualização de emergência deve ser 100% otimizada para telas de smartphones, visando o uso por socorristas em campo.
- **RNF03 - Tempo de Resposta e Desempenho:** A página de emergência acionada via QR Code deve carregar e responder em menos de 2 segundos.
- **RNF04 - Disponibilidade do Serviço:** O sistema deve possuir disponibilidade mínima de 99.5% (SLA) para garantir acesso ininterrupto às fichas clínicas durante emergências médicas.

---

### 2. User Stories e Critérios de Aceite (Mapeamento 1-para-1 com RF01-RF10)

* **US01 (RF01) – Cadastro de Usuário**
  * *Como* trabalhador, *quero* criar uma conta corporativa com e-mail e senha, *para* acessar a plataforma e iniciar o cadastro de minhas informações de saúde.
  * *Critérios de Aceite:*
    1. O sistema deve validar e-mail único e formato válido.
    2. A senha deve ter no mínimo 8 caracteres, contendo letras e números.
    3. Confirmação imediata na tela após a criação da conta.

* **US02 (RF02) – Autenticação e Login**
  * *Como* trabalhador cadastrado, *quero* autenticar no sistema com minhas credenciais, *para* gerenciar minha ficha médica com total segurança.
  * *Critérios de Aceite:*
    1. Autenticação validada contra hash seguro (bcrypt).
    2. Emissão de sessão/token JWT autenticado.
    3. Redirecionamento automático ao painel de controle pós-login.

* **US03 (RF03) – Preenchimento da Ficha Médica**
  * *Como* trabalhador, *quero* preencher meus dados clínicos vitais (tipo sanguíneo, alergias, contatos de emergência, medicamentos, doenças e cirurgias), *para* que socorristas tenham histórico completo em caso de acidente de trabalho.
  * *Critérios de Aceite:*
    1. Formulário com os 9 campos estruturados disponíveis.
    2. Seleção assistida de Tipo Sanguíneo (A+, O+, B-, etc.).
    3. Persistência dos dados no banco PostgreSQL vinculados ao usuário.

* **US04 (RF04) – Definição de Senha de Acesso Público**
  * *Como* trabalhador, *quero* cadastrar uma senha de acesso público independente da senha da minha conta, *para* que socorristas possam acessar meus dados vitais na emergência sem expor meu login pessoal.
  * *Critérios de Aceite:*
    1. Campo dedicado para digitação da senha de acesso público.
    2. Criptografia da senha pública em banco de dados.
    3. Possibilidade de alteração da senha pública quando necessário.

* **US05 (RF05) – Geração do QR Code**
  * *Como* trabalhador, *quero* que o sistema gere automaticamente um QR Code com link exclusivo para minha ficha, *para* colar no verso do meu crachá de trabalho.
  * *Critérios de Aceite:*
    1. Geração instantânea do QR Code apontando para a URL pública do token único.
    2. Alta resolução vetorial para leitura rápida por qualquer câmera de smartphone.

* **US06 (RF06) – Visualização Pública de Emergência**
  * *Como* socorrista, *quero* escanear o QR Code no crachá do trabalhador acidentado, *para* acessar rapidamente a página web de emergência do paciente.
  * *Critérios de Aceite:*
    1. Carregamento da página de emergência em menos de 2 segundos.
    2. Layout 100% responsivo otimizado para celulares (Mobile-First).

* **US07 (RF07) – Autenticação na Página Pública**
  * *Como* socorrista, *quero* digitar a senha pública impressa no crachá na tela de emergência, *para* liberar a exibição imediata dos dados clínicos do trabalhador.
  * *Critérios de Aceite:*
    1. Tela de bloqueio inicial exigindo a senha pública.
    2. Se a senha estiver correta, exibe em destaque: Tipo Sanguíneo, Alergias, Contato de Emergência e Medicamentos.
    3. Se a senha estiver errada, bloqueia o acesso e emite aviso de erro.

* **US08 (RF08) – Exclusão Definitiva do Registro**
  * *Como* trabalhador, *quero* poder excluir completamente meu registro clínico caso não queira mais o serviço ou saia da empresa, *para* resguardar minha privacidade (LGPD).
  * *Critérios de Aceite:*
    1. Modal de confirmação explícita de exclusão.
    2. Exclusão permanente dos dados do banco.
    3. O link público e o QR Code passam a exibir imediatamente status 404 (Registro Indisponível/Inexistente).

* **US09 (RF09) – Impressão do Crachá com QR Code**
  * *Como* trabalhador, *quero* exportar/imprimir um layout formatado com o QR Code e o espaço para anotação da senha pública, *para* fixar no verso do crachá funcional.
  * *Critérios de Aceite:*
    1. Layout nas dimensões exatas de crachás padrão (85mm x 54mm).
    2. Inclusão do QR Code e campo destacado para anotação da senha pública (sem embutir a senha no QR Code).

* **US10 (RF10) – Validação dos Dados Clínicos**
  * *Como* trabalhador, *quero* que o sistema valide o preenchimento de todos os campos obrigatórios e formatos antes de salvar, *para* garantir que minha ficha não fique incompleta.
  * *Critérios de Aceite:*
    1. Bloqueio de envio em caso de campos obrigatórios vazios.
    2. Validação sintática de telefone de emergência e e-mail.
    3. Mensagens de feedback claras ao usuário.

---

### 3. Estrutura Analítica do Projeto (EAP / WBS) em 4 Níveis

```
1.0 Sistema MedQR (Informações Clínicas)
│
├── 1.1 Gerenciamento do Projeto & Modelagem
│   ├── 1.1.1 Elicitação de Requisitos Funcionais e Não Funcionais
│   ├── 1.1.2 Mapeamento de 10 User Stories e Critérios de Aceite
│   ├── 1.1.3 Desenho do Diagrama Entidade-Relacionamento (DER)
│   └── 1.1.4 Protótipo de Alta Fidelidade no Figma
│
├── 1.2 Módulo de Autenticação e Usuários
│   ├── 1.2.1 [US01] Tela de Cadastro e Validação de Contas
│   ├── 1.2.2 [US02] Serviço de Login e Autenticação JWT
│   └── 1.2.3 Criptografia Segura de Senhas (bcrypt)
│
├── 1.3 Módulo de Gestão da Ficha Médica
│   ├── 1.3.1 [US03] Formulário de Cadastro de Dados Clínicos
│   ├── 1.3.2 [US04] Módulo de Definição de Senha de Acesso Público
│   └── 1.3.3 [US10] Validação de Integridade e Campos Obrigatórios
│
├── 1.4 Portal Público de Emergência & QR Code
│   ├── 1.4.1 [US05] Algoritmo de Geração Dinâmica de QR Code
│   ├── 1.4.2 [US06] Portal Web Responsivo para Socorristas
│   └── 1.4.3 [US07] Autenticação e Desbloqueio por Senha Pública
│
└── 1.5 Ações Finais, Implantação e Encerramento
    ├── 1.5.1 [US09] Módulo de Impressão de Crachá com QR Code
    ├── 1.5.2 [US08] Mecanismo de Exclusão Definitiva (Retorno 404)
    ├── 1.5.3 Testes Automatizados Unitários e Integração
    └── 1.5.4 Deploy e Publicação em Produção
```

---

### 4. Roadmap do Projeto (Cronograma por Sprints)

| Sprint | Período Estimado | Principais Entregas e Foco |
| :--- | :--- | :--- |
| **Sprint 1** | 11/08 a 24/08/2026 | **Fase 1:** Elicitação de requisitos, 10 User Stories, EAP, Roadmap, Protótipos Figma, DER do Banco e repositório GitHub. |
| **Sprint 2** | 25/08 a 07/09/2026 | **Backend Core:** API Node.js/Express, banco PostgreSQL e rotas de autenticação (US01, US02). |
| **Sprint 3** | 08/09 a 21/09/2026 | **Ficha Médica:** Formulário de dados clínicos, validações e cadastro de senha pública (US03, US04, US10). |
| **Sprint 4** | 22/09 a 05/10/2026 | **QR Code & Emergência:** Geração de QR Code e portal mobile de emergência protegido por senha (US05, US06, US07). |
| **Sprint 5** | 06/10 a 19/10/2026 | **Impressão & Exclusão:** Módulo de impressão de crachá e exclusão total da ficha com status 404 (US08, US09). |
| **Sprint 6** | 20/10 a 02/11/2026 | **Testes & Deploy:** Testes automatizados, validação de segurança, deploy em produção e documentação final. |

---

### 5. Tecnologias Utilizadas e Justificativas

- **Frontend: React.js com Tailwind CSS**
  - *Justificativa:* O React garante alta reatividade e componentização reutilizável. O Tailwind CSS possibilita styling responsivo em abordagem Mobile-First, essencial para a leitura ágil por socorristas em smartphones.
- **Backend: Node.js com TypeScript e Express.js**
  - *Justificativa:* O ecossistema Node.js/TypeScript oferece alta performance orientada a eventos e tipagem estática que previne erros em tempo de execução. Excelente suporte a bibliotecas de geração de QR Code (`qrcode`) e hashing de senhas (`bcrypt`).
- **Banco de Dados: PostgreSQL (AWS RDS)**
  - *Justificativa:* Banco relacional (RDBMS) altamente confiável. Garante a integridade relacional entre o usuário e sua ficha clínica através de chaves estrangeiras (FK), suporte a transações ACID e consultas otimizadas.
- **Arquitetura: Arquitetura em Camadas (Layered Architecture - Controller / Service / Repository)**
  - *Justificativa:* Promove o desacoplamento das regras de negócio em relação ao banco de dados e à camada de apresentação, permitindo fácil manutenção, testes isolados e escalabilidade.

---

### 6. Repositórios no GitHub

- **Repositório do Projeto:** `https://github.com/samuelaiedo/medqr-clinical-system`
- **Visibilidade:** Privado
- **Colaboradora Adicionada:** `biancacamargomachado` (permissão de Leitura/Read).

---

### 7. Modelagem do Banco de Dados (DER)

| Tabela | Coluna | Tipo | Restrição | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **USUARIOS** | `id` | UUID | Primary Key | Identificador único do usuário |
| | `nome` | VARCHAR(100) | NOT NULL | Nome do trabalhador |
| | `sobrenome` | VARCHAR(100) | NOT NULL | Sobrenome do trabalhador |
| | `email` | VARCHAR(255) | UNIQUE, NOT NULL | E-mail corporativo |
| | `senha_hash` | VARCHAR(255) | NOT NULL | Hash bcrypt da senha da conta |
| | `criado_em` | TIMESTAMP | DEFAULT NOW() | Data de cadastro |
| | `atualizado_em` | TIMESTAMP | DEFAULT NOW() | Data da última alteração |
| **FICHAS_CLINICAS** | `id` | UUID | Primary Key | Identificador da ficha médica |
| | `usuario_id` | UUID | Foreign Key, UNIQUE | Vínculo 1:1 com a tabela USUARIOS |
| | `sexo` | VARCHAR(20) | NOT NULL | Sexo biológico |
| | `contato_emergencia`| VARCHAR(100) | NOT NULL | Nome e telefone de emergência |
| | `tipo_sanguineo` | VARCHAR(5) | NOT NULL | Tipo sanguíneo (ex: O+, AB-) |
| | `alergias` | TEXT | NULLABLE | Lista de alergias |
| | `medicamentos` | TEXT | NULLABLE | Medicamentos em uso continuo |
| | `doencas` | TEXT | NULLABLE | Condições/doenças prévias |
| | `cirurgias` | TEXT | NULLABLE | Histórico de cirurgias |
| | `senha_publica_hash`| VARCHAR(255) | NOT NULL | Hash bcrypt da senha de acesso público |
| | `qr_code_token` | VARCHAR(255) | UNIQUE, NOT NULL | Token gerador da URL do QR |
| | `ativo` | BOOLEAN | DEFAULT TRUE | Status para exclusão/desativação (404) |
| | `criado_em` | TIMESTAMP | DEFAULT NOW() | Data de criação |
| | `atualizado_em` | TIMESTAMP | DEFAULT NOW() | Data da última alteração |

---

### 8. Conclusão e Autoavaliação

Nesta primeira fase do projeto, o foco esteve concentrado na estruturação analítica, no levantamento rigoroso de requisitos e no planejamento arquitetural para resolver um problema real de segurança e saúde do trabalhador. 

**Aprendizados:**
A elaboração da Estrutura Analítica do Projeto (EAP) em 4 níveis e o mapeamento de 10 User Stories com critérios de aceite detalhados foram fundamentais para delimitar o escopo do projeto, evitando retrabalho nas fases de codificação. Além disso, o planejamento da segurança da informação — separando a senha da conta da senha de acesso público — destacou a importância do equilíbrio entre privacidade e acessibilidade em momentos de emergência médica.

**Dificuldades Encontradas:**
O principal desafio foi definir o fluxo de acesso público de forma extremamente simples e rápida para socorristas sem comprometer a privacidade dos dados de saúde do trabalhador (LGPD). A solução encontrada foi a introdução da senha pública impressa visualmente ao lado do QR Code no crachá, porém sem que esta estivesse embutida na URL codificada no próprio QR Code.

**Autoavaliação:**
Avalio meu desempenho nesta Fase 1 como excelente. Todas as etapas solicitadas — elicitação de 10 RFs e 4 RNFs, 10 User Stories completas, EAP gráfica em 4 níveis, Roadmap de 6 Sprints com datas, definição técnica justificada, prototipação de alta fidelidade e modelagem DER com chaves e tipos — foram executadas de maneira coerente, estruturada e alinhada com as melhores práticas de engenharia de software.
