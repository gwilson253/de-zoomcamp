python 10_local_spark_cluster.py \
    --input_green=data/pq/green/2020/*/ \
    --input_yellow=data/pq/yellow/2020/*/ \
    --output=data/report-2020

URL="spark://de-zoomcamp.us-west1-a.c.dtc-de-course-446618.internal:7077"

spark-submit \
    --master="${URL}" \
    10_local_spark_cluster.py \
    --input_green=data/pq/green/2021/*/ \
    --input_yellow=data/pq/yellow/2021/*/ \
    --output=data/report-2021