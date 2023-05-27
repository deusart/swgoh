USE swgoh
GO

CREATE OR ALTER VIEW core.calendar
AS
	SELECT * 
	FROM budget.core.calendar
	WHERE YEAR(calendar_date) > 2021 and calendar_date <= GETDATE()
GO