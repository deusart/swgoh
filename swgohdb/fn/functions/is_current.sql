USE swgoh
GO

CREATE OR ALTER FUNCTION fn.is_current
(
	@allycode bigint
)
RETURNS BIT
AS
BEGIN
	RETURN IIF(
		(
			SELECT COUNT(*) 
			FROM stage.members_current
			WHERE member_allycode = @allycode
		) >0
		, 1
		, 0
	)
END
GO
