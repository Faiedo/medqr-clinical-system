# Documentação Técnica e Entregável - Fase 2
**Disciplina:** Disciplina Integradora de Desenvolvimento de Projetos  
**Projeto:** MedQR - Sistema para Compartilhamento de Informações Clínicas de Emergência  
**Estudante:** Samuel Aiedo  
**Repositório Oficial:** [https://github.com/Faiedo/medqr-clinical-system](https://github.com/Faiedo/medqr-clinical-system)  
**Branch de Entrega da Fase 2:** [https://github.com/Faiedo/medqr-clinical-system/tree/fase-2](https://github.com/Faiedo/medqr-clinical-system/tree/fase-2)  

---

## 1. Organização do GitHub (Seção 1)
O projeto encontra-se integralmente versionado no GitHub sob controle de versão Git:
* **Repositório:** [`https://github.com/Faiedo/medqr-clinical-system`](https://github.com/Faiedo/medqr-clinical-system)
* **Branch Oficial de Entrega:** `fase-2` (congelada no prazo estipulado para avaliação, evitando commits fora do período).
* **Módulos Versionados:**
  * **Backend:** Módulo de validação clínica, rotas REST e servidor HTTP com endpoint de auditoria e `/health` ([`devops/src/index.js`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/src/index.js)).
  * **Frontend:** Aplicação Web interativa desenvolvida com Tailwind CSS, Alpine.js e biblioteca de geração de QR Code dinâmico ([`des-proj/app/index.html`](https://github.com/Faiedo/medqr-clinical-system/blob/main/des-proj/app/index.html)).
  * **Banco de Dados:** Script SQL DDL de inicialização com tabelas normalizadas (`usuarios` e `fichas_clinicas`), chaves estrangeiras com integridade referencial `ON DELETE CASCADE` e índices de performance ([`devops/init-db.sql`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/init-db.sql)).
  * **DevOps / Containers:** `Dockerfile` multi-stage, `docker-compose.yml`, scripts de deploy e pipeline de CI/CD automatizado no GitHub Actions.

---

## 2. Atualização das User Stories (Seção 2)
Durante a transição da Fase 1 (Modelagem) para a Fase 2 (Desenvolvimento Real), as 10 User Stories passaram por um processo de refinamento técnico (*Sprint Backlog Grooming*), agregando critérios de segurança, sanitização e conformidade com a LGPD:

| ID | User Story | Mudanças e Melhorias Implementadas na Fase 2 | Status |
| :--- | :--- | :--- | :--- |
| **US01** | Cadastro de Trabalhador | Adicionada validação de e-mail corporativo único e restrição de senha forte no backend com hash irreversível **bcrypt** (salt rounds = 10). | **Concluído** |
| **US02** | Login Seguro | Implementada sessão stateless via **JSON Web Token (JWT)**, garantindo tempo de expiração seguro e renovação controlada. | **Concluído** |
| **US03** | Preenchimento da Ficha | Validação no backend dos 9 campos obrigatórios, bloqueando payloads incompletos com retorno HTTP 400 e mensagens amigáveis. | **Concluído** |
| **US04** | Registro do Tipo Sanguíneo | Criada regra estrita de enumeração médica (`A+`, `A-`, `B+`, `B-`, `AB+`, `AB-`, `O+`, `O-`) rejeitando dados inválidos. | **Concluído** |
| **US05** | Definição da Senha Pública | Adicionado hash da senha pública no banco de dados e limitação de tentativas de acesso para mitigar ataques de força bruta. | **Concluído** |
| **US06** | Geração Dinâmica do QR Code | Otimizado para gerar QR Code com nível de correção de erro **High (Level H)**, permitindo leitura por câmeras mesmo em crachás arranhados. | **Concluído** |
| **US07** | Impressão do Crachá | Ajustada folha de estilos CSS `@media print` para formato padronizado de crachá corporativo (85x54mm) com QR Code centralizado. | **Concluído** |
| **US08** | Visualização do Socorrista | Interface Mobile-First otimizada para smartphones de socorristas com tema de alto contraste, destaque em vermelho para tipo sanguíneo e botão de chamada telefônica direta para o contato de emergência (`tel:`). | **Concluído** |
| **US09** | Exclusão da Ficha (Direito ao Esquecimento) | Implementada exclusão permanente em conformidade com a LGPD (Art. 18), com invalidação instantânea do token público retornando status **HTTP 404 (Not Found)**. | **Concluído** |
| **US10** | Deploy e Monitoramento de Saúde | Adicionado endpoint de integridade `/health` integrado a testes de fumaça (*Smoke Testing*) e orquestração Docker Compose. | **Concluído** |

---

## 3. Atualização do Roadmap (Seção 3)
O cronograma semestral foi atualizado comparando o planejado com o executado:
* **Sprint 1 (11/08 - 24/08):** Planejamento, Requisitos, EAP, DER e Protótipos de Alta Fidelidade (Concluído na Fase 1).
* **Sprint 2 (25/08 - 07/09):** Backend Core, Autenticação e Banco PostgreSQL (Concluído na Fase 2).
* **Sprint 3 (08/09 - 21/09):** Gestão de Ficha Clínica e Regras de Validação Médica (Concluído na Fase 2).
* **Sprint 4 (22/09 - 05/10):** Geração de QR Code, Layout de Crachá e Portal do Socorrista (Concluído na Fase 2).
* **Sprint 5 (06/10 - 19/10):** Containerização Docker e Orquestração (Adiantado e 100% Concluído).
* **Sprint 6 (20/10 - 02/11):** Pipeline de CI/CD, Testes Automatizados e Deploy (Adiantado e 100% Concluído).

*Melhoria Significativa:* As Sprints 5 e 6 foram adiantadas para a Fase 2, garantindo que a aplicação já fosse entregue containerizada e validada em esteira contínua.

---

## 4. Roteiro Estruturado para o Vídeo Pitch (3 a 5 minutos) (Seção 4)

Este roteiro foi milimetricamente cronometrado para gravação com o celular na horizontal:

### ⏱️ [0:00 - 0:45] Introdução e o Problema Real
> *"Olá! Eu sou o Samuel Aiedo e hoje estou apresentando o projeto final da Disciplina Integradora de Desenvolvimento de Projetos: o **MedQR**.*  
> *Imagine a seguinte situação: um trabalhador sofre um acidente em uma fábrica ou canteiro de obras. Ele está inconsciente. O socorrista do SAMU ou da brigada médica chega ao local e precisa tomar decisões imediatas: qual é o tipo sanguíneo? Ele tem alergia a penicilina ou dipirona? Toma remédios para hipertensão? Quem é o contato de emergência da família?*  
> *Hoje, essas informações ou estão desatualizadas no RH ou demoram preciosos minutos para serem localizadas. E em emergências médicas, minutos significam vidas."*

### ⏱️ [0:45 - 1:30] A Solução MedQR
> *"Para resolver essa dor, desenvolvemos o **MedQR**: uma solução corporativa integrada onde o próprio colaborador cadastra e mantém atualizados seus dados clínicos vitais.*  
> *O sistema gera dinamicamente um QR Code exclusivo com uma senha de acesso público que é impressa diretamente no verso do crachá do trabalhador.*  
> *Ao chegar na ocorrência, o socorrista aponta a câmera do celular para o crachá, digita a senha impressa e, em menos de 5 segundos, tem acesso imediato ao tipo sanguíneo em destaque, alertas de alergias, medicamentos contínuos e discagem direta para a família. Tudo com proteção à privacidade garantida pela LGPD."*

### ⏱️ [1:30 - 3:30] Demonstração Prática da Solução Rodando ao Vivo
*(Neste momento, mostre a tela do computador com o sistema operando em `des-proj/app/index.html`)*:
> 1. *"Aqui temos a **Tela 1**: o login corporativo seguro do trabalhador.*  
> 2. *Ao acessar, entramos na **Tela 2 - Ficha Clínica**: aqui o trabalhador preenche os dados vitais obrigatórios: tipo sanguíneo (com validação estrita O+, A, B, AB), contatos, alergias graves e medicamentos. É aqui também que ele define a sua Senha Pública de Acesso, como por exemplo 'MED2026'.*  
> 3. *Ao salvar, o sistema gera a **Tela 3 - Crachá de Emergência**: vejam que o QR Code é gerado em tempo real com alta densidade de leitura e a senha pública fica demarcada para impressão no formato padrão de crachá de 85x54 milímetros.*  
> 4. *Agora vamos simular a visão do socorrista na **Tela 4**: ao escanear o QR Code no celular, o socorrista cai no portal de emergência protegido por senha. Ele digita a senha 'MED2026' impressa no crachá e clica em Liberar Dados. Imediatamente a tela abre o painel crítico: Tipo O+ em destaque vermelho gigante, aviso de alergia a Penicilina e Dipirona, e o botão que disca direto para a esposa Maria.*  
> 5. *E caso o colaborador se desligue da empresa, temos o botão de Exclusão Definitiva, que apaga os dados do banco e retorna status 404 imediato, cumprindo o direito ao esquecimento da LGPD."*

### ⏱️ [3:30 - 4:15] Arquitetura Técnica e Módulos
> *"O MedQR foi desenvolvido de ponta a ponta com arquitetura profissional:*  
> *• No **Frontend**, usamos HTML5 semântico, Tailwind CSS para responsividade mobile e Alpine.js.*  
> *• No **Backend**, criamos uma API RESTful em Node.js com endpoints de auditoria e healthcheck.*  
> *• No **Banco de Dados**, modelamos o PostgreSQL 15 com integridade referencial em duas tabelas.*  
> *• E no aspecto de **DevOps**, empacotamos tudo em containers Docker com multi-stage build, orquestração via Docker Compose e uma esteira completa de CI/CD no GitHub Actions que executa testes unitários automatizados a cada commit com 100% de aprovação."*

### ⏱️ [4:15 - 4:45] Conclusão e Encerramento
> *"O MedQR comprova como a tecnologia pode transformar protocolos de segurança do trabalho em respostas ágeis que salvam vidas na indústria.*  
> *Todo o código, documentação e instruções de execução estão disponíveis no nosso repositório no GitHub na branch `fase-2`.*  
> *Muito obrigado pela atenção!"*

---

## 5. Artefatos do Projeto (Seção 5)
* **Repositório GitHub:** [`https://github.com/Faiedo/medqr-clinical-system`](https://github.com/Faiedo/medqr-clinical-system)
* **Branch Oficial da Fase 2:** [`https://github.com/Faiedo/medqr-clinical-system/tree/fase-2`](https://github.com/Faiedo/medqr-clinical-system/tree/fase-2)
* **Aplicação Frontend:** [`des-proj/app/index.html`](file:///C:/Users/samuel.aiedo/docs-fac/des-proj/app/index.html)
* **API Backend & Healthcheck:** [`devops/src/index.js`](https://github.com/Faiedo/medqr-clinical-system/blob/main/devops/src/index.js)
* **Pipeline de CI/CD (GitHub Actions):** [`https://github.com/Faiedo/medqr-clinical-system/actions`](https://github.com/Faiedo/medqr-clinical-system/actions)
* **Instruções de Execução:**
  ```bash
  # 1. Execução via Docker Compose (App + Banco)
  cd devops
  docker compose up -d --build
  
  # 2. Testes Automatizados
  npm test
  
  # 3. Acesso Local
  http://localhost:3000
  http://localhost:3000/health
  ```

---

## 6. Conclusão e Autoavaliação (Seção 6)

### Avaliação Qualitativa
Ao longo das Fases 1 e 2, desenvolvemos um produto completo de ponta a ponta. Na Fase 1, estabelecemos uma base sólida com elicitação de requisitos, modelagem relacional de banco de dados (DER) e arquitetura EAP em 4 níveis. Na Fase 2, essa fundação permitiu acelerar o desenvolvimento de todos os módulos (Backend, Frontend e Banco), integrando práticas avançadas de engenharia de software como criptografia, testes automatizados, conteinerização e esteiras de integração e entrega contínuas (CI/CD).

Os feedbacks e orientações da tutoria sobre permissões no GitHub e caminhos no repositório foram prontamente incorporados, assegurando visibilidade pública, rastreabilidade e branch dedicada de entrega (`fase-2`).

### Autoavaliação Quantitativa: 10 / 10
* **Motivo:** O projeto cumpriu com excelência 100% dos requisitos acadêmicos e técnicos estipulados no edital da disciplina:
  1. Todos os módulos (Backend, Frontend e Banco) foram implementados de forma funcional e integrada.
  2. As User Stories foram atualizadas e refinadas com melhorias significativas de segurança e conformidade LGPD.
  3. O Roadmap foi executado com sucesso e teve suas etapas de infraestrutura e CI/CD adiantadas.
  4. O roteiro do Pitch foi estruturado dentro das diretrizes de 3 a 5 minutos com demonstração prática de todas as telas.
  5. Todos os artefatos encontram-se versionados, testados e disponíveis no repositório público do GitHub na branch de entrega da Fase 2.
