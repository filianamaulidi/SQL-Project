create database salary;
SELECT 
    *
FROM
    gaji;

-- 1. Cek data null
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

-- 2. Ada posisi (job title) apa saja dalam data tersebut?
SELECT DISTINCT
    job_title
FROM
    gaji
ORDER BY job_title;

-- 3. Menghitung jumlah posisi pekerjaan yang ada pada data
SELECT 
    COUNT(DISTINCT job_title)
FROM
    gaji;

-- 4. Job title apa saja yang berkaitan dengan data analyst?
SELECT DISTINCT
    job_title
FROM
    gaji
WHERE
    job_title LIKE ('%data analyst%')
ORDER BY job_title;

-- 5. Berapa rata-rata gaji karyawan pada data tersebut (dalam usd)?
SELECT 
    AVG(salary_in_usd) AS rerata_gaji_in_usd
FROM
    gaji;
    
-- Rata-rata gaji dalam rupiah (all experiment level)?
SELECT 
    (AVG(salary_in_usd * 15000)) / 12 AS rerata_gaji_in_rupiah_per_moth
FROM
    gaji;
    
-- Rerata gaji dalam rupiah (tiap experience level)
SELECT 
    experience_level,
    (AVG(salary_in_usd * 15000)) / 12 AS rerata_gaji_in_rupiah_per_moth
FROM
    gaji
GROUP BY experience_level;

-- Rerata gaji berdasarkan work type full-time? 
SELECT 
    experience_level,
    employment_type,
    (AVG(salary_in_usd * 15000)) / 12 AS rerata_gaji_in_rupiah_per_month
FROM
    gaji
WHERE
    employment_type = 'FT'
GROUP BY experience_level , employment_type;

-- 6. Berapa rata-rata gaji data analyst berdasarkan experience level dan jenis employment?
SELECT 
    experience_level,
    employment_type,
    (AVG(salary_in_usd) * 15000) / 12 AS rerata_gaji_data_analyst_in_rupiah_per_month
FROM
    gaji
GROUP BY experience_level , employment_type
ORDER BY experience_level , employment_type;

-- 7. Negara mana dengan gaji yang menarik untuk posisi data analyst posisi full-time, experiment level enty level dan menengah, serta memiliki gaji >= dari $20000 ?
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

-- 8. Di tahun berapa kenaikan gaji dari posisi Mid ke EX (Senior/Expert) memiliki kenaikan tertinggi?
-- untuk pekerjaan berkaitan dengan data analyst, employment type FT (full-time)
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
-- tidak ada tahun 2020 karena di tabel gaji1 sebagai acuan tidak ada data dengan kategori data analyst FT (Full-Time) posisi EX