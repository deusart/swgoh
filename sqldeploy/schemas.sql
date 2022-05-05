USE hordeby
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'stage')
EXEC('CREATE SCHEMA stage');
GO