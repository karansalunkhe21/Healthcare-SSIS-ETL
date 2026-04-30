USE HealthDW_Staging;
SELECT 'STG_Patients'            AS TableName, COUNT(*) AS Rows FROM stg.STG_Patients
UNION ALL
SELECT 'STG_Encounters',                        COUNT(*) FROM stg.STG_Encounters
UNION ALL
SELECT 'STG_Conditions',                        COUNT(*) FROM stg.STG_Conditions
UNION ALL
SELECT 'STG_Observations',                      COUNT(*) FROM stg.STG_Observations
UNION ALL
SELECT 'STG_Procedures',                        COUNT(*) FROM stg.STG_Procedures
UNION ALL
SELECT 'STG_Medications',                       COUNT(*) FROM stg.STG_Medications
UNION ALL
SELECT 'STG_Claims',                            COUNT(*) FROM stg.STG_Claims
UNION ALL
SELECT 'STG_Claims_Transactions',               COUNT(*) FROM stg.STG_Claims_Transactions
ORDER BY TableName;