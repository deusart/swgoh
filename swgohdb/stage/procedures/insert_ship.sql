USE swgoh
GO

-- ships
CREATE OR ALTER PROCEDURE stage.insert_ship
	@ship_id nvarchar(max)
	, @ship_name nvarchar(max)
	, @ship_url nvarchar(max)
	, @ship_image nvarchar(max)
	, @ship_power int
	, @ship_description nvarchar(max)
	, @ship_alignment nvarchar(max)
	, @ship_capital_ship bit
	, @ship_shards int
	, @ship_tags nvarchar(max) = ''
AS
BEGIN	

	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
					, @ship_id, @ship_name
					, @ship_url, @ship_image
					, @ship_power, @ship_description
					, @ship_alignment, @ship_capital_ship
					, @ship_shards, @ship_tags
				)
		)

	IF (SELECT COUNT(*) FROM stage.ships WHERE ship_id = @ship_id) = 0
	BEGIN
		INSERT INTO stage.ships(
			ship_id, ship_name
			, ship_url, ship_image
			, ship_power, ship_description
			, ship_alignment, ship_capital_ship
			, ship_shards, ship_tags, hash_diff
		)
		SELECT @ship_id, @ship_name
			, @ship_url, @ship_image
			, @ship_power, @ship_description
			, @ship_alignment, @ship_capital_ship
			, @ship_shards, @ship_tags, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.ships WHERE ship_id = @ship_id) <> @hash_diff
		BEGIN
			UPDATE stage.ships
			SET ship_id = @ship_id
				, ship_name = @ship_name
				, ship_url = @ship_url
				, ship_image = @ship_image
				, ship_power = @ship_power
				, ship_description = @ship_description
				, ship_alignment = @ship_alignment
				, ship_capital_ship = @ship_capital_ship
				, ship_shards = @ship_shards
				, ship_tags = @ship_tags
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE ship_id = @ship_id
		END
	END
END
GO