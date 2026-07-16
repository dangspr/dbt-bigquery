# dbt-bigquery
## Case Study: dbt with BigQuery Integration

<p align="center">
<a href="https://www.linkedin.com/in/danilo-gaspar98/">
<img alt="Danilo Gaspar" src="https://img.shields.io/badge/LinkedIn-Danilo%20Gaspar-blue" />
</a>
<img alt="License" src="https://img.shields.io/badge/license-MIT-blue">
</p>

## 🚀 Projeto de Pipeline de Dados com dbt
Este projeto demonstra a construção de uma pipeline de dados robusta e automatizada, utilizando ferramentas modernas para transformação e pronto para aplicar orquestração de dados.

A solução integra:

- **dbt (Data Build Tool)**: Para modelagem e transformação de dados.
- **Google Cloud Platform (GCP)**: Como data warehouse, utilizando o BigQuery.
- **GitHub Actions**: Para automação de CI/CD.

## 🧱 Arquitetura da Solução
A arquitetura é composta pelos seguintes componentes:

### 🔧 dbt (Data Build Tool)
Ferramenta de transformação de dados baseada em SQL, que oferece:
- Modularização e reutilização de modelos.
- Aplicação de testes automáticos.
- Documentação integrada.

<div align="center">
  <img src="https://raw.githubusercontent.com/dangspr/dbt-bigquery/main/dbt_docs.png" alt="Evidencia_dbt">
</div>

### ☁️ Google Cloud Platform (GCP)
Plataforma de nuvem utilizada para:
- Armazenamento e processamento de dados.
- BigQuery como DW, onde tabelas e views são materializadas.

### 📂 GitHub
Repositório para versionamento de código, contendo:
- Modelos SQL.
- Arquivos de schema (.yml).
- Configurações do projeto dbt.

### ⚙️ GitHub Actions
Ferramenta de CI/CD que automatiza:
- Deploy.

## 📁 Estrutura do Projeto 
A nova estrutura segue a arquitetura Medallion, separando os modelos em camadas para clareza e governança de dados.

```
├── dbt_project.yml        # Configurações globais do projeto dbt
├── models/
│   ├── raw/               # Camada Raw: Dados brutos, imutáveis e de origem
│   │   ├── tg_shop.sql
│   │   └── schema.yml
│   ├── stg/               # Camada Staging: Dados limpos, padronizados e intermediários
│   │   ├── customers.sql
│   │   ├── orders.sql
│   │   └── schema.yml
│   └── refined/           # Camada Refined: Dados agregados, prontos para análise de negócio
│       ├── customer_orders_summary.sql
│       └── schema.yml
└── ...
```

## 📝 Principais Arquivos
- **dbt_project.yml**: Define configurações como a materialização padrão e o perfil de conexão para cada camada.
- **models/*.sql**: Arquivos com os modelos SQL, organizados por camada.
- **models/*.yml**: Arquivos de schema com testes (unique, not_null, etc.) e documentação, localizados junto aos modelos que descrevem.

## 🔁 Exemplo do Fluxo de Transformação
Este projeto transforma dados brutos de pedidos e clientes em uma tabela analítica, seguindo o fluxo de raw -> stg -> refined.

### 📌 Camada raw: triggo_shop
Fonte de dados brutos do projeto. Contém a tabela estática com dados de clientes e pedidos.

```sql
-- models/raw/tg_shop.sql
{{
  config(
    materialized='table'
  )
}}

select
    id,
    first_name,
    last_name,
    user_id,
    order_date,
    status
from (
    select * from unnest([
        struct(1 as id, 'Elias' as first_name, 'Tanner' as last_name, 1 as user_id, '2023-01-10' as order_date, 'delivered' as status),
        struct(2 as id, 'Hudson' as first_name, 'Manson' as last_name, 1 as user_id, '2023-01-15' as order_date, 'shipped' as status),
        struct(3 as id, 'Michell' as first_name, 'Manson' as last_name, 2 as user_id, '2023-01-18' as order_date, 'delivered' as status),
        struct(4 as id, 'Edson' as first_name, 'Manson' as last_name, 2 as user_id, '2023-01-20' as order_date, 'pending' as status),
        struct(5 as id, 'Murilo' as first_name, 'Tanner' as last_name, 3 as user_id, '2023-01-22' as order_date, 'delivered' as status)
    ])
)
```

### 🔗 Camada stg: customers e orders
Modelos intermediários que selecionam e preparam os dados da tabela triggo_shop.

```sql
-- models/stg/customers.sql
{{
  config(
    materialized='view'
  )
}}

select
    id as customer_id,
    first_name,
    last_name
from {{ ref('tg_shop') }}
```

```sql
-- models/stg/orders.sql
{{
  config(
    materialized='view'
  )
}}

select
    id as order_id,
    user_id as customer_id,
    order_date,
    status
from {{ ref('tg_shop') }}
```

### 📊 Camada refined: customer_orders_summary
Modelo final que agrega dados de clientes e pedidos, pronto para ser consumido por ferramentas de BI.

```sql
-- models/refined/customer_orders_summary.sql
with customers as (
    select * from {{ ref('customers') }}
),

orders as (
    select * from {{ ref('orders') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        count(order_id) as number_of_orders
    from orders
    group by 1
)

select
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.first_order_date,
    customer_orders.number_of_orders
from customers
left join customer_orders using (customer_id)
```

Essa estrutura modular garante manutenção simplificada, clareza na lógica de negócio e execução eficiente.

## 🛠️ Como Replicar o Projeto
1. **Configure o GCP**
   - Crie um projeto no Google Cloud.
   - Ative a API do BigQuery.
   - **Importante**: Crie manualmente os conjuntos de dados (raw, stg, refined) no BigQuery.

2. **Credenciais para o dbt**
   - Crie uma conta de serviço no GCP.
   - Gere uma chave JSON com as permissões necessárias.
   - Salve as credenciais no arquivo `~/.dbt/profiles.yml`, configurando cada um dos destinos (raw, stg, refined).

3. **Configurar GitHub Actions**
   - Acesse o repositório no GitHub.
   - Adicione a chave JSON como um segredo (ex.: `GCP_SERVICE_ACCOUNT`).

4. **Clone o Repositório**
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio
   ```
   Configure o arquivo `profiles.yml` localmente com suas credenciais e projeto GCP.

5. **Executar o Projeto**
   - **Localmente**:
     ```bash
     dbt build
     ```
     O comando `dbt build` irá executar o `run` e `test` para todos os modelos, garantindo que a pipeline seja construída corretamente.
   - **Via GitHub Actions**: Os comandos serão executados automaticamente ao realizar um push.

## 📚 Documentação
Gere a documentação interativa com:
```bash
dbt docs generate && dbt docs serve
```

## ✅ Benefícios da Solução
- 💡 Foco em lógica de negócio, sem preocupações com infraestrutura.
- 🔒 Controle de qualidade com testes automatizados.
- 🧩 Modularidade e escalabilidade com dbt.
- 🚀 Deploy contínuo com GitHub Actions.

## 📬 Contato
<p align="center">
<strong>Data Engineer - Danilo Gaspar</strong><br>
<a href="https://biolink.website/socialDG">📧 Contact</a>
</p>
