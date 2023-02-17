USE swgoh
GO

CREATE OR ALTER VIEW rules.tb_shards
AS
	SELECT 'WATTAMBOR' AS character_id, COUNT(DISTINCT member_allycode) AS shards
	FROM (
		SELECT member_allycode
		FROM core.members_characters
		WHERE character_id IN ('GEONOSIANBROODALPHA','GEONOSIANSOLDIER','GEONOSIANSPY','POGGLETHELESSER','SUNFAC')
		AND fn.is_current(member_allycode) = 1 AND character_stars = 7 AND character_power >= 16500
		GROUP BY member_allycode
		HAVING count(*) = 5
	) src
	UNION ALL
	SELECT 'ROLO', COUNT(DISTINCT member_allycode) AS shards
	FROM core.members_characters
	WHERE character_id  like '%HOTHREBELSOLDIER%'
	AND fn.is_current(member_allycode) = 1 AND character_stars >= 5
	GROUP BY character_id
	UNION ALL
	SELECT 'KAM', COUNT(DISTINCT member_allycode) AS shards
	FROM (
		SELECT member_allycode
		FROM core.members_characters
		WHERE character_id IN (
				'SHAAKTI','ARCTROOPER501ST','CT210408','CT5555','CT7567'
				,'BADBATCHECHO','BADBATCHHUNTER','BADBATCHOMEGA','BADBATCHTECH','BADBATCHWRECKER'
				)
		AND fn.is_current(member_allycode) = 1 AND character_stars = 7 AND character_power >= 22000
		GROUP BY member_allycode
		HAVING count(*) >= 5
	) src
GO