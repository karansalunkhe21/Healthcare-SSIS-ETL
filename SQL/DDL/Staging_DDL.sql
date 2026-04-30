USE HealthDW_Staging;
GO
DROP TABLE IF EXISTS stg.STG_Patients;
CREATE TABLE stg.STG_Patients (
    -- ── Synthea Source Columns ─────────────────────────────
    Id                    VARCHAR(50)   NOT NULL,  -- UUID
    BIRTHDATE             VARCHAR(20),             -- YYYY-MM-DD
    DEATHDATE             VARCHAR(20),             -- YYYY-MM-DD or NULL
    SSN                   VARCHAR(20),
    DRIVERS               VARCHAR(20),
    PASSPORT              VARCHAR(20),
    PREFIX                VARCHAR(20),
    FIRST                 VARCHAR(100),
    LAST                  VARCHAR(100),
    SUFFIX                VARCHAR(20),
    MAIDEN                VARCHAR(100),
    MARITAL               VARCHAR(10),
    RACE                  VARCHAR(50),
    ETHNICITY             VARCHAR(50),
    GENDER                VARCHAR(10),
    BIRTHPLACE            VARCHAR(200),
    ADDRESS               VARCHAR(200),
    CITY                  VARCHAR(100),
    STATE                 VARCHAR(50),
    COUNTY                VARCHAR(100),
    ZIP                   VARCHAR(10),
    LAT                   VARCHAR(30),
    LON                   VARCHAR(30),
    HEALTHCARE_EXPENSES   VARCHAR(30),
    HEALTHCARE_COVERAGE   VARCHAR(30),
    INCOME                VARCHAR(20),
    -- ── ETL Audit Columns ──────────────────────────────────
    ETL_Load_Date         DATETIME      DEFAULT GETDATE(),
    ETL_Source_File       VARCHAR(500)
);


DROP TABLE IF EXISTS stg.STG_Encounters;
CREATE TABLE stg.STG_Encounters (

    Id                    VARCHAR(50)   NOT NULL,
    START                 VARCHAR(30),             -- YYYY-MM-DDTHH:MM:SSZ
    STOP                  VARCHAR(30),
    PATIENT               VARCHAR(50),             -- FK → patients.Id
    ORGANIZATION          VARCHAR(50),
    PROVIDER              VARCHAR(50),
    PAYER                 VARCHAR(50),
    ENCOUNTERCLASS        VARCHAR(50),             -- ambulatory|inpatient|emergency|urgentcare
    CODE                  VARCHAR(20),             -- SNOMED code
    DESCRIPTION           VARCHAR(500),
    BASE_ENCOUNTER_COST   VARCHAR(20),
    TOTAL_CLAIM_COST      VARCHAR(20),
    PAYER_COVERAGE        VARCHAR(20),
    REASONCODE            VARCHAR(20),
    REASONDESCRIPTION     VARCHAR(500),
    ETL_Load_Date         DATETIME      DEFAULT GETDATE(),
    ETL_Source_File       VARCHAR(500)
);



DROP TABLE IF EXISTS stg.STG_Conditions;
CREATE TABLE stg.STG_Conditions (
    START                 VARCHAR(20),             -- onset date YYYY-MM-DD
    STOP                  VARCHAR(20),             -- resolved date or NULL
    PATIENT               VARCHAR(50),
    ENCOUNTER             VARCHAR(50),
    CODE                  VARCHAR(20),             -- SNOMED code
    DESCRIPTION           VARCHAR(500),
    ETL_Load_Date         DATETIME      DEFAULT GETDATE(),
    ETL_Source_File       VARCHAR(500)
);


DROP TABLE IF EXISTS stg.STG_Observations;
CREATE TABLE stg.STG_Observations (
    DATE                  VARCHAR(30),             -- YYYY-MM-DDTHH:MM:SSZ
    PATIENT               VARCHAR(50),
    ENCOUNTER             VARCHAR(50),
    CATEGORY              VARCHAR(50),             -- laboratory|vital-signs|social-history
    CODE                  VARCHAR(20),             -- LOINC code
    DESCRIPTION           VARCHAR(500),
    VALUE                 VARCHAR(200),            -- numeric or text result
    UNITS                 VARCHAR(50),
    TYPE                  VARCHAR(50),             -- numeric|text
    ETL_Load_Date         DATETIME      DEFAULT GETDATE(),
    ETL_Source_File       VARCHAR(500)
);




