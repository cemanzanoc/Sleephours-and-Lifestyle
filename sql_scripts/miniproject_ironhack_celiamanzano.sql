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
    COUNT(*) AS diagnosis_count, 
    ROUND(AVG(stress_level),2) AS avg_stress 
FROM 
    symptoms
GROUP BY 
    age_range, diagnosis
ORDER BY 
    age_range, avg_stress DESC; 

-- 1.2 Query to calculate the average stress level for each occupatio , grouped by age range.
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

-- If I do it for the table counting "No diagnosis" patients... // Graph this add age range¿?
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
    
-- Added no diagnosis and age range
SELECT 
    COALESCE(s.diagnosis, 'No diagnosis') AS diagnosis,
    p.gender, 
    COUNT(p.patient_id) AS num_patients,
    CASE
        WHEN p.age BETWEEN 0 AND 18 THEN '0-18'
        WHEN p.age BETWEEN 19 AND 35 THEN '19-35'
        WHEN p.age BETWEEN 36 AND 50 THEN '36-50'
        WHEN p.age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_range
FROM 
    patients p
LEFT JOIN 
    symptoms s ON p.patient_id = s.patient_id
GROUP BY 
    COALESCE(s.diagnosis, 'No diagnosis'), 
    p.gender, 
    age_range
ORDER BY 
    diagnosis,age_range, p.gender;


-- 3. Physical activity related with sleep quality // Can not be related to diagnosis...--
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
    COUNT(*) AS patient_count
FROM 
    therapy
GROUP BY 
    diagnosis,
    medication
ORDER BY 
    diagnosis,
    patient_count DESC,
    medication;

-- Do the same but only visualising most common medication for each diagnosis
SELECT 
    t.diagnosis,  
    t.medication,  
    COUNT(*) AS patient_count  -- Cuenta el número de pacientes para cada medicamento
FROM 
    therapy t  -- Desde la tabla de tratamientos (therapies) con alias t
JOIN (
    -- Subconsulta para obtener el medicamento más frecuente por diagnóstico
    SELECT 
        diagnosis,  -- Obtiene el diagnóstico
        medication,  -- Obtiene el medicamento
        COUNT(*) AS med_count  -- Cuenta el número de pacientes para cada medicamento
    FROM 
        therapy  -- Desde la tabla de tratamientos
    GROUP BY 
        diagnosis, medication  -- Agrupa por diagnóstico y medicamento
) AS counts  -- Alias para la subconsulta interna
ON t.diagnosis = counts.diagnosis  -- Unimos por diagnóstico
AND t.medication = counts.medication  -- Unimos por medicamento
WHERE 
    counts.med_count = (
        -- Subconsulta para obtener la frecuencia máxima de medicamento para cada diagnóstico
        SELECT MAX(med_count) 
        FROM (
            SELECT 
                diagnosis,
                medication,
                COUNT(*) AS med_count  -- Cuenta el número de pacientes para cada medicamento
            FROM 
                therapy
            GROUP BY 
                diagnosis, medication
        ) AS sub_counts
        WHERE sub_counts.diagnosis = t.diagnosis  -- Asegura que la subconsulta esté filtrada por diagnóstico
    )
GROUP BY 
    t.diagnosis, t.medication  -- Agrupa por diagnóstico y medicamento para contar el número de pacientes
ORDER BY 
    t.diagnosis;  -- Ordena por diagnóstico

