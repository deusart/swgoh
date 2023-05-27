USE swgoh
GO

CREATE OR ALTER FUNCTION fn.is_legend
(
	@character_id nvarchar(max)
)
RETURNS BIT
AS
BEGIN
	RETURN IIF(
		(
			SELECT COUNT(*) 
			FROM stage.characters
			WHERE character_id = @character_id
			AND character_tags like '%|Galactic Legend|%'
		) > 0
		, 1
		, 0
	)
END
GO
