USE swgoh
GO

CREATE OR ALTER VIEW google.gvg_rosters
AS
	SELECT 
		mrs.track
		, CASE 
			WHEN 
				mrs.units_power > ors.units_power
			THEN
				'Мы сильнее'
			WHEN 
				mrs.units_power < ors.units_power
			THEN
				'Мы слабее'
			ELSE
				'Равны'
		END AS analitics
		, mrs.units_count AS guild_units_count
		, mrs.units_power AS guild_units_power
		, ors.units_count AS enemy_units_count
		, ors.units_power AS enemy_units_power
		, mrs.units_count - ors.units_count AS delat_count
		, mrs.units_power - ors.units_power AS delat_power
	FROM hordeby.analise.members_roster mrs
	INNER JOIN hordeby.analise.opponents_roster ors
	ON mrs.track=ors.track
GO