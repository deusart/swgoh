USE swgoh
GO

CREATE OR ALTER FUNCTION fn.level_cost (@base_id nvarchar(max))
RETURNS int
AS
BEGIN
	RETURN 0
	--(
	--	select sum(level_cost) from swgoh.fn.levels
	--	where level_number > (
	--		select character_level  
	--		from stage.player_characters 
	--		where character_base_id = @base_id
	--	)
	--)
END
GO