DROP TABLE IF EXISTS stg.STG_Procedures;
CREATE TABLE stg.STG_Procedures (
    START                 VARCHAR(30),
    STOP                  VARCHAR(30),
    PATIENT               VARCHAR(50),
    ENCOUNTER             VARCHAR(50),
    CODE                  VARCHAR(20),             -- SNOMED code
    DESCRIPTION           VARCHAR(500),
    BASE_COST             VARCHAR(20),
    REASONCODE            VARCHAR(20),
    REASONDESCRIPTION     VARCHAR(500),
    ETL_Load_Date         DATETIME      DEFAULT GETDATE(),
    ETL_Source_File       VARCHAR(500)
);



DROP TABLE IF EXISTS stg.STG_Medications;
CREATE TABLE stg.STG_Medications (
    START                 VARCHAR(30),
    STOP                  VARCHAR(30),
    PATIENT               VARCHAR(50),
    PAYER                 VARCHAR(50),
    ENCOUNTER             VARCHAR(50),
    CODE                  VARCHAR(20),             -- RxNorm code
    DESCRIPTION           VARCHAR(500),
    BASE_COST             VARCHAR(20),
    PAYER_COVERAGE        VARCHAR(20),
    DISPENSES             VARCHAR(10),
    TOTALCOST             VARCHAR(20),
    REASONCODE            VARCHAR(20),
    REASONDESCRIPTION     VARCHAR(500),
    ETL_Load_Date         DATETIME      DEFAULT GETDATE(),
    ETL_Source_File       VARCHAR(500)
);



DROP TABLE IF EXISTS stg.STG_Claims;
CREATE TABLE stg.STG_Claims (
    Id                            VARCHAR(50)   NOT NULL,
    PATIENTID                     VARCHAR(50),
    PROVIDERID                    VARCHAR(50),
    PRIMARYPATIENTINSURANCEID     VARCHAR(50),
    SECONDARYPATIENTINSURANCEID   VARCHAR(50),
    DEPARTMENTID                  VARCHAR(50),
    PATIENTDEPARTMENTID           VARCHAR(50),
    DIAGNOSIS1                    VARCHAR(20),
    DIAGNOSIS2                    VARCHAR(20),
    DIAGNOSIS3                    VARCHAR(20),
    DIAGNOSIS4                    VARCHAR(20),
    DIAGNOSIS5                    VARCHAR(20),
    DIAGNOSIS6                    VARCHAR(20),
    REFERRING_PROVIDER_ID         VARCHAR(50),
    APPOINTMENT_ID                VARCHAR(50),
    CURRENTILLNESSDATE            VARCHAR(30),
    SERVICEDATE                   VARCHAR(30),
    SUPERVISINGPROVIDERID         VARCHAR(50),
    STATUS1                       VARCHAR(20),
    STATUS2                       VARCHAR(20),
    STATUSP                       VARCHAR(20),
    OUTSTANDING1                  VARCHAR(20),
    OUTSTANDING2                  VARCHAR(20),
    OUTSTANDINGP                  VARCHAR(20),
    LASTBILLEDDATE1               VARCHAR(30),
    LASTBILLEDDATE2               VARCHAR(30),
    LASTBILLEDDATEP               VARCHAR(30),
    HEALTHCARECLAIMTYPEID1        VARCHAR(10),
    HEALTHCARECLAIMTYPEID2        VARCHAR(10),
    ETL_Load_Date                 DATETIME      DEFAULT GETDATE(),
    ETL_Source_File               VARCHAR(500)
);



