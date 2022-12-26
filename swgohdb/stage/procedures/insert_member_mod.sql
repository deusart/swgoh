USE swgoh
GO

CREATE OR ALTER PROCEDURE stage.insert_member_mod
	@member_allycode bigint
	, @character_id nvarchar(250)
	, @mod_id nvarchar(250)
	, @mod_level int NULL
	, @mod_pips int NULL
	, @mod_set int NULL
	, @mod_slot int NULL
	, @mod_primary_stat int NULL
	, @mod_primary_value float NULL		
	, @mod_second_01_stat int NULL
	, @mod_second_01_value float NULL
	, @mod_second_01_roll int NULL
	, @mod_second_02_stat int NULL
	, @mod_second_02_value float NULL
	, @mod_second_02_roll int NULL
	, @mod_second_03_stat int NULL
	, @mod_second_03_value float NULL
	, @mod_second_03_roll int NULL
	, @mod_second_04_stat int NULL
	, @mod_second_04_value float NULL
	, @mod_second_04_roll int NULL
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
				, @member_allycode, @character_id, @mod_id, @mod_level, @mod_pips
				, @mod_set, @mod_slot, @mod_primary_stat, @mod_primary_value
				, @mod_second_01_stat, @mod_second_01_value, @mod_second_01_roll
				, @mod_second_02_stat, @mod_second_02_value, @mod_second_02_roll
				, @mod_second_03_stat, @mod_second_03_value, @mod_second_03_roll
				, @mod_second_04_stat, @mod_second_04_value, @mod_second_04_roll
			)
		)

	IF (
		SELECT COUNT(*) 
		FROM stage.members_mods
		WHERE member_allycode = @member_allycode 
			AND character_id = @character_id
			AND mod_id = @mod_id
	) = 0
	BEGIN
		INSERT INTO stage.members_mods(
			member_allycode, character_id, mod_id, mod_level, mod_pips
			, mod_set, mod_slot, mod_primary_stat, mod_primary_value
			, mod_second_01_stat, mod_second_01_value, mod_second_01_roll
			, mod_second_02_stat, mod_second_02_value, mod_second_02_roll
			, mod_second_03_stat, mod_second_03_value, mod_second_03_roll
			, mod_second_04_stat, mod_second_04_value, mod_second_04_roll
			, hash_diff
		)
		SELECT 	
			@member_allycode, @character_id, @mod_id, @mod_level, @mod_pips
			, @mod_set, @mod_slot, @mod_primary_stat, @mod_primary_value
			, @mod_second_01_stat, @mod_second_01_value, @mod_second_01_roll
			, @mod_second_02_stat, @mod_second_02_value, @mod_second_02_roll
			, @mod_second_03_stat, @mod_second_03_value, @mod_second_03_roll
			, @mod_second_04_stat, @mod_second_04_value, @mod_second_04_roll
			, @hash_diff
	END
	ELSE 
	BEGIN
		IF (
			SELECT hash_diff 		
			FROM stage.members_mods
			WHERE member_allycode = @member_allycode 
				AND character_id = @character_id
				AND mod_id = @mod_id
		) <> @hash_diff
		BEGIN
			UPDATE stage.members_mods
			SET mod_pips = @mod_pips
				, mod_set = @mod_set
				, mod_slot = @mod_slot
				, mod_level = @mod_level
				, mod_primary_stat = @mod_primary_stat
				, mod_primary_value = @mod_primary_value
				, mod_second_01_stat = @mod_second_01_stat
				, mod_second_01_value = @mod_second_01_value
				, mod_second_01_roll = @mod_second_01_roll
				, mod_second_02_stat = @mod_second_02_stat
				, mod_second_02_value = @mod_second_02_value
				, mod_second_02_roll = @mod_second_02_roll
				, mod_second_03_stat = @mod_second_03_stat
				, mod_second_03_value = @mod_second_03_value
				, mod_second_03_roll = @mod_second_03_roll
				, mod_second_04_stat = @mod_second_04_stat
				, mod_second_04_value = @mod_second_04_value
				, mod_second_04_roll = @mod_second_04_roll
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode 
				AND character_id = @character_id
				AND mod_id = @mod_id
		END
	END
END
