USE swgoh
GO

CREATE OR ALTER VIEW rules.members_skills
AS
	SELECT 
		member_allycode
		, SUM(omicron_applied) AS total_omicrons_applied
		, SUM(zeta_applied) AS total_zetas_applied
		, SUM(omega_applied) AS total_omegas_applied
		, SUM(IIF(omicron_mode_id = 7, omicron_applied, 0)) AS total_omicron_tw
		, SUM(IIF(omicron_mode_id = 9, omicron_applied, 0)) AS total_omicron_ga
		, SUM(IIF(omicron_mode_id = 8, omicron_applied, 0)) AS total_omicron_tb
		, SUM(IIF(omicron_mode_id = 14, omicron_applied, 0)) AS total_omicron_ga3x3
	FROM swgoh.rules.members_characters_skills_details
	GROUP BY member_allycode
GO