DROP TABLE IF EXISTS stg.STG_Claims_Transactions;
CREATE TABLE stg.STG_Claims_Transactions (
    ID                    VARCHAR(50)   NOT NULL,
    CLAIMID               VARCHAR(50),
    CHARGEID              VARCHAR(50),
    PATIENTID             VARCHAR(50),
    TYPE                  VARCHAR(50),             -- CHARGE|PAYMENT|ADJUSTMENT|TRANSFEROUT|TRANSFERIN
    AMOUNT                VARCHAR(20),
    METHOD                VARCHAR(50),
    FROMDATE              VARCHAR(30),
    TODATE                VARCHAR(30),
    PLACEOFSERVICE        VARCHAR(50),
    PROCEDURECODE         VARCHAR(20),
    MODIFIER1             VARCHAR(10),
    MODIFIER2             VARCHAR(10),
    DIAGNOSISREF1         VARCHAR(10),
    DIAGNOSISREF2         VARCHAR(10),
    DIAGNOSISREF3         VARCHAR(10),
    DIAGNOSISREF4         VARCHAR(10),
    UNITS                 VARCHAR(10),
    DEPARTMENTID          VARCHAR(50),
    NOTES                 VARCHAR(500),
    UNITAMOUNT            VARCHAR(20),
    TRANSFEROUTID         VARCHAR(50),
    TRANSFERTYPE          VARCHAR(20),
    PAYMENTS              VARCHAR(20),
    ADJUSTMENTS           VARCHAR(20),
    TRANSFERS             VARCHAR(20),
    OUTSTANDING           VARCHAR(20),
    APPOINTMENTID         VARCHAR(50),
    LINENOTE              VARCHAR(500),
    PATIENTINSURANCEID    VARCHAR(50),
    FEESCHEDULEID         VARCHAR(50),
    PROVIDERID            VARCHAR(50),
    SUPERVISINGPROVIDERID VARCHAR(50),
    ETL_Load_Date         DATETIME      DEFAULT GETDATE(),
    ETL_Source_File       VARCHAR(500)
);




USE HealthDW;
GO
DROP TABLE IF EXISTS aud.ETL_Run_Log;
CREATE TABLE aud.ETL_Run_Log (
    RunID             INT IDENTITY(1,1) PRIMARY KEY,
    PackageName       VARCHAR(200)  NOT NULL,
    RunStart          DATETIME      DEFAULT GETDATE(),
    RunEnd            DATETIME,
    Status            VARCHAR(20),   -- RUNNING | SUCCESS | FAILED
    RowsLoaded        INT,
    RowsRejected      INT,
    SourceFile        VARCHAR(500),
    ErrorMessage      NVARCHAR(MAX),
    RunBy             VARCHAR(100)  DEFAULT SUSER_SNAME()
);




USE HealthDW_Staging;
GO
ALTER TABLE stg.STG_Patients 
ALTER COLUMN HEALTHCARE_COVERAGE VARCHAR(500);


USE HealthDW_Staging;
GO
ALTER TABLE stg.STG_Patients 
ALTER COLUMN HEALTHCARE_EXPENSES VARCHAR(500);
PRINT 'Columns updated!';


USE HealthDW_Staging;
GO
ALTER TABLE stg.STG_Patients ALTER COLUMN BIRTHDATE VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN DEATHDATE VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN SSN VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN DRIVERS VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN PASSPORT VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN PREFIX VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN SUFFIX VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN MARITAL VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN GENDER VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN ZIP VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN ADDRESS VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN LAT VARCHAR(200);
ALTER TABLE stg.STG_Patients ALTER COLUMN LON VARCHAR(500);

ALTER TABLE stg.STG_Patients ALTER COLUMN BIRTHPLACE            VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN ADDRESS               VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN CITY                  VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN FIRST                 VARCHAR(500);
ALTER TABLE stg.STG_Patients ALTER COLUMN LAST                  VARCHAR(500);
PRINT 'All columns updated!';


USE HealthDW_Staging;
GO
DROP TABLE IF EXISTS stg.STG_Encounters;
CREATE TABLE stg.STG_Encounters (
    Id                    VARCHAR(500),
    START                 VARCHAR(500),
    STOP                  VARCHAR(500),
    PATIENT               VARCHAR(500),
    ORGANIZATION          VARCHAR(500),
    PROVIDER              VARCHAR(500),
    PAYER                 VARCHAR(500),
    ENCOUNTERCLASS        VARCHAR(500),
    CODE                  VARCHAR(500),
    DESCRIPTION           VARCHAR(500),
    BASE_ENCOUNTER_COST   VARCHAR(500),
    TOTAL_CLAIM_COST      VARCHAR(500),
    PAYER_COVERAGE        VARCHAR(500),
    REASONCODE            VARCHAR(500),
    REASONDESCRIPTION     VARCHAR(500),
    ETL_Load_Date         DATETIME DEFAULT GETDATE(),
    ETL_Source_File       VARCHAR(500)
);
PRINT 'STG_Encounters created!';