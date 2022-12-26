USE swgoh
GO

-- daily_members_mods
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'daily_members_mods'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'archive')
)
BEGIN
	CREATE TABLE archive.daily_members_mods (		
		row_id int IDENTITY(1,1) NOT NULL
		, log_date date NULL
		, member_allycode bigint NULL
		, mods_6_pips int NULL
		, mods_5_pips int NULL
		, mods_low_pips int NULL
		, mods_speed_count int NULL
		, mods_speed_15_plus int NULL
		, mods_speed_20_plus int NULL
		, mods_speed_25_plus int NULL
		, mods_speed_arrows int NULL
		, mods_not_speed_arrows int NULL
		, mods_secondary_speed_arrows int NULL
		, mods_total_count int NULL
		, mods_arrows int NULL
		, mods_quality float NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE archive.daily_members_mods ADD CONSTRAINT df_daily_members_mods_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE archive.daily_members_mods ADD CONSTRAINT df_daily_members_mods_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO
