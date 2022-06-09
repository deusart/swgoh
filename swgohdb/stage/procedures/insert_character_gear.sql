USE swgoh
GO

-- characters_gear
CREATE OR ALTER PROCEDURE stage.insert_character_gear
	@character_id nvarchar(max)
	, @character_tier int
	, @gear_slot_01 nvarchar(max)
	, @gear_slot_02 nvarchar(max)
	, @gear_slot_03 nvarchar(max)
	, @gear_slot_04 nvarchar(max)
	, @gear_slot_05 nvarchar(max)
	, @gear_slot_06 nvarchar(max)
AS
BEGIN	

	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' ,
				@character_id, @character_tier
				, @gear_slot_01, @gear_slot_02
				, @gear_slot_03, @gear_slot_04
				, @gear_slot_05, @gear_slot_06
				)
		)

	IF (SELECT COUNT(*) FROM stage.characters_gear WHERE character_id = @character_id AND character_tier = @character_tier) = 0
	BEGIN
		INSERT INTO stage.characters_gear(
				character_id, character_tier
				, gear_slot_01, gear_slot_02
				, gear_slot_03, gear_slot_04
				, gear_slot_05, gear_slot_06, hash_diff
		)
		SELECT @character_id, @character_tier
				, @gear_slot_01, @gear_slot_02
				, @gear_slot_03, @gear_slot_04
				, @gear_slot_05, @gear_slot_06, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.characters_gear WHERE character_id = @character_id AND character_tier = @character_tier) <> @hash_diff
		BEGIN
			UPDATE stage.characters_gear
			SET gear_slot_01 = @gear_slot_01
				, gear_slot_02 = @gear_slot_02
				, gear_slot_03 = @gear_slot_03
				, gear_slot_04 = @gear_slot_04
				, gear_slot_05 = @gear_slot_05
				, gear_slot_06 = @gear_slot_06
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE character_id = @character_id AND character_tier = @character_tier
		END
	END
END
GO