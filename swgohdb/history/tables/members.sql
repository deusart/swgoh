USE swgoh
GO

-- members
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'history')
)
BEGIN
	CREATE TABLE history.members (
		row_id int IDENTITY(1,1) NOT NULL
		, member_name nvarchar(max) NULL
		, member_allycode bigint NULL
		, member_power bigint NULL
		, member_power_characters bigint NULL
		, member_power_ships bigint NULL
		, member_ligue nvarchar(max) NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE history.members ADD CONSTRAINT df_history_members_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE history.members ADD CONSTRAINT df_history_members_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

CREATE OR ALTER TRIGGER stage.members_update
   ON stage.members
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO history.members(
		member_name, member_allycode, member_power
		, member_power_characters, member_power_ships
		, member_ligue, updated
		)
	select 	member_name, member_allycode, member_power
		, member_power_characters, member_power_ships
		, member_ligue, updated
	from inserted
END