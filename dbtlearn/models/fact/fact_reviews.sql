{{
  config(
    materialized = 'incremental',
    on_schema_change ='fail'
    )
}}
    select  {{ dbt_utils.generate_surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) }} as review_id,
    * from {{ref ("src_reviews")}}
    where review_text is not null 

{% if is_incremental() %}
    and review_date > coalesce((select max(review_date) from {{ this }}), '1900-01-01')
{% endif %}