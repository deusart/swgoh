USE swgoh
GO

CREATE OR ALTER VIEW history.members_union
AS
	SELECT ROW_NUMBER() OVER (ORDER BY updated_at, member_allycode) as row_id
			, member_name, member_allycode, member_power
			, member_power_characters, member_power_ships
			, member_ligue, member_squad_rank, member_fleet_rank
			, updated_at
	FROM (
		SELECT
			member_name, member_allycode, member_power
			, member_power_characters, member_power_ships
			, member_ligue, member_squad_rank, member_fleet_rank
			, GETUTCDATE() as updated_at
		FROM stage.members
		UNION ALL
		SELECT
			member_name, member_allycode, member_power
			, member_power_characters, member_power_ships
			, member_ligue, member_squad_rank, member_fleet_rank
			, fn.timestamp_date(updated) as updated_at
		FROM history.members
	) src
GO