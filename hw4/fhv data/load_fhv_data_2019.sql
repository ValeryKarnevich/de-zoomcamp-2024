CREATE OR REPLACE EXTERNAL TABLE `fourth-return-415713.trips_data_all.fhv_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://homework4-fhv-data-2019/fhv_tripdata_2019-*.csv.gz']
);

CREATE OR REPLACE TABLE fourth-return-415713.trips_data_all.fhv_tripdata_local AS
SELECT * FROM fourth-return-415713.trips_data_all.fhv_tripdata;
