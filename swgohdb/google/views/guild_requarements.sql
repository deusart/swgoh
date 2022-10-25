USE swgoh
GO

CREATE OR ALTER VIEW google.guild_requirements
AS
	SELECT 
		member_name
		, cast( 
			(
				select max(updated_at) from hordeby.stage.members_characters mc
				where js.member_allycode = mc.member_allycode
			)
			as date
		) as updated_at
		, round(sum(journey_status),2) as check_sum
		, sum(iif(journey_id = 'GR_GEOS', journey_status, 0.0)) as grgeos
		, sum(iif(journey_id = 'GR_TROOPERS', journey_status, 0.0)) as grtroopers
		, sum(iif(journey_id = 'GR_CLONES', journey_status, 0.0)) as grclones
		, sum(iif(journey_id = 'GR_PADME', journey_status, 0.0)) as grpadme
	FROM core.status_journeys js
	WHERE fn.is_current(member_allycode) = 1
	group by js.member_allycode, member_name
GO