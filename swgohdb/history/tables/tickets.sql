USE swgoh
GO

-- tickets
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'tickets'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'history')
)
BEGIN
	CREATE TABLE history.tickets (
		row_id int IDENTITY(1,1) NOT NULL
		, member_name nvarchar(250) NULL
		, tickets int NULL
		, created_at datetime NOT NULL
	) ON [PRIMARY]
	ALTER TABLE history.tickets ADD DEFAULT (getutcdate()) FOR created_at
END
GO

CREATE OR ALTER TRIGGER input.input_tickets
   ON input.guild_tickets_input
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	insert into history.tickets(member_name, tickets)
	select user_nickname, tickets
	from inserted

	UPDATE gti
	SET gti.updated_at = GETDATE()
	from input.guild_tickets_input gti
	where row_id in (select row_id from inserted)
END
ALTER TABLE input.guild_tickets_input ENABLE TRIGGER input_tickets
GO
