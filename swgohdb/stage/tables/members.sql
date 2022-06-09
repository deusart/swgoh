USE swgoh
GO

-- members
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members (
		row_id int IDENTITY(1,1) NOT NULL
		, member_name nvarchar(max) NULL
		, member_allycode bigint NULL
		, member_power bigint NULL
		, member_power_characters bigint NULL
		, member_power_ships bigint NULL
		, member_current int NULL
		, member_ligue nvarchar(max) NULL
		, updated bigint NULL
		, hash_diff binary(16) NOT NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members ADD CONSTRAINT df_stage_members_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members ADD CONSTRAINT df_stage_members_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO
