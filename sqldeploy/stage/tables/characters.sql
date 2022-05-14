USE hordeby
GO

-- characters
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'characters'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.characters (
		row_id int IDENTITY(1,1) NOT NULL
		, character_id nvarchar(250) NULL
		, character_name nvarchar(250) NULL
		, character_url nvarchar(250) NULL
		, character_image nvarchar(250) NULL
		, character_power int NULL
		, character_description nvarchar(250) NULL
		, character_alignment nvarchar(250) NULL
		, character_ship nvarchar(250) NULL
		, character_shards nvarchar(250) NULL
		, character_tags nvarchar(max) NULL
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.characters ADD CONSTRAINT df_stage_characters_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.characters ADD CONSTRAINT df_stage_characters_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO