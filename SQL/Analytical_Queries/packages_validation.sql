USE HealthDW;
SELECT 'DIM_Patient'        AS TableName, COUNT(*) AS Rows FROM dw.DIM_Patient
UNION ALL
SELECT 'DIM_Provider',                     COUNT(*) FROM dw.DIM_Provider
UNION ALL
SELECT 'DIM_Facility',                     COUNT(*) FROM dw.DIM_Facility
UNION ALL
SELECT 'DIM_Diagnosis',                    COUNT(*) FROM dw.DIM_Diagnosis
UNION ALL
SELECT 'DIM_Procedure',                    COUNT(*) FROM dw.DIM_Procedure
UNION ALL
SELECT 'DIM_Payer',                        COUNT(*) FROM dw.DIM_Payer
UNION ALL
SELECT 'FACT_Encounter',                   COUNT(*) FROM dw.FACT_Encounter
UNION ALL
SELECT 'FACT_Condition',                   COUNT(*) FROM dw.FACT_Condition
UNION ALL
SELECT 'FACT_Observation',                 COUNT(*) FROM dw.FACT_Observation
UNION ALL
SELECT 'FACT_Procedure',                   COUNT(*) FROM dw.FACT_Procedure
UNION ALL
SELECT 'FACT_Medication',                  COUNT(*) FROM dw.FACT_Medication
UNION ALL
SELECT 'FACT_Claim',                       COUNT(*) FROM dw.FACT_Claim
UNION ALL
SELECT 'FACT_ClaimTransaction',            COUNT(*) FROM dw.FACT_ClaimTransaction
ORDER BY TableName;