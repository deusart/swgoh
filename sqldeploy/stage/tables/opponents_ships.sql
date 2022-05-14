USE hordeby
GO

-- opponents_ships
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'opponents_ships'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.opponents_ships (		
		row_id int IDENTITY(1,1) NOT NULL		
		, opponent_allycode bigint NULL
		, ship_id nvarchar(250) NULL		
		, is_legend bit NULL
		, ship_level int NULL
		, ship_power bigint NULL
		, ship_stars int NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.opponents_ships ADD CONSTRAINT df_stage_opponents_ships_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.opponents_ships ADD CONSTRAINT df_stage_opponents_ships_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO