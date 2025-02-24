{{
    config(
        materialized='view'
    )
}}

select
    -- identifiers
    unique_row_id as tripid,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }} as dropoff_locationid,
    
    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime

from {{ source('staging','fhv_tripdata') }}

where dispatching_base_num is not null
