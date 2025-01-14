# Homework

## 01 - pip version
Question: _What's the version of pip in the image?_

Answer: `24.3.1 `

## 02 - Understanding Docker networking and docker-compose
Question: _Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?_

Answer: `postgres:5433`

## 03 - Trip Segmentation Count
Question:
```
During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

Up to 1 mile
In between 1 (exclusive) and 3 miles (inclusive),
In between 3 (exclusive) and 7 miles (inclusive),
In between 7 (exclusive) and 10 miles (inclusive),
Over 10 miles
```

Answer: 104,838; 199,013; 109,645; 27,688; 35,202

SQL:
```
select
	case
		when trip_distance <= 1 then '(0, 1]'
		when trip_distance <= 3 then '(1, 3]'
		when trip_distance <= 7 then '(3, 7]'
		when trip_distance <= 10 then '(7, 10]'
		else '(10,inf]'
	end as trip_dist_bin,
	count(*) as n
from green_taxi_data
group by 1
order by 1
;
```

## 04 - Longest trip for each day
Question: _Which was the pick up day with the longest trip distance? Use the pick up time for your calculations._

Answer: 2019-10-31

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

## 05 - Three biggest pickup zones
Question: _Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?_

Answer: "East Harlem North, East Harlem South, Morningside Heights"

SQL:
```
select
	taxi_zone."Zone",
	sum(green_taxi_data.total_amount) as total_amount
from green_taxi_data
inner join taxi_zone
on green_taxi_data."PULocationID" = taxi_zone."LocationID"
where
	cast(green_taxi_data.lpep_pickup_datetime as date) = '2019-10-18'
group by 1
order by 2 desc
;
```

## 06 - Largest Tip
Question: _For the passengers picked up in October 2019 in the zone name "East Harlem North"" which was the drop off zone that had the largest tip? We want the name of the zone, not the id._

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
	pick_up_location."Zone" = 'East Harlem North'
group by 1
order by 2 desc
;
```

## 07 - Terraform Workflow
Question:
```
Which of the following sequences, respectively, describes the workflow for:

Downloading the provider plugins and setting up backend,
Generating proposed changes and auto-executing the plan
Remove all resources managed by terraform`
```

Answer: `terraform init, terraform apply -auto-aprove, terraform destroy`
