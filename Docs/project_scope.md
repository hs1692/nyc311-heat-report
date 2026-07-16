# Project Scope

## Project Name

NYC HPD Heat/Hot Water Operational Analytics Pipeline

---

## Project Objective

Develop an automated analytics pipeline that retrieves NYC 311 Heat/Hot Water complaints from the NYC Open Data API, stores them in PostgreSQL, transforms the data with SQL, and delivers operational dashboards through Power BI.

The goal is to replace a manually downloaded CSV workflow with a repeatable and automated reporting solution.

---

## Business Problem

The original project analyzed a historical CSV export of NYC 311 complaints.

Although useful for one-time analysis, the process required manually downloading updated data whenever new complaints became available.

This project modernizes that workflow by creating a pipeline capable of automatically retrieving and processing current complaint data.

---

## Business Users

- HPD Operations Analysts
- HPD Supervisors
- HPD Managers
- NYC Data Analysts
- Business Intelligence Analysts

---

## Data Source

NYC Open Data

Dataset:

311 Service Requests (2020–Present)

---

## Project Scope

This project focuses exclusively on:

Agency:
- HPD

Complaint Type:
- Heat/Hot Water

The project intentionally excludes unrelated complaint categories such as Noise, Rodents, Illegal Parking, Taxi, Parks, and Transportation requests.

---

## Data Pipeline

NYC Open Data API

↓

Python

↓

PostgreSQL

↓

SQL

↓

Power BI

↓

Azure Automation

---

## Expected Business Questions

Examples include:

- How many new Heat/Hot Water complaints were received today?
- How many complaints remain open?
- What is the average resolution time?
- Which ZIP Codes generate the highest complaint volume?
- Which buildings repeatedly generate complaints?
- Which boroughs experience the largest backlog?
- Which complaints are overdue?

---

## Future Scope

The pipeline will be designed to support future expansion into additional HPD complaint categories, such as:

- Water Leak
- Plumbing
- Electrical
- Mold

without requiring significant architectural changes.