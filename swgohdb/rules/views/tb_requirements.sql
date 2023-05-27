USE swgoh
GO

CREATE OR ALTER VIEW rules.tb_requirements
AS
	SELECT tb_article, unit_team, count(member_allycode) AS count_members
	FROM (
		SELECT
			'GDS Fleet' AS tb_article
			, CASE 
				WHEN ship_id IN ('GEONOSIANSTARFIGHTER2','GEONOSIANSTARFIGHTER3','GEONOSIANSTARFIGHTER1') THEN 'Geonosians' 
				WHEN ship_id IN ('CAPITALSTARDESTROYER','CAPITALCHIMAERA') THEN 'Empire'
				WHEN ship_id IN ('CAPITALFINALIZER') THEN 'First Order'
				WHEN ship_id IN ('CAPITALMALEVOLENCE') THEN 'Separatists'
				WHEN ship_id IN ('CAPITALEXECUTOR') THEN 'Executor'
			END AS unit_team
			, member_allycode
			, COUNT(*) AS count_units
		FROM stage.members_ships
		WHERE ship_id  IN (  
		'GEONOSIANSTARFIGHTER2','GEONOSIANSTARFIGHTER3','GEONOSIANSTARFIGHTER1'
		,'CAPITALCHIMAERA','CAPITALEXECUTOR'
		,'CAPITALFINALIZER','CAPITALMALEVOLENCE','CAPITALSTARDESTROYER'
		)
		AND fn.is_current(member_allycode) = 1 AND ship_stars = 7
		GROUP BY 	
			CASE 
				WHEN ship_id IN ('GEONOSIANSTARFIGHTER2','GEONOSIANSTARFIGHTER3','GEONOSIANSTARFIGHTER1') THEN 'Geonosians' 
				WHEN ship_id IN ('CAPITALSTARDESTROYER','CAPITALCHIMAERA') THEN 'Empire'
				WHEN ship_id IN ('CAPITALFINALIZER') THEN 'First Order'
				WHEN ship_id IN ('CAPITALMALEVOLENCE') THEN 'Separatists'
				WHEN ship_id IN ('CAPITALEXECUTOR') THEN 'Executor'
			END, member_allycode
	) src
	WHERE (count_units = 1 AND unit_team <> 'Geonosians') OR (count_units = 3)
	GROUP BY tb_article, unit_team
	UNION ALL
	SELECT
		'GDS Platoons' AS tb_article
		, CONCAT_WS(' ', s.ship_name, CAST(ms.ship_stars AS nvarchar(max))+'*')
		, COUNT(member_allycode) AS count_members
	FROM stage.members_ships ms
	INNER JOIN stage.ships s on ms.ship_id = s.ship_id
	WHERE ms.ship_id IN ('EBONHAWK','EMPERORSSHUTTLE') 
	AND fn.is_current(member_allycode) = 1 AND ship_stars >= 6
	GROUP BY CONCAT_WS(' ', s.ship_name, CAST(ms.ship_stars AS nvarchar(max))+'*')
	UNION ALL	
	SELECT 
		'GDS Platoons' AS tb_article
		, CONCAT_WS(' ', c.character_name, CAST(mc.character_stars AS nvarchar(max))+'*')
		, COUNT(*)
	FROM core.members_characters mc
	INNER JOIN stage.characters c ON c.character_id = mc.character_id
	WHERE mc.character_id IN (
			'DARTHMALAK','DARTHREVAN','BASTILASHANDARK','IMPERIALPROBEDROID'
			)
	AND fn.is_current(member_allycode) = 1 AND character_stars >= 6
	GROUP BY CONCAT_WS(' ', c.character_name, CAST(mc.character_stars AS nvarchar(max))+'*')
	UNION ALL
	SELECT tb_article, teams, SUM(IIF(member_allycode>0,1,0))
	FROM (
		SELECT 'GDS Teams' AS tb_article, 'Geosians(1,2,3)' AS teams, member_allycode
		FROM core.members_characters
		WHERE character_id IN ('GEONOSIANBROODALPHA','GEONOSIANSOLDIER','GEONOSIANSPY','POGGLETHELESSER','SUNFAC') 
		AND fn.is_current(member_allycode) = 1 AND character_stars = 7 AND character_power >= 16500
		GROUP BY member_allycode HAVING COUNT(*) = 5 
		UNION ALL
		SELECT 'GDS Teams' AS tb_article, 'Dooku&Asaj(2)' AS teams, member_allycode
		FROM core.members_characters
		WHERE character_id IN ('COUNTDOOKU','ASAJVENTRESS')
		AND fn.is_current(member_allycode) = 1 AND character_stars = 7 AND character_power >= 16500
		GROUP BY member_allycode  HAVING COUNT(*) = 2 
		UNION ALL
		SELECT 'GDS Teams' AS tb_article, 'Nute Droids(1)' AS teams, member_allycode
		FROM core.members_characters
		WHERE character_id IN ('NUTEGUNRAY','MAGNAGUARD','DROIDEKA','B1BATTLEDROIDV2','B2SUPERBATTLEDROID')
		AND fn.is_current(member_allycode) = 1 AND character_stars>= 6 AND character_power >= 16500
		GROUP BY member_allycode HAVING COUNT(*) = 5 
		UNION ALL
		SELECT 'GDS Teams' AS tb_article, 'Grevous Droids(3)' AS teams, member_allycode
		FROM core.members_characters
		WHERE character_id IN ('GRIEVOUS','MAGNAGUARD','DROIDEKA','B1BATTLEDROIDV2','B2SUPERBATTLEDROID')
		AND fn.is_current(member_allycode) = 1 AND character_stars = 7 AND character_power >= 16500
		GROUP BY member_allycode HAVING COUNT(*) = 5 
		UNION ALL
		SELECT 'GDS Teams' AS tb_article, 'Dooku Separatists(4)' AS teams, member_allycode
		FROM core.members_characters
		WHERE character_id IN ('JANGOFETT','ASAJVENTRESS','GRIEVOUS','MAGNAGUARD','DROIDEKA','B1BATTLEDROIDV2','B2SUPERBATTLEDROID','COUNTDOOKU') 
		AND fn.is_current(member_allycode) = 1 AND character_stars = 7 AND character_power >= 16500
		GROUP BY member_allycode HAVING COUNT(*) = 5 AND SUM(IIF(character_id = 'COUNTDOOKU',1,0))>0
		UNION ALL
		SELECT 'GDS Teams' AS tb_article, 'Wat Separatists(4)' AS teams, member_allycode
		FROM core.members_characters
		WHERE character_id IN ('GEONOSIANBROODALPHA','GEONOSIANSOLDIER','GEONOSIANSPY','POGGLETHELESSER','SUNFAC','WATTAMBOR') 			
		AND fn.is_current(member_allycode) = 1 AND character_stars = 7 AND character_power >= 16500
		GROUP BY member_allycode HAVING COUNT(*) = 5 AND SUM(IIF(character_id = 'WATTAMBOR',1,0))>0
		UNION ALL
		SELECT 'GDS Teams' AS tb_article, 'Wat Separatists(4)' AS teams, 0 AS member_allycode		
	) src
	GROUP BY tb_article, teams

GO