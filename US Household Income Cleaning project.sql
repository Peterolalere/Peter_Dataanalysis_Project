# US Household Income Data Cleaning

#Let's fetch record from then 'us_project.us_household_income' table so we can look through it
SELECT * 
FROM us_project.us_household_income; 


#Let's fetch record from then 'us_project.us_household_income_statistics' table so we can look through it
SELECT *
FROM us_project.us_household_income_statistics;

#Let's change the name of the first column in the 'us_project.us_household_income_statistics' table from `ï»¿id` TO `id`
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

#To know the size of the 'us_project.us_household_income' table, let's do a count of it
SELECT COUNT(id)
FROM us_project.us_household_income;

#To know the size of the 'us_project.us_household_income_statistics' table, let's do a count of it also
SELECT COUNT(id)
FROM us_project.us_household_income_statistics;

#Lets check for duplicate in the 'us_project.us_household_income' table by Grouping By
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id)> 1 ;

#Now let's use a window function known as ROW_NUMBER() to assess duplicate records in the us_project.us_household_income table
SELECT *
FROM (
SELECT row_id, 
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1
;

#Now we are deleting the duplicate records we found
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

#Let's select distict list of state_name in the table this will helps in standarizing our data andhelps in the cleaning process
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1;

#We are changing a name that was spelt incorrectly from 'georia' to 'Georgia' in the us_project.us_household_income  table
UPDATE us_project.us_household_income 
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

#Lets also standardize a name  from 'alabama' to 'Alabama' in the us_project.us_household_income  table
UPDATE us_project.us_household_income 
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

#In the 'Autauga County' we are getting distinct records
SELECT DISTINCT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1;

#Updating the Place field to 'Autaugaville' for records in 'Autauga County' where the City is 'Vinemont'
UPDATE us_project.us_household_income 
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

#Lets do a count of distict or unique 'Type' values in the us_project.us_household_income table
SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
;

#In the 'Type' Field lets set 'Boroughs' to  'Borough'
UPDATE us_project.us_household_income 
SET Type = 'Borough'
WHERE Type = 'Boroughs';

SELECT ALand, AWater
FROM us_project.us_household_income 
WHERE (ALand = 0 OR ALand = ' ' OR ALand IS NULL);

#We are able to detect where the land area is 0, empty or NULL












