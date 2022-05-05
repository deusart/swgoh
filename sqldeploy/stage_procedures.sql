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
			, updated
		)
		SELECT 	
			@member_name, @member_allycode, @member_power
			, @member_power_characters, @member_power_ships
			, @updated 
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
				, updated = @updated
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode
		END
	END
END
GO

CREATE OR ALTER PROCEDURE stage.insert_member_ship
	@member_allycode bigint
	, @ship_id nvarchar(250)		
	, @is_legend bit
	, @ship_level int
	, @ship_power bigint
	, @ship_stars int
	, @updated bigint
AS
BEGIN
	IF (
		SELECT COUNT(*) 
		FROM stage.members_ships 
		WHERE member_allycode = @member_allycode 
		AND ship_id = @ship_id
	) = 0
	BEGIN
		INSERT INTO stage.members_ships(
			member_allycode, ship_id, is_legend
			, ship_level, ship_power, ship_stars 
			, updated 
		)
		SELECT 	
			@member_allycode, @ship_id, @is_legend
			, @ship_level, @ship_power, @ship_stars 
			, @updated 
	END
	ELSE 
	BEGIN
		IF (
			SELECT updated 		
			FROM stage.members_ships 
			WHERE member_allycode = @member_allycode 
			AND ship_id = @ship_id
		) <> @updated
		BEGIN
			UPDATE stage.members_ships
			SET member_allycode = @member_allycode
				, ship_id = ship_id
				, is_legend = @is_legend
				, ship_level = @ship_level
				, ship_power = @ship_power
				, ship_stars = @ship_stars
				, updated = @updated
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode 
			AND ship_id = @ship_id
		END
	END
END
GO

CREATE OR ALTER PROCEDURE stage.insert_member_character
	@member_allycode bigint
	, @character_id nvarchar(250)		
	, @is_legend bit
	, @character_level int
	, @character_power bigint
	, @character_stars int
	, @character_relic int
	, @character_zetas int
	, @character_omegas int
	, @updated bigint
AS
BEGIN
	IF (
		SELECT COUNT(*) 
		FROM stage.members_characters
		WHERE member_allycode = @member_allycode 
		AND character_id = @character_id
	) = 0
	BEGIN
		INSERT INTO stage.members_characters(
			member_allycode, character_id, is_legend
			, character_level, character_power, character_stars
			, character_relic, character_zetas, character_omegas
			, updated 
		)
		SELECT 	
			@member_allycode, @character_id, @is_legend
			, @character_level, @character_power, @character_stars
			, @character_relic, @character_zetas, @character_omegas
			, @updated 
	END
	ELSE 
	BEGIN
		IF (
			SELECT updated 		
			FROM stage.members_characters 
			WHERE member_allycode = @member_allycode 
			AND character_id = @character_id
		) <> @updated
		BEGIN
			UPDATE stage.members_characters
			SET member_allycode = @member_allycode
				, character_id = @character_id
				, is_legend = @is_legend
				, character_level = @character_level
				, character_power = @character_power
				, character_stars = @character_stars				
				, character_relic = @character_relic
				, character_zetas = @character_zetas
				, character_omegas = @character_omegas
				, updated = @updated
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode 
			AND character_id = @character_id
		END
	END
END
GO

CREATE OR ALTER PROCEDURE stage.insert_member_character_skill
	@member_allycode bigint
	, @character_id nvarchar(250)
	, @skill_id nvarchar(250)
	, @tier int
	, @tier_max int
	, @is_zeta bit
	, @updated bigint
AS
BEGIN
	IF (
		SELECT COUNT(*) 
		FROM stage.members_characters_skills
		WHERE member_allycode = @member_allycode 
		AND character_id = @character_id
		AND skill_id = @skill_id
	) = 0
	BEGIN
		INSERT INTO stage.members_characters_skills(
			member_allycode, character_id
			, tier, tier_max, is_zeta
			, updated
		)
		SELECT 	
			@member_allycode, @character_id
			, @tier, @tier_max, @is_zeta
			, @updated 
	END
	ELSE 
	BEGIN
		IF (
			SELECT updated 		
			FROM stage.members_characters_skills 
			WHERE member_allycode = @member_allycode 
			AND character_id = @character_id
			AND skill_id = @skill_id
		) <> @updated
		BEGIN
			UPDATE stage.members_characters_skills
			SET member_allycode = @member_allycode
				, character_id = @character_id
				, tier = @tier
				, tier_max = @tier_max
				, is_zeta = @is_zeta
				, updated = @updated
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode
			AND character_id = @character_id
			AND skill_id = @skill_id
		END
	END
END
GO

-- characters
CREATE OR ALTER PROCEDURE stage.insert_character
	@character_id nvarchar(250)
	, @character_name nvarchar(250)
	, @character_url nvarchar(250)
	, @character_image nvarchar(250)
	, @character_power int
	, @character_description nvarchar(250)
	, @character_alignment nvarchar(250)
	, @character_ship nvarchar(250)
	, @character_shards nvarchar(250)
AS
BEGIN	

	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
					, @character_id, @character_name
					, @character_url, @character_image
					, @character_power, @character_description
					, @character_alignment, @character_ship, @character_shards
				)
		)

	IF (SELECT COUNT(*) FROM stage.characters WHERE character_id = @character_id) = 0
	BEGIN
		INSERT INTO stage.characters(
			character_id, character_name
			, character_url, character_image
			, character_power, character_description
			, character_alignment, character_ship
			, character_shards, hash_diff
		)
		SELECT @character_id, @character_name
			, @character_url, @character_image
			, @character_power, @character_description
			, @character_alignment, @character_ship
			, @character_shards, @hash_diff
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
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE character_id = @character_id
		END
	END
END
GO

-- characters_gear
CREATE OR ALTER PROCEDURE stage.insert_character_gear
	@character_id nvarchar(250)
	, @character_tier int
	, @gear_slot_01 nvarchar(250)
	, @gear_slot_02 nvarchar(250)
	, @gear_slot_03 nvarchar(250)
	, @gear_slot_04 nvarchar(250)
	, @gear_slot_05 nvarchar(250)
	, @gear_slot_06 nvarchar(250)
AS
BEGIN	

	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' ,
				@character_id, @character_tier
				, @gear_slot_01, @gear_slot_02
				, @gear_slot_03, @gear_slot_04
				, @gear_slot_05, @gear_slot_06
				)
		)

	IF (SELECT COUNT(*) FROM stage.characters_gear WHERE character_id = @character_id AND character_tier = @character_tier) = 0
	BEGIN
		INSERT INTO stage.characters_gear(
				character_id, character_tier
				, gear_slot_01, gear_slot_02
				, gear_slot_03, gear_slot_04
				, gear_slot_05, gear_slot_06, hash_diff
		)
		SELECT @character_id, @character_tier
				, @gear_slot_01, @gear_slot_02
				, @gear_slot_03, @gear_slot_04
				, @gear_slot_05, @gear_slot_06, @hash_diff
	END
	ELSE 
	BEGIN
		IF (SELECT hash_diff FROM stage.characters_gear WHERE character_id = @character_id AND character_tier = @character_tier) <> @hash_diff
		BEGIN
			UPDATE stage.characters_gear
			SET gear_slot_01 = @gear_slot_01
				, gear_slot_02 = @gear_slot_02
				, gear_slot_03 = @gear_slot_03
				, gear_slot_04 = @gear_slot_04
				, gear_slot_05 = @gear_slot_05
				, gear_slot_06 = @gear_slot_06
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE character_id = @character_id AND character_tier = @character_tier
		END
	END
END
GO

-- gear
CREATE OR ALTER PROCEDURE stage.insert_gear
		@gear_id nvarchar(250)
		, @gear_name nvarchar(250) NULL
		, @gear_tier int
		, @gear_required_level nvarchar(250) NULL
		, @gear_url nvarchar(250) NULL
		, @gear_image nvarchar(250) NULL
		, @gear_cost nvarchar(250) NULL
		, @gear_mark nvarchar(250) NULL
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

-- gear_recipes
CREATE OR ALTER PROCEDURE stage.insert_gear_recipe
		@gear_id nvarchar(250)
		, @gear_part_id nvarchar(250) NULL
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

-- ships
CREATE OR ALTER PROCEDURE stage.insert_ship
	@ship_id nvarchar(250)
	, @ship_name nvarchar(250)
	, @ship_url nvarchar(250)
	, @ship_image nvarchar(250)
	, @ship_power int
	, @ship_description nvarchar(250)
	, @ship_alignment nvarchar(250)
	, @ship_capital_ship nvarchar(250)
	, @ship_shards nvarchar(250)
AS
BEGIN	

	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
					, @ship_id, @ship_name
					, @ship_url, @ship_image
					, @ship_power, @ship_description
					, @ship_alignment, @ship_capital_ship, @ship_shards
				)
		)

	IF (SELECT COUNT(*) FROM stage.ships WHERE ship_id = @ship_id) = 0
	BEGIN
		INSERT INTO stage.ships(
			ship_id, ship_name
			, ship_url, ship_image
			, ship_power, ship_description
			, ship_alignment, ship_capital_ship
			, ship_shards, hash_diff
		)
		SELECT @ship_id, @ship_name
			, @ship_url, @ship_image
			, @ship_power, @ship_description
			, @ship_alignment, @ship_capital_ship
			, @ship_shards, @hash_diff
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
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE ship_id = @ship_id
		END
	END
END
GO