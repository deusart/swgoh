USE swgoh
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
		, ship_id nvarchar(max) NULL		
		, is_legend bit NULL
		, ship_level int NULL
		, ship_power bigint NULL
		, ship_stars int NULL
		, updated bigint NULL
		, hash_diff binary(16) NOT NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members_ships ADD CONSTRAINT df_stage_members_ships_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members_ships ADD CONSTRAINT df_stage_members_ships_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO