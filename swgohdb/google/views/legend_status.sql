USE swgoh
GO

CREATE OR ALTER VIEW google.legend_status
AS
SELECT 
	member_allycode
	, fn.member_name(member_allycode) AS member_name
	, fn.member_update(member_allycode) AS updated_at
	, round(sum(completion),2) as check_sum
	, sum(iif(legend_id = 'SUPREMELEADERKYLOREN', completion, 0.0)) as glkylo
	, sum(iif(legend_id = 'SITHPALPATINE', completion, 0.0)) as glsse
	, sum(iif(legend_id = 'GLREY', completion, 0.0)) as glrey
	, sum(iif(legend_id = 'JEDIMASTERKENOBI', completion, 0.0)) as glkenobi
	, sum(iif(legend_id = 'LORDVADER', completion, 0.0)) as glvader
	, sum(iif(legend_id = 'GRANDMASTERLUKE', completion, 0.0)) as glluke
	, sum(iif(legend_id = 'CAPITALEXECUTOR', completion, 0.0)) as glexecutor
FROM core.status_legends ls
WHERE fn.is_current(member_allycode) = 1
group by ls.member_allycode
GO