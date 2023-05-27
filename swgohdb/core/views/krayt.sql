USE swgoh
GO

CREATE OR ALTER VIEW core.krayt
AS
	WITH chars AS (
		SELECT character_id
		, IIF(character_tags LIKE '%|tusken|%', 1, 0) AS is_tusken
		, IIF(character_tags LIKE '%|jawa|%', 1, 0) AS is_jawa
		, IIF(character_tags LIKE '%|mandalorian|%', 1, 0) AS is_mandalorian
		, IIF(character_tags LIKE '%|old republic|%', 1, 0) AS is_old
		, IIF(character_tags LIKE '%|hutt cartel|%', 1, 0) AS is_hutt
		FROM stage.characters
		WHERE 
		(
			character_tags LIKE '%|old republic|%'
			OR character_tags LIKE '%|jawa|%'
			OR character_tags LIKE '%|tusken|%'
			OR character_tags LIKE '%|mandalorian|%'
			OR character_tags LIKE '%|hutt cartel|%'
		)
	), progress AS (
		SELECT 
			m.member_allycode
			, c.character_id
			, is_tusken, is_jawa, is_mandalorian, is_old, is_hutt
			, ROUND(
				CAST(
					SUM(IIF(mcg.gear_ready = 1 AND mc.character_stars >= 5, mcg.amount, 0)) 
					AS float
					)
				/ SUM(mcg.amount) 
				, 2
				) AS gear_progress 
			, CASE
				WHEN mc.character_stars = 7 THEN CAST(0.5 AS FLOAT)
				WHEN mc.character_stars = 6 THEN CAST(0.3 AS FLOAT)
				WHEN mc.character_stars = 5 THEN CAST(0.1 AS FLOAT)
				ELSE 0
			END AS stars_progress
			, CASE
				WHEN mc.character_relic >= 5 THEN CAST(1 AS FLOAT)
				WHEN mc.character_relic >= 4 THEN CAST(0.7 AS FLOAT)
				WHEN mc.character_relic >= 3  THEN CAST(0.5 AS FLOAT)
				WHEN mc.character_relic >= 2  THEN CAST(0.3 AS FLOAT)
				WHEN mc.character_relic >= 1  THEN CAST(0.1 AS FLOAT)
				ELSE 0
			END AS relic_progress
		FROM chars c
		CROSS JOIN stage.members_current m
		LEFT JOIN core.members_characters_gear mcg 
			ON m.member_allycode = mcg.member_allycode AND c.character_id = mcg.character_id
		LEFT JOIN stage.members_characters mc 
			ON m.member_allycode = mc.member_allycode AND c.character_id = mc.character_id
		GROUP BY m.member_allycode, c.character_id, mc.character_stars, mc.character_relic
		, is_tusken, is_jawa, is_mandalorian, is_old, is_hutt
	), 
	roster AS (
		SELECT 
		member_allycode
		, fn.member_name(member_allycode) AS member_name
		, SUM(gear_progress + stars_progress + relic_progress)/10 AS roster_score
		FROM progress
		GROUP BY member_allycode
	), teams AS (
		SELECT member_allycode, 'JABBATHEHUTT' AS team, 4 + (gear_progress + stars_progress + relic_progress) as team_progress
		FROM progress
		WHERE character_id = 'JABBATHEHUTT' AND stars_progress > 0
		UNION ALL
		SELECT member_allycode, 'MAULS7', 3 + (gear_progress + stars_progress + relic_progress) as team_progress
		FROM progress
		WHERE character_id = 'MAULS7' AND stars_progress > 0
		UNION ALL
		SELECT member_allycode, 'JEDIKNIGHTREVAN', 1 + (gear_progress + stars_progress + relic_progress) as team_progress
		FROM progress
		WHERE character_id = 'JEDIKNIGHTREVAN' AND stars_progress > 0
		UNION ALL
		SELECT member_allycode, 'CARTHONASI', SUM(1 + (gear_progress + stars_progress + relic_progress))/10 as team_progress
		FROM progress
		WHERE character_id IN ('CARTHONASI', 'MISSIONVAO', 'ZAALBAR', 'CANDEROUSORDO')
			AND stars_progress > 0
		GROUP BY member_allycode
		UNION ALL
		SELECT member_allycode, 'JAWA', SUM(1 + (gear_progress + stars_progress + relic_progress))/5 as team_progress
		FROM progress
		WHERE is_jawa = 1
			AND stars_progress > 0
		GROUP BY member_allycode
		UNION ALL
		SELECT member_allycode, 'TUSKEN', SUM(1 + (gear_progress + stars_progress + relic_progress))/5 as team_progress
		FROM progress
		WHERE is_tusken = 1
			AND stars_progress > 0
		GROUP BY member_allycode
	)
	SELECT r.member_allycode, r.member_name
		, ROUND(MAX(roster_score) + ISNULL(SUM(team_progress),0),2) AS krayt_score
	FROM roster r
	LEFT JOIN teams t ON r.member_allycode = t.member_allycode
	GROUP BY r.member_allycode, r.member_name
GO