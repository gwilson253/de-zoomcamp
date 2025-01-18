# Setup for Local Postgres DB & Kestra
I was running into issues for the [DE Zoomcamp 2.2.3](https://www.youtube.com/watch?v=OkfLX28Ecjg) videos related to loading data into a target Postgres DB. I have mostly fixed these issues by creating a docker network that links the containers created in the first module's `docker-compose.yml` file, with those created in the second modules `docker-compose.yml` file. 

First, create the shared network: `docker network create shared-network`, where "shared-network" is the name of the network that will link everything together. Next, update both `docker-compose.yml` files to add the following properties:

```
# docker-compose-1.yml
networks:
  shared-network:
    external: true

services:
  service1:
    networks:
      - shared-network
```

```
# docker-compose-2.yml
networks:
  shared-network:
    external: true

services:
  service2:
    networks:
      - shared-network
```

Finally, you'll need to update the `values > url, username, and password` for the Postgres plugin at the bottom of your kestra flow file:
```
pluginDefaults:
  - type: io.kestra.plugin.jdbc.postgresql
    values:
      url: jdbc:postgresql://pgdatabase:5432/ny_taxi
      username: root
      password: root
```

I'm still running into some loading errors, but the staging and final tables were able to create, and I was able to inspect them in the DB I created in the first module. 

# Module 2 Homework
1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- 128.3 MB [x]
- 134.5 MB
- 364.7 MB
- 692.6 MB

Note: inspected file in project bucket

2) What is the value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- `green_tripdata_2020-04.csv` [x]
- `green_tripdata_04_2020.csv`
- `green_tripdata_2020.csv`

3) How many rows are there for the `Yellow` Taxi data for the year 2020?
- 13,537.299
- 24,648,499 [x]
- 18,324,219
- 29,430,127

precise sql: `select count(*) as n from taxi_data.yellow_tripdata where filename like 'yellow_tripdata_2020-%%.csv';`
realistic sql: `select * from taxi_data.green_tripdata where extract(year from lpep_pickup_datetime) = 2020;`

4) How many rows are there for the `Green` Taxi data for the year 2020?
- 5,327,301
- 936,199
- 1,734,051 [x]
- 1,342,034

precise sql: `select count(*) as n from taxi_data.yellow_tripdata where filename like 'green_tripdata_2020-%%.csv';`
realistic sql: `select * from taxi_data.green_tripdata where extract(year from lpep_pickup_datetime) = 2020;`

5) How many rows are there for the `Yellow` Taxi data for March 2021?
- 1,428,092
- 706,911
- 1,925,152 [x]
- 2,561,031

sql: `select count(*) as n from taxi_data.yellow_tripdata where filename = 'yellow_tripdata_2021-03.csv';`

6) How would you configure the timezone to New York in a Schedule trigger?
- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration [x]
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration  

Notes: See the Kestra documentation [here](https://kestra.io/plugins/core/triggers/io.kestra.plugin.core.trigger.schedule#timezone)


