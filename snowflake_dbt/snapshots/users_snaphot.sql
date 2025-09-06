{% snapshot users_snapshot %}

    {{
        config(
            target_schema='snapshots', 
            target_database='CLICK2CART',
            unique_key='user_id',       
            strategy='timestamp',            
            updated_at='timestamp'          
        )
    }}

    SELECT *
    FROM {{ ref('dim_users') }}

{% endsnapshot %}
