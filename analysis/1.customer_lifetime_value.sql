WITH sales_base AS (
    SELECT 
        fs.sales_key,
        fs.customer_key,
        fs.quantity,
        fs.unit_price,
        fs.date_key,
        fs.product_key
    FROM fact_sales fs
),
sales_with_date AS (
    SELECT 
        sb.customer_key,
        sb.sales_key,
        sb.quantity,
        sb.unit_price,
        CAST(CONCAT(dd.year, '-', dd.month, '-', dd.day) AS DATE) AS order_date,
        sb.quantity * sb.unit_price AS revenue
    FROM sales_base sb
    JOIN dim_date dd ON sb.date_key = dd.date_key
),
customer_orders AS (
    SELECT 
        customer_key,
        COUNT(DISTINCT sales_key) AS total_orders,
        SUM(revenue) AS total_spent,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM sales_with_date
    GROUP BY customer_key
),
returns_mapped AS (
    SELECT 
        fr.return_key,
        fr.sales_key,
        fr.return_amount
    FROM fact_returns fr
),
returns_joined AS (
    SELECT 
        sb.customer_key,
        SUM(fr.return_amount) AS total_returns
    FROM returns_mapped fr
    JOIN sales_base sb ON fr.sales_key = sb.sales_key
    GROUP BY sb.customer_key
),
clv_calc AS (
    SELECT 
        co.customer_key,
        co.total_orders,
        co.total_spent,
        COALESCE(rj.total_returns, 0) AS total_returns,
        co.total_spent - COALESCE(rj.total_returns, 0) AS net_spent,
        DATEDIFF(DAY, co.first_order, co.last_order) AS active_days,
        ROUND((co.total_spent - COALESCE(rj.total_returns, 0)) * 1.0 / NULLIF(co.total_orders, 0), 2) AS avg_spend_per_order
    FROM customer_orders co
    LEFT JOIN returns_joined rj ON co.customer_key = rj.customer_key
)
SELECT TOP 5 *
FROM clv_calc
ORDER BY net_spent DESC;
