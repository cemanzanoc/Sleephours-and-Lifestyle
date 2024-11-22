USE miniproject_ironhack; 

-- INDEX OF QUERIES:

-- 1. Sleep health and lifestyle
    -- 1.1 Average sleep quality, group by stress level
    -- 1.2 Average sleep quality, group by occupation
    -- 1.3 Average sleep quality, group by weight
    -- 1.4 Average stress level vs occupation
    -- 1.5 Average sleep quality and duration, group by age
        -- 1.5.1 Average sleep quality and duration, group by age range
        -- 1.5.2 TOP 10 AGES with the greatest average sleep duration
        -- 1.5.3 TOP 10 AGES with the lowest average sleep quality
        -- 1.5.4 TOP 10 AGES with sleep quality lower that 7
    -- 1.6 General average of sleep quality and duration
    -- 1.7 Average sleep quality and duration, group by gender 
    -- 1.8 Average sleep quality, duration and stress level group by gender
    -- 1.9 Physical activity vs sleep quality 
-- 2. Mental health diagnosis
    -- 2.1 Count of each type of diagnosis per age
    -- 2.2 Average sleep quality group by age, gender and diagnosis
    -- 2.3 Frequency of each diagnosis vs gender
    -- 2.4 Diagnosis vs sleep quality, group by gender
    -- 2.5 Diagnosis vs stress level, group by gender
    -- 2.6 Average stress level and diagnosis
        -- 2.6.1 Average stress level and diagnosis, group by age range
        -- 2.6.2 Average stress level and diagnosis frequency, group by age range
        -- 2.6.3 Average stress level and occupation, group by age range
    -- 2.7 Diagnosis per gender
        -- 2.7.1 Diagnosis per gender including 'No diagnosis' patients. 
        -- 2.7.2 Diagnosis per gender including 'No diagnosis' patients and age range. 
    -- 2.8 Number of patients group by diagnosis and medication
    -- 2.9 Most common medication for each diagnosis
-- 3. Mental health therapies
    -- 3.1 Most effective therapy
        -- 3.1.1 Taking into account severity
        -- 3.1.2 Not taking into account severity
    -- 3.2 Diagnosis vs treatment duration group by age, gender
    -- 3.3 Outcome vs adherence to treatment

-------------------------------------------------------------

-- 1. Sleep health and lifestyle:

-- 1.1 Average sleep quality, group by stress level:
SELECT 
    stress_level, 
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality'
FROM 
    lifestyle_and_sleep
GROUP BY stress_level
ORDER BY stress_level ASC;
    
-- 1.2 Average sleep quality, group by occupation:
SELECT 
    occupation, 
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality'
FROM 
    lifestyle_and_sleep
GROUP BY occupation
ORDER BY average_sleep_quality ASC;
    
-- 1.3 Average sleep quality, group by weight:
SELECT 
    bmi_category, 
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality'
FROM 
    lifestyle_and_sleep
GROUP BY bmi_category
ORDER BY average_sleep_quality ASC;
    
-- 1.4 Average stress level vs occupation:
SELECT 
    occupation, 
    ROUND(AVG(stress_level),2) AS 'average_stress_level'
FROM 
    lifestyle_and_sleep
GROUP BY occupation
ORDER BY average_stress_level ASC;

-- 1.5 Average sleep quality and duration, group by age:
SELECT 
	ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    ROUND(AVG(sleep_duration),2) AS 'average_sleep_duration', 
    age

FROM lifestyle_and_sleep
GROUP BY age
ORDER BY age DESC; 

-- 1.5.1 Average sleep quality and duration, group by age range:
SELECT 
	ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    ROUND(AVG(sleep_duration),2) AS 'average_sleep_duration', 
     CASE
        WHEN lage BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_range

FROM lifestyle_and_sleep
GROUP BY age_range
ORDER BY age_range DESC; 

-- 1.5.2 TOP 10 AGES with the greatest average sleep duration:
SELECT 
	ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    ROUND(AVG(sleep_duration),2) AS 'average_sleep_duration', 
    age

FROM lifestyle_and_sleep
GROUP BY age
ORDER BY average_sleep_duration DESC
LIMIT 10; 

