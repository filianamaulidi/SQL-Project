# SQL Project: Analysis for the Salaries of Data Science and Data Analysis Positions

## Checking whether there is the null data or not
Here are the SQL syntax or query:
``` js
SELECT 
    *
FROM
    gaji
WHERE
    work_year IS NULL
        OR experience_level IS NULL
        OR employment_type IS NULL
        OR job_title IS NULL
        OR salary IS NULL
        OR salary_currency IS NULL
        OR salary_in_usd IS NULL
        OR employee_residence IS NULL
        OR remote_ratio IS NULL
        OR company_location IS NULL
        OR company_size IS NULL;
```
+ **Result**: There is no null data exist in the whole table.

## Identify all job positions in the data
Syntax:
```js
SELECT DISTINCT
    job_title
FROM
    gaji
ORDER BY job_title;
```
+ **Result**: There are several job positions in the data. Those jobs are varies from 3D Computer Vision Researcher to Finance Data Analyst.

## Calculate total job title that are listed on the whole data
```js
SELECT 
    COUNT(DISTINCT job_title)
FROM
    gaji;
```
+ **Result**: There are 50 job positions listed on the data.

## What are job titles that related to data analysis?
``` js
SELECT DISTINCT
    job_title
FROM
    gaji
WHERE
    job_title LIKE ('%data analyst%')
ORDER BY job_title;
```
+ **Result**: There are 9 job positions that are related to data analyst which are BI Data Analyst, Business Data Analyst, Data Analyst, Finance Data Analyst, Financial Data Analyst, Lead Data Analyst, Marketing Data Analyst, Principal Data Analyst, and Product Data Analyst,

## Calculate the average salary of the employees (in USD)
```js
SELECT 
    AVG(salary_in_usd) AS rerata_gaji_in_usd
FROM
    gaji;
```
+ **Result**: The average salary of all employees in USD is $112.297.
+ **Recommendation**: We might want to know the average salary in rupiah to make it more insightfull as an Indonesian. Thus, we need to convert it to Indonesian Rupiah.

## Calculate the average salary of the employees (in Rupiahs)
``` js
SELECT 
    (AVG(salary_in_usd * 15000)) / 12 AS rerata_gaji_in_rupiah_per_moth
FROM
    gaji;
```
+ **Result**: The average salary of all employees in Rupiah is Rp140.372.337

## What is the average salary for a data analyst based on experience level and type of employment?
```js
SELECT 
    experience_level,
    employment_type,
    (AVG(salary_in_usd) * 15000) / 12 AS rerata_gaji_data_analyst_in_rupiah_per_month
FROM
    gaji
GROUP BY experience_level , employment_type
ORDER BY rerata_gaji_data_analyst_in_rupiah_per_month;
```
+ **Result**: Based on the experience level and employment type, the highest average salary (Rp) owned by contract expert position which the salary is Rp520.000.000 while the lowest salary is from the part-timer entry level which the salary is Rp3.582.1071

## Which countries have an interesting salaries for full-time posisition data analyst, with entry or mid level, and have salaries >= from $20,000?
``` js
SELECT 
    company_location, AVG(salary_in_usd) AS rerata_gaji
FROM
    gaji
WHERE
    job_title LIKE ('%data analyst%')
        AND employment_type = 'FT'
        AND experience_level IN ('EN' , 'MI')
GROUP BY company_location
HAVING rerata_gaji >= 20000
ORDER BY rerata_gaji DESC;
```
+ **Result**: Based on the data, the country with the highest paid data analyst is the United States ($101.397), followed by Canada at $70.818 and Luxembourg at $59.102.
+ **Insight**: This opens up insight for job seeker, especially those who are in interested in the data analysis field, in choosing which country is the best decision in deciding to pursue a career.

## In what year did the salary increase from Mid to EX (Senior/Expert) level have the highest increase?
Job category: Data Analysis 

Employment type: Full-Time (FT)

Here are the syntax using CTE:
```js
with gaji1 as (
select work_year, avg(salary_in_usd) as rerata_gaji_posisi_expert
from gaji
where
	employment_type="FT" and experience_level="EX" and job_title like "%data analyst%"
group by work_year
), gaji2 as (
select work_year, avg(salary_in_usd) as rerata_gaji_posisi_mid
from gaji
where
	employment_type="FT" and experience_level="MI" and job_title like "%data analyst%"
group by work_year
),
t_year as (
select distinct work_year from gaji
)
select t_year.work_year,
	gaji1.rerata_gaji_posisi_expert, gaji2.rerata_gaji_posisi_mid, 
    gaji1.rerata_gaji_posisi_expert - gaji2.rerata_gaji_posisi_mid as selisih
from t_year
left join gaji1 on gaji1.work_year=t_year.work_year
left join gaji2 on gaji2.work_year=t_year.work_year;
```
+ **Result**: 2022 has the highest salary increase for Mid Level to Expert Level. The increase itself reaches $51.029. It has a quite significant increase compared to the previous year with $41.601 salary increase.
