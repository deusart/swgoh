USE swgoh
GO

CREATE OR ALTER PROCEDURE stage.insert_member_ship
	@member_allycode bigint
	, @ship_id nvarchar(250)		
	, @is_legend bit
	, @ship_level int
	, @ship_power bigint
	, @ship_stars int
	, @updated bigint
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
				, @member_allycode, @ship_id, @is_legend
				, @ship_level, @ship_power, @ship_stars 
				)
		)

	IF (
		SELECT COUNT(*) 
		FROM stage.members_ships 
		WHERE member_allycode = @member_allycode 
		AND ship_id = @ship_id
	) = 0
	BEGIN
		INSERT INTO stage.members_ships(
			member_allycode, ship_id, is_legend
			, ship_level, ship_power, ship_stars 
			, updated, hash_diff
		)
		SELECT 	
			@member_allycode, @ship_id, @is_legend
			, @ship_level, @ship_power, @ship_stars 
			, @updated, @hash_diff
	END
	ELSE 
	BEGIN
		IF (
			SELECT hash_diff 		
			FROM stage.members_ships 
			WHERE member_allycode = @member_allycode 
			AND ship_id = @ship_id
		) <> @hash_diff
		BEGIN
			UPDATE stage.members_ships
			SET member_allycode = @member_allycode
				, ship_id = ship_id
				, is_legend = @is_legend
				, ship_level = @ship_level
				, ship_power = @ship_power
				, ship_stars = @ship_stars
				, updated = @updated
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode 
			AND ship_id = @ship_id
		END
	END
END
GO