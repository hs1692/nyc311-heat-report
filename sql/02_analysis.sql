#SQL Structure
-- Combines validation, cleaning, and analysis steps
-- Includes borough and ZIP aggregations used in Tableau

use  nyc311;

select count(*) from nyc311_raw;
SELECT
  MIN(`Created Date`) AS min_created,
  MAX(`Created Date`) AS max_created
FROM nyc311_raw;
# checking min max dates correct. was not
SELECT *
FROM nyc311_raw
LIMIT 5;
#looking at first 5 rows showed they were indeed correct. sql reading dates wrong because text
SELECT 
  MIN(STR_TO_DATE(`Created Date`, '%m/%d/%Y %h:%i:%s %p')) AS min_created,
  MAX(STR_TO_DATE(`Created Date`, '%m/%d/%Y %h:%i:%s %p')) AS max_created
FROM nyc311_raw;
 # conversion showed correc  date range of sample is what i exported from online. 
 USE nyc311;

CREATE OR REPLACE VIEW nyc311_clean AS
SELECT
  `Unique Key` AS unique_key,
  STR_TO_DATE(`Created Date`, '%m/%d/%Y %h:%i:%s %p') AS created_dt,
  STR_TO_DATE(`Closed Date`, '%m/%d/%Y %h:%i:%s %p') AS closed_dt,
  `Agency` AS agency,
  `Agency Name` AS agency_name,
  `Problem (formerly Complaint Type)` AS complaint_type,
  `Problem Detail (formerly Descriptor)` AS descriptor,
  `Additional Details` AS descriptor_2,
  `Location Type` AS location_type,
  `Incident Zip` AS incident_zip,
  `Status` AS status,
  `Resolution Description` AS resolution_description,
  STR_TO_DATE(`Resolution Action Updated Date`, '%m/%d/%Y %h:%i:%s %p') AS resolution_action_updated_dt,
  `City` AS city,
  `Borough` AS borough,
  `Location` AS location
FROM nyc311_raw;

SELECT created_dt, closed_dt
FROM nyc311_clean
LIMIT 5;

SELECT 
  MIN(created_dt) AS min_created,
  MAX(created_dt) AS max_created
FROM nyc311_clean;

select 
	complaint_type, 
    count(*) as cnt 
    from nyc311_clean 
    group by complaint_type 
    order by cnt desc 
    limit 20;
    
USE nyc311;
select 
	sum(created_dt is null) as null_created_dt, 
	sum(closed_dt is null) as null_closed_dt, 
	sum(resolution_action_updated_dt is null) as null_resolution_action_updated_dt
from nyc311_clean;
# fix nulls in datetime

#still didnt work when creating heat table so have to trim potential missing values with empty spaces '   ' before replacing with null. 
CREATE OR REPLACE VIEW nyc311_clean AS
SELECT
  `Unique Key` AS unique_key,

  STR_TO_DATE(NULLIF(TRIM(`Created Date`), ''), '%m/%d/%Y %h:%i:%s %p') AS created_dt,
  STR_TO_DATE(NULLIF(TRIM(`Closed Date`), ''), '%m/%d/%Y %h:%i:%s %p') AS closed_dt,

  `Agency` AS agency,
  `Agency Name` AS agency_name,
  `Problem (formerly Complaint Type)` AS complaint_type,
  `Problem Detail (formerly Descriptor)` AS descriptor,
  `Additional Details` AS descriptor_2,
  `Location Type` AS location_type,
  `Incident Zip` AS incident_zip,
  `Status` AS status,
  `Resolution Description` AS resolution_description,

  STR_TO_DATE(NULLIF(TRIM(`Resolution Action Updated Date`), ''), '%m/%d/%Y %h:%i:%s %p') AS resolution_action_updated_dt,

  `City` AS city,
  `Borough` AS borough,
  `Location` AS location
FROM nyc311_raw;

DROP TABLE IF EXISTS heat_hotwater;
CREATE TABLE heat_hotwater AS
SELECT *
FROM nyc311_clean
WHERE complaint_type = 'Heat/Hot Water';
# filtered for only heat water comlaints for scope 

SELECT 
  SUM(incident_zip IS NULL OR incident_zip = '') AS missing_zip,
  SUM(borough IS NULL OR borough = '') AS missing_borough,
  SUM(status IS NULL OR status = '') AS missing_status
FROM heat_hotwater;
# validation of zips borough and status daat for missing values. small amounts and negligble. clean 

SELECT status, COUNT(*)
FROM heat_hotwater
GROUP BY status;
# status counts for heat water complaints. closed ins dominant. some still in progress or open. 


# startign metrics 
#1. total complaints 
SELECT COUNT(*) AS total_heat_complaints
FROM heat_hotwater;
#2. avg resolution time 
SELECT 
  AVG(TIMESTAMPDIFF(HOUR, created_dt, closed_dt)) AS avg_resolution_hours
FROM heat_hotwater
WHERE closed_dt IS NOT NULL;

#3 open vs closed 
select status, 
count(*) as cnt 
from heat_hotwater
group by status;
#4 borough breakdown 
SELECT 
  borough,
  COUNT(*) AS cnt
FROM heat_hotwater
GROUP BY borough
ORDER BY cnt DESC;

#date conversion

#1a borough complaints as percentage for hto water 
SELECT 
  borough,
  COUNT(*) AS complaints,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM heat_hotwater), 2) AS pct
FROM heat_hotwater
GROUP BY borough
ORDER BY complaints DESC;

#2 resolution performance(speed) by borough 
SELECT 
  borough,
  COUNT(*) AS complaints,
  ROUND(AVG(TIMESTAMPDIFF(HOUR, created_dt, closed_dt)), 2) AS avg_resolution_hours
FROM heat_hotwater
WHERE closed_dt IS NOT NULL
GROUP BY borough
ORDER BY avg_resolution_hours DESC;

#3 more micro resolution by zipcode 
SELECT 
  incident_zip,
  COUNT(*) AS complaints,
  ROUND(AVG(TIMESTAMPDIFF(HOUR, created_dt, closed_dt)), 2) AS avg_resolution_hours
FROM heat_hotwater
WHERE closed_dt IS NOT NULL
  AND incident_zip IS NOT NULL
  AND incident_zip != ''
GROUP BY incident_zip
HAVING COUNT(*) > 50
ORDER BY complaints DESC;
