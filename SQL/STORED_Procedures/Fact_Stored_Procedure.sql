USE HealthDW;
GO
CREATE OR ALTER PROCEDURE dw.usp_Load_FACT_Encounter
AS
BEGIN
    SET NOCOUNT ON;

    -- Delete existing records for idempotency
    TRUNCATE TABLE dw.FACT_Encounter;

    INSERT INTO dw.FACT_Encounter
    (
        Encounter_NK,
        Patient_SK,
        Provider_SK,
        Facility_SK,
        Payer_SK,
        AdmitDate_SK,
        DischargeDate_SK,
        EncounterClass,
        EncounterCode,
        EncounterDescription,
        BaseEncounterCost,
        TotalClaimCost,
        PayerCoverage,
        ReasonCode,
        ReasonDescription,
        LengthOfStay_Days
    )
    SELECT
        e.Id,

        -- Patient surrogate key
        ISNULL(dp.Patient_SK, -1),

        -- Provider surrogate key
        ISNULL(dpr.Provider_SK, -1),

        -- Facility surrogate key
        ISNULL(df.Facility_SK, -1),

        -- Payer surrogate key
        ISNULL(dpy.Payer_SK, -1),

        -- Admit date surrogate key
        ISNULL(
            CAST(FORMAT(TRY_CAST(LEFT(e.START,10) AS DATE),'yyyyMMdd') AS INT),
        -1),

        -- Discharge date surrogate key
        ISNULL(
            CAST(FORMAT(TRY_CAST(LEFT(e.STOP,10) AS DATE),'yyyyMMdd') AS INT),
        -1),

        e.ENCOUNTERCLASS,
        e.CODE,
        e.DESCRIPTION,

        -- Costs
        TRY_CAST(e.BASE_ENCOUNTER_COST AS DECIMAL(18,2)),
        TRY_CAST(e.TOTAL_CLAIM_COST    AS DECIMAL(18,2)),
        TRY_CAST(e.PAYER_COVERAGE      AS DECIMAL(18,2)),

        e.REASONCODE,
        e.REASONDESCRIPTION,

        -- Length of stay in days
        CASE
            WHEN TRY_CAST(LEFT(e.STOP,10) AS DATE) IS NOT NULL
            AND  TRY_CAST(LEFT(e.START,10) AS DATE) IS NOT NULL
            THEN DATEDIFF(DAY,
                 TRY_CAST(LEFT(e.START,10) AS DATE),
                 TRY_CAST(LEFT(e.STOP,10)  AS DATE))
            ELSE 0
        END

    FROM HealthDW_Staging.stg.STG_Encounters e

    -- Lookup Patient_SK
    LEFT JOIN dw.DIM_Patient dp
        ON dp.Patient_NK = e.PATIENT
        AND dp.Is_Current = 1

    -- Lookup Provider_SK
    LEFT JOIN dw.DIM_Provider dpr
        ON dpr.Provider_NK = e.PROVIDER
        AND dpr.Is_Current = 1

    -- Lookup Facility_SK
    LEFT JOIN dw.DIM_Facility df
        ON df.Facility_NK = e.ORGANIZATION

    -- Lookup Payer_SK
    LEFT JOIN dw.DIM_Payer dpy
        ON dpy.Payer_NK = e.PAYER;

    PRINT 'FACT_Encounter loaded!';
    SELECT COUNT(*) AS Rows_Loaded FROM dw.FACT_Encounter;
END;
GO

USE HealthDW;
GO

-- ============================================================
-- FACT_Condition
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_FACT_Condition
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE dw.FACT_Condition;

    INSERT INTO dw.FACT_Condition
    (
        Patient_SK, Encounter_SK, Diagnosis_SK,
        OnsetDate_SK, ResolvedDate_SK,
        ConditionCode, ConditionDesc, IsActive
    )
    SELECT
        ISNULL(dp.Patient_SK, -1),
        ISNULL(fe.Encounter_SK, -1),
        ISNULL(dd.Diagnosis_SK, -1),
        ISNULL(CAST(FORMAT(TRY_CAST(c.START AS DATE),'yyyyMMdd') AS INT),-1),
        ISNULL(CAST(FORMAT(TRY_CAST(c.STOP  AS DATE),'yyyyMMdd') AS INT),-1),
        c.CODE,
        c.DESCRIPTION,
        CASE WHEN c.STOP IS NULL THEN 1 ELSE 0 END
    FROM HealthDW_Staging.stg.STG_Conditions c
    LEFT JOIN dw.DIM_Patient dp
        ON dp.Patient_NK = c.PATIENT
        AND dp.Is_Current = 1
    LEFT JOIN dw.FACT_Encounter fe
        ON fe.Encounter_NK = c.ENCOUNTER
    LEFT JOIN dw.DIM_Diagnosis dd
        ON dd.Diagnosis_Code = c.CODE;

    PRINT 'FACT_Condition loaded!';
    SELECT COUNT(*) AS Rows_Loaded FROM dw.FACT_Condition;
END;
GO

-- ============================================================
-- FACT_Observation
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_FACT_Observation
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE dw.FACT_Observation;

    INSERT INTO dw.FACT_Observation
    (
        Patient_SK, Encounter_SK, ObsDate_SK,
        ObsCode, ObsDescription, ObsCategory,
        ObsValue, ObsValueNumeric, ObsUnits, ObsType
    )
    SELECT
        ISNULL(dp.Patient_SK, -1),
        ISNULL(fe.Encounter_SK, -1),
        ISNULL(CAST(FORMAT(TRY_CAST(LEFT(o.DATE,10) AS DATE),'yyyyMMdd') AS INT),-1),
        o.CODE,
        o.DESCRIPTION,
        o.CATEGORY,
        o.VALUE,
        TRY_CAST(o.VALUE AS DECIMAL(18,4)),
        o.UNITS,
        o.TYPE
    FROM HealthDW_Staging.stg.STG_Observations o
    LEFT JOIN dw.DIM_Patient dp
        ON dp.Patient_NK = o.PATIENT
        AND dp.Is_Current = 1
    LEFT JOIN dw.FACT_Encounter fe
        ON fe.Encounter_NK = o.ENCOUNTER;

    PRINT 'FACT_Observation loaded!';
    SELECT COUNT(*) AS Rows_Loaded FROM dw.FACT_Observation;
END;
GO

-- ============================================================
-- FACT_Procedure
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_FACT_Procedure
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE dw.FACT_Procedure;

    INSERT INTO dw.FACT_Procedure
    (
        Patient_SK, Encounter_SK, Procedure_DimSK,
        ProcDate_SK, ProcedureCode, ProcedureDesc,
        BaseCost, ReasonCode, ReasonDesc
    )
    SELECT
        ISNULL(dp.Patient_SK, -1),
        ISNULL(fe.Encounter_SK, -1),
        ISNULL(dpr.Procedure_SK, -1),
        ISNULL(CAST(FORMAT(TRY_CAST(LEFT(p.START,10) AS DATE),'yyyyMMdd') AS INT),-1),
        p.CODE,
        p.DESCRIPTION,
        TRY_CAST(p.BASE_COST AS DECIMAL(18,2)),
        p.REASONCODE,
        p.REASONDESCRIPTION
    FROM HealthDW_Staging.stg.STG_Procedures p
    LEFT JOIN dw.DIM_Patient dp
        ON dp.Patient_NK = p.PATIENT
        AND dp.Is_Current = 1
    LEFT JOIN dw.FACT_Encounter fe
        ON fe.Encounter_NK = p.ENCOUNTER
    LEFT JOIN dw.DIM_Procedure dpr
        ON dpr.Procedure_Code = p.CODE;

    PRINT 'FACT_Procedure loaded!';
    SELECT COUNT(*) AS Rows_Loaded FROM dw.FACT_Procedure;
END;
GO

-- ============================================================
-- FACT_Medication
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_FACT_Medication
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE dw.FACT_Medication;

    INSERT INTO dw.FACT_Medication
    (
        Patient_SK, Encounter_SK, Payer_SK,
        StartDate_SK, StopDate_SK,
        MedicationCode, MedicationDesc,
        BaseCost, PayerCoverage, Dispenses,
        TotalCost, ReasonCode, ReasonDesc, IsActive
    )
    SELECT
        ISNULL(dp.Patient_SK, -1),
        ISNULL(fe.Encounter_SK, -1),
        ISNULL(dpy.Payer_SK, -1),
        ISNULL(CAST(FORMAT(TRY_CAST(LEFT(m.START,10) AS DATE),'yyyyMMdd') AS INT),-1),
        ISNULL(CAST(FORMAT(TRY_CAST(LEFT(m.STOP,10) AS DATE),'yyyyMMdd') AS INT),-1),
        m.CODE,
        m.DESCRIPTION,
        TRY_CAST(m.BASE_COST AS DECIMAL(18,2)),
        TRY_CAST(m.PAYER_COVERAGE AS DECIMAL(18,2)),
        TRY_CAST(m.DISPENSES AS INT),
        TRY_CAST(m.TOTALCOST AS DECIMAL(18,2)),
        m.REASONCODE,
        m.REASONDESCRIPTION,
        CASE WHEN m.STOP IS NULL THEN 1 ELSE 0 END
    FROM HealthDW_Staging.stg.STG_Medications m
    LEFT JOIN dw.DIM_Patient dp
        ON dp.Patient_NK = m.PATIENT
        AND dp.Is_Current = 1
    LEFT JOIN dw.FACT_Encounter fe
        ON fe.Encounter_NK = m.ENCOUNTER
    LEFT JOIN dw.DIM_Payer dpy
        ON dpy.Payer_NK = m.PAYER;

    PRINT 'FACT_Medication loaded!';
    SELECT COUNT(*) AS Rows_Loaded FROM dw.FACT_Medication;
END;
GO

-- ============================================================
-- FACT_Claim
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_FACT_Claim
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE dw.FACT_Claim;

    INSERT INTO dw.FACT_Claim
    (
        Claim_NK, Patient_SK, Provider_SK,
        ServiceDate_SK,
        Diagnosis1, Diagnosis2, Diagnosis3,
        Status1, Outstanding1, Outstanding2, OutstandingP
    )
    SELECT
        c.Id,
        ISNULL(dp.Patient_SK, -1),
        ISNULL(dpr.Provider_SK, -1),
        ISNULL(CAST(FORMAT(TRY_CAST(LEFT(c.SERVICEDATE,10) AS DATE),'yyyyMMdd') AS INT),-1),
        c.DIAGNOSIS1,
        c.DIAGNOSIS2,
        c.DIAGNOSIS3,
        c.STATUS1,
        TRY_CAST(c.OUTSTANDING1 AS DECIMAL(18,2)),
        TRY_CAST(c.OUTSTANDING2 AS DECIMAL(18,2)),
        TRY_CAST(c.OUTSTANDINGP AS DECIMAL(18,2))
    FROM HealthDW_Staging.stg.STG_Claims c
    LEFT JOIN dw.DIM_Patient dp
        ON dp.Patient_NK = c.PATIENTID
        AND dp.Is_Current = 1
    LEFT JOIN dw.DIM_Provider dpr
        ON dpr.Provider_NK = c.PROVIDERID
        AND dpr.Is_Current = 1;

    PRINT 'FACT_Claim loaded!';
    SELECT COUNT(*) AS Rows_Loaded FROM dw.FACT_Claim;
END;
GO

-- ============================================================
-- FACT_ClaimTransaction
-- ============================================================
CREATE OR ALTER PROCEDURE dw.usp_Load_FACT_ClaimTransaction
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE dw.FACT_ClaimTransaction;

    INSERT INTO dw.FACT_ClaimTransaction
    (
        ClaimTxn_NK, Claim_NK, Patient_SK,
        FromDate_SK, TransactionType,
        Amount, Method, ProcedureCode,
        Units, Payments, Adjustments, Outstanding
    )
    SELECT
        ct.ID,
        ct.CLAIMID,
        ISNULL(dp.Patient_SK, -1),
        ISNULL(CAST(FORMAT(TRY_CAST(LEFT(ct.FROMDATE,10) AS DATE),'yyyyMMdd') AS INT),-1),
        ct.TYPE,
        TRY_CAST(ct.AMOUNT      AS DECIMAL(18,2)),
        ct.METHOD,
        ct.PROCEDURECODE,
        TRY_CAST(ct.UNITS       AS INT),
        TRY_CAST(ct.PAYMENTS    AS DECIMAL(18,2)),
        TRY_CAST(ct.ADJUSTMENTS AS DECIMAL(18,2)),
        TRY_CAST(ct.OUTSTANDING AS DECIMAL(18,2))
    FROM HealthDW_Staging.stg.STG_Claims_Transactions ct
    LEFT JOIN dw.DIM_Patient dp
        ON dp.Patient_NK = ct.PATIENTID
        AND dp.Is_Current = 1;

    PRINT 'FACT_ClaimTransaction loaded!';
    SELECT COUNT(*) AS Rows_Loaded FROM dw.FACT_ClaimTransaction;
END;
GO

EXEC dw.usp_Load_FACT_Encounter;
EXEC dw.usp_Load_FACT_Condition;
EXEC dw.usp_Load_FACT_Observation;
EXEC dw.usp_Load_FACT_Procedure;
EXEC dw.usp_Load_FACT_Medication;
EXEC dw.usp_Load_FACT_Claim;
EXEC dw.usp_Load_FACT_ClaimTransaction;

