-- miniproject_ironhack_carlota

USE miniproject_ironhack; 
-- 1. average sleep quality group by age and compare with symptoms


-- 1.1 average sleep quality and duration group by age in order descend by age
SELECT 
	ROUND(AVG(ls.sleep_quality),2) as 'avg_sleep_quality', 
    ROUND(AVG(ls.sleep_duration),2) as 'avg_sleep_duration', 
    ls.age


FROM lifestyle_and_sleep ls
GROUP BY ls.age
ORDER BY ls.age DESC; 

-- 1.2 TOP 10 AGES with the greatest average sleep duration
SELECT 
	round(AVG(ls.sleep_quality),2) as 'avg_sleep_quality', 
    ROUND(AVG(ls.sleep_duration),2) as 'avg_sleep_duration', 
    ls.age


FROM lifestyle_and_sleep ls
GROUP BY ls.age
ORDER BY avg_sleep_duration DESC
LIMIT 10; 

-- 1.3 TOP 10 AGES with the lowest average sleep quality
SELECT 
	round(AVG(ls.sleep_quality),2) as 'avg_sleep_quality', 
    ROUND(AVG(ls.sleep_duration),2) as 'avg_sleep_duration', 
    ls.age


FROM lifestyle_and_sleep ls
GROUP BY ls.age
ORDER BY avg_sleep_duration ASC
LIMIT 10; 

-- 1.4 TOP 10 AGES with the sleep quality lower that 7
SELECT 
	round(AVG(ls.sleep_quality),2) as 'avg_sleep_quality', 
    ROUND(AVG(ls.sleep_duration),2) as 'avg_sleep_duration', 
    ls.age


FROM lifestyle_and_sleep ls
GROUP BY ls.age
HAVING avg_sleep_quality < 7
ORDER BY avg_sleep_quality ASC
LIMIT 10; 

-- in this table, we can observe that the average_sleep_quality is correlated with
-- the avg_sleep_durate. And the age with the lowest sleep quality and sleep duration 
-- are in the range (25,35) and (45,50) <- this range could be outliers

-- 1.5 Compare with the symptoms

SELECT 
	p.age as 'age', 
    avg(ls.sleep_quality) as 'avg_sleep_quality', 
    avg(ls.sleep_duration) as 'avg_sleep_duration', 
    s.diagnosis as 'diagnosis'

FROM patients p
INNER JOIN lifestyle_and_sleep ls
ON ls.age = p.age
INNER JOIN symptoms s
ON s.age = p.age
GROUP BY  p.age, s.diagnosis 
HAVING avg_sleep_quality < 6; 

-- we can observe that people with avg_sleep_quality < 6 their age are in [28,34] and in general, have bipolar and anxiety disorder

-- 1.5 Compare with the symptoms

SELECT 
	p.age as 'age', 
    avg(ls.sleep_quality) as 'avg_sleep_quality', 
    avg(ls.sleep_duration) as 'avg_sleep_duration', 
    s.diagnosis as 'diagnosis'

FROM patients p
INNER JOIN lifestyle_and_sleep ls
ON ls.age = p.age
INNER JOIN symptoms s
ON s.age = p.age
GROUP BY  p.age, s.diagnosis 
HAVING avg_sleep_duration < (SELECT ROUND(AVG(sleep_duration),2) FROM lifestyle_and_sleep); 


SELECT ROUND(AVG(sleep_duration),2) FROM lifestyle_and_sleep;
-- the average of sleep duration is 7.13


-- 2. average sleep quality group by gender and compare with symptoms

-- 2.1 average sleep quality and duration group by gender 
SELECT 
	ROUND(AVG(ls.sleep_quality),2) as 'avg_sleep_quality', 
    ROUND(AVG(ls.sleep_duration),2) as 'avg_sleep_duration', 
    ls.gender


FROM lifestyle_and_sleep ls
GROUP BY ls.gender; 

-- in general, men sleep better than women

-- 2.2 average sleep quality, duration and stress level group by gender
SELECT 
	ROUND(AVG(ls.sleep_quality),2) as 'avg_sleep_quality', 
    ROUND(AVG(ls.sleep_duration),2) as 'avg_sleep_duration', 
    ROUND(AVG(ls.stress_level),2) as 'avg_stress_level',
    ls.gender


FROM lifestyle_and_sleep ls
GROUP BY ls.gender; 

-- in the same way, men have usually more stress level than women

-- 2.3

SELECT 
	p.gender, 
    s.diagnosis,
    COUNT(s.diagnosis) as 'frequency'
	

FROM patients p
INNER JOIN symptoms s
ON s.patient_id = p.patient_id
GROUP BY  p.gender, s.diagnosis
ORDER BY
	frequency DESC; 


-- 3. diagnosis vs sleep quality group by gender 

SELECT 
	gender, 
    diagnosis, 
    AVG(sleep_quality) as 'avg_sleep_quality'
    FROM symptoms
    group by gender, diagnosis
    ORDER BY avg_sleep_quality ASC; 
    
    
-- 4. diagnosis vs stress group by gender
SELECT 
	gender, 
    diagnosis, 
    AVG(stress_level) as 'avg_stress_level'
    FROM symptoms
    group by gender, diagnosis
    ORDER BY avg_stress_level ASC; 
    
-- 5. 