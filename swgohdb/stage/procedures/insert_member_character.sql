USE swgoh
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
	, @gear_slot_01 int NULL
	, @gear_slot_02 int NULL
	, @gear_slot_03 int NULL
    , @gear_slot_04 int NULL
	, @gear_slot_05 int NULL
	, @gear_slot_06 int NULL
	, @updated bigint
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
				, @member_allycode, @character_id, @is_legend, @character_gear
				, @character_level, @character_power, @character_stars
				, @character_relic, @character_zetas, @character_omegas
				, @gear_slot_01, @gear_slot_02, @gear_slot_03
				, @gear_slot_04, @gear_slot_05, @gear_slot_06
				)
		)

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
			, gear_slot_01, gear_slot_02, gear_slot_03
			, gear_slot_04, gear_slot_05, gear_slot_06
			, updated, hash_diff
		)
		SELECT 	
			@member_allycode, @character_id, @is_legend, @character_gear
			, @character_level, @character_power, @character_stars
			, @character_relic, @character_zetas, @character_omegas
			, @gear_slot_01, @gear_slot_02, @gear_slot_03
			, @gear_slot_04, @gear_slot_05, @gear_slot_06
			, @updated, @hash_diff
	END
	ELSE 
	BEGIN
		IF (
			SELECT hash_diff 		
			FROM stage.members_characters 
			WHERE member_allycode = @member_allycode 
			AND character_id = @character_id
		) <> @hash_diff
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
				, gear_slot_01 = @gear_slot_01
				, gear_slot_02 = @gear_slot_02
				, gear_slot_03 = @gear_slot_03
				, gear_slot_04 = @gear_slot_04
				, gear_slot_05 = @gear_slot_05
				, gear_slot_06 = @gear_slot_06
				, updated = @updated
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode 
			AND character_id = @character_id
		END
	END
END
