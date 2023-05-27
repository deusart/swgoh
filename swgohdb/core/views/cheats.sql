USE swgoh
GO

CREATE OR ALTER VIEW core.cheats
AS
	WITH c3p0 AS (
		SELECT member_allycode
			, COUNT(*) AS ewoks_count
			, SUM(IIF(character_gear>=9,1,0)) AS ewoks_gear_9
			, SUM(IIF(character_gear>=12,1,0)) AS ewoks_gear_12
			, SUM(IIF(character_id IN ('CHIEFCHIRPA','WICKET','LOGRAY','EWOKELDER','PAPLOO'),1,0)) AS ewoks_core
			, SUM(zetas_applied) AS ewoks_zetas
		FROM core.members_characters
		WHERE member_allycode IN (
			SELECT member_allycode
			FROM core.members_characters
			WHERE character_id = 'C3POLEGENDARY'
			AND character_stars = 7
		) AND character_id IN ('CHIEFCHIRPA','WICKET','LOGRAY','EWOKELDER','PAPLOO','TEEBO','EWOKSCOUT')
		AND character_stars = 7
		GROUP BY member_allycode
	), cls AS (
		SELECT member_allycode
			, COUNT(*) AS cls_count
			, SUM(IIF(character_gear>=5,1,0)) AS cls_gear_5
			, SUM(IIF(character_gear>=9,1,0)) AS cls_gear_9
			, SUM(zetas_applied) AS cls_zetas
		FROM core.members_characters
		WHERE member_allycode IN (
			SELECT member_allycode
			FROM core.members_characters
			WHERE character_id = 'COMMANDERLUKESKYWALKER'
			AND character_stars = 7
		) AND character_id IN ('STORMTROOPERHAN','LUKESKYWALKER')
		AND character_stars = 7
		GROUP BY member_allycode
	), jkr AS (
		SELECT member_allycode
			, COUNT(*) AS jkr_count
			, SUM(IIF(character_gear>=7,1,0)) AS jkr_gear_7
			, SUM(IIF(character_gear>=11,1,0)) AS jkr_gear_11
		FROM core.members_characters
		WHERE member_allycode IN (
			SELECT member_allycode
			FROM core.members_characters
			WHERE character_id = 'JEDIKNIGHTREVAN'
			AND character_stars = 7
		) AND character_id IN ('MISSIONVAO','T3_M4','JOLEEBINDO','ZAALBAR','BASTILASHAN')
		AND character_stars = 7
		GROUP BY member_allycode
	), dr AS (
		SELECT member_allycode
			, COUNT(*) AS dr_count
			, SUM(IIF(character_gear>=7,1,0)) AS dr_gear_7
			, SUM(IIF(character_gear>=11,1,0)) AS dr_gear_11
		FROM core.members_characters
		WHERE member_allycode IN (
			SELECT member_allycode
			FROM core.members_characters
			WHERE character_id = 'DARTHREVAN'
			AND character_stars = 7
		) AND character_id IN ('HK47','CARTHONASI','JUHANI','CANDEROUSORDO','BASTILASHANDARK')
		AND character_stars = 7
		GROUP BY member_allycode
	), padme AS (
		SELECT member_allycode
			, COUNT(*) AS padme_count
			, SUM(IIF(character_gear>=7,1,0)) AS padme_gear_7
			, SUM(IIF(character_gear>=11,1,0)) AS padme_gear_11
		FROM core.members_characters
		WHERE member_allycode IN (
			SELECT member_allycode
			FROM core.members_characters
			WHERE character_id = 'PADMEAMIDALA'
			AND character_stars = 7
		) 
		AND character_id IN (
			SELECT character_id 
			FROM stage.characters
			WHERE character_tags like '%|Separatist|%'
			)
		AND character_stars = 7
		GROUP BY member_allycode
	)
	, gas AS (
		SELECT member_allycode
			, COUNT(*) AS gas_count
			, SUM(IIF(character_gear>=11,1,0)) AS gas_gear_11
			, SUM(IIF(character_gear>=12,1,0)) AS gas_gear_12
			, SUM(IIF(character_gear>=13,1,0)) AS gas_gear_13
		FROM core.members_characters
		WHERE member_allycode IN (
			SELECT member_allycode
			FROM core.members_characters
			WHERE character_id = 'GENERALSKYWALKER'
			AND character_stars = 7
		) 
		AND character_id IN (
			'PADMEAMIDALA','AHSOKATANO','C3POLEGENDARY','SHAAKTI','GENERALKENOBI'
			, 'ASAJVENTRESS','DROIDEKA','B1BATTLEDROIDV2','B2SUPERBATTLEDROID','MAGNAGUARD'
			)
		AND character_stars = 7
		GROUP BY member_allycode
	)
	, result AS (
		SELECT 
			m.member_name
			, m.member_allycode
			, CASE 
				WHEN ewoks_count < 5 THEN 1
				WHEN ewoks_zetas > 2 THEN 0
				WHEN ewoks_zetas = 0 AND ewoks_gear_12 < 3 AND ewoks_core < 5 THEN 1
				WHEN ewoks_zetas = 0 AND ewoks_gear_9 < 4 THEN 1
				ELSE 0
			END AS c3p0_cheat
			, CASE 
				WHEN cls_count < 2 THEN 1
				WHEN cls_zetas > 0 THEN 0
				WHEN cls_gear_9 = 2 THEN 0
				WHEN cls_gear_5 < 2 THEN 1
			ELSE 0
			END AS cls_cheat	
			, CASE 
				WHEN jkr_count < 5 THEN 1
				WHEN jkr_gear_7 < 2 AND jkr_gear_11 < 1 THEN 1
			ELSE 0
			END AS jkr_cheat
			, CASE 
				WHEN dr_count < 5 THEN 1
				WHEN dr_gear_7 < 2 AND jkr_gear_11 < 1 THEN 1
			ELSE 0
			END AS dr_cheat	
			, CASE 
				WHEN padme_count < 5 THEN 1
				WHEN padme_gear_7 < 5 AND padme_gear_11 < 1 THEN 1
			ELSE 0
			END AS padme_cheat
			, CASE 
				WHEN gas_count < 10 THEN 1
				WHEN gas_gear_11 < 10 THEN 1
				WHEN gas_gear_12 < 10 AND gas_gear_13 < 2 THEN 1
			ELSE 0
			END AS gas_cheat
		FROM stage.members m
		LEFT JOIN c3p0 c ON m.member_allycode = c.member_allycode
		LEFT JOIN cls ON m.member_allycode = cls.member_allycode
		LEFT JOIN jkr ON m.member_allycode = jkr.member_allycode
		LEFT JOIN dr ON m.member_allycode = dr.member_allycode
		LEFT JOIN padme ON m.member_allycode = padme.member_allycode
		LEFT JOIN gas ON m.member_allycode = gas.member_allycode
	)
	SELECT 
		member_name, member_allycode
		, fn.is_current(member_allycode) AS current_member
		, c3p0_cheat + cls_cheat + jkr_cheat + dr_cheat + padme_cheat + gas_cheat AS cheat_flag
		, REPLACE(
			IIF(c3p0_cheat = 1, 'C3P0-', '') 
			+ IIF(cls_cheat = 1, 'CLS-', '')
			+ IIF(jkr_cheat = 1, 'JKR-', '')
			+ IIF(dr_cheat = 1, 'DR-', '')
			+ IIF(padme_cheat = 1, 'PADME-', '')
			+ IIF(gas_cheat = 1, 'GAS-', '')
			+ 'OK'
		,'-OK','') AS cheat
	FROM result
GO