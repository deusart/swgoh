USE swgoh
GO

CREATE OR ALTER VIEW rules.geods
AS
	WITH gds AS (
		SELECT 
			member_allycode
			, ROUND(
				CAST(SUM(IIF(ship_id IN ('CAPITALEXECUTOR','CAPITALMALEVOLENCE'), ship_stars,0)) AS float) / 14
				+ CAST(SUM(IIF(ship_id IN (
					'HYENABOMBER','HOUNDSTOOTH','GEONOSIANSTARFIGHTER2'
					,'GEONOSIANSTARFIGHTER3','GEONOSIANSTARFIGHTER1','VULTUREDROID'
					), ship_stars,0)) AS float) / 21
			, 2) AS geo_score
		FROM swgoh.stage.members_ships
		GROUP BY member_allycode		
		UNION ALL
		SELECT member_allycode, 1 AS geo_score
		FROM swgoh.stage.members_characters
		WHERE character_id IN ('GEONOSIANBROODALPHA','GEONOSIANSOLDIER','GEONOSIANSPY','POGGLETHELESSER','SUNFAC')
		AND character_power >= 16500
		GROUP BY member_allycode
		HAVING count(*) = 5
		UNION ALL		
		SELECT member_allycode, CAST(count(*) AS float)/5 AS geo_score
		FROM swgoh.stage.members_characters
		WHERE character_id IN ('GEONOSIANBROODALPHA','GEONOSIANSOLDIER','GEONOSIANSPY','POGGLETHELESSER','SUNFAC')
		AND character_power >= 20000
		AND member_allycode IN (
			SELECT member_allycode
			FROM swgoh.stage.members_characters
			WHERE character_id IN ('GEONOSIANBROODALPHA','GEONOSIANSOLDIER','GEONOSIANSPY','POGGLETHELESSER','SUNFAC')
			AND character_power >= 16500
		)
		GROUP BY member_allycode
		UNION ALL
		SELECT 
			member_allycode
			, ROUND(
				CAST(count(*) AS float)/9 
				+ SUM(IIF(character_id = 'WATTAMBOR', 1, 0))
				,2) AS geo_score
		FROM swgoh.stage.members_characters
		WHERE character_id IN (
			'GRIEVOUS','NUTEGUNRAY','MAGNAGUARD'
			, 'DROIDEKA','COUNTDOOKU', 'WATTAMBOR'
			, 'ASAJVENTRESS', 'B1BATTLEDROIDV2', 'B2SUPERBATTLEDROID'
			)
		AND character_power >= 16500
		GROUP BY member_allycode
	) 
	SELECT member_allycode, SUM(geo_score) AS geo_score
	FROM gds
	GROUP BY member_allycode
GO