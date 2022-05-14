USE hordeby
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