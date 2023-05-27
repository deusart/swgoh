USE swgoh
GO

CREATE OR ALTER FUNCTION fn.is_capital
(
	@unit_id nvarchar(max)
)
RETURNS BIT
AS
BEGIN
	RETURN IIF(
		(
			SELECT COUNT(*) 
			FROM stage.ships
			WHERE ship_id = @unit_id
			AND ship_tags like '%|Capital Ship|%'
		) > 0
		, 1
		, 0
	)
END
GO
