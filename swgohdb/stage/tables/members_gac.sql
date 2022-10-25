USE swgoh
GO

-- members_ships
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_gac'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members_gac (		
		row_id int IDENTITY(1,1) NOT NULL		
		, member_allycode bigint NULL
		, season_id nvarchar(max) NULL		
		, event_id nvarchar(max) NULL		
		, gac_ligue nvarchar(15) NULL
		, gac_division int NULL
		, gac_banners int NULL
		, gac_rank int NULL
		, gac_end_time bigint NULL
		, hash_diff binary(16) NOT NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members_gac ADD CONSTRAINT df_stage_members_gac_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members_gac ADD CONSTRAINT df_stage_members_gac_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO