# Question 1: Understanding dbt model resolution

Answer: `select * from myproject.raw_nyc_tripdata.ext_green_taxi`

Reason: The `env_var` function will reference a declared environment variable, and optionally accepts a default fallback value in the case that the env var in the first argument is not found. 
* The source database references the env var `DBT_BIGQUERY_PROJECT`, which is declared, so `myproject` is used.
* the source schema references `DBT_BIGQUERY_SOURCE_DATASET`, which is not declared, so the fallback `raw_nyc_tripdata` is used.

# Question 2: dbt Variables & Dynamic Models

Answer: `Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY`

# Question 3: dbt Data Lineage and Execution

Note: confusingly worded question. 

Answer: `dbt run --select models/staging/+`

# Question 4: dbt Macros and Jinja

Answer:
* `Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile`
* `When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET`
* `When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET`
* `When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET`

Note: the submission form doesn't allow for multiple answers. 

# Quesion 5: Taxi Quarterly Revenue Growth

Answer: `green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}`

Query: 
```
select *,
from `taxi_data.fct_taxi_trips_quarterly_revenue`
where extract(year from revenue_quarter) = 2020
order by 2, 1
```

