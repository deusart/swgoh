USE swgoh
GO

-- ships
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'ships'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.ships (
		row_id int IDENTITY(1,1) NOT NULL
		, ship_id nvarchar(max) NULL
		, ship_name nvarchar(max) NULL
		, ship_url nvarchar(max) NULL
		, ship_image nvarchar(max) NULL
		, ship_power int NULL
		, ship_description nvarchar(max) NULL
		, ship_alignment nvarchar(max) NULL
		, ship_capital_ship bit NULL
		, ship_shards int NULL
		, ship_tags nvarchar(max) NULL
		, hash_diff binary(16) NOT NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.ships ADD CONSTRAINT df_stage_ships_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.ships ADD CONSTRAINT df_stage_ships_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO