USE swgoh
GO

CREATE OR ALTER FUNCTION fn.alignment  
(
	@unit_id nvarchar(max)
)
RETURNS NVARCHAR(50) AS
BEGIN
	RETURN (
			SELECT TOP 1 character_alignment 
			FROM stage.characters
			WHERE character_id = @unit_id
			UNION ALL
			SELECT TOP 1 ship_alignment 
			FROM stage.ships
			WHERE ship_id = @unit_id
		) 
END
GO