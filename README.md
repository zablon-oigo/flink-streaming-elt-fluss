## Streaming ELT from Postgres to Fluss


This project demonstrate a streaming ELT job from PostgreSQL to Fluss using Flink CDC, including full-database synchronization and schema change evolution. 

#### Architecture Diagram
<img width="491" height="212" alt="fluss drawio" src="https://github.com/user-attachments/assets/8fd6be8a-0680-4afd-a3c8-3a1822c1a033" />


#### Demo

Connect to PostgreSQL:

```sh
psql -h localhost -p 5432 -U root postgres
```
Create the adb database
```sh
CREATE DATABASE adb;
\c adb
```
#### Create Schemas and Tables

Create schemas and tables, then insert data
```sh
-- Create schemas
CREATE SCHEMA hr;
CREATE SCHEMA sales;

-- Create tables
CREATE TABLE hr.employees(
   ID INT PRIMARY KEY NOT NULL,
   NAME TEXT NOT NULL,
   AGE INT NOT NULL,
   ADDRESS CHAR(50),
   SALARY REAL
);

CREATE TABLE sales.orders(
   ID INT PRIMARY KEY NOT NULL,
   PRODUCT TEXT NOT NULL,
   QUANTITY INT NOT NULL,
   REGION CHAR(50),
   AMOUNT REAL
);

-- Insert data
INSERT INTO hr.employees (ID, NAME, AGE, ADDRESS, SALARY)
VALUES (1, 'Paul', 32, 'California', 20000.00);

INSERT INTO sales.orders (ID, PRODUCT, QUANTITY, REGION, AMOUNT)
VALUES (1, 'Laptop', 5, 'East', 49999.50);

```
#### Submit the Flink CDC Job

Deploy the CDC pipeline to the Flink Standalone cluster:

```sh
bash bin/flink-cdc.sh postgres-to-fluss.yaml

```
#### Verify Data in Fluss

Query data in Fluss
```sh
bin/sql-client.sh
```

```sh
SET 'sql-client.execution.result-mode' = 'tableau';
```

```sh
CREATE CATALOG developer_catalog WITH (
    'type' = 'fluss',
    'bootstrap.servers' = 'coordinator-server:9123',
    'client.security.protocol' = 'SASL',
    'client.security.sasl.username' = 'developer',
    'client.security.sasl.password' = 'developer-pass'
);
```

```sh
   USE CATALOG developer_catalog;
   SHOW DATABASES;
```

Query the synchronized table:

```sh
SELECT * FROM `developer_catalog`.`hr`.`employees` LIMIT 20;
```
