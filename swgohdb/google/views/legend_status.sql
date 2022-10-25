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
	, sum(iif(legend_id = 'PROFUNDITY', completion, 0.0)) as glprofundity
	, sum(iif(legend_id = 'JUBBATHEHUTT', completion, 0.0)) as gljabba
FROM core.status_legends ls
GROUP BY ls.member_allycode
GO