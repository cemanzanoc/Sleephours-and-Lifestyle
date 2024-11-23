-- Create database
CREATE DATABASE IF NOT EXISTS miniproject_ironhack;
-- Use miniproject_ironhack database
USE miniproject_ironhack;

-- Show tables
SHOW TABLES;

-- 1. Average stress level and diagnosis vs. average stress level and occupation group by age
-- 1.1.1 Query to calculate the average stress level for each diagnosis, grouped by age range.
SELECT 
    CASE
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_range,
    diagnosis,
    AVG(stress_level) AS avg_stress
FROM 
    symptoms
GROUP BY 
    age_range, diagnosis
ORDER BY 
    age_range, avg_stress DESC;
    
-- Same but counting the frequency

SELECT 
    CASE
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_range,
    diagnosis,
    COUNT(*) AS diagnosis_count, 
    ROUND(AVG(stress_level),2) AS avg_stress 
FROM 
    symptoms
GROUP BY 
    age_range, diagnosis
ORDER BY 
    age_range, avg_stress DESC; 
    
-- 1.1.2 Query to get according to average stress level diagnosis vs.gender
SELECT 
    gender,
    diagnosis,
    AVG(stress_level) AS avg_stress_level
FROM 
    symptoms
GROUP BY 
    gender, diagnosis
ORDER BY 
    gender, avg_stress_level DESC;

-- 1.2 Query to calculate the average stress level for each occupation , grouped by age range.
SELECT 
    CASE
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_range,
    occupation,
    COUNT(*) AS occupation_count, 
    ROUND(AVG(stress_level),2) AS avg_stress 
FROM 
    lifestyle_and_sleep

GROUP BY 
    age_range, occupation
ORDER BY 
    age_range, avg_stress DESC; 


-- 2. Query to know diagnosis type regarding gender.
SELECT 
	diagnosis, 
    gender, 
    COUNT(patient_id) AS num_patients
FROM 
    symptoms
GROUP BY 
    diagnosis, gender
ORDER BY 
    diagnosis, gender;
    
-- 2.1 Query to know diagnosis type regarding gender and age range

SELECT 
    diagnosis, 
    gender, 
    COUNT(patient_id) AS num_patients,
    CASE
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_range
FROM 
    symptoms 
GROUP BY 
    diagnosis, 
    gender, 
    age_range
ORDER BY 
    diagnosis, 
    gender, 
    age_range;


-- 3. Physical activity related with sleep quality grouped by age 
SELECT
    age,
    AVG(physical_activity_level) AS avg_physical_activity_level,
    AVG(sleep_quality) AS avg_sleep_quality
FROM 
    lifestyle_and_sleep
GROUP BY
    age
ORDER BY
    age;
-- 3.1. Do the same but wit age ranges
SELECT
    CASE
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+' 
    END AS age_range,
    AVG(physical_activity_level) AS avg_physical_activity_level,
    AVG(sleep_quality) AS avg_sleep_quality
FROM 
    lifestyle_and_sleep
GROUP BY
    age_range
ORDER BY
    age_range;

-- 4. Relationship between diagnosis, medication and the and number of patients associated with each combination
SELECT 
    diagnosis,
    medication,
    COUNT(*) AS num_patient
FROM 
    therapy
GROUP BY 
    diagnosis,
    medication
ORDER BY 
    diagnosis,
    num_patient DESC,
    medication;
-- All medicines are used for all diagnosis, so there are more factors to analyse in here

-- 4.1 Most used medication for each diagnosis type
WITH ranked_medications AS (
    SELECT 
        diagnosis,
        medication,
        COUNT(*) AS num_patient,
        ROW_NUMBER() OVER (
            PARTITION BY diagnosis 
            ORDER BY COUNT(*) DESC
        ) AS row_rank
    FROM 
        therapy
    GROUP BY 
        diagnosis, 
        medication
)
SELECT 
    diagnosis,
    medication,
    num_patient
FROM 
    ranked_medications
WHERE 
    row_rank = 1
ORDER BY 
    diagnosis;
-- Depending the diagnosis there are different medications, but no conclusions

-- 4.2 Most used medication for each theraphy type. Is it more common to use a medicine rather than others?
SELECT 
    therapy_type,
    SUM(CASE WHEN medication = 'Antipsychotics' THEN 1 ELSE 0 END) AS Antipsychotics,
    SUM(CASE WHEN medication = 'Mood Stabilizers' THEN 1 ELSE 0 END) AS Mood_Stabilizers,
    SUM(CASE WHEN medication = 'Antidepressants' THEN 1 ELSE 0 END) AS Antidepressants,
    SUM(CASE WHEN medication = 'Benzodiazepines' THEN 1 ELSE 0 END) AS Benzodiazepines,
    SUM(CASE WHEN medication = 'Anxiolytics' THEN 1 ELSE 0 END) AS Anxiolytics,
    SUM(CASE WHEN medication = 'SSRIs' THEN 1 ELSE 0 END) AS SSRIs
FROM 
    therapy
GROUP BY 
    therapy_type
ORDER BY 
    therapy_type;
