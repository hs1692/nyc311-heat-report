# NYC 311 Heat Complaint Analysis 

## Overview Analyzed NYC 311 Heat/Hot Water complaints across recent winter periods using SQL and Tableau to evaluate service demand and resolution performance. 

## Tools - MySQL - Tableau Public 

## Dataset - NYC 311 Service Requests - Date Range: 2023-10-01 to 2025-04-30 - Focus: Heat/Hot Water complaints 

## Workflow - Imported raw CSV into MySQL - Created cleaned view with renamed fields and datetime conversion - Validated date ranges, null values, and complaint types - Built Heat/Hot Water subset table - Aggregated complaint volume and resolution time by borough and ZIP code - Visualized results in Tableau 
## SQL Structure

- 01_table_creation.sql: table setup and initial data load  
- 02_analysis.sql: combined data cleaning, validation, and aggregation queries  

## Key Insights - The Bronx had the highest complaint volume. - Manhattan had the slowest average resolution time. - Northern Manhattan showed both high complaint volume and slower resolution times, indicating a localized service bottleneck. - The Bronx handled a higher volume of complaints more efficiently relative to other boroughs. 

## Dashboard ![Dashboard](images/dashboard.png)
