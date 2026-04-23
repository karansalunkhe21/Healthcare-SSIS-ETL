-- Create all 3 databases
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HealthDW_Staging')
    CREATE DATABASE HealthDW_Staging;
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HealthDW')
    CREATE DATABASE HealthDW;
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HealthDW_Error')
    CREATE DATABASE HealthDW_Error;
GO

-- Create schemas
USE HealthDW_Staging;
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg')
    EXEC('CREATE SCHEMA stg');
GO

USE HealthDW;
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dw')
    EXEC('CREATE SCHEMA dw');
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'aud')
    EXEC('CREATE SCHEMA aud');
GO

PRINT 'All databases and schemas created successfully!';