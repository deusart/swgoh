USE swgoh
GO

CREATE OR ALTER VIEW core.leftovers
AS
	SELECT member_name
		, member_allycode
		, member_power
		, IIF(player_power > member_power, player_power - member_power, 0) AS power_delta
		, player_guild
		, IIF(p.updated_at > m.updated_at, DATEDIFF(DAY, m.updated_at, p.updated_at ), 0) AS days_passed
		, IIF(
			DATEDIFF(DAY, m.updated_at, p.updated_at) > 0,
			ROUND(IIF(player_power > member_power, player_power - member_power, 0)/ DATEDIFF(DAY, m.updated_at, p.updated_at),2)
			, 0) * 30 AS avg_power_progress_month
		, m.member_ligue AS gac_ligue_guild
		, p.player_ligue AS gac_ligue_now
		, p.player_legends_count
		, p.player_ship_legends_count
		, p.player_guild_power
		, p.player_guild_members_count
		, m.updated_at AS last_seen_guild
		, p.updated_at
	FROM [swgoh].[stage].[members] m
	LEFT JOIN swgoh.stage.players p ON m.member_allycode = p.player_allycode
	WHERE Year(m.updated_at) >= 2022 and member_allycode not in (select member_allycode from stage.members_current)
GO