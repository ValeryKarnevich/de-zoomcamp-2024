-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `fourth-return-415713.ny_taxi.external_green_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://de-zoomcamp-homework3-data/green_tripdata_2022-*.parquet']
);

-- Check green trip data
SELECT * FROM fourth-return-415713.ny_taxi.external_green_tripdata limit 10;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE fourth-return-415713.ny_taxi.green_tripdata_non_partitoned AS
SELECT * FROM fourth-return-415713.ny_taxi.external_green_tripdata;

-- Count of records for the 2022 Green Taxi Data
SELECT COUNT(1) 
FROM fourth-return-415713.ny_taxi.green_tripdata_non_partitoned;

-- Distinct number of PULocationIDs for the entire dataset on both the tables
SELECT COUNT(DISTINCT PULocationID) FROM fourth-return-415713.ny_taxi.external_green_tripdata;

SELECT COUNT(DISTINCT PULocationID) FROM fourth-return-415713.ny_taxi.green_tripdata_non_partitoned;

-- Number of records with 'fare_amount' of 0
SELECT COUNT(1)
FROM fourth-return-415713.ny_taxi.external_green_tripdata
WHERE fare_amount = 0;

-- Optimized table for ordering the results by 'PUlocationID' and filtering based on 'lpep_pickup_datetime'
CREATE OR REPLACE TABLE fourth-return-415713.ny_taxi.green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT * FROM fourth-return-415713.ny_taxi.external_green_tripdata;

-- Distinct 'PULocationID' between 'lpep_pickup_datetime' 06/01/2022 and 06/30/2022
SELECT count(DISTINCT PULocationID)
FROM fourth-return-415713.ny_taxi.green_tripdata_non_partitoned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

SELECT count(DISTINCT PULocationID)
FROM fourth-return-415713.ny_taxi.green_tripdata_partitoned_clustered
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- Estimate query cost
SELECT COUNT(*)
FROM fourth-return-415713.ny_taxi.green_tripdata_non_partitoned;

