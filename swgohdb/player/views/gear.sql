USE swgoh
GO

CREATE OR ALTER VIEW player.gear
AS
	SELECT member_allycode
		  , character_id
		  , character_tier
		  , gear_slot
		  , gear_name
		  , gear_part_name
		  , amount
		  , gear_ready
		  , gear_parts_count
		  , gear_cost	
	FROM core.members_characters_gear
	WHERE member_allycode = fn.player()
GO