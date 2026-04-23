USE HealthDW_Staging;
SELECT COUNT(*) AS Total_Patients 
FROM stg.STG_Patients;

-- See sample data
SELECT TOP 5 Id, FIRST, LAST, BIRTHDATE, GENDER, CITY, STATE
FROM stg.STG_Patients;