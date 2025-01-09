export URL="https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2019-09.parquet"


python ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=${URL}