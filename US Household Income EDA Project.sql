# US Household Income Exploratory Data Analysis


SELECT * 
FROM us_project.us_household_income; 

SELECT *
FROM us_project.us_household_income_statistics; 

#When we are exploring the data we are trying to find trends, patterns, insights into the data.
#I'm noticing there's no date fields, so no time series data. So probably won't be looking for trends over time.

#We can look at some information at the state level through, like size of each state, average city size, etc. 
#We can also join to the statistics table and look at mean and median incomes

#Let's start with some simple stuff and work our way to joining the tables.

#Let's select the columns we want to work with
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;  

#Just glancing at these results, they look quite accurate. Texas being the largest

#Let's look at the total size of each state and order it from smallest to largest
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

#I expected Michigan, florida, minnesota to be in there and also Alaska, but I didn't expect Texas or North carolina to be in the top 10

#Now that's interesting, but this is primarily an income dataset. Let's join the table together and look at that
 
SELECT * 
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
; 

#Now let's filter on the column we want
SELECT u.State_Name, County, Type, 'Primary', Mean, Median
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
; 

#First let's look at just the state level and the average mean and median
SELECT u.State_Name, AVG(Mean), AVG(Median)
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
GROUP BY u.State_Name
ORDER BY 3;

#These are the lowest paid or at least have the lowest income in the US

SELECT u.State_Name, AVG(Mean), AVG(Median)
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
GROUP BY u.State_Name
ORDER BY 3;

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5
; 

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10
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

#Now we've just look at the state level. We don't have to just use this. Let's look at it by type
#I don't know what primary is so let's add it in there and let's the a count of type
SELECT 'Type', 'Primary', AVG(Mean), AVG(Median)
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
GROUP BY 'Type', 'Primary'
ORDER BY 3;

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY 3 DESC
LIMIT 20
; 

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20
; 

SELECT *
FROM us_project.us_household_income
WHERE Type = 'community'
; 

SELECT u.State_Name, City, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean), 1) DESC
;