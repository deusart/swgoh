USE swgoh
GO

CREATE OR ALTER VIEW rules.hothls
AS
	WITH hoth_phoenix_1_1 AS (
		SELECT
			mc.member_allycode
			, ROW_NUMBER() OVER (
					PARTITION BY mc.member_allycode
					ORDER BY mc.character_stars desc, mc.character_power desc
					) as row_num
		FROM stage.characters c
		INNER JOIN stage.members_characters mc ON mc.character_id = c.character_id
		WHERE c.character_tags like '%|Phoenix|%'
			AND c.character_power > 5000
	)
	, hoth_rogueone_2_2 AS (
		SELECT
			mc.member_allycode
			, ROW_NUMBER() OVER (
					PARTITION BY mc.member_allycode
					ORDER BY mc.character_stars desc, mc.character_power desc
					) as row_num
		FROM stage.characters c
		INNER JOIN stage.members_characters mc ON mc.character_id = c.character_id
		WHERE c.character_tags like '%|Rogue One|%'
			AND c.character_power > 7000
	)
	, hoth_hothlea_3_3 AS (
		SELECT
			mc.member_allycode
			, ROW_NUMBER() OVER (
					PARTITION BY mc.member_allycode
					ORDER BY mc.character_stars desc, mc.character_power desc
					) as row_num
		FROM stage.members_characters mc
		WHERE mc.character_id like '%HOTHREBELSOLDIER%'
			AND mc.character_stars >= 5
	) 
	SELECT 'Hoth 1-1 Phoenix' AS tb_mission, member_allycode, fn.member_name(member_allycode), IIF(COUNT(*) >= 5, 1, 0) AS ready
		FROM hoth_phoenix_1_1
		WHERE row_num < 6
		GROUP BY member_allycode
	, total AS (
		
	
		UNION ALL
		SELECT 'Hoth 2-2 Rogue One' AS tb_mission, member_allycode, IIF(COUNT(*) >= 5, 1, 0) AS ready
		FROM hoth_rogueone_2_2
		WHERE row_num < 6
		GROUP BY member_allycode
	
		UNION ALL	
		SELECT 'Hoth 3-3 Hoth Lea' AS tb_mission, member_allycode, IIF(COUNT(*) >= 1, 1, 0) AS ready
		FROM hoth_hothlea_3_3
		GROUP BY member_allycode
	)
	SELECT tb_mission, SUM(ready) AS ready_count
	FROM total 
	WHERE fn.is_current(member_allycode) = 1
	GROUP BY tb_mission
GO