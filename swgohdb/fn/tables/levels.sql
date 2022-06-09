USE swgoh
GO

IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'levels'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'fn')
)
BEGIN
	CREATE TABLE fn.levels (
		level_number int NULL
		, level_cost int NULL
	) ON [PRIMARY]
END