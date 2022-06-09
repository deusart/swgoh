USE swgoh
GO

-- skills
CREATE OR ALTER PROCEDURE stage.insert_skill
	@skill_id nvarchar(max)
	, @character_id nvarchar(max)
	, @skill_name nvarchar(max)
	, @tier_max int
	, @is_zeta bit
	, @is_omega bit
	, @is_omicron bit
	, @omicron_mode int
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||'
				, @skill_id, @character_id, @skill_name, @tier_max
				, @is_zeta, @is_omega, @is_omicron, @omicron_mode
				)
			)

	IF (SELECT COUNT(*) FROM stage.skills WHERE skill_id = @skill_id) = 0
	BEGIN
		INSERT INTO stage.skills(
			skill_id, character_id, skill_name
			, tier_max, is_zeta, is_omega, is_omicron
			, omicron_mode, hash_diff
		)
		SELECT @skill_id, @character_id, @skill_name
			, @tier_max, @is_zeta, @is_omega, @is_omicron
			, @omicron_mode, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.skills WHERE skill_id = @skill_id) <> @hash_diff
		BEGIN
			UPDATE stage.skills
			SET skill_id = @skill_id
				, character_id = @character_id
				, skill_name = @skill_name
				, tier_max = @tier_max
				, is_zeta = @is_zeta
				, is_omega = @is_omega
				, is_omicron = @is_omicron
				, omicron_mode = @omicron_mode
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE skill_id = @skill_id
		END
	END
END
GO