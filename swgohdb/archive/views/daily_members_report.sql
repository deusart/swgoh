USE swgoh
GO

CREATE OR ALTER VIEW archive.daily_members_report
AS
	SELECT 
		COALESCE(en.member_allycode, st.member_allycode) AS member_allycode
		, en.member_name
		, st.log_date AS log_date_start, en.log_date AS log_date_end
		, (en.member_power - st.member_power) AS delta_power
		, (en.member_power_characters - st.member_power_characters) AS member_power_characters
		, (en.member_power_ships - st.member_power_ships) AS member_power_ships
		, (en.member_legends - st.member_legends) AS member_legends
		, (en.member_relics - st.member_relics) AS member_relics
		, (en.member_relic_levels - st.member_relic_levels) AS member_relic_levels
		, (en.member_zetas - st.member_zetas) AS member_zetas
		, (en.member_omicrons - st.member_omicrons) AS member_omicrons
		, (en.member_characters - st.member_characters) AS member_characters
		, (en.member_ships - st.member_ships) AS member_ships
		, (en.member_characters_g12 - st.member_characters_g12) AS member_characters_g12
		, st.member_fleet_rank - en.member_fleet_rank AS member_fleet_rank_changes
		, st.member_arena_rank - en.member_arena_rank AS member_arena_rank_changes
		, st.member_ligue AS member_ligue_start
		, en.member_ligue AS member_ligue_end
	FROM (
		SELECT dm.* 
		FROM archive.daily_members dm
		INNER JOIN (
			SELECT member_allycode, MIN(log_date) AS log_date
			FROM archive.daily_members
			GROUP BY member_allycode
		) dmmin ON dm.log_date = dmmin.log_date AND dm.member_allycode = dmmin.member_allycode
	) AS st
	INNER JOIN (
		SELECT dm.* 
		FROM archive.daily_members dm
		INNER JOIN (
			SELECT member_allycode, MAX(log_date) AS log_date
			FROM archive.daily_members
			GROUP BY member_allycode
		) dmmax ON dm.log_date = dmmax.log_date AND dm.member_allycode = dmmax.member_allycode
	) en ON st.member_allycode = en.member_allycode
	WHERE en.member_allycode IN (SELECT member_allycode FROM stage.members_current)
GO