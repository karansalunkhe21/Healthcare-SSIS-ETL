USE HealthDW_Staging;
SELECT COUNT(*) AS Total_Encounters 
FROM stg.STG_Encounters;



-- See sample encounters
SELECT TOP 5 
    Id, START, STOP, 
    PATIENT, ENCOUNTERCLASS, 
    DESCRIPTION, TOTAL_CLAIM_COST
FROM stg.STG_Encounters;