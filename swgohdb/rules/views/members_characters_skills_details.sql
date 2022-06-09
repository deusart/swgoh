USE swgoh
GO

CREATE OR ALTER VIEW rules.members_characters_skills_details
AS
	SELECT 
		mcs.member_allycode
		, mcs.skill_id, mcs.character_id
		, iif(mcs.tier = mcs.tier_max and is_omicron = 1, 1, 0) AS omicron_applied
		, iif(mcs.tier = mcs.tier_max and s.is_zeta = 1, 1, 0) AS zeta_applied
		, iif(mcs.tier = mcs.tier_max and is_omega = 1, 1, 0) AS omega_applied
		, CAST(is_omicron AS INT) AS is_omicron
		, CAST(s.is_zeta AS INT) AS is_zeta
		, CAST(is_omega AS INT) AS is_omega
		, omicron_mode AS omicron_mode_id
		, CASE
			WHEN omicron_mode = 9 THEN 'GA'
			WHEN omicron_mode = 8 THEN 'TB'
			WHEN omicron_mode = 7 THEN 'TW'
			WHEN omicron_mode = 14 THEN 'GA3x3'
			ELSE 'NO'
		END AS omicron_mode
	FROM stage.members_characters_skills mcs
	INNER JOIN stage.skills s 
		ON s.skill_id = mcs.skill_id 
		AND s.character_id = mcs.character_id 
GO