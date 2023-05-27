USE swgoh
GO

-- results_guildwars
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'results_guildwars'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.results_guildwars (
		row_id int IDENTITY(1,1) NOT NULL
		, guildwar_id nvarchar(250) NULL
		, ligue_name nvarchar(250) NULL
		, ligue_min bigint NULL
		, result int NULL
		, score_guild bigint NULL
		, score_opponent bigint NULL
		, date_start date NULL
	) ON [PRIMARY]
END
GO