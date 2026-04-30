USE HealthDW;
GO

-- ============================================================
-- DIM_Date (Pre-populated calendar table)
-- ============================================================
DROP TABLE IF EXISTS dw.DIM_Date;
CREATE TABLE dw.DIM_Date (
    Date_SK         INT           NOT NULL PRIMARY KEY,
    FullDate        DATE          NOT NULL,
    Year            INT,
    Quarter         INT,
    Month           INT,
    MonthName       VARCHAR(20),
    Week            INT,
    Day             INT,
    DayName         VARCHAR(20),
    IsWeekend       BIT
);

-- Populate DIM_Date (2000 to 2030)
DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate   DATE = '2030-12-31';
DECLARE @Date      DATE = @StartDate;

WHILE @Date <= @EndDate
BEGIN
    INSERT INTO dw.DIM_Date
    SELECT
        CAST(FORMAT(@Date,'yyyyMMdd') AS INT),
        @Date,
        YEAR(@Date),
        DATEPART(QUARTER, @Date),
        MONTH(@Date),
        DATENAME(MONTH, @Date),
        DATEPART(WEEK, @Date),
        DAY(@Date),
        DATENAME(WEEKDAY, @Date),
        CASE WHEN DATEPART(WEEKDAY,@Date) IN (1,7) THEN 1 ELSE 0 END
    SET @Date = DATEADD(DAY, 1, @Date)
END
PRINT 'DIM_Date created and populated!';
GO

-- ============================================================
-- DIM_Patient (SCD Type 2)
-- ============================================================
DROP TABLE IF EXISTS dw.DIM_Patient;
CREATE TABLE dw.DIM_Patient (
    Patient_SK          INT IDENTITY(1,1) PRIMARY KEY,
    Patient_NK          VARCHAR(500),
    FirstName           VARCHAR(500),
    LastName            VARCHAR(500),
    DateOfBirth         DATE,
    DeathDate           DATE,
    Gender              VARCHAR(50),
    Race                VARCHAR(500),
    Ethnicity           VARCHAR(500),
    City                VARCHAR(500),
    State               VARCHAR(500),
    ZipCode             VARCHAR(50),
    SCD_Start_Date      DATE,
    SCD_End_Date        DATE,
    Is_Current          BIT DEFAULT 1,
    ETL_Load_Date       DATETIME DEFAULT GETDATE()
);
PRINT 'DIM_Patient created!';
GO

-- ============================================================
-- DIM_Provider
-- ============================================================
DROP TABLE IF EXISTS dw.DIM_Provider;
CREATE TABLE dw.DIM_Provider (
    Provider_SK         INT IDENTITY(1,1) PRIMARY KEY,
    Provider_NK         VARCHAR(500),
    Organization_NK     VARCHAR(500),
    SCD_Start_Date      DATE,
    SCD_End_Date        DATE,
    Is_Current          BIT DEFAULT 1,
    ETL_Load_Date       DATETIME DEFAULT GETDATE()
);
PRINT 'DIM_Provider created!';
GO

-- ============================================================
-- DIM_Facility
-- ============================================================
DROP TABLE IF EXISTS dw.DIM_Facility;
CREATE TABLE dw.DIM_Facility (
    Facility_SK         INT IDENTITY(1,1) PRIMARY KEY,
    Facility_NK         VARCHAR(500),
    ETL_Load_Date       DATETIME DEFAULT GETDATE()
);
PRINT 'DIM_Facility created!';
GO

-- ============================================================
-- DIM_Diagnosis
-- ============================================================
DROP TABLE IF EXISTS dw.DIM_Diagnosis;
CREATE TABLE dw.DIM_Diagnosis (
    Diagnosis_SK        INT IDENTITY(1,1) PRIMARY KEY,
    Diagnosis_Code      VARCHAR(500),
    Diagnosis_Desc      VARCHAR(500),
    ETL_Load_Date       DATETIME DEFAULT GETDATE()
);
PRINT 'DIM_Diagnosis created!';
GO

-- ============================================================
-- DIM_Procedure
-- ============================================================
DROP TABLE IF EXISTS dw.DIM_Procedure;
CREATE TABLE dw.DIM_Procedure (
    Procedure_SK        INT IDENTITY(1,1) PRIMARY KEY,
    Procedure_Code      VARCHAR(500),
    Procedure_Desc      VARCHAR(500),
    ETL_Load_Date       DATETIME DEFAULT GETDATE()
);
PRINT 'DIM_Procedure created!';
GO

-- ============================================================
-- DIM_Payer
-- ============================================================
DROP TABLE IF EXISTS dw.DIM_Payer;
CREATE TABLE dw.DIM_Payer (
    Payer_SK            INT IDENTITY(1,1) PRIMARY KEY,
    Payer_NK            VARCHAR(500),
    ETL_Load_Date       DATETIME DEFAULT GETDATE()
);
PRINT 'DIM_Payer created!';
GO