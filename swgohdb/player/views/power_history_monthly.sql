USE swgoh
GO

CREATE OR ALTER VIEW player.power_history_monthly
AS
	WITH cte AS (
		SELECT 
			year(log_date)*100+month(log_date) as log_key
			, datediff(day,min(log_date), max(log_date)) as count_days
			, max(member_power) AS member_power
			, max(member_power_characters) AS member_power_characters
			, max(member_power_ships) AS member_power_ships
		FROM [swgoh].[player].[power_history]
		GROUP BY year(log_date)*100+month(log_date)
	)
	SELECT 
	log_key
	, member_power - lag(member_power) OVER (ORDER BY log_key) as delta_power
	,(member_power - lag(member_power) OVER (ORDER BY log_key))/count_days as daily_power
	FROM cte;
GO