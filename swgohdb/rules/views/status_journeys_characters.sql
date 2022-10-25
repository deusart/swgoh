USE swgoh
GO

CREATE OR ALTER VIEW rules.status_journeys_characters
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
				, mc.member_allycode
				, COALESCE(c.character_id, jr.unit_id) as unit_id
				, jr.row_id as journey_key
				, ROW_NUMBER() OVER (
					PARTITION BY mc.member_allycode, jr.row_id 
					ORDER BY mc.character_stars desc, mc.character_power desc
					) as row_num
				, jr.units_total
				, fn.legend_stars(mc.character_stars, 7) AS stars_status
				, IIF(
					jr.req_power > mc.character_power
					, mc.character_power/jr.req_power
					, 1
				) AS power_status
				, IIF(
					jr.req_relic > 0
					, COALESCE(fn.legend_relic(mc.character_relic, jr.req_relic), 0)
					, 0
				) as relic_status
				, IIF(
					jr.req_relic > 0
					, fn.legend_gear(mc.character_gear)
					, 0
				) as gear_status
				, jr.unit_rarity
				, IIF(jr.req_relic > 0, 2, 0) + 2  AS total_status
			FROM input.journey_requirements jr
			INNER JOIN stage.characters c ON CHARINDEX( jr.unit_tag, c.character_tags) > 0
			INNER JOIN stage.members_characters mc ON mc.character_id = c.character_id
			WHERE jr.unit_type = 'unit'
				and c.character_id not in (
					SELECT distinct unit_id 
					FROM input.journey_requirements
					WHERE journey_id = jr.journey_id
				)
		) src
		WHERE row_num <= units_total
		union all
		SELECT * FROM (
			SELECT 
				jr.journey_id
				, mc.member_allycode
				, jr.unit_id
				, jr.row_id as journey_key
				, ROW_NUMBER() OVER (
					PARTITION BY mc.member_allycode, jr.is_option, jr.journey_id  
					ORDER BY mc.character_stars desc, mc.character_power desc
					) as row_num
				, iif( is_option > 0, jr.units_total, 1000) as units_total
				, fn.legend_stars(mc.character_stars, 7) AS stars_status
				, IIF(
					jr.req_power > mc.character_power
					, mc.character_power/jr.req_power
					, 1
				) AS power_status
				, IIF(
					jr.req_relic > 0
					, COALESCE(fn.legend_relic(mc.character_relic, jr.req_relic), 0)
					, 0
				) as relic_status
				, IIF(
					jr.req_relic > 0
					, fn.legend_gear(mc.character_gear)
					, 0
				) as gear_status
				, jr.unit_rarity
				, IIF(jr.req_relic > 0, 2, 0) + 2  AS total_status
			FROM input.journey_requirements jr
			INNER JOIN stage.members_characters mc ON mc.character_id = jr.unit_id
			WHERE jr.unit_type = 'special_unit'
		) src
		WHERE row_num <= units_total	
	) src
GO


