USE hordeby
GO

CREATE OR ALTER PROCEDURE stage.insert_member_character
	@member_allycode bigint
	, @character_id nvarchar(250)		
	, @is_legend bit
	, @character_level int
	, @character_power bigint
	, @character_gear int
	, @character_stars int
	, @character_relic int
	, @character_zetas int
	, @character_omegas int
	, @updated bigint
AS
BEGIN
	IF (
		SELECT COUNT(*) 
		FROM stage.members_characters
		WHERE member_allycode = @member_allycode 
		AND character_id = @character_id
	) = 0
	BEGIN
		INSERT INTO stage.members_characters(
			member_allycode, character_id, is_legend, character_gear
			, character_level, character_power, character_stars
			, character_relic, character_zetas, character_omegas
			, updated 
		)
		SELECT 	
			@member_allycode, @character_id, @is_legend, @character_gear
			, @character_level, @character_power, @character_stars
			, @character_relic, @character_zetas, @character_omegas
			, @updated 
	END
	ELSE 
	BEGIN
		IF (
			SELECT updated 		
			FROM stage.members_characters 
			WHERE member_allycode = @member_allycode 
			AND character_id = @character_id
		) <> @updated
		BEGIN
			UPDATE stage.members_characters
			SET member_allycode = @member_allycode
				, character_id = @character_id
				, is_legend = @is_legend
				, character_gear = @character_gear
				, character_level = @character_level
				, character_power = @character_power
				, character_stars = @character_stars				
				, character_relic = @character_relic
				, character_zetas = @character_zetas
				, character_omegas = @character_omegas
				, updated = @updated
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode 
			AND character_id = @character_id
		END
	END
END
