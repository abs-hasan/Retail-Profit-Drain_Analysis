-- Drop tables if they exist before creating new ones

DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,                -- Primary key: unique identifier for each date
    day INT NOT NULL CHECK (day BETWEEN 1 AND 31),
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    quarter INT NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    year INT NOT NULL,
    day_of_week VARCHAR(10) NOT NULL,
    is_weekend BIT NOT NULL
);

DROP TABLE IF EXISTS dim_customer;
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,             -- Primary key: unique internal ID for each customer
    customer_id VARCHAR(50) NOT NULL UNIQUE,  -- Business/customer ID from source systems
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    loyalty_status VARCHAR(50) NOT NULL DEFAULT 'Bronze',
    segment VARCHAR(50) NOT NULL,
    region VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS dim_product;
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,               -- Primary key: unique internal ID for each product
    product_id VARCHAR(50) NOT NULL UNIQUE,   -- Product code from source systems
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    supplier_id VARCHAR(50)                    -- Links to supplier’s business ID (see dim_supplier)
);

DROP TABLE IF EXISTS dim_campaign;


CREATE TABLE dim_campaign (
    campaign_key INT PRIMARY KEY,              -- Primary key: unique internal ID for each campaign
    campaign_id VARCHAR(50) NOT NULL UNIQUE,  -- Campaign code from marketing system
    campaign_name VARCHAR(255) NOT NULL,
    campaign_type VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget NUMERIC(15,2) CHECK (budget >= 0)
);

DROP TABLE IF EXISTS dim_location;
CREATE TABLE dim_location (
    location_key INT PRIMARY KEY,              -- Primary key: unique internal ID for each location
    store_id VARCHAR(50) UNIQUE,               -- Store or warehouse code
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    warehouse_flag BIT NOT NULL DEFAULT 0      -- 1 for warehouse, 0 for store
);

DROP TABLE IF EXISTS dim_supplier;
CREATE TABLE dim_supplier (
    supplier_key INT PRIMARY KEY,              -- Primary key: unique internal ID for each supplier
    supplier_id VARCHAR(50) NOT NULL UNIQUE,  -- Supplier business code
    supplier_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50)
);


DROP TABLE IF EXISTS dim_payment_method;
CREATE TABLE dim_payment_method (
    payment_method_id  VARCHAR(50) PRIMARY KEY,    -- business code
    method_name        VARCHAR(100) NOT NULL,          
    card_type          VARCHAR(50) NULL,               
    created_at         DATETIME2 DEFAULT SYSUTCDATETIME()
);


DROP TABLE IF EXISTS dim_address;
CREATE TABLE dim_address (
    address_key INT PRIMARY KEY, 
    address_id  VARCHAR(50),                   -- address code
    street      VARCHAR(255) NULL,
    city        VARCHAR(100) NULL,
    state       VARCHAR(100) NULL,
    postcode    VARCHAR(20) NULL,
    country     VARCHAR(100) NULL
);


DROP TABLE IF EXISTS dim_warehouse;
CREATE TABLE dim_warehouse (
    warehouse_id  VARCHAR(50) NOT NULL,           -- business warehouse code
    warehouse_key INT PRIMARY KEY,       -- surrogate/business key (should be unique)
    address_key   INT NOT NULL,                      -- FK → dim_address.address_key
    city          VARCHAR(100) NOT NULL,
    region        VARCHAR(100) NOT NULL,
    country       VARCHAR(100) NOT NULL,
    sla_days      INT NULL,
    created_at    DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (address_key) REFERENCES dim_address(address_key)
);


DROP TABLE IF EXISTS dim_marketing_segment;
CREATE TABLE dim_marketing_segment (
    segment_id          VARCHAR(50) PRIMARY KEY,    -- segment code
    segment_name        VARCHAR(100) NOT NULL,          
    segment_description VARCHAR(255) NULL
);




