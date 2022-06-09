USE swgoh
GO

-- members_characters
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_characters'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members_characters (		
		row_id int IDENTITY(1,1) NOT NULL
		, member_allycode bigint NULL
		, character_id nvarchar(250) NULL		
		, is_legend bit NULL
		, character_level int NULL
		, character_power bigint NULL
		, character_stars int NULL
		, character_gear int NULL
		, character_relic int NULL
		, character_zetas int NULL
		, character_omegas int NULL
		, gear_slot_01 int NULL
		, gear_slot_02 int NULL
		, gear_slot_03 int NULL
		, gear_slot_04 int NULL
		, gear_slot_05 int NULL
		, gear_slot_06 int NULL
		, updated bigint NULL
		, hash_diff binary(16) NOT NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members_characters ADD CONSTRAINT df_stage_members_characters_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members_characters ADD CONSTRAINT df_stage_members_characters_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

CREATE UNIQUE CLUSTERED INDEX ci_smc ON stage.members_characters
(
	member_allycode ASC,
	character_id ASC
) ON [PRIMARY]
GO
