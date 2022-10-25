USE swgoh
GO

CREATE OR ALTER VIEW rules.members_roster_omicrons
AS
SELECT 
	mcs.member_allycode
	, mcs.skill_id, mcs.character_id
	, iif(mcs.tier = mcs.tier_max, 1, 0) AS is_applied
	, CASE
		WHEN omicron_mode = 9 THEN 'GA'
		WHEN omicron_mode = 8 THEN 'TB'
		WHEN omicron_mode = 7 THEN 'TW'
		WHEN omicron_mode = 14 THEN 'GA3x3'
		ELSE 'OTHER'
	END AS omicron_mode
FROM stage.members_characters_skills mcs
inner join stage.skills s ON s.skill_id = mcs.skill_id AND s.character_id = mcs.character_id 
WHERE is_omicron = 1
GO