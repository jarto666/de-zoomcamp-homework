python ingest_data.py --user postgres \
    --password postgres \
    --host localhost \
    --port 5433 \
    --db ny_taxi \
    --table_name trips \
    --file_path ./green_tripdata_2019-10.csv.gz

python ingest_data.py --user postgres \
    --password postgres \
    --host localhost \
    --port 5433 \
    --db ny_taxi \
    --table_name zones \
    --file_path ./taxi_zone_lookup.csv
