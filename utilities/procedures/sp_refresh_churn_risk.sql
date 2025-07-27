CREATE PROCEDURE sp_refresh_churn_risk
AS
BEGIN
    IF OBJECT_ID('tempdb..#churn_risk_latest') IS NOT NULL
        DROP TABLE #churn_risk_latest;

    -- Create date from year/month/day
    SELECT 
        s.customer_key,
        MAX(DATEFROMPARTS(d.year, d.month, d.day)) AS last_order_date,
        DATEDIFF(DAY, MAX(DATEFROMPARTS(d.year, d.month, d.day)), GETDATE()) AS days_since_last_order,
        CASE 
            WHEN DATEDIFF(DAY, MAX(DATEFROMPARTS(d.year, d.month, d.day)), GETDATE()) <= 90 THEN 'Active (=90d)'
            WHEN DATEDIFF(DAY, MAX(DATEFROMPARTS(d.year, d.month, d.day)), GETDATE()) BETWEEN 91 AND 179 THEN 'Dormant (91–179d)'
            ELSE 'At Risk (180+d)'
        END AS churn_status
    INTO #churn_risk_latest
    FROM fact_sales s
    JOIN dim_date d ON s.date_key = d.date_key
    GROUP BY s.customer_key;

    SELECT * FROM #churn_risk_latest;
END;
