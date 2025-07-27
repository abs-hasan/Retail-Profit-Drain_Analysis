
WITH base_sales AS (
    SELECT 
        fs.sales_key,
        fs.location_key,
        fs.quantity,
        fs.unit_price,
        fs.quantity * fs.unit_price AS revenue
    FROM fact_sales fs
),
returns_summary AS (
    SELECT 
        sales_key,
        SUM(return_amount) AS return_amount
    FROM fact_returns
    GROUP BY sales_key
),
sales_with_returns AS (
    SELECT 
        bs.location_key,
        bs.revenue,
        COALESCE(rs.return_amount, 0) AS return_amount,
        bs.revenue - COALESCE(rs.return_amount, 0) AS net_revenue
    FROM base_sales bs
    LEFT JOIN returns_summary rs ON bs.sales_key = rs.sales_key
),
profit_by_type AS (
    SELECT 
        CASE 
            WHEN dl.warehouse_flag = 1 THEN 'Warehouse'
            ELSE 'Retail Store'
        END AS store_type,
        COUNT(*) AS total_orders,
        SUM(swr.revenue) AS gross_revenue,
        SUM(swr.return_amount) AS total_returns,
        SUM(swr.net_revenue) AS net_revenue,
        ROUND(SUM(swr.net_revenue) * 1.0 / COUNT(*), 2) AS avg_order_value
    FROM sales_with_returns swr
    JOIN dim_location dl ON swr.location_key = dl.location_key
    GROUP BY dl.warehouse_flag
)
SELECT top 5 *
FROM profit_by_type
ORDER BY net_revenue DESC;

