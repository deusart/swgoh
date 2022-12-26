USE swgoh
GO

CREATE OR ALTER PROCEDURE stage.insert_member
	@member_name nvarchar(max)
	, @member_allycode bigint
	, @member_power bigint
	, @member_power_characters bigint
	, @member_power_ships bigint
	, @member_ligue nvarchar(max)
	, @member_squad_rank int
	, @member_fleet_rank int
	, @updated bigint
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
					, @member_name, @member_allycode, @member_power
					, @member_power_characters, @member_power_ships
					, @member_ligue, @member_squad_rank, @member_fleet_rank
				)
		)

	IF (SELECT COUNT(*) FROM stage.members WHERE member_allycode = @member_allycode) = 0
	BEGIN
		INSERT INTO stage.members(
			member_name, member_allycode, member_power
			, member_power_characters, member_power_ships
			, member_current, member_ligue, member_squad_rank, member_fleet_rank
			, updated, hash_diff
		)
		SELECT 	
			@member_name, @member_allycode, @member_power
			, @member_power_characters, @member_power_ships
			, 1, @member_ligue, @member_squad_rank, @member_fleet_rank
			, @updated, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.members WHERE member_allycode = @member_allycode) <> @hash_diff
		BEGIN
			UPDATE stage.members
			SET member_name = @member_name
				, member_allycode = @member_allycode
				, member_power = @member_power
				, member_power_characters = @member_power_characters
				, member_power_ships = @member_power_ships
				, member_ligue = @member_ligue
				, member_squad_rank = @member_squad_rank
				, member_fleet_rank = @member_fleet_rank
				, member_current = 1
				, updated = @updated
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode
		END
	END

	INSERT INTO input.guild_tickets_input(user_nickname, tickets)
	SELECT distinct member_name, 0
	FROM stage.members
	WHERE member_name not in (select distinct user_nickname from input.guild_tickets_input) 
	AND member_name IN (SELECT fn.member_name(member_allycode) FROM stage.members_current)
END