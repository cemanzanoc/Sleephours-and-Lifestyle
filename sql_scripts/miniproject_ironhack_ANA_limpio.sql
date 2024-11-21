-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS miniproject_ironhack;
-- Usar la base de datos
USE miniproject_ironhack;

-- Crear las claves primarias y foráneas con nombres personalizados
ALTER TABLE symptoms DROP FOREIGN KEY symptoms_ibfk_1;
ALTER TABLE therapy DROP FOREIGN KEY therapy_ibfk_1; 
ALTER TABLE lifestyle_and_sleep DROP FOREIGN KEY lifestyle_and_sleep_ibfk_1;

ALTER TABLE patients DROP PRIMARY KEY;
ALTER TABLE patients
ADD PRIMARY KEY (patient_id);

ALTER TABLE symptoms
ADD FOREIGN KEY (patient_id) REFERENCES patients(patient_id);
ALTER TABLE therapy
ADD FOREIGN KEY (patient_id) REFERENCES patients(patient_id);
ALTER TABLE lifestyle_and_sleep
ADD FOREIGN KEY (patient_id) REFERENCES patients(patient_id);

############################ ANA

## 1. What therapy_type is more effective (i.e. has more outcome = 'Improved' in a given diagnosis)
# taking into account the symptom severity:

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
    ts1.diagnosis,
    ts1.symptom_severity,
    ts1.therapy_type,
    ts1.outcome_deteriorated,
    ts1.outcome_improved,
    ts1.outcome_nochange,
    ts1.occurrence_count,
    ts1.success_rate
FROM 
    TherapySuccess ts1
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
ON ts1.diagnosis = ts2.diagnosis
AND ts1.symptom_severity = ts2.symptom_severity
AND ts1.success_rate = ts2.max_success_rate
ORDER BY 
    ts1.diagnosis ASC,
    ts1.symptom_severity DESC;
## 1.1 What therapy_type is more effective (i.e. has more outcome = 'Improved' in a given diagnosis)
# NOT taking into account the symptom severity:

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

# 2. Diagnosis vs treatment_duration_(weeks) group by age, gender
# First of all, take a look at the data
SELECT 
    diagnosis,
    `treatment_duration_(weeks)`,
    symptom_severity,
    gender,
	    CASE
		WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '35-50'
        WHEN age BETWEEN 51 AND 65 THEN '50-65'
        ELSE '65+'
	END AS age_range
FROM 
    therapy
GROUP BY 
    diagnosis, 
    `treatment_duration_(weeks)`,
    symptom_severity,
    gender,
    age_range
ORDER BY 
    diagnosis ASC, 
    gender ASC,
    symptom_severity DESC;

# 3. Outcome vs adherence_to_treatment_(%)

SELECT 
    diagnosis, 
    outcome,
    symptom_severity,
    gender,
    ## CASE
	##	 WHEN `adherence_to_treatment_(%)` BETWEEN 0 AND 20 THEN '0-20'
    ##    WHEN `adherence_to_treatment_(%)` BETWEEN 21 AND 40 THEN '21-40'
    ##    WHEN `adherence_to_treatment_(%)` BETWEEN 41 AND 60 THEN '41-60'
    ##    WHEN `adherence_to_treatment_(%)` BETWEEN 61 AND 80 THEN '61-80'
    ##    ELSE '>80'
	# END AS adherence_range,
    `adherence_to_treatment_(%)` AS adherence_range,
	CASE
		WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '35-50'
        WHEN age BETWEEN 51 AND 65 THEN '50-65'
        ELSE '65+'
	END AS age_range
FROM 
    therapy
GROUP BY 
    diagnosis, 
    adherence_range,
    outcome,
    symptom_severity,
    gender,
    age_range
ORDER BY 
    diagnosis ASC, 
    gender ASC,
    symptom_severity DESC;


