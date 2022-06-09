USE swgoh
GO

CREATE OR ALTER VIEW player.characters
AS
	SELECT member_allycode
		  , character_id
		  , character_gear
		  , character_level
		  , character_relic
		  , character_stars
		  , character_power
		  , omicrons_applied
		  , zetas_applied
		  , omicron_ga
		  , omicron_ga3x3
		  , full_update
	FROM core.members_characters
	WHERE member_allycode = fn.player()
GO