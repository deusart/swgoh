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
	FROM (
		SELECT 
			member_allycode
			, COUNT(character_id) AS characters_count
			, SUM(IIF(is_legend=1,1,0)) AS legends_count
			, SUM(IIF(character_relic>0,1,0)) AS relics_count
			, SUM(IIF(character_relic = 9, 1, 0)) AS r9_count
			, SUM(IIF(character_relic = 8, 1, 0)) AS r8_count
			, SUM(IIF(character_relic = 7, 1, 0)) AS r7_count
			, SUM(IIF(character_relic <= 6 AND character_gear = 13, 1, 0)) AS r0_6_count
			, SUM(IIF(character_gear = 12, 1, 0)) AS g12_count
		FROM stage.members_characters
		GROUP BY member_allycode
	) c
	INNER JOIN (
		SELECT 
			member_allycode
			, COUNT(ship_id) AS ships_count			
		FROM stage.members_ships
		GROUP BY member_allycode
	) s ON s.member_allycode = c.member_allycode
GO