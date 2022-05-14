USE hordeby
GO

-- opponents_characters
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'opponents_characters'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.opponents_characters (		
		row_id int IDENTITY(1,1) NOT NULL
		, opponent_allycode bigint NULL
		, character_id nvarchar(250) NULL		
		, is_legend bit NULL
		, character_level int NULL
		, character_power bigint NULL
		, character_stars int NULL
		, character_gear int NULL
		, character_relic int NULL
		, character_zetas int NULL
		, character_omegas int NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.opponents_characters ADD CONSTRAINT df_stage_opponents_characters_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.opponents_characters ADD CONSTRAINT df_stage_opponents_characters_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO