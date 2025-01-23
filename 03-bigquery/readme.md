# Homework

## Question 1:
Question 1: What is count of records for the 2022 Green Taxi Data??
- 65,623,481
- 840,402 [x]
- 1,936,423
- 253,647

sql: `select count(*) as row_count from taxi_data.green_taxi_data_2022;`

## Question 2:
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br> 
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

- 0 MB for the External Table and 6.41MB for the Materialized Table [x]
- 18.82 MB for the External Table and 47.60 MB for the Materialized Table
- 0 MB for the External Table and 0MB for the Materialized Table
- 2.14 MB for the External Table and 0MB for the Materialized Table

sql:
```
select 'internal' as src, count(distinct PULocationID) as n from `taxi_data.green_taxi_data_2022`; # ext. 6.41 MB for internal | returns 258
select 'external' as src, count(distinct PULocationID) as n from `taxi_data.green_taxi_data_2022_ext`; # est. 0B for external | returns 258
```

## Question 3:
How many records have a fare_amount of 0?
- 12,488
- 128,219
- 112
- 1,622 [x]

sql: `select count(*) as n from taxi_data.green_taxi_data_2022 where fare_amount is not null and fare_amount = 0;`

## Question 4:
What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)
- Cluster on lpep_pickup_datetime Partition by PUlocationID
- Partition by lpep_pickup_datetime  Cluster on PUlocationID [x]
- Partition by lpep_pickup_datetime and Partition by PUlocationID
- Cluster on by lpep_pickup_datetime and Cluster on PUlocationID

Notes:
* Partitioning on `lpep_pickup_datetime` makes sense since we're filtering on this column. Having this partitioned will allow BiqQuery to skip over partitions that don't match our filter criteria.
* Clustering on `PULocationID` makes sense because we're ordering by this value. Given that they'll be clustered within each partition, this should lower the cost of `order by` operations.
* Our table size is very small - only 114 active logical MB and 13.24 physical MB. Given this, we probably wouldn't apply partitioning or clustering.

sql:
```
CREATE OR REPLACE TABLE taxi_data.green_taxi_data_2022_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM taxi_data.green_taxi_data_2022
;
```

## Question 5:
Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime
06/01/2022 and 06/30/2022 (inclusive)</br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values? </br>

Choose the answer which most closely matches.</br> 

- 22.82 MB for non-partitioned table and 647.87 MB for the partitioned table
- 12.82 MB for non-partitioned table and 1.12 MB for the partitioned table [x]
- 5.63 MB for non-partitioned table and 0 MB for the partitioned table
- 10.31 MB for non-partitioned table and 10.31 MB for the partitioned table

sql: 
```
select count(distinct PULocationID) as n
from taxi_data.green_taxi_data_2022_clustered
where
  lpep_pickup_datetime >= '2022-06-01'
  and lpep_pickup_datetime < '2022-07-01'
;
```

## Question 6: 
Where is the data stored in the External Table you created?

- Big Query
- GCP Bucket [x]
- Big Table
- Container Registry

Notes: I couldn't find documentation on this, but it seems the most logical answer. It's not BigQuery, because that would defeat the purpose of external tables. BigTable is a managed NoSQL database service - not relevant here. And container registry has nothing to do with storing data. 

## Question 7:
It is best practice in Big Query to always cluster your data:
- True
- False [x]

Notes: From the presentation, partitioning & clustering on tables smaller than 1 GB may adversely affect query performance. My assumption is that this is becuase of the following:
* Partitioning a small table may preclude the use of broadcast joins when they would be performant.
* The overhead costs inclurred from managing and planning around the partitions and clusters may outweigh performance gains when your table is small.

## (Bonus: Not worth points) Question 8:
No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
* The estimate is `0 B`. I have two hypothesis. The first is that this is because we've run this query before (problem #1), and the results are cached. The second is that data warehouses, like Snowflake, often have table metadata like this at the ready so that querying the actual data is not required. I do not know whether this applies to BigQuery.