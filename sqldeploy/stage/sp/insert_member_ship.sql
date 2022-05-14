USE hordeby
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
			, updated 
		)
		SELECT 	
			@member_allycode, @ship_id, @is_legend
			, @ship_level, @ship_power, @ship_stars 
			, @updated 
	END
	ELSE 
	BEGIN
		IF (
			SELECT updated 		
			FROM stage.members_ships 
			WHERE member_allycode = @member_allycode 
			AND ship_id = @ship_id
		) <> @updated
		BEGIN
			UPDATE stage.members_ships
			SET member_allycode = @member_allycode
				, ship_id = ship_id
				, is_legend = @is_legend
				, ship_level = @ship_level
				, ship_power = @ship_power
				, ship_stars = @ship_stars
				, updated = @updated
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode 
			AND ship_id = @ship_id
		END
	END
END
GO