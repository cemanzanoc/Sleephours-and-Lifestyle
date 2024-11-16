-- Create database
CREATE DATABASE IF NOT EXISTS miniproject_ironhack;
-- Use miniproject_ironhack database
USE miniproject_ironhack;


-- Show tables
SHOW TABLES;

-- Eliminate the restrictions

ALTER TABLE symptoms DROP FOREIGN KEY patient_id;
ALTER TABLE therapy DROP FOREIGN KEY  patient_id;
ALTER TABLE lifestyle_and_sleep DROP FOREIGN KEY  patient_id;
ALTER TABLE patients DROP PRIMARY KEY;

-- Create patient_id columns in all tables as primary key 
ALTER TABLE patients
ADD CONSTRAINT patient_id PRIMARY KEY (patient_id);

ALTER TABLE symptoms
ADD CONSTRAINT patient_id FOREIGN KEY (patient_id) REFERENCES patients(patient_id);

ALTER TABLE therapy
ADD CONSTRAINT patient_id FOREIGN KEY (patient_id) REFERENCES patients(patient_id);

ALTER TABLE lifestyle_and_sleep
ADD CONSTRAINT patient_id FOREIGN KEY (patient_id) REFERENCES patients(patient_id);

SELECT * FROM therapy;



