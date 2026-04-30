USE HealthDW_Staging;
SELECT COUNT(*) AS Total_observation
FROM stg.STG_Observations;


    SELECT TOP 5 
    DATE     ,                       
    PATIENT     ,          
    ENCOUNTER   ,          
    CATEGORY    ,                    
    CODE     ,             
    VALUE    ,                        -
    UNITS   ,              
    TYPE   
FROM stg.STG_Observations 