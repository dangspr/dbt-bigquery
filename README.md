# dbt-bigquery

Case Dbt with bigquery integration

<!-- Badges -->
<p align="center">
   <a href="https://www.linkedin.com/in/danilo-gaspar98/">
      <img alt="Danilo Gaspar" src="https://img.shields.io/badge/LinkedIn%20--%20-Danilo%20Gaspar-blue" />
   </a>
  <img alt="License" src="https://img.shields.io/badge/license-MIT-blue">
</p>

##🚀 Projeto de Pipeline de Dados com dbt
Este projeto demonstra a criação de uma pipeline de dados robusta e automatizada, utilizando ferramentas modernas de transformação e orquestração de dados.

A solução combina:

dbt (Data Build Tool) para modelagem de dados,

Google Cloud Platform (GCP) como data warehouse (via BigQuery),

GitHub Actions para automação do CI/CD.

##🧱 Arquitetura da Solução
A arquitetura é composta pelos seguintes componentes:

🔧 dbt (Data Build Tool)
Ferramenta de transformação de dados baseada em SQL. Permite:

Modularização e reutilização de modelos;

Aplicação de testes automáticos;

Documentação integrada.

☁️ Google Cloud Platform (GCP)
Plataforma de nuvem usada para:

Armazenamento e processamento dos dados;

BigQuery como o data warehouse principal, onde as tabelas/views são materializadas.

##📂 GitHub
Repositório para versionamento de código, contendo:

Modelos SQL;

Arquivos de schema (.yml);

Configurações do projeto dbt.

##⚙️ GitHub Actions
Ferramenta de CI/CD que automatiza:

Execução de builds do dbt;

Testes de validação;

Deploy automático para o BigQuery.

##📁 Estrutura do Projeto
bash
Copiar
Editar
├── dbt_project.yml       # Configurações globais do projeto dbt
├── models/
│   ├── stg/              # Modelos intermediários (materializados como 'table')
│   └── my_first_dbt_model.sql
├── macros/               # Funções reutilizáveis (opcional)
└── tests/                # Testes customizados
📝 Principais arquivos
dbt_project.yml: Define configurações como materialização padrão e perfil de conexão.

models/*.sql: Arquivos com os modelos SQL.

models/*.yml: Arquivos de schema com testes (unique, not_null, etc) e documentação.

##🔁 Exemplo de Pipeline de Transformação
📌 my_first_dbt_model
Modelo inicial com dados de exemplo:

sql
{{ config(materialized='table') }}

SELECT 1 AS id, 'example' AS name
🔗 Modelo Dependente
Consome o modelo anterior e aplica transformação:

sql
Copiar
Editar
SELECT *
FROM {{ ref('my_first_dbt_model') }}
WHERE id = 1
Essa estrutura modular permite fácil manutenção, clareza na lógica de negócio e execução eficiente.

##🛠️ Como Replicar o Projeto
1. Configure o GCP
Crie um projeto no Google Cloud;

Ative a API do BigQuery.

2. Credenciais para o dbt
Crie uma conta de serviço no GCP;

Gere uma chave JSON com as permissões necessárias;

Salve as credenciais no arquivo ~/.dbt/profiles.yml.

3. Configurar GitHub Actions
Vá até o repositório no GitHub;

Adicione o conteúdo da chave JSON como um secreto (ex: GCP_SERVICE_ACCOUNT).

4. Clone o repositório
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
Configure o arquivo profiles.yml localmente com suas credenciais e projeto GCP.

5. Executar o projeto
Localmente:

dbt run
dbt test
dbt docs generate && dbt docs serve
Ou via GitHub Actions: Os comandos serão executados automaticamente ao realizar um push.

##📚 Documentação
Você pode gerar a documentação interativa com:

dbt docs generate && dbt docs serve
✅ Benefícios da Solução
💡 Foco em lógica de negócio e não em infraestrutura

🔒 Controle de qualidade com testes automatizados

🧩 Modularidade e escalabilidade com dbt

🚀 Deploy contínuo com GitHub Actions

##📬 Contato
<h4 align=center> Data Engineer - Danilo Gaspar <a href="https://idolink.bio/redessociaisdg"> <strong>Contact</strong> :)</a></a></h4>