USE swgoh
GO

-- gear_recipes
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'gear_recipes'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.gear_recipes (
		row_id int IDENTITY(1,1) NOT NULL
		, gear_id nvarchar(max)
		, gear_part_id nvarchar(max) NULL
		, amount int
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.gear_recipes ADD CONSTRAINT df_stage_gear_recipes_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.gear_recipes ADD CONSTRAINT df_stage_gear_recipes_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END