-- 1.5.3 TOP 10 AGES with the lowest average sleep quality:
SELECT 
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    ROUND(AVG(sleep_duration),2) AS 'average_sleep_duration', 
    age

FROM lifestyle_and_sleep
GROUP BY age
ORDER BY average_sleep_duration ASC
LIMIT 10;

-- 1.5.4 TOP 10 AGES with sleep quality lower that 7:
SELECT 
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    ROUND(AVG(sleep_duration),2) AS 'average_sleep_duration', 
    age

FROM lifestyle_and_sleep
GROUP BY age
HAVING average_sleep_quality < 7
ORDER BY average_sleep_quality ASC
LIMIT 10; 

-- In this table, we can observe that average_sleep_quality is correlated with
-- average_sleep_duration. The age with both lowest sleep quality and sleep duration 
-- is in the ranges (25,35) and (45,50) <- this range could be an outlier.

-- 1.6 General average of sleep quality and duration:

SELECT ROUND(AVG(sleep_duration),2) AS average_total_of_sleep_duration FROM lifestyle_and_sleep;
SELECT ROUND(AVG(sleep_quality),2) AS average_total_of_sleep_quality FROM lifestyle_and_sleep;
-- The average of sleep duration is 7.13

-- 1.7 Average sleep quality and duration, group by gender: 
SELECT 
	ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    ROUND(AVG(sleep_duration),2) AS 'average_sleep_duration', 
    gender

FROM lifestyle_and_sleep
GROUP BY gender; 

-- In general, men sleep better than women

-- 1.8 Average sleep quality, duration and stress level group by gender:
SELECT 
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    ROUND(AVG(sleep_duration),2) AS 'average_sleep_duration',
    ROUND(AVG(stress_level),2) AS 'average_stress_level', 
    gender

FROM lifestyle_and_sleep
GROUP BY gender; 

-- In the same way, men have usually more stress level than women

-- 1.9 Physical activity vs sleep quality: 
SELECT
    physical_activity_level,
    OUND(AVG(sleep_quality),2) AS 'average_sleep_quality'
FROM lifestyle_and_sleep
GROUP BY physical_activity_level
ORDER BY physical_activity_level,average_sleep_quality;

-- 2. Mental health diagnosis:

-- 2.1 Count of each type of diagnosis per age:

SELECT 
	CASE
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_range,
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    diagnosis, 
    COUNT(diagnosis) AS 'diagnosis_count'

FROM symptoms
GROUP BY age_range, diagnosis; 

SELECT 
	age,
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    diagnosis, 
    COUNT(diagnosis) AS 'diagnosis_count'

FROM symptoms
GROUP BY diagnosis, age;  

-- 2.2 Average sleep quality group by age, gender and diagnosis
SELECT 
	age,
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality', 
    diagnosis,
    gender

FROM symptoms
GROUP BY diagnosis, age, gender; 

-- 2.3 Frequency of each diagnosis vs gender:
SELECT 
	p.gender, 
    s.diagnosis,
    COUNT(s.diagnosis) AS 'frequency'

FROM patients p
INNER JOIN symptoms s
ON s.patient_id = p.patient_id
GROUP BY p.gender, s.diagnosis
ORDER BY frequency DESC; 

-- 2.4 Diagnosis vs sleep quality, group by gender:
SELECT 
	gender, 
    diagnosis, 
    ROUND(AVG(sleep_quality),2) AS 'average_sleep_quality'
    FROM symptoms
    group by gender, diagnosis
    ORDER BY average_sleep_quality ASC; 
    
-- 2.5 Diagnosis vs stress level, group by gender:
SELECT 
	gender, 
    diagnosis, 
    ROUND(AVG(stress_level),2) AS 'average_stress_level'
    FROM symptoms
    group by gender, diagnosis
    ORDER BY average_stress_level ASC; 
    
-- 2.6 Average stress level and diagnosis:

-- 2.6.1 Average stress level and diagnosis, group by age range:
SELECT 
    CASE
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_range,
    diagnosis,
    ROUND(AVG(stress_level),2) AS 'average_stress_level'
FROM symptoms
WHERE stress_level IS NOT NULL -- Exclude null values
GROUP BY age_range, diagnosis
ORDER BY age_range, average_stress_level DESC;
    
-- 2.6.2 Average stress level and diagnosis frequency, group by age range:
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
    ROUND(AVG(stress_level),2) AS 'average_stress_level'
FROM symptoms
GROUP BY age_range, diagnosis
ORDER BY age_range, average_stress_level DESC; 

-- 2.6.3 Average stress level and occupation, group by age range:
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
    ROUND(AVG(stress_level),2) AS 'average_stress_level'
FROM lifestyle_and_sleep
GROUP BY age_range, occupation
ORDER BY age_range, average_stress_level DESC; 

-- 2.7 Diagnosis per gender:
SELECT 
	diagnosis, 
    gender, 
    COUNT(patient_id) AS num_patients
FROM symptoms
GROUP BY diagnosis, gender
ORDER BY diagnosis, gender;

-- 2.7.1 Diagnosis per gender including 'No diagnosis' patients. 
SELECT 
    COALESCE(s.diagnosis, 'No diagnosis') AS diagnosis,
    p.gender, 
    COUNT(p.patient_id) AS num_patients
FROM patients p
LEFT JOIN symptoms s ON p.patient_id = s.patient_id
GROUP BY COALESCE(s.diagnosis, 'No diagnosis'), p.gender
ORDER BY diagnosis, p.gender;
    
-- 2.7.2 Diagnosis per gender including 'No diagnosis' patients and age range. 
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
FROM patients p
LEFT JOIN symptoms s ON p.patient_id = s.patient_id
GROUP BY 
    COALESCE(s.diagnosis, 'No diagnosis'), 
    p.gender, 
    age_range
ORDER BY diagnosis,age_range, p.gender;

-- 2.8 Number of patients group by diagnosis and medication:

SELECT 
    diagnosis,
    medication,
    COUNT(*) AS patient_count -- Number of patients for each medication.
FROM therapy
GROUP BY diagnosis, medication
ORDER BY 
    diagnosis,
    patient_count DESC,
    medication;

-- 2.9 Most common medication for each diagnosis:
SELECT 
    diagnosis,  
    medication,  
    COUNT(*) AS patient_count  -- Number of patients for each medication
FROM therapy
JOIN (
    -- Subquery to obtain most common medication
    SELECT 
        diagnosis, 
        medication, 
        COUNT(*) AS med_count 
    FROM therapy
    GROUP BY diagnosis, medication
) AS counts  -- Alias for intern subquery
ON t.diagnosis = counts.diagnosis  -- Join by diagnosis
AND t.medication = counts.medication  -- Join by medication
WHERE 
    counts.med_count = (
        -- Subquery to obtain max medication count for each diagnosis
        SELECT MAX(med_count) 
        FROM (
            SELECT 
                diagnosis,
                medication,
                COUNT(*) AS med_count  -- Number of patients for each medication.
            FROM 
                therapy
            GROUP BY 
                diagnosis, medication
        ) AS sub_counts
        WHERE sub_counts.diagnosis = t.diagnosis  -- Ensures subquery filtered by diagnosis
    )
GROUP BY 
    t.diagnosis, t.medication
ORDER BY 
    t.diagnosis;

-- 3. Mental health therapies:

-- 3.1 Most effective therapy (i.e. has more outcome = 'Improved' in a given diagnosis):
-- 3.1.1 Taking into account severity:
WITH TherapySuccess AS (
    SELECT 
        diagnosis,
        symptom_severity,
        therapy_type,
        SUM(CASE WHEN outcome = 'Deteriorated' THEN 1 ELSE 0 END) AS outcome_deteriorated,
        SUM(CASE WHEN outcome = 'Improved' THEN 1 ELSE 0 END) AS outcome_improved,
        SUM(CASE WHEN outcome = 'No Change' THEN 1 ELSE 0 END) AS outcome_nochange,
        SUM(CASE WHEN outcome IN ('Deteriorated', 'Improved', 'No Change') THEN 1 ELSE 0 END) AS occurrence_count,
        SUM(CASE WHEN outcome = 'Improved' THEN 1 ELSE 0 END) /
        SUM(CASE WHEN outcome IN ('Deteriorated', 'Improved', 'No Change') THEN 1 ELSE 0 END) AS success_rate
    FROM 
        therapy
    GROUP BY 
        diagnosis, 
        symptom_severity, 
        therapy_type
)
SELECT 
    ts.diagnosis,
    ts.symptom_severity,
    ts.therapy_type,
    ts.outcome_deteriorated,
    ts.outcome_improved,
    ts.outcome_nochange,
    ts.occurrence_count,
    ts.success_rate
FROM 
    TherapySuccess ts
JOIN (
    SELECT 
        diagnosis,
        symptom_severity,
        MAX(success_rate) AS max_success_rate
    FROM 
        TherapySuccess
    GROUP BY 
        diagnosis, 
        symptom_severity
) AS ts2
ON ts.diagnosis = ts2.diagnosis
AND ts.symptom_severity = ts2.symptom_severity
AND ts.success_rate = ts2.max_success_rate
ORDER BY 
    ts.diagnosis ASC,
    ts.symptom_severity DESC;


-- 3.1.2 Not taking into account severity:
WITH TherapySuccessNotSeverity AS (
    SELECT 
        diagnosis,
        therapy_type,
        SUM(CASE WHEN outcome = 'Deteriorated' THEN 1 ELSE 0 END) AS outcome_deteriorated,
        SUM(CASE WHEN outcome = 'Improved' THEN 1 ELSE 0 END) AS outcome_improved,
        SUM(CASE WHEN outcome = 'No Change' THEN 1 ELSE 0 END) AS outcome_nochange,
        SUM(CASE WHEN outcome IN ('Deteriorated', 'Improved', 'No Change') THEN 1 ELSE 0 END) AS occurrence_count,
        SUM(CASE WHEN outcome = 'Improved' THEN 1 ELSE 0 END) /
        SUM(CASE WHEN outcome IN ('Deteriorated', 'Improved', 'No Change') THEN 1 ELSE 0 END) AS success_rate
    FROM 
        therapy
    GROUP BY 
        diagnosis, 
        therapy_type
)
SELECT 
    tsns.diagnosis,
    tsns.therapy_type,
    tsns.outcome_deteriorated,
    tsns.outcome_improved,
    tsns.outcome_nochange,
    tsns.occurrence_count,
    tsns.success_rate
FROM 
    TherapySuccessNotSeverity tsns
JOIN (
    SELECT 
        diagnosis,
        MAX(success_rate) AS max_success_rate
    FROM 
        TherapySuccessNotSeverity
    GROUP BY 
        diagnosis 
) AS ts2
ON tsns.diagnosis = ts2.diagnosis
AND tsns.success_rate = ts2.max_success_rate
ORDER BY 
    tsns.diagnosis ASC;

-- 3.2 Diagnosis vs treatment duration group by age, gender:
SELECT 
    diagnosis,
    `treatment_duration_(weeks)` AS treatment_duration,
    symptom_severity,
    gender,
	    CASE
		WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
	END AS age_range
FROM therapy
GROUP BY diagnosis, treatment_duration, symptom_severity, gender, age_range
ORDER BY 
    diagnosis ASC, 
    gender ASC,
    symptom_severity DESC;

-- 3.3 Outcome vs adherence to treatment:
SELECT 
    diagnosis, 
    outcome,
    symptom_severity,
    gender,
    -- CASE
	--	 WHEN `adherence_to_treatment_(%)` BETWEEN 0 AND 20 THEN '0-20'
    --    WHEN `adherence_to_treatment_(%)` BETWEEN 21 AND 40 THEN '21-40'
    --    WHEN `adherence_to_treatment_(%)` BETWEEN 41 AND 60 THEN '41-60'
    --    WHEN `adherence_to_treatment_(%)` BETWEEN 61 AND 80 THEN '61-80'
    --    ELSE '>80'
	-- END AS adherence_range,
    `adherence_to_treatment_(%)` AS adherence_range,
	CASE
		WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
	END AS age_range
FROM therapy
GROUP BY diagnosis, adherence_range, outcome, symptom_severity, gender, age_range
ORDER BY 
    diagnosis ASC, 
    gender ASC,
    symptom_severity DESC;


