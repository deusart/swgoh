USE swgoh
GO

-- members_ships
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_ships'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'history')
)
BEGIN
	CREATE TABLE history.members_ships (		
		row_id int IDENTITY(1,1) NOT NULL		
		, member_allycode bigint NULL
		, ship_id nvarchar(max) NULL		
		, is_legend bit NULL
		, ship_level int NULL
		, ship_power bigint NULL
		, ship_stars int NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE history.members_ships ADD CONSTRAINT df_history_members_ships_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE history.members_ships ADD CONSTRAINT df_history_members_ships_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

CREATE OR ALTER TRIGGER stage.members_ships_update
   ON stage.members_ships
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO history.members_ships(
		member_allycode, ship_id, is_legend
		, ship_level, ship_power, ship_stars
		, updated
		)
	SELECT member_allycode, ship_id, is_legend
		, ship_level, ship_power, ship_stars
		, updated
	FROM inserted
END