USE swgoh
GO

CREATE OR ALTER PROCEDURE stage.insert_members_current
	@members nvarchar(max)
AS
BEGIN
	TRUNCATE TABLE stage.members_current;

	INSERT INTO stage.members_current(member_allycode)
	SELECT value FROM STRING_SPLIT(@members, ',')

	INSERT INTO history.members_current(member_allycode)
	SELECT member_allycode FROM stage.members_current
END
