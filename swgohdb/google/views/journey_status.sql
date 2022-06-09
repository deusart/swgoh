USE swgoh
GO

CREATE OR ALTER VIEW [google].[journey_status]
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
	, sum(iif(journey_id = 'GRANDMASTERYODA', journey_status, 0.0)) as jlyoda
	, sum(iif(journey_id = 'EMPERORPALPATINE', journey_status, 0.0)) as jlemperor
	, sum(iif(journey_id = 'GRANDADMIRALTHRAWN', journey_status, 0.0)) as jlthrawn
	, sum(iif(journey_id = 'R2D2_LEGENDARY', journey_status, 0.0)) as jlr2d2
	, sum(iif(journey_id = 'BB8', journey_status, 0.0)) as jlbb8
	, sum(iif(journey_id = 'PADMEAMIDALA', journey_status, 0.0)) as jlpadme
	, sum(iif(journey_id = 'COMMANDERLUKESKYWALKER', journey_status, 0.0)) as jlcls
	, sum(iif(journey_id = 'REYJEDITRAINING', journey_status, 0.0)) as jlrey
	, sum(iif(journey_id = 'THEMANDALORIANBESKARARMOR', journey_status, 0.0)) as jlmando

	, sum(iif(journey_id = 'CAPITALCHIMAERA', journey_status, 0.0)) as jlchimera

	, sum(iif(journey_id = 'JEDIKNIGHTREVAN', journey_status, 0.0)) as jljkrevan
	, sum(iif(journey_id = 'DARTHREVAN', journey_status, 0.0)) as jldrevan
	, sum(iif(journey_id = 'C3POLEGENDARY', journey_status, 0.0)) as jlc3p0
	, sum(iif(journey_id = 'CHEWBACCALEGENDARY', journey_status, 0.0)) as jlchewbacca
	, sum(iif(journey_id = 'MILLENNIUMFALCON', journey_status, 0.0)) as jlfalcon

	, sum(iif(journey_id = 'STARKILLER', journey_status, 0.0)) as jlstarkiller
	, sum(iif(journey_id = 'DARTHMALAK', journey_status, 0.0)) as jlmalak
	, sum(iif(journey_id = 'JEDIKNIGHTLUKE', journey_status, 0.0)) as jljediluke
	, sum(iif(journey_id = 'GENERALSKYWALKER', journey_status, 0.0)) as jlgas

FROM hordeby.analise.journey_status js
INNER JOIN stage.members_current mc on mc.member_allycode = js.member_allycode
where js.member_allycode > 0
group by js.member_allycode, member_name
GO