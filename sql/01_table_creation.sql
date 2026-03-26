
USE nyc311;
DROP TABLE IF EXISTS nyc311_raw;
SHOW TABLES LIKE 'nyc311_raw';

CREATE TABLE nyc311_raw (
  `Unique Key` TEXT,
  `Created Date` TEXT,
  `Closed Date` TEXT,
  `Agency` TEXT,
  `Agency Name` TEXT,
  `Problem (formerly Complaint Type)` TEXT,
  `Problem Detail (formerly Descriptor)` TEXT,
  `Additional Details` TEXT,
  `Location Type` TEXT,
  `Incident Zip` TEXT,
  `Status` TEXT,
  `Resolution Description` TEXT,
  `Resolution Action Updated Date` TEXT,
  `City` TEXT,
  `Borough` TEXT,
  `Location` TEXT
);


LOAD DATA LOCAL INFILE 'D:/Projects/nyc311-heat-report/data/raw/311_Service_Requests_from_2020_to_Present_20260325.csv'
INTO TABLE nyc311_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
`Unique Key`,
`Created Date`,
`Closed Date`,
`Agency`,
`Agency Name`,
`Problem (formerly Complaint Type)`,
`Problem Detail (formerly Descriptor)`,
`Additional Details`,
`Location Type`,
`Incident Zip`,
`Status`,
`Resolution Description`,
`Resolution Action Updated Date`,
`City`,
`Borough`,
`Location`
);
