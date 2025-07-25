-- FACT_SALES
DROP TABLE IF EXISTS fact_sales;
CREATE TABLE fact_sales (
    sales_key INT PRIMARY KEY,              -- Manually controlled unique sales ID
    order_id VARCHAR(50) NOT NULL,
    customer_key INT NOT NULL,                      -- FK → dim_customer
    product_key INT NOT NULL,                       -- FK → dim_product
    campaign_key INT NULL,                          -- FK → dim_campaign
    date_key DATE NOT NULL,                         -- FK → dim_date
    quantity INT CHECK (quantity >= 0),
    unit_price NUMERIC(10,2) CHECK (unit_price >= 0),
    discount_amount NUMERIC(10,2) CHECK (discount_amount >= 0),
    total_amount NUMERIC(15,2) CHECK (total_amount >= 0),
    location_key INT NULL,                          -- FK → dim_location
    payment_method_id VARCHAR(50),                    -- FK → dim_payment_method
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (campaign_key) REFERENCES dim_campaign(campaign_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (location_key) REFERENCES dim_location(location_key),
    FOREIGN KEY (payment_method_id) REFERENCES dim_payment_method(payment_method_id)
);






-- FACT_RETURNS
DROP TABLE IF EXISTS fact_returns;
CREATE TABLE fact_returns (
    return_key INT PRIMARY KEY,
    return_id VARCHAR(50),
    sales_key INT NOT NULL,                 -- FK → fact_sales
    product_key INT NOT NULL,                       -- FK → dim_product
    date_key DATE NOT NULL,                         -- FK → dim_date
    quantity_returned INT CHECK (quantity_returned >= 0),
    return_amount NUMERIC(15,2) CHECK (return_amount >= 0),
    return_reason VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (sales_key) REFERENCES fact_sales(sales_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

-- FACT_MARKETING
DROP TABLE IF EXISTS fact_marketing;
CREATE TABLE fact_marketing (
    marketing_key VARCHAR(50) PRIMARY KEY,
    campaign_key INT NOT NULL,                      -- FK → dim_campaign
    date_key DATE NOT NULL,                         -- FK → dim_date
    spend_amount NUMERIC(15,2) CHECK (spend_amount >= 0),
    impressions INT CHECK (impressions >= 0),
    clicks INT CHECK (clicks >= 0),
    conversions INT CHECK (conversions >= 0),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (campaign_key) REFERENCES dim_campaign(campaign_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

-- FACT_INVENTORY
DROP TABLE IF EXISTS fact_inventory;
CREATE TABLE fact_inventory (
    inventory_key VARCHAR(50) PRIMARY KEY,
    product_key INT NOT NULL,                       -- FK → dim_product
    date_key DATE NOT NULL,                         -- FK → dim_date
    location_key INT NOT NULL,                      -- FK → dim_location
    stock_level INT CHECK (stock_level >= 0),
    stock_in INT CHECK (stock_in >= 0),
    stock_out INT CHECK (stock_out >= 0),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (location_key) REFERENCES dim_location(location_key)
);

-- FACT_WEB_ACTIVITY
DROP TABLE IF EXISTS fact_web_activity;
CREATE TABLE fact_web_activity (
    web_activity_key VARCHAR(50) PRIMARY KEY,
    customer_key INT NOT NULL,                      -- FK → dim_customer
    date_key DATE NOT NULL,                         -- FK → dim_date
    session_id VARCHAR(50) NOT NULL,
    page_views INT CHECK (page_views >= 0),
    duration_seconds INT CHECK (duration_seconds >= 0),
    converted BIT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

-- FACT_SHIPMENTS
DROP TABLE IF EXISTS fact_shipments;
CREATE TABLE fact_shipments (
    shipment_key VARCHAR(50) PRIMARY KEY,
    sales_key INT NOT NULL,                 -- FK → fact_sales
    warehouse_key INT NOT NULL,              -- FK → dim_warehouse
    shipment_date DATE NOT NULL,
    delivery_date DATE,
    delay_days INT CHECK (delay_days >= 0),
    shipping_cost NUMERIC(10,2),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (sales_key) REFERENCES fact_sales(sales_key),
    FOREIGN KEY (warehouse_key) REFERENCES dim_warehouse(warehouse_key)
);
