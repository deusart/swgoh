USE swgoh
GO

CREATE OR ALTER PROCEDURE stage.insert_player	
	@player_allycode bigint
	, @player_name nvarchar(max)
	, @player_power bigint
	, @player_power_characters bigint
	, @player_power_ships bigint
	, @player_ligue nvarchar(max)
	, @player_arena_rank int
	, @player_fleet_rank int
	, @player_characters_count int
	, @player_ships_count int
	, @player_legends_count int	
	, @player_ship_legends_count int NULL
	, @player_relics_count int
	, @player_relic_levels_count int
	, @player_guild nvarchar(max)
	, @updated bigint

AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
				, @player_name, @player_power, @player_power_characters, @player_power_ships
				, @player_ligue, @player_arena_rank, @player_fleet_rank
				, @player_characters_count, @player_ships_count
				, @player_legends_count, @player_ship_legends_count
				, @player_relics_count, @player_relic_levels_count, @player_guild
			)
		)

	IF (SELECT COUNT(*) FROM stage.players WHERE player_allycode = @player_allycode) = 0
	BEGIN
		INSERT INTO stage.players(
			player_allycode, player_name
			, player_power, player_power_characters
			, player_power_ships, player_ligue
			, player_arena_rank, player_fleet_rank	
			, player_characters_count, player_ships_count
			, player_legends_count, player_ship_legends_count
			, player_relics_count, player_relic_levels_count, player_guild
			, updated, hash_diff
		)
		SELECT 	
				@player_allycode, @player_name 
				, @player_power, @player_power_characters, @player_power_ships
				, @player_ligue, @player_arena_rank, @player_fleet_rank
				, @player_characters_count, @player_ships_count
				, @player_legends_count, @player_ship_legends_count
				, @player_relics_count, @player_relic_levels_count, @player_guild
				, @updated, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.players WHERE player_allycode = @player_allycode) <> @hash_diff
		BEGIN
			UPDATE stage.players
			SET player_name = @player_name
				, player_power = @player_power
				, player_power_characters = @player_power_characters
				, player_power_ships = @player_power_ships
				, player_ligue = @player_ligue
				, player_arena_rank = @player_arena_rank
				, player_fleet_rank = @player_fleet_rank
				, player_characters_count = @player_characters_count
				, player_ships_count = @player_ships_count
				, player_legends_count = @player_legends_count
				, player_ship_legends_count = @player_ship_legends_count
				, player_relics_count = @player_relics_count
				, player_relic_levels_count = @player_relic_levels_count
				, player_guild = @player_guild
				, updated = @updated
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE player_allycode = @player_allycode
		END
	END

END