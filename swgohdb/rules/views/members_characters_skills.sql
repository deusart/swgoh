USE swgoh
GO

CREATE OR ALTER VIEW rules.members_characters_skills
AS
	SELECT 
		member_allycode, character_id
		, SUM(omicron_applied) AS omicrons_applied
		, SUM(zeta_applied) AS zetas_applied
		, SUM(omega_applied) AS omegas_applied
		, IIF(
			SUM(is_omicron+is_zeta+is_omega) = SUM(omicron_applied+zeta_applied+omega_applied)
			, 1
			, 0
		) AS full_update
		, SUM(IIF(omicron_mode_id = 7, omicron_applied, 0)) AS omicron_tw
		, SUM(IIF(omicron_mode_id = 9, omicron_applied, 0)) AS omicron_ga
		, SUM(IIF(omicron_mode_id = 8, omicron_applied, 0)) AS omicron_tb
		, SUM(IIF(omicron_mode_id = 14, omicron_applied, 0)) AS omicron_ga3x3
	FROM swgoh.rules.members_characters_skills_details
	GROUP BY member_allycode, character_id
GO
