USE swgoh
GO

-- members_mods
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_mods'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members_mods (
		row_id int IDENTITY(1,1) NOT NULL
		, member_allycode bigint NULL
		, character_id nvarchar(max) NULL
		, mod_id nvarchar(max) NULL
		, mod_level int NULL
		, mod_pips int NULL
		, mod_set int NULL
		, mod_slot int NULL
		, mod_primary_stat int NULL
		, mod_primary_value float NULL		
		, mod_second_01_stat int NULL
		, mod_second_01_value float NULL
		, mod_second_01_roll int NULL
		, mod_second_02_stat int NULL
		, mod_second_02_value float NULL
		, mod_second_02_roll int NULL
		, mod_second_03_stat int NULL
		, mod_second_03_value float NULL
		, mod_second_03_roll int NULL
		, mod_second_04_stat int NULL
		, mod_second_04_value float NULL
		, mod_second_04_roll int NULL
		, hash_diff binary(16) NOT NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members_mods ADD CONSTRAINT df_stage_members_mods_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members_mods ADD CONSTRAINT df_stage_members_mods_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO
