USE HealthDW;
GO

-- ============================================================
-- FACT_Encounter
-- ============================================================
DROP TABLE IF EXISTS dw.FACT_Encounter;
CREATE TABLE dw.FACT_Encounter (
    Encounter_SK          INT IDENTITY(1,1) PRIMARY KEY,
    Encounter_NK          VARCHAR(500),
    Patient_SK            INT,
    Provider_SK           INT,
    Facility_SK           INT,
    Payer_SK              INT,
    AdmitDate_SK          INT,
    DischargeDate_SK      INT,
    EncounterClass        VARCHAR(500),
    EncounterCode         VARCHAR(500),
    EncounterDescription  VARCHAR(500),
    BaseEncounterCost     DECIMAL(18,2),
    TotalClaimCost        DECIMAL(18,2),
    PayerCoverage         DECIMAL(18,2),
    ReasonCode            VARCHAR(500),
    ReasonDescription     VARCHAR(500),
    LengthOfStay_Days     INT,
    ETL_Load_Date         DATETIME DEFAULT GETDATE()
);
PRINT 'FACT_Encounter created!';
GO

-- ============================================================
-- FACT_Condition
-- ============================================================
DROP TABLE IF EXISTS dw.FACT_Condition;
CREATE TABLE dw.FACT_Condition (
    Condition_SK      INT IDENTITY(1,1) PRIMARY KEY,
    Patient_SK        INT,
    Encounter_SK      INT,
    Diagnosis_SK      INT,
    OnsetDate_SK      INT,
    ResolvedDate_SK   INT,
    ConditionCode     VARCHAR(500),
    ConditionDesc     VARCHAR(500),
    IsActive          BIT,
    ETL_Load_Date     DATETIME DEFAULT GETDATE()
);
PRINT 'FACT_Condition created!';
GO

-- ============================================================
-- FACT_Observation (Lab Results & Vitals)
-- ============================================================
DROP TABLE IF EXISTS dw.FACT_Observation;
CREATE TABLE dw.FACT_Observation (
    Observation_SK    INT IDENTITY(1,1) PRIMARY KEY,
    Patient_SK        INT,
    Encounter_SK      INT,
    ObsDate_SK        INT,
    ObsCode           VARCHAR(500),
    ObsDescription    VARCHAR(500),
    ObsCategory       VARCHAR(500),
    ObsValue          VARCHAR(500),
    ObsValueNumeric   DECIMAL(18,4),
    ObsUnits          VARCHAR(500),
    ObsType           VARCHAR(500),
    ETL_Load_Date     DATETIME DEFAULT GETDATE()
);
PRINT 'FACT_Observation created!';
GO

-- ============================================================
-- FACT_Procedure
-- ============================================================
DROP TABLE IF EXISTS dw.FACT_Procedure;
CREATE TABLE dw.FACT_Procedure (
    Procedure_SK      INT IDENTITY(1,1) PRIMARY KEY,
    Patient_SK        INT,
    Encounter_SK      INT,
    Procedure_DimSK   INT,
    ProcDate_SK       INT,
    ProcedureCode     VARCHAR(500),
    ProcedureDesc     VARCHAR(500),
    BaseCost          DECIMAL(18,2),
    ReasonCode        VARCHAR(500),
    ReasonDesc        VARCHAR(500),
    ETL_Load_Date     DATETIME DEFAULT GETDATE()
);
PRINT 'FACT_Procedure created!';
GO

-- ============================================================
-- FACT_Medication
-- ============================================================
DROP TABLE IF EXISTS dw.FACT_Medication;
CREATE TABLE dw.FACT_Medication (
    Medication_SK     INT IDENTITY(1,1) PRIMARY KEY,
    Patient_SK        INT,
    Encounter_SK      INT,
    Payer_SK          INT,
    StartDate_SK      INT,
    StopDate_SK       INT,
    MedicationCode    VARCHAR(500),
    MedicationDesc    VARCHAR(500),
    BaseCost          DECIMAL(18,2),
    PayerCoverage     DECIMAL(18,2),
    Dispenses         INT,
    TotalCost         DECIMAL(18,2),
    ReasonCode        VARCHAR(500),
    ReasonDesc        VARCHAR(500),
    IsActive          BIT,
    ETL_Load_Date     DATETIME DEFAULT GETDATE()
);
PRINT 'FACT_Medication created!';
GO

-- ============================================================
-- FACT_Claim
-- ============================================================
DROP TABLE IF EXISTS dw.FACT_Claim;
CREATE TABLE dw.FACT_Claim (
    Claim_SK              INT IDENTITY(1,1) PRIMARY KEY,
    Claim_NK              VARCHAR(500),
    Patient_SK            INT,
    Provider_SK           INT,
    ServiceDate_SK        INT,
    Diagnosis1            VARCHAR(500),
    Diagnosis2            VARCHAR(500),
    Diagnosis3            VARCHAR(500),
    Status1               VARCHAR(500),
    Outstanding1          DECIMAL(18,2),
    Outstanding2          DECIMAL(18,2),
    OutstandingP          DECIMAL(18,2),
    ETL_Load_Date         DATETIME DEFAULT GETDATE()
);
PRINT 'FACT_Claim created!';
GO

-- ============================================================
-- FACT_ClaimTransaction
-- ============================================================
DROP TABLE IF EXISTS dw.FACT_ClaimTransaction;
CREATE TABLE dw.FACT_ClaimTransaction (
    ClaimTxn_SK       INT IDENTITY(1,1) PRIMARY KEY,
    ClaimTxn_NK       VARCHAR(500),
    Claim_NK          VARCHAR(500),
    Patient_SK        INT,
    FromDate_SK       INT,
    TransactionType   VARCHAR(500),
    Amount            DECIMAL(18,2),
    Method            VARCHAR(500),
    ProcedureCode     VARCHAR(500),
    Units             INT,
    Payments          DECIMAL(18,2),
    Adjustments       DECIMAL(18,2),
    Outstanding       DECIMAL(18,2),
    ETL_Load_Date     DATETIME DEFAULT GETDATE()
);
PRINT 'FACT_ClaimTransaction created!';
GO