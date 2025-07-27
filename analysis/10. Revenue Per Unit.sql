WITH product_sales AS (
    SELECT 
        fs.product_key,
        dp.product_name,
        dp.category,
        COUNT(DISTINCT fs.sales_key) AS order_count,
        SUM(fs.quantity) AS units_sold,
        SUM(fs.quantity * fs.unit_price) AS total_revenue
    FROM fact_sales fs
    JOIN dim_product dp ON fs.product_key = dp.product_key
    GROUP BY fs.product_key, dp.product_name, dp.category
),
product_returns AS (
    SELECT 
        fr.product_key,
        SUM(fr.return_amount) AS total_returns
    FROM fact_returns fr
    GROUP BY fr.product_key
),
adjusted_metrics AS (
    SELECT 
        ps.product_key,
        ps.product_name,
        ps.category,
        ps.order_count,
        ps.units_sold,
        ps.total_revenue,
        COALESCE(pr.total_returns, 0) AS total_returns,
        ps.total_revenue - COALESCE(pr.total_returns, 0) AS net_revenue,
        ROUND((ps.total_revenue - COALESCE(pr.total_returns, 0)) * 1.0 / NULLIF(ps.units_sold, 0), 2) AS revenue_per_unit
    FROM product_sales ps
    LEFT JOIN product_returns pr ON ps.product_key = pr.product_key
)
SELECT TOP 10 *
FROM adjusted_metrics
WHERE units_sold >= 20
ORDER BY revenue_per_unit ASC;



-- Portfolio Interpretation
-- “Among top-selling SKUs, we found several with very low revenue per unit, such as Million Electronic at $53.82 per unit after returns.
-- Even though they sell decently, their adjusted earnings are weak, likely due to:

-- Excessive promotions,

-- High return rates (e.g., Society Electronic lost over $2,000),

-- Or poor pricing power.

-- These should be flagged for:

-- Margin improvement strategies

-- Targeted cost renegotiation with suppliers

-- Or campaign re-evaluation to boost ROI.”