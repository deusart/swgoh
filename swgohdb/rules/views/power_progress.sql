USE swgoh
GO

CREATE OR ALTER VIEW rules.power_progress
AS
	SELECT 
		member_allycode
		, (
			MAX(member_power) -  MIN(member_power))
			/ IIF(DATEDIFF(day, MIN(updated_at), MAX(updated_at)) = 0
				, 1
				, ISNULL(
						DATEDIFF(
							day
							, MIN(updated_at)
							, MAX(updated_at)
						) , 1)
		) * 30 AS avg_monthly_power
	FROM history.members
	GROUP BY member_allycode
GO