USE hordeby
GO

-- characters_gear
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'characters_gear'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.characters_gear (
		row_id int IDENTITY(1,1) NOT NULL
		, character_id nvarchar(250)
		, character_tier int NULL
		, gear_slot_01 nvarchar(250) NULL
		, gear_slot_02 nvarchar(250) NULL
		, gear_slot_03 nvarchar(250) NULL
		, gear_slot_04 nvarchar(250) NULL
		, gear_slot_05 nvarchar(250) NULL
		, gear_slot_06 nvarchar(250) NULL
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.characters_gear ADD CONSTRAINT df_stage_characters_gear_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.characters_gear ADD CONSTRAINT df_stage_characters_gear_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO