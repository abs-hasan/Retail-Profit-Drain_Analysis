DROP TABLE IF EXISTS fact_sales;
CREATE TABLE fact_sales (
    sales_key INT IDENTITY(1,1) PRIMARY KEY,    -- PK: unique internal ID
    order_id VARCHAR(50) NOT NULL,
    customer_key INT NOT NULL,                   -- FK: dim_customer.customer_key
    product_key INT NOT NULL,                    -- FK: dim_product.product_key
    campaign_key INT NULL,                       -- FK: dim_campaign.campaign_key
    date_key DATE NOT NULL,                      -- FK: dim_date.date_key
    quantity INT CHECK (quantity >= 0),
    unit_price NUMERIC(10,2) CHECK (unit_price >= 0),
    discount_amount NUMERIC(10,2) CHECK (discount_amount >= 0),
    total_amount NUMERIC(15,2) CHECK (total_amount >= 0),
    location_key INT NULL,                       -- FK: dim_location.location_key
    payment_method VARCHAR(50),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (campaign_key) REFERENCES dim_campaign(campaign_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (location_key) REFERENCES dim_location(location_key)
);

DROP TABLE IF EXISTS fact_returns;
CREATE TABLE fact_returns (
    return_key INT IDENTITY(1,1) PRIMARY KEY,   -- PK: unique internal ID
    return_id VARCHAR(50) NOT NULL,
    sales_key INT NOT NULL,                      -- FK: fact_sales.sales_key
    product_key INT NOT NULL,                    -- FK: dim_product.product_key
    date_key DATE NOT NULL,                      -- FK: dim_date.date_key
    quantity_returned INT CHECK (quantity_returned >= 0),
    return_amount NUMERIC(15,2) CHECK (return_amount >= 0),
    return_reason VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (sales_key) REFERENCES fact_sales(sales_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

DROP TABLE IF EXISTS fact_marketing;
CREATE TABLE fact_marketing (
    marketing_key INT IDENTITY(1,1) PRIMARY KEY, -- PK: unique internal ID
    campaign_key INT NOT NULL,                    -- FK: dim_campaign.campaign_key
    date_key DATE NOT NULL,                       -- FK: dim_date.date_key
    spend_amount NUMERIC(15,2) CHECK (spend_amount >= 0),
    impressions INT CHECK (impressions >= 0),
    clicks INT CHECK (clicks >= 0),
    conversions INT CHECK (conversions >= 0),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (campaign_key) REFERENCES dim_campaign(campaign_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

DROP TABLE IF EXISTS fact_inventory;
CREATE TABLE fact_inventory (
    inventory_key INT IDENTITY(1,1) PRIMARY KEY, -- PK: unique internal ID
    product_key INT NOT NULL,                      -- FK: dim_product.product_key
    date_key DATE NOT NULL,                        -- FK: dim_date.date_key
    location_key INT NOT NULL,                     -- FK: dim_location.location_key
    stock_level INT CHECK (stock_level >= 0),
    stock_in INT CHECK (stock_in >= 0),
    stock_out INT CHECK (stock_out >= 0),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (location_key) REFERENCES dim_location(location_key)
);
