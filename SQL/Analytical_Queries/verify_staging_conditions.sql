USE HealthDW_Staging;
SELECT COUNT(*) AS Total_Conditions 
FROM stg.STG_Conditions;

SELECT TOP 5 
    START ,                          -- onset date YYYY-MM-DD
    STOP   ,                          -- resolved date or NULL
    PATIENT ,              
    ENCOUNTER ,            
    CODE ,                              -- SNOMED code
    DESCRIPTION        
FROM stg.STG_Conditions