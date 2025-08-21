-- models/raw/triggo_shop.sql
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
        struct(1 as id, 'Enio' as first_name, 'Tanner' as last_name, 1 as user_id, '2023-01-10' as order_date, 'delivered' as status),
        struct(2 as id, 'Galego' as first_name, 'Manson' as last_name, 1 as user_id, '2023-01-15' as order_date, 'shipped' as status),
        struct(3 as id, 'Michelle' as first_name, 'Manson' as last_name, 2 as user_id, '2023-01-18' as order_date, 'delivered' as status),
        struct(4 as id, 'Edson' as first_name, 'Manson' as last_name, 2 as user_id, '2023-01-20' as order_date, 'pending' as status),
        struct(5 as id, 'Murilo' as first_name, 'Tanner' as last_name, 3 as user_id, '2023-01-22' as order_date, 'delivered' as status)
    ])
)