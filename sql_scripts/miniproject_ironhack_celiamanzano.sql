-- Create database
CREATE DATABASE IF NOT EXISTS miniproject_ironhack;
-- Use miniproject_ironhack database
USE miniproject_ironhack;

-- Show tables
SHOW TABLES;

-- 1. Average stress level and diagnosis vs. Average stress level and occupation group by age
-- 1.1 Query to calculate the average stress level for each diagnosis, grouped by age range.
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
WHERE 
    stress_level IS NOT NULL -- Excluye valores nulos
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
    COUNT(*) AS diagnosis_count, -- Número de casos por diagnóstico
    ROUND(AVG(stress_level),2) AS avg_stress -- Promedio de nivel de estrés
FROM 
    symptoms
GROUP BY 
    age_range, diagnosis
ORDER BY 
    age_range, avg_stress DESC; 

-- 1.2 Query to calculate the average stress level for each diagnosis, grouped by age range.
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

-- Problema no se pueden comparar o juntar porque no coinciden la tabla symptoms no tiene occupation y la tabla lifestyle and sleep no tiene diagnosis.... Sería una relación indirecta....

-- 2. Query to know diagnosis type regarding gender. Only need to do it in Symptoms table, if you use JOIN with "No diagnosis" with table patient same result¿?
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

-- If I do it for the table counting "No diagnosis" patients...
SELECT 
    COALESCE(s.diagnosis, 'No diagnosis') AS diagnosis,
    p.gender, 
    COUNT(p.patient_id) AS num_patients
FROM 
    patients p
LEFT JOIN 
    symptoms s ON p.patient_id = s.patient_id
GROUP BY 
    COALESCE(s.diagnosis, 'No diagnosis'), p.gender
ORDER BY 
    diagnosis, p.gender;

-- 3. Physical activity related with sleep quality // Can not be related to diagnosis...
SELECT
    physical_activity_level,
    ROUND(AVG(sleep_quality),2) AS avg_sleep_quality
FROM 
    lifestyle_and_sleep
GROUP BY
    physical_activity_level
ORDER BY
    physical_activity_level,
    avg_sleep_quality;

-- 4. Relationship between diagnosis, medication and therapy type. And number of patients associated with each combination
SELECT 
    diagnosis,
    medication,
    therapy_type,
    COUNT(*) AS patient_count
FROM 
    therapy
GROUP BY 
    diagnosis,
    medication,
    therapy_type
ORDER BY 
    diagnosis, 
    medication,
    therapy_type;
