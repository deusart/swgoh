USE swgoh
GO

CREATE OR ALTER VIEW rules.tickets
AS
	SELECT 
		lt.member_name
		, avg_tickets_lifetime
		, m.avg_tickets_month
		, hw.avg_tickets_half_month
		, coalesce(w.avg_tickets_week, hw.avg_tickets_half_month) AS avg_tickets_week
		, lt.log_datetime
	FROM (
		SELECT 
			member_name
			, iif(
				(DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24) = 0
				, iif(max(tickets)>600,600,max(tickets))
				, iif(
					(max(tickets) - min(tickets)) / (DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24) > 600
						, 600
						, (max(tickets) - min(tickets)) / (DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24)
					)
			) as avg_tickets_lifetime
			, MAX(created_at) as log_datetime
		from history.tickets gl	
		where tickets >0
		group by member_name
	) lt
	left join (
		select 
			member_name
			, iif(
				(DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24) = 0
				, iif(max(tickets)>600,600,max(tickets))
				, iif(
					(max(tickets) - min(tickets)) / (DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24) > 600
						, 600
						, (max(tickets) - min(tickets)) / (DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24)
					)
			) as avg_tickets_half_month
			, MAX(created_at) as log_datetime
		from history.tickets gl	
		where convert(datetime,created_at) > dateadd(day, -14, getdate()) and tickets >0 
		group by member_name
	) hw on lt.member_name = hw.member_name
	left join (
		select 
			member_name
			, iif(
				(DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24) = 0
				, iif(max(tickets)>600,600,max(tickets))
				, iif(
					(max(tickets) - min(tickets)) / (DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24) > 600
						, 600
						, (max(tickets) - min(tickets)) / (DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24)
					)
			) as avg_tickets_month
		from history.tickets gl	
		where convert(datetime,created_at) > dateadd(day, -31, getdate()) and tickets >0
		group by member_name
	) m on lt.member_name = m.member_name
	left join (
		select 
			member_name
			, iif(
				(DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24) = 0
				, iif(max(tickets)>600,600,max(tickets))
				, iif(
					(max(tickets) - min(tickets)) / (DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24) > 600
						, 600
						, (max(tickets) - min(tickets)) / (DATEDIFF(hour, min(convert(datetime,created_at)), max(convert(datetime,created_at)))/24)
					)
			) as avg_tickets_week
			, MAX(created_at) as log_datetime
		from history.tickets gl	
		where convert(datetime,created_at) > dateadd(day, -7, getdate()) and tickets >0 
		group by member_name
	) w on lt.member_name = w.member_name
GO