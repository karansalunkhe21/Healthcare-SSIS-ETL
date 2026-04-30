# 📖 Data Dictionary — Healthcare Data Warehouse

**Project:** Healthcare Data Warehouse & ETL Pipeline  
**Database:** HealthDW  
**Last Updated:** April 2026  
**Author:** Karan Salunkhe  

---

## 📋 Table of Contents

1. [Staging Tables](#staging-tables)
2. [Dimension Tables](#dimension-tables)
3. [Fact Tables](#fact-tables)
4. [Stored Procedures](#stored-procedures)
5. [ETL Audit Log](#etl-audit-log)

---

## 🗂️ Staging Tables

### stg.STG_Patients
**Source:** patients.csv  
**Description:** Raw patient demographics loaded directly from Synthea CSV

| Column | Data Type | Description |
|---|---|---|
| Id | VARCHAR(500) | Unique patient identifier (UUID) |
| BIRTHDATE | VARCHAR(500) | Patient date of birth (YYYY-MM-DD) |
| DEATHDATE | VARCHAR(500) | Date of death if applicable (YYYY-MM-DD) |
| SSN | VARCHAR(500) | Social Security Number |
| DRIVERS | VARCHAR(500) | Driver's license number |
| PASSPORT | VARCHAR(500) | Passport number |
| PREFIX | VARCHAR(500) | Name prefix (Mr, Mrs, Dr) |
| FIRST | VARCHAR(500) | First name |
| LAST | VARCHAR(500) | Last name |
| SUFFIX | VARCHAR(500) | Name suffix |
| MAIDEN | VARCHAR(500) | Maiden name |
| MARITAL | VARCHAR(500) | Marital status |
| RACE | VARCHAR(500) | Patient race |
| ETHNICITY | VARCHAR(500) | Patient ethnicity |
| GENDER | VARCHAR(500) | Patient gender (M/F) |
| BIRTHPLACE | VARCHAR(500) | City of birth |
| ADDRESS | VARCHAR(500) | Street address |
| CITY | VARCHAR(500) | City of residence |
| STATE | VARCHAR(500) | State of residence |
| COUNTY | VARCHAR(500) | County of residence |
| ZIP | VARCHAR(500) | ZIP/postal code |
| LAT | VARCHAR(500) | Latitude coordinate |
| LON | VARCHAR(500) | Longitude coordinate |
| HEALTHCARE_EXPENSES | VARCHAR(500) | Total healthcare expenses |
| HEALTHCARE_COVERAGE | VARCHAR(500) | Total healthcare coverage |
| ETL_Load_Date | DATETIME | Timestamp when record was loaded |
| ETL_Source_File | VARCHAR(500) | Source CSV file name |

---

### stg.STG_Encounters
**Source:** encounters.csv  
**Description:** Raw clinical encounter records

| Column | Data Type | Description |
|---|---|---|
| Id | VARCHAR(500) | Unique encounter identifier (UUID) |
| START | VARCHAR(500) | Encounter start datetime (ISO 8601) |
| STOP | VARCHAR(500) | Encounter end datetime (ISO 8601) |
| PATIENT | VARCHAR(500) | FK to patients.Id |
| ORGANIZATION | VARCHAR(500) | Healthcare organization UUID |
| PROVIDER | VARCHAR(500) | Provider UUID |
| PAYER | VARCHAR(500) | Insurance payer UUID |
| ENCOUNTERCLASS | VARCHAR(500) | Type of encounter (ambulatory/inpatient/emergency/urgentcare) |
| CODE | VARCHAR(500) | SNOMED encounter code |
| DESCRIPTION | VARCHAR(500) | Encounter description |
| BASE_ENCOUNTER_COST | VARCHAR(500) | Base cost before insurance |
| TOTAL_CLAIM_COST | VARCHAR(500) | Total claim cost |
| PAYER_COVERAGE | VARCHAR(500) | Amount covered by payer |
| REASONCODE | VARCHAR(500) | SNOMED reason code |
| REASONDESCRIPTION | VARCHAR(500) | Reason for encounter |
| ETL_Load_Date | DATETIME | Timestamp when record was loaded |
| ETL_Source_File | VARCHAR(500) | Source CSV file name |

---

### stg.STG_Conditions
**Source:** conditions.csv  
**Description:** Raw patient diagnosis and condition records

| Column | Data Type | Description |
|---|---|---|
| START | VARCHAR(500) | Condition onset date (YYYY-MM-DD) |
| STOP | VARCHAR(500) | Condition resolved date (NULL if active) |
| PATIENT | VARCHAR(500) | FK to patients.Id |
| ENCOUNTER | VARCHAR(500) | FK to encounters.Id |
| CODE | VARCHAR(500) | SNOMED condition code |
| DESCRIPTION | VARCHAR(500) | Condition description |
| ETL_Load_Date | DATETIME | Timestamp when record was loaded |
| ETL_Source_File | VARCHAR(500) | Source CSV file name |

---

### stg.STG_Observations
**Source:** observations.csv  
**Description:** Raw lab results, vitals, and social history observations

| Column | Data Type | Description |
|---|---|---|
| DATE | VARCHAR(500) | Observation datetime (ISO 8601) |
| PATIENT | VARCHAR(500) | FK to patients.Id |
| ENCOUNTER | VARCHAR(500) | FK to encounters.Id |
| CATEGORY | VARCHAR(500) | Observation category (laboratory/vital-signs/social-history) |
| CODE | VARCHAR(500) | LOINC observation code |
| DESCRIPTION | VARCHAR(500) | Observation description |
| VALUE | VARCHAR(500) | Observation result value |
| UNITS | VARCHAR(500) | Unit of measurement |
| TYPE | VARCHAR(500) | Value type (numeric/text) |
| ETL_Load_Date | DATETIME | Timestamp when record was loaded |
| ETL_Source_File | VARCHAR(500) | Source CSV file name |

---

### stg.STG_Procedures
**Source:** procedures.csv  
**Description:** Raw clinical procedure records

| Column | Data Type | Description |
|---|---|---|
| START | VARCHAR(500) | Procedure start datetime |
| STOP | VARCHAR(500) | Procedure end datetime |
| PATIENT | VARCHAR(500) | FK to patients.Id |
| ENCOUNTER | VARCHAR(500) | FK to encounters.Id |
| CODE | VARCHAR(500) | SNOMED procedure code |
| DESCRIPTION | VARCHAR(500) | Procedure description |
| BASE_COST | VARCHAR(500) | Base cost of procedure |
| REASONCODE | VARCHAR(500) | SNOMED reason code |
| REASONDESCRIPTION | VARCHAR(500) | Reason for procedure |
| ETL_Load_Date | DATETIME | Timestamp when record was loaded |
| ETL_Source_File | VARCHAR(500) | Source CSV file name |

---

### stg.STG_Medications
**Source:** medications.csv  
**Description:** Raw medication prescription records

| Column | Data Type | Description |
|---|---|---|
| START | VARCHAR(500) | Prescription start date |
| STOP | VARCHAR(500) | Prescription end date (NULL if active) |
| PATIENT | VARCHAR(500) | FK to patients.Id |
| PAYER | VARCHAR(500) | Insurance payer UUID |
| ENCOUNTER | VARCHAR(500) | FK to encounters.Id |
| CODE | VARCHAR(500) | RxNorm medication code |
| DESCRIPTION | VARCHAR(500) | Medication name and dosage |
| BASE_COST | VARCHAR(500) | Base cost per dispense |
| PAYER_COVERAGE | VARCHAR(500) | Amount covered by payer |
| DISPENSES | VARCHAR(500) | Number of dispenses |
| TOTALCOST | VARCHAR(500) | Total medication cost |
| REASONCODE | VARCHAR(500) | SNOMED reason code |
| REASONDESCRIPTION | VARCHAR(500) | Reason for prescription |
| ETL_Load_Date | DATETIME | Timestamp when record was loaded |
| ETL_Source_File | VARCHAR(500) | Source CSV file name |

---

### stg.STG_Claims
**Source:** claims.csv  
**Description:** Raw insurance claim header records

| Column | Data Type | Description |
|---|---|---|
| Id | VARCHAR(500) | Unique claim identifier (UUID) |
| PATIENTID | VARCHAR(500) | FK to patients.Id |
| PROVIDERID | VARCHAR(500) | Provider UUID |
| PRIMARYPATIENTINSURANCEID | VARCHAR(500) | Primary insurance ID |
| SECONDARYPATIENTINSURANCEID | VARCHAR(500) | Secondary insurance ID |
| DEPARTMENTID | VARCHAR(500) | Department identifier |
| DIAGNOSIS1-6 | VARCHAR(500) | ICD diagnosis codes |
| SERVICEDATE | VARCHAR(500) | Date of service |
| STATUS1 | VARCHAR(500) | Primary claim status |
| OUTSTANDING1 | VARCHAR(500) | Primary outstanding balance |
| ETL_Load_Date | DATETIME | Timestamp when record was loaded |
| ETL_Source_File | VARCHAR(500) | Source CSV file name |

---

### stg.STG_Claims_Transactions
**Source:** claims_transactions.csv  
**Description:** Raw claim line item transaction records

| Column | Data Type | Description |
|---|---|---|
| ID | VARCHAR(500) | Unique transaction identifier |
| CLAIMID | VARCHAR(500) | FK to claims.Id |
| PATIENTID | VARCHAR(500) | FK to patients.Id |
| TYPE | VARCHAR(500) | Transaction type (CHARGE/PAYMENT/ADJUSTMENT) |
| AMOUNT | VARCHAR(500) | Transaction amount |
| METHOD | VARCHAR(500) | Payment method |
| FROMDATE | VARCHAR(500) | Service from date |
| TODATE | VARCHAR(500) | Service to date |
| PROCEDURECODE | VARCHAR(500) | CPT procedure code |
| PAYMENTS | VARCHAR(500) | Total payments applied |
| ADJUSTMENTS | VARCHAR(500) | Total adjustments |
| OUTSTANDING | VARCHAR(500) | Outstanding balance |
| ETL_Load_Date | DATETIME | Timestamp when record was loaded |
| ETL_Source_File | VARCHAR(500) | Source CSV file name |

---

## 🌟 Dimension Tables

### dw.DIM_Date
**Description:** Pre-populated calendar dimension table (2000-2030)  
**SCD Type:** N/A — static reference table

| Column | Data Type | Description |
|---|---|---|
| Date_SK | INT | Surrogate key (format: YYYYMMDD e.g. 20240101) |
| FullDate | DATE | Full calendar date |
| Year | INT | Calendar year |
| Quarter | INT | Quarter number (1-4) |
| Month | INT | Month number (1-12) |
| MonthName | VARCHAR(20) | Month name (January-December) |
| Week | INT | Week number of year |
| Day | INT | Day of month |
| DayName | VARCHAR(20) | Day name (Monday-Sunday) |
| IsWeekend | BIT | 1=Weekend, 0=Weekday |

---

### dw.DIM_Patient
**Description:** Patient demographics with full change history  
**SCD Type:** Type 2 — tracks all changes to patient records

| Column | Data Type | Description |
|---|---|---|
| Patient_SK | INT IDENTITY | Surrogate key (system generated) |
| Patient_NK | VARCHAR(500) | Natural key — Synthea patient UUID |
| FirstName | VARCHAR(500) | Patient first name |
| LastName | VARCHAR(500) | Patient last name |
| DateOfBirth | DATE | Date of birth |
| DeathDate | DATE | Date of death (NULL if alive) |
| Gender | VARCHAR(50) | Gender (M/F) |
| Race | VARCHAR(500) | Patient race |
| Ethnicity | VARCHAR(500) | Patient ethnicity |
| City | VARCHAR(500) | City of residence |
| State | VARCHAR(500) | State of residence |
| ZipCode | VARCHAR(50) | ZIP code |
| SCD_Start_Date | DATE | Date this record version became active |
| SCD_End_Date | DATE | Date this record version expired (NULL=current) |
| Is_Current | BIT | 1=Current record, 0=Historical record |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.DIM_Provider
**Description:** Healthcare provider records  
**SCD Type:** Type 2 — tracks provider changes

| Column | Data Type | Description |
|---|---|---|
| Provider_SK | INT IDENTITY | Surrogate key |
| Provider_NK | VARCHAR(500) | Natural key — provider UUID |
| Organization_NK | VARCHAR(500) | Organization UUID |
| SCD_Start_Date | DATE | Record active start date |
| SCD_End_Date | DATE | Record expiry date (NULL=current) |
| Is_Current | BIT | 1=Current, 0=Historical |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.DIM_Facility
**Description:** Healthcare facility/organization records  
**SCD Type:** Type 1 — overwrites on change

| Column | Data Type | Description |
|---|---|---|
| Facility_SK | INT IDENTITY | Surrogate key |
| Facility_NK | VARCHAR(500) | Natural key — organization UUID |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.DIM_Diagnosis
**Description:** Diagnosis code reference table  
**SCD Type:** Type 1 — overwrites on change

| Column | Data Type | Description |
|---|---|---|
| Diagnosis_SK | INT IDENTITY | Surrogate key |
| Diagnosis_Code | VARCHAR(500) | SNOMED/ICD diagnosis code |
| Diagnosis_Desc | VARCHAR(500) | Diagnosis description |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.DIM_Procedure
**Description:** Procedure code reference table  
**SCD Type:** Type 1 — overwrites on change

| Column | Data Type | Description |
|---|---|---|
| Procedure_SK | INT IDENTITY | Surrogate key |
| Procedure_Code | VARCHAR(500) | SNOMED/CPT procedure code |
| Procedure_Desc | VARCHAR(500) | Procedure description |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.DIM_Payer
**Description:** Insurance payer reference table  
**SCD Type:** Type 1 — overwrites on change

| Column | Data Type | Description |
|---|---|---|
| Payer_SK | INT IDENTITY | Surrogate key |
| Payer_NK | VARCHAR(500) | Natural key — payer UUID |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

## 📊 Fact Tables

### dw.FACT_Encounter
**Description:** Clinical encounter transactions — one row per encounter  
**Grain:** One row per patient encounter

| Column | Data Type | Description |
|---|---|---|
| Encounter_SK | INT IDENTITY | Surrogate key |
| Encounter_NK | VARCHAR(500) | Natural key — encounter UUID |
| Patient_SK | INT | FK to DIM_Patient |
| Provider_SK | INT | FK to DIM_Provider |
| Facility_SK | INT | FK to DIM_Facility |
| Payer_SK | INT | FK to DIM_Payer |
| AdmitDate_SK | INT | FK to DIM_Date (admit date) |
| DischargeDate_SK | INT | FK to DIM_Date (discharge date) |
| EncounterClass | VARCHAR(500) | Encounter type (ambulatory/inpatient/emergency) |
| EncounterCode | VARCHAR(500) | SNOMED encounter code |
| EncounterDescription | VARCHAR(500) | Encounter description |
| BaseEncounterCost | DECIMAL(18,2) | Base cost before insurance |
| TotalClaimCost | DECIMAL(18,2) | Total claim cost |
| PayerCoverage | DECIMAL(18,2) | Amount covered by insurance |
| ReasonCode | VARCHAR(500) | Reason for encounter code |
| ReasonDescription | VARCHAR(500) | Reason for encounter description |
| LengthOfStay_Days | INT | Days between admit and discharge |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.FACT_Condition
**Description:** Patient diagnosis history — one row per condition per patient  
**Grain:** One row per patient condition

| Column | Data Type | Description |
|---|---|---|
| Condition_SK | INT IDENTITY | Surrogate key |
| Patient_SK | INT | FK to DIM_Patient |
| Encounter_SK | INT | FK to FACT_Encounter |
| Diagnosis_SK | INT | FK to DIM_Diagnosis |
| OnsetDate_SK | INT | FK to DIM_Date (onset date) |
| ResolvedDate_SK | INT | FK to DIM_Date (resolved date) |
| ConditionCode | VARCHAR(500) | SNOMED condition code |
| ConditionDesc | VARCHAR(500) | Condition description |
| IsActive | BIT | 1=Active condition, 0=Resolved |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.FACT_Observation
**Description:** Lab results, vitals and social history — one row per observation  
**Grain:** One row per observation per encounter

| Column | Data Type | Description |
|---|---|---|
| Observation_SK | INT IDENTITY | Surrogate key |
| Patient_SK | INT | FK to DIM_Patient |
| Encounter_SK | INT | FK to FACT_Encounter |
| ObsDate_SK | INT | FK to DIM_Date |
| ObsCode | VARCHAR(500) | LOINC observation code |
| ObsDescription | VARCHAR(500) | Observation description |
| ObsCategory | VARCHAR(500) | Category (laboratory/vital-signs/social-history) |
| ObsValue | VARCHAR(500) | Raw observation value |
| ObsValueNumeric | DECIMAL(18,4) | Numeric value (NULL for text results) |
| ObsUnits | VARCHAR(500) | Unit of measurement |
| ObsType | VARCHAR(500) | Value type (numeric/text) |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.FACT_Procedure
**Description:** Clinical procedures performed — one row per procedure  
**Grain:** One row per procedure per encounter

| Column | Data Type | Description |
|---|---|---|
| Procedure_SK | INT IDENTITY | Surrogate key |
| Patient_SK | INT | FK to DIM_Patient |
| Encounter_SK | INT | FK to FACT_Encounter |
| Procedure_DimSK | INT | FK to DIM_Procedure |
| ProcDate_SK | INT | FK to DIM_Date |
| ProcedureCode | VARCHAR(500) | SNOMED/CPT procedure code |
| ProcedureDesc | VARCHAR(500) | Procedure description |
| BaseCost | DECIMAL(18,2) | Base cost of procedure |
| ReasonCode | VARCHAR(500) | Reason code |
| ReasonDesc | VARCHAR(500) | Reason description |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.FACT_Medication
**Description:** Medication prescription records — one row per prescription  
**Grain:** One row per medication per patient encounter

| Column | Data Type | Description |
|---|---|---|
| Medication_SK | INT IDENTITY | Surrogate key |
| Patient_SK | INT | FK to DIM_Patient |
| Encounter_SK | INT | FK to FACT_Encounter |
| Payer_SK | INT | FK to DIM_Payer |
| StartDate_SK | INT | FK to DIM_Date (start date) |
| StopDate_SK | INT | FK to DIM_Date (stop date) |
| MedicationCode | VARCHAR(500) | RxNorm medication code |
| MedicationDesc | VARCHAR(500) | Medication name and dosage |
| BaseCost | DECIMAL(18,2) | Base cost per dispense |
| PayerCoverage | DECIMAL(18,2) | Amount covered by insurance |
| Dispenses | INT | Number of dispenses |
| TotalCost | DECIMAL(18,2) | Total medication cost |
| ReasonCode | VARCHAR(500) | Reason for prescription |
| ReasonDesc | VARCHAR(500) | Reason description |
| IsActive | BIT | 1=Active prescription, 0=Discontinued |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.FACT_Claim
**Description:** Insurance claim header records — one row per claim  
**Grain:** One row per insurance claim

| Column | Data Type | Description |
|---|---|---|
| Claim_SK | INT IDENTITY | Surrogate key |
| Claim_NK | VARCHAR(500) | Natural key — claim UUID |
| Patient_SK | INT | FK to DIM_Patient |
| Provider_SK | INT | FK to DIM_Provider |
| ServiceDate_SK | INT | FK to DIM_Date |
| Diagnosis1 | VARCHAR(500) | Primary diagnosis code |
| Diagnosis2 | VARCHAR(500) | Secondary diagnosis code |
| Diagnosis3 | VARCHAR(500) | Tertiary diagnosis code |
| Status1 | VARCHAR(500) | Primary claim status |
| Outstanding1 | DECIMAL(18,2) | Primary outstanding balance |
| Outstanding2 | DECIMAL(18,2) | Secondary outstanding balance |
| OutstandingP | DECIMAL(18,2) | Patient outstanding balance |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

### dw.FACT_ClaimTransaction
**Description:** Claim line item transactions — one row per transaction  
**Grain:** One row per claim transaction

| Column | Data Type | Description |
|---|---|---|
| ClaimTxn_SK | INT IDENTITY | Surrogate key |
| ClaimTxn_NK | VARCHAR(500) | Natural key — transaction UUID |
| Claim_NK | VARCHAR(500) | FK to FACT_Claim |
| Patient_SK | INT | FK to DIM_Patient |
| FromDate_SK | INT | FK to DIM_Date |
| TransactionType | VARCHAR(500) | Type (CHARGE/PAYMENT/ADJUSTMENT) |
| Amount | DECIMAL(18,2) | Transaction amount |
| Method | VARCHAR(500) | Payment method |
| ProcedureCode | VARCHAR(500) | CPT procedure code |
| Units | INT | Number of units |
| Payments | DECIMAL(18,2) | Total payments applied |
| Adjustments | DECIMAL(18,2) | Total adjustments |
| Outstanding | DECIMAL(18,2) | Outstanding balance |
| ETL_Load_Date | DATETIME | ETL load timestamp |

---

## 🔧 Stored Procedures

| Procedure | Database | Description |
|---|---|---|
| dw.usp_Load_DIM_Patient | HealthDW | Loads DIM_Patient with SCD Type 2 logic |
| dw.usp_Load_DIM_Provider | HealthDW | Loads DIM_Provider with SCD Type 2 logic |
| dw.usp_Load_DIM_Facility | HealthDW | Loads DIM_Facility (SCD Type 1) |
| dw.usp_Load_DIM_Diagnosis | HealthDW | Loads DIM_Diagnosis (SCD Type 1) |
| dw.usp_Load_DIM_Procedure | HealthDW | Loads DIM_Procedure (SCD Type 1) |
| dw.usp_Load_DIM_Payer | HealthDW | Loads DIM_Payer (SCD Type 1) |
| dw.usp_Load_FACT_Encounter | HealthDW | Loads FACT_Encounter with dimension lookups |
| dw.usp_Load_FACT_Condition | HealthDW | Loads FACT_Condition |
| dw.usp_Load_FACT_Observation | HealthDW | Loads FACT_Observation |
| dw.usp_Load_FACT_Procedure | HealthDW | Loads FACT_Procedure |
| dw.usp_Load_FACT_Medication | HealthDW | Loads FACT_Medication |
| dw.usp_Load_FACT_Claim | HealthDW | Loads FACT_Claim |
| dw.usp_Load_FACT_ClaimTransaction | HealthDW | Loads FACT_ClaimTransaction |

---

## 📝 ETL Audit Log

### aud.ETL_Run_Log
**Description:** Tracks every ETL package execution for monitoring and debugging

| Column | Data Type | Description |
|---|---|---|
| RunID | INT IDENTITY | Unique run identifier |
| PackageName | VARCHAR(200) | SSIS package name |
| RunStart | DATETIME | Package execution start time |
| RunEnd | DATETIME | Package execution end time |
| Status | VARCHAR(20) | RUNNING / SUCCESS / FAILED |
| RowsLoaded | INT | Number of rows successfully loaded |
| RowsRejected | INT | Number of rows rejected |
| SourceFile | VARCHAR(500) | Source file processed |
| ErrorMessage | NVARCHAR(MAX) | Error details if failed |
| RunBy | VARCHAR(100) | Windows user who ran the package |

---

## 🔑 Key Design Decisions

| Decision | Rationale |
|---|---|
| All staging columns VARCHAR(500) | Avoids truncation errors from source data |
| SCD Type 2 for Patient & Provider | Maintains full history of demographic changes |
| SCD Type 1 for reference dimensions | Diagnosis/Procedure codes rarely change meaning |
| Surrogate keys on all DW tables | Decouples DW from source system key changes |
| TRY_CAST for all conversions | Prevents ETL failure on bad data — returns NULL instead |
| ISNULL(SK, -1) for lookups | Handles orphan records without breaking fact loads |
| DIM_Date pre-populated | Faster date-based aggregations in Power BI |
