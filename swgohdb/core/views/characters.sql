USE swgoh
GO

CREATE OR ALTER VIEW core.characters
AS
	SELECT row_id, character_id, character_name
		  , character_url, character_image
		  , character_power as character_max_power
		  , character_description
		  , character_alignment
		  , character_ship
		  , IIF(LEN(character_ship)>0,1,0) AS is_pilot
		  , character_shards
		  , character_tags
		  , IIF(CHARINDEX('Legend', character_tags)>0, 1,0) AS is_legend
	FROM stage.characters
GO