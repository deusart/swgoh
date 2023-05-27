USE swgoh
GO

-- members_swgohgg
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_swgohgg'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'history')
)
BEGIN
	CREATE TABLE history.members_swgohgg (
		row_id int IDENTITY(1,1) NOT NULL
		, member_allycode bigint NULL
		, member_skillrating bigint NULL
		, datacrons_0 int NULL
		, datacrons_1 int NULL
		, datacrons_2 int NULL
		, datacrons_3 int NULL
		, datacrons_4 int NULL
		, datacrons_5 int NULL
		, datacrons_6 int NULL
		, datacrons_7 int NULL
		, datacrons_8 int NULL
		, datacrons_9 int NULL
		, last_updated datetime NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE history.members_swgohgg ADD CONSTRAINT df_history_members_swgohgg_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE history.members_swgohgg ADD CONSTRAINT df_history_members_swgohgg_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

CREATE OR ALTER TRIGGER stage.members_swgohgg_update
   ON stage.members_swgohgg
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO history.members_swgohgg(
		member_allycode, member_skillrating
		, datacrons_0, datacrons_1, datacrons_2, datacrons_3
		, datacrons_4, datacrons_5, datacrons_6, datacrons_7
		, datacrons_8, datacrons_9, last_updated
		)
	select 	
		member_allycode, member_skillrating
		, datacrons_0, datacrons_1, datacrons_2, datacrons_3
		, datacrons_4, datacrons_5, datacrons_6, datacrons_7
		, datacrons_8, datacrons_9, last_updated
	from inserted
END