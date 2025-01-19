# Module 1: Containerization and Infrastructure as Code

In this homework we'll prepare the environment and practice Docker and SQL

## Part 1: [Docker](docker)

### Prerequisites:

Download data CSVs and put them into the same folder as [ingest_data.py](docker/ingest_data.py):

```sh
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```

#### Run Docker Compose up

It is necessary to start the instance of postgres where data is going to be injested to.

```sh
docker-compose up
```

#### Create virtual environment

```sh
python3 -m venv venv
source venv/bin/activate
```

#### Install necessary packages

```sh
pip install pandas sqlalchemy psycopg2-binary
```

#### Injest data

```sh
sh ./pipeline.sh
```

### Questions {and answers}

#### Question 1. Understanding docker first run

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

What's the version of pip in the image?

```sh
docker run -it --entrypoint bash python:3.12.8
pip -V
```

> **Answer**: pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)

#### Question 2. Understanding Docker networking and docker-compose

Given the following [docker-compose.yaml](docker/docker-compose.yaml), what is the hostname and port that pgadmin should use to connect to the postgres database?

> **Answer**: postgres:5432

#### Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

- Up to 1 mile
- In between 1 (exclusive) and 3 miles (inclusive),
- In between 3 (exclusive) and 7 miles (inclusive),
- In between 7 (exclusive) and 10 miles (inclusive),
- Over 10 miles

```sql
SELECT COUNT(1) AS trip_count
FROM trips
WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01'
  AND lpep_dropoff_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance <= 1;

SELECT COUNT(1) AS trip_count
FROM trips
WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01'
  AND lpep_dropoff_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 1 AND trip_distance <= 3;

SELECT COUNT(1) AS trip_count
FROM trips
WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01'
  AND lpep_dropoff_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 3 AND trip_distance <= 7;

SELECT COUNT(1) AS trip_count
FROM trips
WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01'
  AND lpep_dropoff_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 7 AND trip_distance <= 10;

SELECT COUNT(1) AS trip_count
FROM trips
WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01'
  AND lpep_dropoff_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 10;
```

> **Answer**: 104,802; 198,924; 109,603; 27,678; 35,189

#### Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.

```sql
SELECT lpep_pickup_datetime
FROM trips
ORDER BY trip_distance DESC
LIMIT 1;
```

> **Answer**: 2019-10-31

#### Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

```sql
SELECT z."Zone", SUM(t.total_amount) AS total_amount_all
FROM trips AS t
LEFT JOIN zones AS z ON t."PULocationID" = z."LocationID"
WHERE t.lpep_pickup_datetime::date = '2019-10-18'
GROUP BY z."Zone"
HAVING SUM(t.total_amount) > 13000
ORDER BY total_amount_all DESC
LIMIT 5;
```

> **Answer**: East Harlem North, East Harlem South, Morningside Heights

#### Question 6. Largest tip

For the passengers picked up in October 2019 in the zone name "East Harlem North" which was the drop off zone that had the largest tip?

Note: it's tip , not trip

We need the name of the zone, not the ID.

```sql
SELECT zd."Zone", t.lpep_pickup_datetime, tip_amount
FROM trips AS t
LEFT JOIN zones AS zp ON t."PULocationID" = zp."LocationID"
LEFT JOIN zones AS zd ON t."DOLocationID" = zd."LocationID"
WHERE date_trunc('month', t.lpep_pickup_datetime) = '2019-10-01'
  AND zp."Zone" = 'East Harlem North'
ORDER BY tip_amount desc
LIMIT 1;
```

> **Answer**: JFK Airport

## Part 2: [Terraform](terraform)

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

### Prerequisites:

Put GCP credentials keys under `keys/my-creds.json`

### Questions {and answers}

#### Question 7. Trip Segmentation Count

Which of the following sequences, respectively, describes the workflow for:

- Downloading the provider plugins and setting up backend,
- Generating proposed changes and auto-executing the plan
- Remove all resources managed by terraform`

> **Answer**: terraform init, terraform apply -auto-approve, terraform destroy
