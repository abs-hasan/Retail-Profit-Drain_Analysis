-- Indexes for fact_sales table
CREATE INDEX idx_fact_sales_customer_key ON fact_sales(customer_key);
CREATE INDEX idx_fact_sales_product_key ON fact_sales(product_key);
CREATE INDEX idx_fact_sales_date_key ON fact_sales(date_key);
CREATE INDEX idx_fact_sales_campaign_key ON fact_sales(campaign_key);
CREATE INDEX idx_fact_sales_location_key ON fact_sales(location_key);

-- Indexes for fact_returns table
CREATE INDEX idx_fact_returns_sales_key ON fact_returns(sales_key);
CREATE INDEX idx_fact_returns_product_key ON fact_returns(product_key);
CREATE INDEX idx_fact_returns_date_key ON fact_returns(date_key);

-- Indexes for fact_marketing table
CREATE INDEX idx_fact_marketing_campaign_key ON fact_marketing(campaign_key);
CREATE INDEX idx_fact_marketing_date_key ON fact_marketing(date_key);

-- Indexes for fact_inventory table
CREATE INDEX idx_fact_inventory_product_key ON fact_inventory(product_key);
CREATE INDEX idx_fact_inventory_date_key ON fact_inventory(date_key);
CREATE INDEX idx_fact_inventory_location_key ON fact_inventory(location_key);
