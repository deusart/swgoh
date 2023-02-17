USE swgoh
GO

CREATE OR ALTER PROCEDURE stage.insert_member_swgohgg
	@member_allycode bigint
	, @skillrating bigint	
	, @datacrons_0 int
	, @datacrons_1 int
	, @datacrons_2 int
	, @datacrons_3 int
	, @datacrons_4 int
	, @datacrons_5 int
	, @datacrons_6 int
	, @datacrons_7 int
	, @datacrons_8 int
	, @datacrons_9 int	
	, @last_updated datetime
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
					, @skillrating, @datacrons_0, @datacrons_1, @datacrons_2
					, @datacrons_3, @datacrons_4, @datacrons_5, @datacrons_6
					, @datacrons_7, @datacrons_8, @datacrons_9	
				)
		)

	IF (SELECT COUNT(*) FROM stage.members_swgohgg WHERE member_allycode = @member_allycode) = 0
	BEGIN
		INSERT INTO stage.members_swgohgg(
			member_allycode
			, member_skillrating, datacrons_0, datacrons_1, datacrons_2
			, datacrons_3, datacrons_4, datacrons_5, datacrons_6
			, datacrons_7, datacrons_8, datacrons_9	
			, last_updated, hash_diff
		)
		SELECT 	
			@member_allycode 					
			, @skillrating, @datacrons_0, @datacrons_1, @datacrons_2
			, @datacrons_3, @datacrons_4, @datacrons_5, @datacrons_6
			, @datacrons_7, @datacrons_8, @datacrons_9	
			, @last_updated, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.members_swgohgg WHERE member_allycode = @member_allycode) <> @hash_diff
		BEGIN
			UPDATE stage.members_swgohgg
			SET 
				member_skillrating = @skillrating
				, datacrons_0 = @datacrons_0
				, datacrons_1 = @datacrons_1
				, datacrons_2 = @datacrons_2
				, datacrons_3 = @datacrons_3
				, datacrons_4 = @datacrons_4
				, datacrons_5 = @datacrons_5
				, datacrons_6 = @datacrons_6
				, datacrons_7 = @datacrons_7
				, datacrons_8 = @datacrons_8
				, datacrons_9 = @datacrons_9
				, last_updated = @last_updated
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode
		END
	END

END