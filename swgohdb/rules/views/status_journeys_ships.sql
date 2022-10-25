USE swgoh
GO

CREATE OR ALTER VIEW rules.status_journeys_ships
AS	
	SELECT
		journey_id
		, member_allycode
		, unit_id
		, journey_key
		, stars_status
		, power_status
		, relic_status
		, gear_status
		, total_status
		, unit_rarity
	FROM (
		SELECT * FROM (		
			SELECT 
				jr.journey_id
				, ms.member_allycode
				, s.ship_id AS unit_id
				, jr.row_id AS journey_key
				, ROW_NUMBER() OVER (
					PARTITION BY ms.member_allycode, jr.row_id 
					ORDER BY ms.ship_stars desc, ms.ship_power desc
					) AS row_num
				, jr.units_total
				, fn.legend_stars(ms.ship_stars, 7) AS stars_status
				, IIF(
					jr.req_power > ms.ship_power
					, ms.ship_power/jr.req_power
					, 1
				) AS power_status
				, 0 AS relic_status
				, 0 gear_status
				, jr.unit_rarity
				, 2  AS total_status
			FROM input.journey_requirements jr
			INNER JOIN stage.ships s 
				ON CHARINDEX(jr.unit_tag, s.ship_tags) > 0 
				and CHARINDEX( '|Capital ship|', s.ship_tags) = 0			
			INNER JOIN stage.members_ships ms ON ms.ship_id = s.ship_id
			WHERE jr.unit_type = 'ship'	
				and s.ship_id not in (
					SELECT distinct unit_id 
					FROM input.journey_requirements
					WHERE journey_id = jr.journey_id
				)
		) src
		WHERE row_num <= units_total
		UNION ALL
		SELECT * FROM (		
			SELECT 
				jr.journey_id
				, ms.member_allycode
				, s.ship_id AS unit_id
				, jr.row_id AS journey_key
				, ROW_NUMBER() OVER (
					PARTITION BY ms.member_allycode, jr.row_id 
					ORDER BY ms.ship_stars desc, ms.ship_power desc
					) AS row_num
				, jr.units_total
				, fn.legend_stars(ms.ship_stars, 7) AS stars_status
				, IIF(
					jr.req_power > ms.ship_power
					, ms.ship_power/jr.req_power
					, 1
				) AS power_status
				, 0 AS relic_status
				, 0 gear_status
				, jr.unit_rarity
				, 2  AS total_status
			FROM input.journey_requirements jr
			INNER JOIN stage.ships s ON CHARINDEX( jr.unit_tag, s.ship_tags) > 0
			INNER JOIN stage.members_ships ms ON ms.ship_id = s.ship_id
			WHERE jr.unit_type = 'capital_ship' and CHARINDEX( '|Capital ship|', s.ship_tags) > 0
		) src
		WHERE row_num = 1
		UNION ALL
		SELECT * FROM (
			SELECT
				jr.journey_id
				, ms.member_allycode
				, jr.unit_id
				, jr.row_id AS journey_key
				, ROW_NUMBER() OVER (
					PARTITION BY ms.member_allycode, jr.is_option, jr.journey_id
					ORDER BY ms.ship_stars desc, ms.ship_power desc
					) AS row_num
				, IIF(is_option = 1, jr.units_total, 1000) AS units_total
				, fn.legend_stars(ms.ship_stars, 7) AS stars_status
				, IIF(
					jr.req_power > ms.ship_power
					, ms.ship_power/jr.req_power
					, 1
				) AS power_status
				, 0 AS relic_status
				, 0 gear_status
				, jr.unit_rarity
				, 2  AS total_status
			FROM input.journey_requirements jr
			INNER JOIN stage.members_ships ms ON ms.ship_id = jr.unit_id
			WHERE jr.unit_type = 'special_ship'
		) src
		WHERE row_num <= units_total	
	) src
GO


