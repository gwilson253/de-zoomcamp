{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
),

base as (
    select distinct
        extract(year from pickup_datetime) as pickup_year,
        extract(month from pickup_datetime) as pickup_month,
        service_type,
        fare_amount,
        percentile_cont(fare_amount, 0.90) over (partition by service_type, extract(year from pickup_datetime), extract(month from pickup_datetime)) as perc_90,
        percentile_cont(fare_amount, 0.95) over (partition by service_type, extract(year from pickup_datetime), extract(month from pickup_datetime)) as perc_95,
        percentile_cont(fare_amount, 0.97) over (partition by service_type, extract(year from pickup_datetime), extract(month from pickup_datetime)) as perc_97
    from trips_data
    
    where
        fare_amount > 0
        and trip_distance > 0
        and payment_type_description in ('Cash', 'Credit Card')

)

select distinct 
    service_type,
    pickup_year,
    pickup_month,
    perc_90,
    perc_95,
    perc_97
    
from base 
