USE swgoh
GO

CREATE OR ALTER VIEW google.tickets_history
AS
	SELECT top 100 percent
			member_name, [202112], [202201], [202202]
			, [202203], [202204], [202205]
			, [202206], [202207], [202208]
			, [202209], [202210], [202211]
			, [202212], [202301], [202302]
	FROM (
		select 
			member_name
			, IIF(tickets/count_days > 600, 600, tickets/count_days) as avg_tickets
			, key_date
		from
		(
			SELECT [member_name] 
			  , max([tickets]) - min([tickets]) as tickets
			  , datediff(day,min([created_at]),max([created_at])) as  count_days
	
			  , year([created_at])*100 + month([created_at]) as key_date

			FROM [swgoh].[history].[tickets]
			where [tickets] > 0
			group by  [member_name]
			  , year([created_at])*100 + month([created_at]) 
		) src
		where count_days > 0
	) srcpvt
	PIVOT
	(
		AVG(avg_tickets)
		FOR key_date IN (
			[202112], [202201], [202202]
			, [202203], [202204], [202205]
			, [202206], [202207], [202208]
			, [202209], [202210], [202211]
			, [202212], [202301], [202302]
		)
	) as pvt
	where member_name in (select fn.member_name(member_allycode) from stage.members_current)
	order by member_name
GO

