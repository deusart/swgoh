USE swgoh
GO

CREATE OR ALTER VIEW archive.player
AS
	SELECT 
	cast(last_updated as date) as log_date
		, user_allycode as member_allycode
		, max(user_gp) as member_power
		, max(user_cgp) as member_power_characters
		, max(user_sgp) as member_power_ships
	FROM [swgoh_previous].[stage].[guild_log]
	where user_nickname = 'DeusArt'
	group by cast(last_updated as date), user_allycode
GO