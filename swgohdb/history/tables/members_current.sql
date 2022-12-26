USE swgoh
GO

-- members_current
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_current'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'history')
)
BEGIN
	CREATE TABLE history.members_current (
		row_id int IDENTITY(1,1) NOT NULL
		, member_allycode bigint NULL		
		, created_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE history.members_current ADD CONSTRAINT df_history_members_current_created_at DEFAULT (GETUTCDATE()) FOR created_at
END
GO

CREATE OR ALTER TRIGGER stage.members_current_update
   ON stage.members_current
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO history.members_current(member_allycode)
	select member_allycode
	from inserted
END