-- Question 3. Trip Segmentation Count
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


-- Question 4. Longest trip
SELECT lpep_pickup_datetime
FROM trips
ORDER BY trip_distance DESC
LIMIT 1;


-- Question 5. Biggest pickup zones
SELECT z
."Zone", SUM
(t.total_amount) AS total_amount_all
FROM trips AS t
LEFT JOIN zones AS z ON t."PULocationID" = z."LocationID"
WHERE t.lpep_pickup_datetime::date = '2019-10-18'
GROUP BY z."Zone"
HAVING SUM
(t.total_amount) > 13000
ORDER BY total_amount_all DESC
LIMIT 5;


-- Question 6. Largest tip
SELECT zd."Zone", t.lpep_pickup_datetime, tip_amount
FROM trips AS t
    LEFT JOIN zones AS zp ON t."PULocationID" = zp."LocationID"
    LEFT JOIN zones AS zd ON t."DOLocationID" = zd."LocationID"
WHERE date_trunc('month', t.lpep_pickup_datetime) = '2019-10-01'
    AND zp."Zone" = 'East Harlem North'
ORDER BY tip_amount desc
LIMIT 1;