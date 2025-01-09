# Homework

## 01 - knowing Docker tags
Question: _Which tag has the following text? - Automatically remove the container when it exits_

Answer: `--rm`

## 02 - Simple Docker Run
Question: _Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash. Now check the python modules that are installed ( use pip list ). What is version of the package wheel ?_

Answer: `0.45.1`

Notes:
I ran `docker run python:3.9 --it bash` to run the image interactively with `bash` as the entry point.

## 03 - Counting Taxi Trips
Question: _How many taxi trips were totally made on September 18th 2019?_

Answer: 15,612

SQL:
```
select count(*) as n
from green_taxi_data
where
	lpep_pickup_datetime >= '2019-09-18'
	and lpep_dropoff_datetime < '2019-09-19'
;
```

## 04 - Longest trip for each day
Question: _Which was the pick up day with the longest trip distance? Use the pick up time for your calculations._

Answer: 2019-09-26

SQL:
```
select 
	cast(lpep_pickup_datetime as date) as pickup_date,
	max(trip_distance) as max_trip_distance
from green_taxi_data
group by 1
order by 2 desc
;
```

## 05 - Three biggest pick up Boroughs
Question: _Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?_

Answer: "Brooklyn" "Manhattan" "Queens"

SQL:
```
select
	taxi_zone."Borough",
	sum(green_taxi_data.total_amount) as total_amount
from green_taxi_data
inner join taxi_zone
on green_taxi_data."PULocationID" = taxi_zone."LocationID"
where
	cast(green_taxi_data.lpep_pickup_datetime as date) = '2019-09-18'
group by 1
order by 2 desc
;
```

## 06 - Largest Tip
Question: _For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip? We want the name of the zone, not the id._

Answer: JFK Airport

SQL:
```
select
	drop_off_location."Zone",
	max(green_taxi_data.tip_amount) as max_tip_amount
from green_taxi_data
inner join taxi_zone as pick_up_location
on green_taxi_data."PULocationID" = pick_up_location."LocationID"
inner join taxi_zone as drop_off_location
on green_taxi_data."DOLocationID" = drop_off_location."LocationID"
where
	pick_up_location."Zone" = 'Astoria'
group by 1
order by 2 desc
;
```