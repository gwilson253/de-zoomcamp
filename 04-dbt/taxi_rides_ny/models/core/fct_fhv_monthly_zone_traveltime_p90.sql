
select
    *,
    date_diff(dropoff_datetime, pickup_datetime, second) as trip_duration,
    percentile_cont(date_diff(dropoff_datetime, pickup_datetime, second), 0.90) over (partition by pickup_year, pickup_month, pickup_locationid, dropoff_locationid) as perc_90
from {{ ref('dim_fhv_trips') }} as fhv
