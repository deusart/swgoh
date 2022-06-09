USE swgoh
GO

-- members_current
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_current'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members_current (
		member_allycode bigint NULL
	) ON [PRIMARY]
END
GO
