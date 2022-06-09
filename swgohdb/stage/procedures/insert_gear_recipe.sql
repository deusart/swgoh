USE swgoh
GO

-- gear_recipes
CREATE OR ALTER PROCEDURE stage.insert_gear_recipe
	@gear_id nvarchar(max)
	, @gear_part_id nvarchar(max) NULL
	, @amount int		
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(CONCAT_WS('||' , @gear_id, @gear_part_id, @amount))

	IF (SELECT COUNT(*) FROM stage.gear_recipes WHERE gear_id = @gear_id AND gear_part_id = @gear_part_id) = 0
	BEGIN
		INSERT INTO stage.gear_recipes(
				gear_id, gear_part_id
				, amount, hash_diff
		)
		SELECT 	@gear_id, @gear_part_id
				, @amount, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.gear_recipes WHERE gear_id = @gear_id AND gear_part_id = @gear_part_id) <> @hash_diff
		BEGIN
			UPDATE stage.gear_recipes
			SET amount = @amount
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE gear_id = @gear_id AND gear_part_id = @gear_part_id
		END
	END
END
GO