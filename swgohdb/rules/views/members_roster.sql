USE swgoh
GO

CREATE OR ALTER VIEW rules.members_roster
AS
	SELECT 
		c.member_allycode
		, c.characters_count
		, s.ships_count
		, c.legends_count
		, c.relics_count
		, c.r9_count
		, c.r8_count
		, c.r7_count
		, c.r0_6_count
		, c.g12_count
		, c.zetas_count
		, c.total_relic_levels
		, c.top_unit
	FROM (
		SELECT 
			mc.member_allycode
			, COUNT(character_id) AS characters_count
			, SUM(IIF(is_legend=1,1,0)) AS legends_count
			, SUM(IIF(character_relic>0,1,0)) AS relics_count
			, SUM(IIF(character_relic = 9, 1, 0)) AS r9_count
			, SUM(IIF(character_relic = 8, 1, 0)) AS r8_count
			, SUM(IIF(character_relic = 7, 1, 0)) AS r7_count
			, SUM(IIF(character_relic <= 6 AND character_gear = 13, 1, 0)) AS r0_6_count
			, SUM(IIF(character_gear = 12, 1, 0)) AS g12_count
			, SUM(character_relic) AS total_relic_levels
			, MAX(ms.total_zetas_applied) AS zetas_count
			, (
				SELECT TOP 1 
					(
						SELECT character_name
						FROM stage.characters
						WHERE mci.character_id = character_id
					) AS character_name
				FROM stage.members_characters mci
				WHERE character_power = max(mc.character_power) AND mci.member_allycode = mc.member_allycode
			) as top_unit
		FROM stage.members_characters mc
		INNER JOIN rules.members_skills ms on ms.member_allycode = mc.member_allycode
		GROUP BY mc.member_allycode
	) c
	INNER JOIN (
		SELECT 
			member_allycode
			, COUNT(ship_id) AS ships_count			
		FROM stage.members_ships
		GROUP BY member_allycode
	) s ON s.member_allycode = c.member_allycode

GO

