
WITH sales_summary AS (
    SELECT 
        product_key,
        SUM(quantity) AS total_sold
    FROM fact_sales
    GROUP BY product_key
),
inventory_summary AS (
    SELECT 
        product_key,
        SUM(stock_in) AS total_available
    FROM fact_inventory
    GROUP BY product_key
),
inventory_drift_calc AS (
    SELECT 
        ss.product_key,
        dp.product_name,
        dp.category,
        ss.total_sold,
        COALESCE(isum.total_available, 0) AS total_available,
        ss.total_sold - COALESCE(isum.total_available, 0) AS drift_units,
        ROUND(
            CASE 
                WHEN ss.total_sold > COALESCE(isum.total_available, 0)
                THEN (ss.total_sold - COALESCE(isum.total_available, 0)) * 100.0 / ss.total_sold
                ELSE 0
            END, 
            2
        ) AS drift_pct
    FROM sales_summary ss
    LEFT JOIN inventory_summary isum ON ss.product_key = isum.product_key
    JOIN dim_product dp ON ss.product_key = dp.product_key
)
SELECT TOP 5 *
FROM inventory_drift_calc
WHERE drift_units > 0 AND total_sold >= 20
ORDER BY drift_pct DESC;
