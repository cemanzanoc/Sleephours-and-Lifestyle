-- sleep quality  group by nivel de stress
SELECT 
    stress_level, 
    AVG(sleep_quality) AS average_sleep_quality
FROM 
    lifestyle_and_sleep
GROUP BY 
    stress_level
ORDER BY 
	stress_level ASC;
    
-- sleep quality group by profession
SELECT 
    occupation, 
    AVG(sleep_quality) AS average_sleep_quality
FROM 
    lifestyle_and_sleep
GROUP BY 
    occupation
ORDER BY
	average_sleep_quality ASC;
    
-- sleep quality group by weight
SELECT 
    bmi_category, 
    AVG(sleep_quality) AS average_sleep_quality
FROM 
    lifestyle_and_sleep
GROUP BY 
    bmi_category
ORDER BY
	average_sleep_quality ASC;
    
-- stress level vs profesion
SELECT 
    occupation, 
    AVG(stress_level) AS average_stress_level
FROM 
    lifestyle_and_sleep
GROUP BY 
    occupation
ORDER BY
	average_stress_level ASC;

