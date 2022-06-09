USE swgoh
GO

CREATE OR ALTER PROCEDURE stage.insert_opponent
	@opponent_allycode bigint
	, @opponent_name nvarchar(250)		
	, @opponent_power bigint
	, @opponent_ligue nvarchar(250)		
	, @updated bigint
AS
BEGIN
	IF (
		SELECT COUNT(*) 
		FROM stage.opponents
		WHERE opponent_allycode = @opponent_allycode 
	) = 0
	BEGIN
		INSERT INTO stage.opponents(
			opponent_allycode, opponent_name
			, opponent_power, opponent_ligue, updated 
		)
		SELECT @opponent_allycode, @opponent_name
		, @opponent_power, @opponent_ligue, @updated 
	END
	ELSE 
	BEGIN
		IF (
			SELECT updated 		
			FROM stage.opponents
			WHERE opponent_allycode = @opponent_allycode 
		) <> @updated
		BEGIN
			UPDATE stage.opponents
			SET opponent_allycode = @opponent_allycode
				, opponent_name = @opponent_name
				, opponent_power = @opponent_power
				, opponent_ligue = @opponent_ligue
				, updated = @updated
				, updated_at = GETUTCDATE()
			WHERE opponent_allycode = @opponent_allycode 
		END
	END
END
