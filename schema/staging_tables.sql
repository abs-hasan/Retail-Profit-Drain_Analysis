-- 1. Create staging schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'staging')
    EXEC('CREATE SCHEMA staging;');
GO

-- 2. Drop & recreate staging tables

-- ===========================================
-- STAGING TABLES — DIMENSIONS
-- ===========================================

DROP TABLE IF EXISTS staging.dim_date;
CREATE TABLE staging.dim_date (
    date_key DATE,
    day INT,
    month INT,
    quarter INT,
    year INT,
    day_of_week VARCHAR(10),
    is_weekend BIT
);

DROP TABLE IF EXISTS staging.dim_customer;
CREATE TABLE staging.dim_customer (
    customer_key INT,
    customer_id VARCHAR(50),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    loyalty_status VARCHAR(50),
    segment VARCHAR(50),
    region VARCHAR(100)
);

DROP TABLE IF EXISTS staging.dim_product;
CREATE TABLE staging.dim_product (
    product_key INT,
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(100),
    brand VARCHAR(100),
    supplier_id VARCHAR(50)
);

DROP TABLE IF EXISTS staging.dim_campaign;
CREATE TABLE staging.dim_campaign (
    campaign_key INT,
    campaign_id VARCHAR(50),
    campaign_name VARCHAR(255),
    campaign_type VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget NUMERIC(15,2)
);

DROP TABLE IF EXISTS staging.dim_location;
CREATE TABLE staging.dim_location (
    location_key INT,
    store_id VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    warehouse_flag BIT
);

DROP TABLE IF EXISTS staging.dim_supplier;
CREATE TABLE staging.dim_supplier (
    supplier_key INT,
    supplier_id VARCHAR(50),
    supplier_name VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50)
);

DROP TABLE IF EXISTS staging.dim_warehouse;
CREATE TABLE staging.dim_warehouse (
    warehouse_key VARCHAR(50),
    warehouse_id  VARCHAR(50),
    address_key   INT NOT NULL,                -- match `dim_address`
    city          VARCHAR(100),
    region        VARCHAR(100),
    country       VARCHAR(100),
    sla_days      VARCHAR(50)                  -- will be cast to INT later
);

DROP TABLE IF EXISTS staging.dim_payment_method;
CREATE TABLE staging.dim_payment_method (
    payment_key INT,
    payment_method VARCHAR(50),
    provider VARCHAR(100)
);

DROP TABLE IF EXISTS staging.dim_marketing_segment;
CREATE TABLE staging.dim_marketing_segment (
    segment_key INT,
    segment_name VARCHAR(100),
    description TEXT
);

DROP TABLE IF EXISTS staging.dim_address;
CREATE TABLE staging.dim_address (
    address_key INT,
    address_id VARCHAR(50),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postcode VARCHAR(20),
    country VARCHAR(100),
    region VARCHAR(100)
);




-- ===========================================
-- STAGING TABLES — FACTS
-- ===========================================

DROP TABLE IF EXISTS staging.fact_sales;
CREATE TABLE staging.fact_sales (
    sales_key INT,
    order_id VARCHAR(50),
    customer_key INT,
    product_key INT,
    campaign_key INT,
    date_key DATE,
    quantity INT,
    unit_price NUMERIC(10,2),
    discount_amount NUMERIC(10,2),
    total_amount NUMERIC(15,2),
    location_key INT,
    payment_method_id VARCHAR(50),
    created_at DATETIME
);

DROP TABLE IF EXISTS staging.fact_returns;
CREATE TABLE staging.fact_returns (
    return_key INT,
    return_id VARCHAR(50),
    sales_key INT,
    product_key INT,
    date_key DATE,
    quantity_returned INT,
    return_amount NUMERIC(15,2),
    return_reason VARCHAR(255),
    created_at DATETIME
);

DROP TABLE IF EXISTS staging.fact_marketing;
CREATE TABLE staging.fact_marketing (
    marketing_key INT,
    campaign_key INT,
    date_key DATE,
    spend_amount NUMERIC(15,2),
    impressions INT,
    clicks INT,
    conversions INT,
    created_at DATETIME
);

DROP TABLE IF EXISTS staging.fact_inventory;
CREATE TABLE staging.fact_inventory (
    inventory_key INT,
    product_key INT,
    date_key DATE,
    location_key INT,
    stock_level INT,
    stock_in INT,
    stock_out INT,
    created_at DATETIME
);

DROP TABLE IF EXISTS staging.fact_web_activity;
CREATE TABLE staging.fact_web_activity (
    web_activity_key INT,
    customer_key INT,
    date_key DATE,
    session_id VARCHAR(50),
    page_views INT,
    duration_seconds INT,
    converted BIT,
    created_at DATETIME
);

DROP TABLE IF EXISTS staging.fact_shipments;
CREATE TABLE staging.fact_shipments (
    shipment_key INT,
    sales_key INT,
    warehouse_key INT,
    shipment_date DATE,
    delivery_date DATE,
    delay_days INT,
    shipping_cost NUMERIC(10,2),
    created_at DATETIME
); 
