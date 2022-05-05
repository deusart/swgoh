USE hordeby
GO

-- drop table stage.members
-- drop table stage.members_ships

-- members
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members (
		row_id int IDENTITY(1,1) NOT NULL
		, member_name nvarchar(250) NULL
		, member_allycode bigint NULL
		, member_power bigint NULL
		, member_power_characters bigint NULL
		, member_power_ships bigint NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members ADD CONSTRAINT df_stage_members_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members ADD CONSTRAINT df_stage_members_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

-- members_ships
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_ships'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members_ships (		
		row_id int IDENTITY(1,1) NOT NULL		
		, member_allycode bigint NULL
		, ship_id nvarchar(250) NULL		
		, is_legend bit NULL
		, ship_level int NULL
		, ship_power bigint NULL
		, ship_stars int NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members_ships ADD CONSTRAINT df_stage_members_ships_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members_ships ADD CONSTRAINT df_stage_members_ships_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
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

		, character_relic int NULL
		, character_zetas int NULL
		, character_omegas int NULL

		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members_characters ADD CONSTRAINT df_stage_members_characters_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members_characters ADD CONSTRAINT df_stage_members_characters_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

-- members_characters_skills
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_characters_skills'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members_characters_skills (		
		row_id int IDENTITY(1,1) NOT NULL		
		, member_allycode bigint NULL
		, character_id nvarchar(250) NULL
		, skill_id nvarchar(250) NULL
		, tier int NULL
		, tier_max int NULL
		, is_zeta bit NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members_characters_skills ADD CONSTRAINT df_stage_members_characters_skills_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members_characters_skills ADD CONSTRAINT df_stage_members_characters_skills_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
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
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.characters ADD CONSTRAINT df_stage_characters_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.characters ADD CONSTRAINT df_stage_characters_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
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

-- gear
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'gear'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.gear (
		row_id int IDENTITY(1,1) NOT NULL
		, gear_id nvarchar(250)
		, gear_name nvarchar(250) NULL
		, gear_tier int
		, gear_required_level nvarchar(250) NULL
		, gear_url nvarchar(250) NULL
		, gear_image nvarchar(250) NULL
		, gear_cost nvarchar(250) NULL
		, gear_mark nvarchar(250) NULL
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.gear ADD CONSTRAINT df_stage_gear_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.gear ADD CONSTRAINT df_stage_gear_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

-- gear_recipes
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'gear_recipes'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.gear_recipes (
		row_id int IDENTITY(1,1) NOT NULL
		, gear_id nvarchar(250)
		, gear_part_id nvarchar(250) NULL
		, amount int
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.gear_recipes ADD CONSTRAINT df_stage_gear_recipes_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.gear_recipes ADD CONSTRAINT df_stage_gear_recipes_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

-- ships
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'ships'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.ships (
		row_id int IDENTITY(1,1) NOT NULL
		, ship_id nvarchar(250) NULL
		, ship_name nvarchar(250) NULL
		, ship_url nvarchar(250) NULL
		, ship_image nvarchar(250) NULL
		, ship_power int NULL
		, ship_description nvarchar(250) NULL
		, ship_alignment nvarchar(250) NULL
		, ship_capital_ship nvarchar(250) NULL
		, ship_shards nvarchar(250) NULL
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.ships ADD CONSTRAINT df_stage_ships_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.ships ADD CONSTRAINT df_stage_ships_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO