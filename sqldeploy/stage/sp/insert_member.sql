USE hordeby
GO

CREATE OR ALTER PROCEDURE stage.insert_member
	@member_name nvarchar(250)
	, @member_allycode bigint
	, @member_power bigint
	, @member_power_characters bigint
	, @member_power_ships bigint
	, @updated bigint
AS
BEGIN
	IF (SELECT COUNT(*) FROM stage.members WHERE member_allycode = @member_allycode) = 0
	BEGIN
		INSERT INTO stage.members(
			member_name, member_allycode, member_power
			, member_power_characters, member_power_ships
			, member_current, updated
		)
		SELECT 	
			@member_name, @member_allycode, @member_power
			, @member_power_characters, @member_power_ships
			, 1, @updated 
	END
	ELSE 
	BEGIN
		IF (SELECT updated FROM stage.members WHERE member_allycode = @member_allycode) <> @updated
		BEGIN
			UPDATE stage.members
			SET member_name = @member_name
				, member_allycode = @member_allycode
				, member_power = @member_power
				, member_power_characters = @member_power_characters
				, member_power_ships = @member_power_ships
				, member_current = 1
				, updated = @updated
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode
		END
	END
END