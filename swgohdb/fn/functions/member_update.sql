USE swgoh
GO

CREATE OR ALTER FUNCTION fn.member_update (@allycode INT)
RETURNS DATE AS
BEGIN
	RETURN (
			SELECT TOP 1 max(updated_at) 
			FROM stage.members
			WHERE member_allycode = @allycode
		) 
END
GO