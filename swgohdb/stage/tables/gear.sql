USE swgoh
GO

-- gear
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'gear'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.gear (
		row_id int IDENTITY(1,1) NOT NULL
		, gear_id nvarchar(max)
		, gear_name nvarchar(max) NULL
		, gear_tier int
		, gear_required_level int NULL
		, gear_url nvarchar(max) NULL
		, gear_image nvarchar(max) NULL
		, gear_cost int NULL
		, gear_mark nvarchar(max) NULL
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.gear ADD CONSTRAINT df_stage_gear_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.gear ADD CONSTRAINT df_stage_gear_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO