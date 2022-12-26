USE swgoh
GO

CREATE OR ALTER PROCEDURE stage.insert_member_gac
	@member_allycode bigint
	, @season_id nvarchar(max)		
	, @event_id nvarchar(max)		
	, @gac_ligue nvarchar(15)
	, @gac_division int
	, @gac_banners int
	, @gac_rank int
	, @gac_end_time bigint
AS
BEGIN
	DECLARE @hash_diff binary(16) = fn.hash_diff(
			CONCAT_WS('||' 
				, @member_allycode, @season_id, @event_id
				, @gac_ligue, @gac_division, @gac_banners 
				, @gac_rank, @gac_end_time
				)
		)

	IF (
		SELECT COUNT(*) 
		FROM stage.members_gac
		WHERE member_allycode = @member_allycode 
		AND season_id = @season_id
	) = 0
	BEGIN
		INSERT INTO stage.members_gac(
			member_allycode, season_id, event_id
			, gac_ligue, gac_division, gac_banners 
			, gac_rank, gac_end_time, hash_diff
		)
		SELECT 	
			@member_allycode, @season_id, @event_id
			, @gac_ligue, @gac_division, @gac_banners 
			, @gac_rank, @gac_end_time, @hash_diff
	END
	ELSE 
	BEGIN
		IF (
			SELECT hash_diff 		
			FROM stage.members_gac 
			WHERE member_allycode = @member_allycode 
			AND season_id = @season_id
		) <> @hash_diff
		BEGIN
			UPDATE stage.members_gac
			SET event_id = @event_id
				, gac_ligue = @gac_ligue
				, gac_division = @gac_division
				, gac_banners = @gac_banners
				, gac_rank = @gac_rank
				, gac_end_time = @gac_end_time
				, hash_diff = @hash_diff
				, updated_at = GETUTCDATE()
			WHERE member_allycode = @member_allycode 
			AND season_id = @season_id
		END
	END
END
GO