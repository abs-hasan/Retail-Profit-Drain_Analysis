WITH sales_summary AS (
    SELECT 
        product_key,
        SUM(quantity) AS total_sold
    FROM fact_sales
    GROUP BY product_key
),
returns_summary AS (
    SELECT 
        product_key,
        SUM(quantity_returned) AS total_returned
    FROM fact_returns
    GROUP BY product_key
),
return_rate_calc AS (
    SELECT 
        ss.product_key,
        dp.product_name,
        dp.category,
        ss.total_sold,
        COALESCE(rs.total_returned, 0) AS total_returned,
        ROUND(COALESCE(rs.total_returned, 0) * 100.0 / NULLIF(ss.total_sold, 0), 2) AS return_rate_pct
    FROM sales_summary ss
    LEFT JOIN returns_summary rs ON ss.product_key = rs.product_key
    JOIN dim_product dp ON ss.product_key = dp.product_key
)
SELECT top 5 *
FROM return_rate_calc
WHERE total_sold >= 20 
ORDER BY return_rate_pct DESC;
