WITH delay_summary AS (
    SELECT 
        s.sales_key,
        s.delivery_date,
        s.shipment_date,
        DATEDIFF(DAY, s.shipment_date, s.delivery_date) AS delay_days,
        fs.customer_key,
        fs.product_key,
        fs.quantity,
        fs.unit_price,
        dp.product_name,
        dp.category,
        dc.campaign_name
    FROM fact_shipments s
    JOIN fact_sales fs ON s.sales_key = fs.sales_key
    JOIN dim_product dp ON fs.product_key = dp.product_key
    LEFT JOIN dim_campaign dc ON fs.campaign_key = dc.campaign_key
    WHERE s.shipment_date IS NOT NULL AND s.delivery_date IS NOT NULL
),
delay_stats AS (
    SELECT 
        product_key,
        product_name,
        category,
        COUNT(*) AS delayed_orders,
        AVG(delay_days) AS avg_delay,
        SUM(CASE WHEN delay_days > 3 THEN 1 ELSE 0 END) AS late_shipments
    FROM delay_summary
    WHERE delay_days > 0
    GROUP BY product_key, product_name, category
)
SELECT TOP 5 *
FROM delay_stats
ORDER BY avg_delay DESC;
