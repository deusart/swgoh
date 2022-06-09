USE swgoh
GO

-- members
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'opponents'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.opponents (
		row_id int IDENTITY(1,1) NOT NULL
		, opponent_name nvarchar(max) NULL
		, opponent_allycode bigint NULL
		, opponent_power bigint NULL
		, opponent_ligue nvarchar(max) NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.opponents ADD CONSTRAINT df_stage_opponents_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.opponents ADD CONSTRAINT df_stage_opponents_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO
