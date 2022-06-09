USE swgoh
GO

CREATE OR ALTER FUNCTION fn.member_name (@allycode INT)
RETURNS NVARCHAR(50) AS
BEGIN
	RETURN (
			SELECT TOP 1 member_name 
			FROM stage.members
			WHERE member_allycode = @allycode
		) 
END
GO