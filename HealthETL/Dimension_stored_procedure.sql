USE HealthDW;
GO
CREATE OR ALTER PROCEDURE dw.usp_Load_DIM_Patient
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Expire changed records
    UPDATE dw.DIM_Patient
    SET    SCD_End_Date      = CAST(GETDATE() AS DATE),
           Is_Current        = 0,
           ETL_Load_Date     = GETDATE()
    FROM   dw.DIM_Patient dp
    JOIN   HealthDW_Staging.stg.STG_Patients sp 
           ON dp.Patient_NK  = sp.Id
           AND dp.Is_Current = 1
    WHERE  ISNULL(dp.FirstName,'')    <> ISNULL(sp.FIRST,'')
        OR ISNULL(dp.LastName,'')     <> ISNULL(sp.LAST,'')
        OR ISNULL(dp.Gender,'')       <> ISNULL(sp.GENDER,'')
        OR ISNULL(dp.City,'')         <> ISNULL(sp.CITY,'')
        OR ISNULL(dp.State,'')        <> ISNULL(sp.STATE,'')
        OR ISNULL(dp.ZipCode,'')      <> ISNULL(sp.ZIP,'');

    -- Step 2: Insert new and changed records
    INSERT INTO dw.DIM_Patient
    (
        Patient_NK, FirstName, LastName,
        DateOfBirth, DeathDate, Gender,
        Race, Ethnicity, City, State, ZipCode,
        SCD_Start_Date, SCD_End_Date, Is_Current
    )
    SELECT
        sp.Id,
        sp.FIRST,
        sp.LAST,
        TRY_CAST(sp.BIRTHDATE AS DATE),
        TRY_CAST(sp.DEATHDATE AS DATE),
        sp.GENDER,
        sp.RACE,
        sp.ETHNICITY,
        sp.CITY,
        sp.STATE,
        sp.ZIP,
        CAST(GETDATE() AS DATE),
        NULL,
        1
    FROM HealthDW_Staging.stg.STG_Patients sp
    WHERE NOT EXISTS (
        SELECT 1 FROM dw.DIM_Patient dp
        WHERE  dp.Patient_NK = sp.Id
        AND    dp.Is_Current = 1
    );

    PRINT 'DIM_Patient loaded successfully!';
    SELECT @@ROWCOUNT AS Rows_Inserted;
END;
GO

USE HealthDW;
GO

-- ============================================================
-- DIM_Provider
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_DIM_Provider
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dw.DIM_Provider
    (Provider_NK, Organization_NK, SCD_Start_Date, SCD_End_Date, Is_Current)
    SELECT DISTINCT
        e.PROVIDER,
        e.ORGANIZATION,
        CAST(GETDATE() AS DATE),
        NULL,
        1
    FROM HealthDW_Staging.stg.STG_Encounters e
    WHERE NOT EXISTS (
        SELECT 1 FROM dw.DIM_Provider dp
        WHERE dp.Provider_NK = e.PROVIDER
        AND   dp.Is_Current  = 1
    );
    PRINT 'DIM_Provider loaded!';
END;
GO

-- ============================================================
-- DIM_Facility
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_DIM_Facility
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dw.DIM_Facility (Facility_NK)
    SELECT DISTINCT ORGANIZATION
    FROM HealthDW_Staging.stg.STG_Encounters
    WHERE ORGANIZATION NOT IN (
        SELECT Facility_NK FROM dw.DIM_Facility
    );
    PRINT 'DIM_Facility loaded!';
END;
GO

-- ============================================================
-- DIM_Diagnosis
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_DIM_Diagnosis
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dw.DIM_Diagnosis (Diagnosis_Code, Diagnosis_Desc)
    SELECT DISTINCT CODE, DESCRIPTION
    FROM HealthDW_Staging.stg.STG_Conditions
    WHERE CODE NOT IN (
        SELECT Diagnosis_Code FROM dw.DIM_Diagnosis
    );
    PRINT 'DIM_Diagnosis loaded!';
END;
GO

-- ============================================================
-- DIM_Procedure
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_DIM_Procedure
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dw.DIM_Procedure (Procedure_Code, Procedure_Desc)
    SELECT DISTINCT CODE, DESCRIPTION
    FROM HealthDW_Staging.stg.STG_Procedures
    WHERE CODE NOT IN (
        SELECT Procedure_Code FROM dw.DIM_Procedure
    );
    PRINT 'DIM_Procedure loaded!';
END;
GO

-- ============================================================
-- DIM_Payer
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_DIM_Payer
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dw.DIM_Payer (Payer_NK)
    SELECT DISTINCT PAYER
    FROM HealthDW_Staging.stg.STG_Encounters
    WHERE PAYER NOT IN (
        SELECT Payer_NK FROM dw.DIM_Payer
    );
    PRINT 'DIM_Payer loaded!';
END;
GO


USE HealthDW;
EXEC dw.usp_Load_DIM_Provider;
EXEC dw.usp_Load_DIM_Facility;
EXEC dw.usp_Load_DIM_Diagnosis;
EXEC dw.usp_Load_DIM_Procedure;
EXEC dw.usp_Load_DIM_Payer;


SELECT 'DIM_Patient'   AS DimName, COUNT(*) AS Rows FROM dw.DIM_Patient
UNION ALL
SELECT 'DIM_Provider',              COUNT(*) FROM dw.DIM_Provider
UNION ALL
SELECT 'DIM_Facility',              COUNT(*) FROM dw.DIM_Facility
UNION ALL
SELECT 'DIM_Diagnosis',             COUNT(*) FROM dw.DIM_Diagnosis
UNION ALL
SELECT 'DIM_Procedure',             COUNT(*) FROM dw.DIM_Procedure
UNION ALL
SELECT 'DIM_Payer',                 COUNT(*) FROM dw.DIM_Payer;