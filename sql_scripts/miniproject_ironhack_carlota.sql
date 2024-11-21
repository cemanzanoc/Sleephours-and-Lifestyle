-- miniproject_ironhack_carlota

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

-- 1.4 TOP 10 AGES with the quality lower that 7
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

