USE swgoh
GO

-- insert_guild
CREATE OR ALTER PROCEDURE stage.insert_guild
	@guild_string nvarchar(max)
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(@guild_string)

	DECLARE @guild_name nvarchar(max)
	DECLARE @guild_members int
	DECLARE @guild_power bigint

	DROP TABLE IF EXISTS #guild
	SELECT trim(value) AS str_data, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS row_num
	INTO #guild
	FROM string_split(@guild_string, '·')

	SET @guild_name = (SELECT str_data FROM #guild WHERE row_num=1)
	SET @guild_members = (SELECT TRIM(REPLACE(str_data,'Members','')) FROM #guild WHERE row_num=3)
	SET @guild_power = (
		SELECT 
			TRIM(
				REPLACE(
					REPLACE(
						SUBSTRING(
							str_data
							, CHARINDEX('GP', str_data)-12
							, 15
						)
						, 'GP'
						, ''
					)
					, ','
					, ''
				)	
			) 
		FROM #guild WHERE row_num=2
	)

	INSERT INTO stage.guilds(
		guild_name, guild_members, guild_power, guild_string, hash_diff
	)
	SELECT @guild_name, @guild_members, @guild_power, @guild_string, @hash_diff


	--IF (SELECT COUNT(*) FROM stage.guilds WHERE guild_name = @guild_name) = 0
	--BEGIN
	--	INSERT INTO stage.characters(
	--		character_id, character_name
	--		, character_url, character_image
	--		, character_power, character_description
	--		, character_alignment, character_ship
	--		, character_shards, character_tags, hash_diff
	--	)
	--	SELECT @character_id, @character_name
	--		, @character_url, @character_image
	--		, @character_power, @character_description
	--		, @character_alignment, @character_ship
	--		, @character_shards, @character_tags, @hash_diff
	--END
	--ELSE 
	--BEGIN
	--	IF (SELECT hash_diff FROM stage.characters WHERE character_id = @character_id) <> @hash_diff
	--	BEGIN
	--		UPDATE stage.characters
	--		SET character_id = @character_id
	--			, character_name = @character_name
	--			, character_url = @character_url
	--			, character_image = @character_image
	--			, character_power = @character_power
	--			, character_description = @character_description
	--			, character_alignment = @character_alignment
	--			, character_ship = @character_ship
	--			, character_shards = @character_shards
	--			, character_tags = @character_tags
	--			, hash_diff = @hash_diff
	--			, updated_at = GETUTCDATE()
	--		WHERE character_id = @character_id
	--	END
	--END
END
GO