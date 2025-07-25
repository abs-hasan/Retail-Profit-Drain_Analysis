
WITH campaign_spend AS (
    SELECT 
        m.campaign_key,
        dc.campaign_name,
        dc.campaign_type,
        dc.start_date,
        dc.end_date,
        SUM(m.spend_amount) AS total_spend,  
        SUM(m.impressions) AS total_impressions
    FROM fact_marketing m
    JOIN dim_campaign dc ON m.campaign_key = dc.campaign_key
    GROUP BY m.campaign_key, dc.campaign_name, dc.campaign_type, dc.start_date, dc.end_date
),
campaign_sales AS (
    SELECT 
        campaign_key,
        COUNT(DISTINCT customer_key) AS unique_customers,
        SUM(quantity * unit_price) AS total_revenue,
        SUM(quantity) AS units_sold
    FROM fact_sales
    GROUP BY campaign_key
),
campaign_metrics AS (
    SELECT 
        cs.campaign_key,
        cs.total_revenue,
        cs.units_sold,
        cs.unique_customers,
        sp.campaign_name,
        sp.campaign_type,
        sp.start_date,

        sp.end_date,
        sp.total_spend,
        sp.total_impressions,
        ROUND(CASE WHEN sp.total_spend = 0 THEN NULL ELSE cs.total_revenue * 1.0 / sp.total_spend END, 2) AS roas,
        ROUND(CASE WHEN cs.unique_customers = 0 THEN NULL ELSE sp.total_spend * 1.0 / cs.unique_customers END, 2) AS cpa
    FROM campaign_sales cs
    JOIN campaign_spend sp ON cs.campaign_key = sp.campaign_key
)
SELECT TOP 5 *
FROM campaign_metrics
ORDER BY roas ASC;
