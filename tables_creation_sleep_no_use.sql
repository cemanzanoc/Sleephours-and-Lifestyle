-- Create database
CREATE DATABASE IF NOT EXISTS patients;

-- Use this database
USE patients;

-- Drop Tables if they exist
DROP TABLE IF EXISTS symptom;
DROP TABLE IF EXISTS theraphy;
DROP TABLE IF EXISTS lifestyleandsleep;
DROP TABLE IF EXISTS patient;

-- Tabla principal de pacientes
CREATE TABLE patient ( 
PatientID INT PRIMARY KEY, 
Age INT, 
Gender VARCHAR(10) 
);

-- Symptom Table
CREATE TABLE symptom (
    SymptomID INT PRIMARY KEY,
    PatientID INT, -- Llave foránea hacia la tabla Patient
    SymptomSeverity INT,
    Diagnosis VARCHAR(250),
    MoodScore INT,
    SleepQuality INT,
    PhysicalActivityLevel INT,
    StressLevel INT,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) -- Relación muchos-a-uno con Patient
-- ON DELATE ON CASCADE
);

-- Theraphy table
CREATE TABLE therapy (
    TherapyID INT PRIMARY KEY,
    PatientID INT, -- Llave foránea hacia la tabla Patient
    Medication VARCHAR(100),
    TherapyType VARCHAR(250),
    TreatmentDuration INT,
    Outcome VARCHAR(255),
    TreatmentProgress INT,
    AdherenceToTreatment INT,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) -- Relación muchos-a-uno con Patient
);

-- Lifestyle and sleep table
CREATE TABLE lifestyleandsleep (
    LifestyleID INT PRIMARY KEY,
    PatientID INT, -- Llave foránea hacia la tabla Patient
    Occupation VARCHAR(100),
    SleepDuration FLOAT,
    SleepQuality INT,
    PhysicalActivityLevel INT,
    StressLevel INT,
    BMICategory VARCHAR(50),
    DailySteps INT,
    SleepDisorder VARCHAR(250),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) -- Relación muchos-a-uno con Patient
);








