USE DAMG7370SU24
GO

SELECT * FROM CallCenterServiceRequests;

--Top 10 Performance Metrics (Response Time) per CATEGORY and Type of Request: (SQL Only)
WITH RankedRequests AS (
    SELECT 
        case_id,
		category1,
        type,
        creation_date,
        closed_date,
		days_to_close,
        DATEDIFF(day, TRY_CONVERT(DATE, creation_date, 101), TRY_CONVERT(DATE, closed_date, 101)) AS response_time, -- Calculate response time in days
        ROW_NUMBER() OVER (
            PARTITION BY category1, type
            ORDER BY DATEDIFF(day, TRY_CONVERT(DATE, creation_date, 101), TRY_CONVERT(DATE, closed_date, 101)) ASC
        ) AS rn
    FROM 
        CallCenterServiceRequests
)
SELECT 
    case_id,
	category1,
    type,
    creation_date,
    closed_date,
	days_to_close,
    response_time
FROM 
    RankedRequests
WHERE 
    rn <= 10
ORDER BY 
    category1, 
    type, 
    response_time ASC;

--Row count
SELECT COUNT(*) AS row_count
FROM CallCenterServiceRequests;

