USE swgoh
GO

-- gear
CREATE OR ALTER PROCEDURE stage.insert_gear
	@gear_id nvarchar(max)
	, @gear_name nvarchar(max) NULL
	, @gear_tier int
	, @gear_required_level int NULL
	, @gear_url nvarchar(max) NULL
	, @gear_image nvarchar(max) NULL
	, @gear_cost int NULL
	, @gear_mark nvarchar(max) NULL
AS
BEGIN	
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' ,
				@gear_id, @gear_name
				, @gear_tier, @gear_required_level
				, @gear_url, @gear_image
				, @gear_cost, @gear_mark
				)
		)

	IF (SELECT COUNT(*) FROM stage.gear WHERE gear_id = @gear_id) = 0
	BEGIN
		INSERT INTO stage.gear(
				gear_id, gear_name
				, gear_tier, gear_required_level
				, gear_url, gear_image
				, gear_cost, gear_mark, hash_diff
		)
		SELECT 	@gear_id, @gear_name
				, @gear_tier, @gear_required_level
				, @gear_url, @gear_image
				, @gear_cost, @gear_mark, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.gear WHERE gear_id = @gear_id) <> @hash_diff
		BEGIN
			UPDATE stage.gear
			SET gear_name = @gear_name
				, gear_tier = @gear_tier
				, gear_required_level = @gear_required_level
				, gear_url = @gear_url
				, gear_image = @gear_image
				, gear_cost = @gear_cost
				, gear_mark = @gear_mark
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE gear_id = @gear_id
		END
	END
END
GO