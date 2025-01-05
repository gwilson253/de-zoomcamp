#!/usr/bin/env python
# coding: utf-8

import argparse
import os
import pandas as pd
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url
    file_name = 'output.parquet'

    os.system(f"wget {url} -O {file_name}")

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df = pd.read_parquet(file_name)

    df.tpep_pickup_datetime = pd.to_datetime(df['tpep_pickup_datetime'])
    df.tpep_dropoff_datetime = pd.to_datetime(df['tpep_dropoff_datetime'])

    df.head(0).to_sql(name=table_name, con=engine, if_exists='replace')

    chunk_size = 100000
    chunk = 0
    while True:
        lower_bound = chunk * chunk_size
        upper_bound = (chunk + 1) * chunk_size
        print(f'appending rows {lower_bound} to {upper_bound}')
        if lower_bound > len(df):
            print('load complete')
            break
        chunk_df = df.iloc[lower_bound:upper_bound, :]
        chunk_df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')
        chunk += 1
    
    os.system(f"rm {file_name}")

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')
    parser.add_argument('--user')
    parser.add_argument('--password')
    parser.add_argument('--host')
    parser.add_argument('--port')
    parser.add_argument('--db')
    parser.add_argument('--table_name')
    parser.add_argument('--url')

    args = parser.parse_args()

    main(args)



