
WITH delay_summary AS (
    SELECT 
        s.sales_key,
        s.shipment_date,
        s.delivery_date,
        DATEDIFF(DAY, s.shipment_date, s.delivery_date) AS delay_days,
        CASE WHEN DATEDIFF(DAY, s.shipment_date, s.delivery_date) > 3 THEN 1 ELSE 0 END AS is_delayed,
        fs.customer_key,
        fs.product_key,
        fs.quantity,
        fs.unit_price
    FROM fact_shipments s
    JOIN fact_sales fs ON s.sales_key = fs.sales_key
    WHERE s.shipment_date IS NOT NULL AND s.delivery_date IS NOT NULL
),
-- STEP 2: Mark returns per sale
returns_flag AS (
    SELECT 
        sales_key,
        1 AS was_returned
    FROM fact_returns
),
-- STEP 3: Join delays and returns
joined_data AS (
    SELECT 
        d.product_key,
        d.sales_key,
        d.is_delayed,
        COALESCE(r.was_returned, 0) AS was_returned
    FROM delay_summary d
    LEFT JOIN returns_flag r ON d.sales_key = r.sales_key
),
-- STEP 4: Calculate return rate by delay status
return_rate_by_delay AS (
    SELECT 
        is_delayed,
        COUNT(*) AS total_orders,
        SUM(was_returned) AS returned_orders,
        ROUND(SUM(was_returned) * 100.0 / NULLIF(COUNT(*), 0), 2) AS return_rate_pct
    FROM joined_data
    GROUP BY is_delayed
)
SELECT 
    CASE WHEN is_delayed = 1 THEN 'Delayed (>3 days)' ELSE 'On-time (≤3 days)' END AS shipping_status,
    total_orders,
    returned_orders,
    return_rate_pct
FROM return_rate_by_delay;

