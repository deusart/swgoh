USE swgoh
GO

-- members_characters
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_characters'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'history')
)
BEGIN
	CREATE TABLE history.members_characters (		
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
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE history.members_characters ADD CONSTRAINT df_history_members_characters_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE history.members_characters ADD CONSTRAINT df_history_members_characters_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

CREATE OR ALTER TRIGGER stage.members_characters_update
   ON stage.members_characters
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO history.members_characters(
		member_allycode, character_id, is_legend
		, character_level, character_power, character_stars
		, character_gear, character_relic, character_zetas
		, character_omegas, gear_slot_01, gear_slot_02
		, gear_slot_03, gear_slot_04, gear_slot_05, gear_slot_06
		, updated
		)
	SELECT member_allycode, character_id, is_legend
		, character_level, character_power, character_stars
		, character_gear, character_relic, character_zetas
		, character_omegas, gear_slot_01, gear_slot_02
		, gear_slot_03, gear_slot_04, gear_slot_05, gear_slot_06
		, updated
	FROM inserted
END