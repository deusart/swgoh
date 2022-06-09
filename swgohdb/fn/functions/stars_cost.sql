USE swgoh
GO

CREATE OR ALTER FUNCTION fn.stars_cost (@base_id nvarchar(max))
RETURNS int
AS
BEGIN
	--declare @shards int = (
	--	select character_shards 
	--	from stage.characters 
	--	where character_base_id = @base_id
	--	)
	--declare @star int = (
	--	select 
	--		isnull(
	--			(
	--				select character_stars 
	--				from  stage.player_characters 
	--				where character_base_id = @base_id
	--			)
	--			, 0
	--		)
	--	)
	
	RETURN 0 -- iif(@star = 0, 100, 0) + isnull((select sum(star_cost) from fn.stars where star_shards > @shards and star_number > @star),0)
END
GO