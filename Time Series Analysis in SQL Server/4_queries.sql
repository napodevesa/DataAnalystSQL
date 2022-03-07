SELECT
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth,
    -- Include the sum of incidents by day over each range
	SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	ir.IncidentTypeID = 2
GROUP BY
	-- GROUP BY needs to include all non-aggregated columns
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth
-- Fill in your grouping operator
WITH ROLLUP
ORDER BY
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth;

	--- ********** ---

	SELECT
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth,
    -- Include the sum of incidents by day over each range
	SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	ir.IncidentTypeID = 2
GROUP BY
	-- GROUP BY needs to include all non-aggregated columns
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth

WITH ROLLUP
ORDER BY
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth;


	--- ********** ---

	SELECT
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth,
	SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	ir.IncidentTypeID = 2
GROUP BY GROUPING SETS
(
  	-- Group in hierarchical order:  calendar year,
    -- calendar quarter name, calendar month
	(c.CalendarYear, c.CalendarQuarterName, c.CalendarMonth),
  	-- Group by calendar year
	(c.CalendarYear),
    -- This remains blank; it gives us the grand total
	()
)
ORDER BY
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth;


	--- ********** ---

	SELECT
	c.CalendarYear,
	c.CalendarMonth,
	c.DayOfWeek,
	c.IsWeekend,
	SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
GROUP BY GROUPING SETS
(
    -- Each non-aggregated column from above should appear once
  	-- Calendar year and month
	(c.CalendarYear, c.CalendarMonth),
  	-- Day of week
	(c.DayOfWeek),
  	-- Is weekend or not
	(c.IsWeekend),
    -- This remains empty; it gives us the grand total
	()
)
ORDER BY
	c.CalendarYear,
	c.CalendarMonth,
	c.DayOfWeek,
	c.IsWeekend;

		--- ********** ---

SELECT
	ir.IncidentDate,
	ir.NumberOfIncidents,

	ROW_NUMBER() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rownum,
	RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rk,
	DENSE_RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS dr
FROM dbo.IncidentRollup ir
WHERE
	ir.IncidentTypeID = 3
	AND ir.NumberOfIncidents >= 8
ORDER BY
	ir.NumberOfIncidents DESC;

			--- ********** ---
SELECT
	ir.IncidentDate,
	ir.NumberOfIncidents,
    
    sum	(ir.NumberOfIncidents) OVER () AS SumOfIncidents,
	min(ir.NumberOfIncidents) OVER () AS LowestNumberOfIncidents,
	max(ir.NumberOfIncidents) OVER () AS HighestNumberOfIncidents,
	count(ir.NumberOfIncidents) OVER () AS CountOfIncidents
FROM dbo.IncidentRollup ir
WHERE
	ir.IncidentDate BETWEEN '2019-07-01' AND '2019-07-31'
AND ir.IncidentTypeID = 3;

			--- ********** ---
SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
	ir.NumberOfIncidents,
    -- Get the total number of incidents
	SUM(ir.NumberOfIncidents) OVER (
      	-- Do this for each incident type ID
		PARTITION BY ir.IncidentTypeID
      	-- Sort by the incident date
		ORDER BY ir.IncidentDate
	) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	c.CalendarYear = 2019
	AND c.CalendarMonth = 7
	AND ir.IncidentTypeID IN (1, 2)
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;
				--- ********** ---

SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
	ir.NumberOfIncidents,
	AVG(ir.NumberOfIncidents) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	) AS MeanNumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	c.CalendarYear = 2019
	AND c.CalendarMonth IN (7, 8)
	AND ir.IncidentTypeID = 1
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;

				--- ********** ---

	SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
	ir.NumberOfIncidents,
	AVG(ir.NumberOfIncidents) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	) AS MeanNumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	c.CalendarYear = 2019
	AND c.CalendarMonth IN (7, 8)
	AND ir.IncidentTypeID = 1
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;

				--- ********** ---
SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
	DATEDIFF(DAY, LAG(ir.IncidentDate, 1) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
	), ir.IncidentDate) AS DaysSinceLastIncident,
	DATEDIFF(DAY, ir.IncidentDate, LEAD(ir.IncidentDate, 1) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
	)) AS DaysUntilNextIncident
FROM dbo.IncidentRollup ir
WHERE
	ir.IncidentDate >= '2019-07-02'
	AND ir.IncidentDate <= '2019-07-31'
	AND ir.IncidentTypeID IN (1, 2)
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;