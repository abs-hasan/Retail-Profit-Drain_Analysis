-- ===========================================
-- FACT TABLE INDEXES
-- ===========================================

-- fact_sales
CREATE INDEX idx_fact_sales_customer_key ON fact_sales(customer_key);
CREATE INDEX idx_fact_sales_product_key ON fact_sales(product_key);
CREATE INDEX idx_fact_sales_date_key ON fact_sales(date_key);
CREATE INDEX idx_fact_sales_campaign_key ON fact_sales(campaign_key);
CREATE INDEX idx_fact_sales_location_key ON fact_sales(location_key);

-- fact_returns
CREATE INDEX idx_fact_returns_sales_key ON fact_returns(sales_key);
CREATE INDEX idx_fact_returns_product_key ON fact_returns(product_key);
CREATE INDEX idx_fact_returns_date_key ON fact_returns(date_key);

-- fact_marketing_interactions
CREATE INDEX idx_fact_marketing_campaign_key ON fact_marketing_interactions(campaign_key);
CREATE INDEX idx_fact_marketing_date_key ON fact_marketing_interactions(date_key);

-- fact_inventory
CREATE INDEX idx_fact_inventory_product_key ON fact_inventory(product_key);
CREATE INDEX idx_fact_inventory_date_key ON fact_inventory(date_key);
CREATE INDEX idx_fact_inventory_location_key ON fact_inventory(location_key);

-- fact_web_activity
CREATE INDEX idx_fact_web_activity_customer_key ON fact_web_activity(customer_key);
CREATE INDEX idx_fact_web_activity_date_key ON fact_web_activity(date_key);

-- fact_shipments
CREATE INDEX idx_fact_shipments_sales_key ON fact_shipments(sales_key);
CREATE INDEX idx_fact_shipments_warehouse_key ON fact_shipments(warehouse_key);
