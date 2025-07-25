WITH sales_dates AS (
    SELECT 
        fs.customer_key,
        CAST(CONCAT(dd.year, '-', dd.month, '-', dd.day) AS DATE) AS order_date
    FROM fact_sales fs
    JOIN dim_date dd ON fs.date_key = dd.date_key
),
latest_activity AS (
    SELECT 
        customer_key,
        MAX(order_date) AS last_order_date
    FROM sales_dates
    GROUP BY customer_key
),
reference_date AS (
    SELECT MAX(order_date) AS reference_date FROM sales_dates
),
churn_flags AS (
    SELECT 
        la.customer_key,
        la.last_order_date,
        DATEDIFF(DAY, la.last_order_date, r.reference_date) AS days_since_last_order,
        CASE 
            WHEN DATEDIFF(DAY, la.last_order_date, r.reference_date) <= 90 THEN 'Active (≤90d)'
            WHEN DATEDIFF(DAY, la.last_order_date, r.reference_date) <= 179 THEN 'Dormant (91–179d)'
            ELSE 'At Risk (180+d)'
        END AS churn_status
    FROM latest_activity la
    CROSS JOIN reference_date r
)
SELECT 
    churn_status,
    COUNT(*) AS customer_count
FROM churn_flags
GROUP BY churn_status
ORDER BY customer_count DESC;
