USE swgoh
GO

-- characters
CREATE OR ALTER PROCEDURE stage.insert_character
	@character_id nvarchar(max)
	, @character_name nvarchar(max)
	, @character_url nvarchar(max)
	, @character_image nvarchar(max)
	, @character_power int
	, @character_description nvarchar(max)
	, @character_alignment nvarchar(max)
	, @character_ship nvarchar(max)
	, @character_shards int
	, @character_tags nvarchar(max) = ''
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
					, @character_id, @character_name
					, @character_url, @character_image
					, @character_power, @character_description
					, @character_alignment, @character_ship, @character_shards
					, @character_tags
				)
		)

	IF (SELECT COUNT(*) FROM stage.characters WHERE character_id = @character_id) = 0
	BEGIN
		INSERT INTO stage.characters(
			character_id, character_name
			, character_url, character_image
			, character_power, character_description
			, character_alignment, character_ship
			, character_shards, character_tags, hash_diff
		)
		SELECT @character_id, @character_name
			, @character_url, @character_image
			, @character_power, @character_description
			, @character_alignment, @character_ship
			, @character_shards, @character_tags, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.characters WHERE character_id = @character_id) <> @hash_diff
		BEGIN
			UPDATE stage.characters
			SET character_id = @character_id
				, character_name = @character_name
				, character_url = @character_url
				, character_image = @character_image
				, character_power = @character_power
				, character_description = @character_description
				, character_alignment = @character_alignment
				, character_ship = @character_ship
				, character_shards = @character_shards
				, character_tags = @character_tags
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE character_id = @character_id
		END
	END
END
GO