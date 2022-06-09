USE swgoh
GO

CREATE OR ALTER VIEW player.power_history
AS
	SELECT 
		log_date
		, member_allycode
		, member_power
		, member_power_characters
		, member_power_ships
	from archive.player
	UNION ALL
	SELECT
		cast(updated_at as date) as log_date
		, member_allycode
		, max(member_power) as member_power
		, max(member_power_characters) as member_power_characters
		, max(member_power_ships) as member_power_ships
	FROM swgoh.history.members
	where member_allycode = fn.player()
	group by member_allycode, cast(updated_at as date)
GO