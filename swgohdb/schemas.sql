USE swgoh
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'stage')
EXEC('CREATE SCHEMA stage');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'history')
EXEC('CREATE SCHEMA history');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'fn')
EXEC('CREATE SCHEMA fn');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'control')
EXEC('CREATE SCHEMA control');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'google')
EXEC('CREATE SCHEMA google');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'input')
EXEC('CREATE SCHEMA input');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'rules')
EXEC('CREATE SCHEMA rules');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'player')
EXEC('CREATE SCHEMA player');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'core')
EXEC('CREATE SCHEMA core');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'archive')
EXEC('CREATE SCHEMA archive');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'storage')
EXEC('CREATE SCHEMA storage');
GO
