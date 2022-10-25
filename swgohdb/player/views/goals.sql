USE swgoh
GO

CREATE OR ALTER VIEW player.goals
AS
	SELECT mcg.*, g.goal_name, g.priority_num
	FROM core.members_characters_gear mcg
	INNER JOIN input.goals g on g.unit_id = mcg.character_id
	WHERE member_allycode = fn.player() AND g.unit_type = 'character'
	AND mcg.gear_ready = 0 and g.unit_gear >= mcg.character_tier
	AND goal_status = 'Process'
GO