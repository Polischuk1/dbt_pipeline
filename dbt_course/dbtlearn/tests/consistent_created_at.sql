with fr as (
    select * from {{ ref ('fact_reviews')}}
),
l as (
    select * from {{ ref('dim_listings_cleansed') }}
)
select * from fr
join l 
on fr.listing_id = l.listing_id
where  l.created_at >= fr.review_date

