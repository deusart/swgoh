USE swgoh
GO

-- daily_members
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'daily_members'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'archive')
)
BEGIN
	CREATE TABLE archive.daily_members (		
		row_id int IDENTITY(1,1) NOT NULL
		, log_date date null
		, member_allycode bigint NULL
		, member_name nvarchar(max) NULL		
		, member_power bigint NULL
		, member_power_characters bigint NULL
		, member_power_ships bigint NULL
		, member_legends int NULL
		, member_relics int NULL
		, member_relic_levels int NULL
		, member_zetas int NULL	
		, member_omicrons int NULL
		, member_characters int NULL	
		, member_ships int NULL	
		, member_characters_g12 int NULL	
		, member_fleet_rank int NULL
		, member_arena_rank int NULL
		, member_ligue nvarchar(max) NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE archive.daily_members ADD CONSTRAINT df_daily_members_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE archive.daily_members ADD CONSTRAINT df_daily_members_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO
