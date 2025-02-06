#  US Household Income Analysis

### Project Overview

This data analysis project focuses on analyzing U.S. household income data by performing data cleaning firstly, such as renaming columns and ensuring data consistency, followed by exploratory data analysis (EDA) to uncover trends, patterns, and insights at the state and city levels. The analysis aims to provide meaningful insights into household income distribution without time-series considerations, leveraging structured queries to extract and interpret key statistics.

### Data Sources 

Household Income Data: The datasets used for this analysis are the "USHouseholdIncome.csv" file and the "USHouseholdIncome_Statistics.csv" file containing detailed information about  U.S. household income data, including state, county, city, zip codes, area codes, land and water area, latitude, longitude, and geospatial attributes relevant to local government and economic analysis.

### Tools

- SQL (MYSQL) - For cleaning and analyzing the data

### Data Cleaning/Preparation

In the initial data preparation phase, I performed the following tasks:
1. Data loading and inspection.
2. Column Renaming.
3. Data cleaning.
   
These are some interesting code I worked with in the data cleaning phase

```sql
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id)> 1 ;

SELECT *
FROM (
SELECT row_id, 
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1
;

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, 
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_project.us_household_income
		) duplicates
		WHERE row_num > 1
);

UPDATE us_project.us_household_income 
SET Type = 'Borough'
WHERE Type = 'Boroughs';

SELECT ALand, AWater
FROM us_project.us_household_income 
WHERE (ALand = 0 OR ALand = ' ' OR ALand IS NULL);

```
### Exploratory Data Analysis (EDA)

When we are exploring the data we are trying to find trends, patterns, insights into the data, I notice there's no date fields, so no time series data. So probably won't be looking for trends over time.

### Data Analysis

These are some interesting code I worked with

```sql
SELECT * 
FROM us_project.us_household_income; 

SELECT *
FROM us_project.us_household_income_statistics;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

SELECT u.State_Name, County, Type, 'Primary', Mean, Median
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
;

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10
;
```






