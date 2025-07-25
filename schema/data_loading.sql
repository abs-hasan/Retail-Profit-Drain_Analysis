
-- ================================================
-- STEP 1: LOAD DIMENSION TABLES FROM STAGING
-- ================================================

-- Date - Ok
DELETE FROM dim_date;
INSERT INTO dim_date (date_key, day, month, quarter, year, day_of_week, is_weekend)
SELECT date_key, day, month, quarter, year, day_of_week, is_weekend
FROM staging.dim_date;


-- Customer
DELETE FROM dim_customer;
INSERT INTO dim_customer (customer_key, customer_id, first_name, last_name, email, loyalty_status, segment, region)
SELECT customer_key, customer_id, first_name, last_name, email, loyalty_status, segment, region
FROM staging.dim_customer;



-- Product
DELETE FROM dim_product;
INSERT INTO dim_product (product_key, product_id, product_name, category, brand, supplier_id)
SELECT product_key, product_id, product_name, category, brand, supplier_id
FROM staging.dim_product;

-- Location
DELETE FROM dim_location;
INSERT INTO dim_location (location_key, store_id, city, state, country, warehouse_flag)
SELECT location_key, store_id, city, state, country, warehouse_flag
FROM staging.dim_location;


-- Supplier
DELETE FROM dim_supplier;
INSERT INTO dim_supplier (supplier_key, supplier_id, supplier_name, contact_email, contact_phone)
SELECT supplier_key, supplier_id, supplier_name, contact_email, contact_phone
FROM staging.dim_supplier;


-- Payment Method
DELETE FROM dim_payment_method;
INSERT INTO dim_payment_method (payment_method_id, method_name, card_type)
SELECT DISTINCT  payment_method_id, method_name, card_type
FROM staging.dim_payment_method;


-- Marketing Segment

DELETE FROM dim_marketing_segment;
INSERT INTO dim_marketing_segment (segment_id, segment_name, segment_description)
SELECT DISTINCT segment_id, segment_name, segment_description
FROM staging.dim_marketing_segment;


-- 10. dim_address
DELETE FROM dim_address;
INSERT INTO dim_address (address_key, address_id, street, city, state, postcode, country)
SELECT DISTINCT address_key,address_id, street, city, state, postcode, country
FROM staging.dim_address;


-- Warehouse (with FK safety) 
DELETE FROM dim_warehouse;

-- Insert with proper conversion
INSERT INTO dim_warehouse (warehouse_id, warehouse_key, address_key, city, region, country, sla_days)
SELECT
    warehouse_id,
    warehouse_key,
    address_key,
    city,
    region,
    country,
    TRY_CAST(sla_days AS INT)  -- safely convert from string to INT
FROM staging.dim_warehouse
WHERE TRY_CAST(sla_days AS INT) IS NOT NULL  -- optional: skip bad data
  AND address_key IN (SELECT address_key FROM dim_address);  -- FK safety



-- Campaign
DELETE FROM dim_campaign;
INSERT INTO dim_campaign (campaign_key, campaign_id, campaign_name, campaign_type, start_date, end_date, budget)
SELECT campaign_key, campaign_id, campaign_name, campaign_type,
       start_date, end_date, budget
FROM staging.dim_campaign;


-- ================================================
-- STEP 2: LOAD FACT TABLES USING JOINED SURROGATE KEYS
-- ================================================

INSERT INTO fact_sales (
    sales_key,
    order_id,
    customer_key,
    product_key,
    campaign_key,
    date_key,
    quantity,
    unit_price,
    discount_amount,
    total_amount,
    location_key,
    payment_method_id
)
SELECT
    fs.sales_key,
    fs.order_id,
    dc.customer_key,
    dp.product_key,
    dcam.campaign_key,
    CONVERT(DATE, fs.date_key, 103),        -- Converts dd/mm/yyyy string to DATE
    fs.quantity,
    fs.unit_price,
    fs.discount_amount,
    fs.total_amount,
    dloc.location_key,
    dpm.payment_method_id
FROM staging.fact_sales fs
JOIN dim_customer dc ON fs.customer_key = dc.customer_key
JOIN dim_product dp ON fs.product_key = dp.product_key
LEFT JOIN dim_campaign dcam ON fs.campaign_key = dcam.campaign_key
LEFT JOIN dim_location dloc ON fs.location_key = dloc.location_key
JOIN dim_payment_method dpm ON fs.payment_method_id = dpm.payment_method_id;






-- Fact Returns
INSERT INTO fact_returns (
    return_key, return_id, sales_key, product_key, date_key,
    quantity_returned, return_amount, return_reason
)
SELECT
    fr.return_key,
    fr.return_id,
    fs.sales_key,                  -- ✅ ensures valid sales_key
    dp.product_key,
    dd.date_key,
    fr.quantity_returned,
    fr.return_amount,
    fr.return_reason
FROM staging.fact_returns fr
JOIN fact_sales fs ON fr.sales_key = fs.sales_key
JOIN dim_product dp ON fr.product_key = dp.product_key
JOIN dim_date dd ON fr.date_key = dd.date_key;



-- Fact Marketing -- 
INSERT INTO fact_marketing (marketing_key,campaign_key, date_key, spend_amount, impressions, clicks, conversions)
SELECT
    fmi.marketing_key,
    dcam.campaign_key,
    dd.date_key,
    fmi.spend_amount,
    fmi.impressions,
    fmi.clicks,
    fmi.conversions
FROM staging.fact_marketing fmi
JOIN dim_campaign dcam ON fmi.campaign_key = dcam.campaign_key
JOIN dim_date dd ON fmi.date_key = dd.date_key;




-- Fact Inventory
INSERT INTO fact_inventory (inventory_key, product_key, date_key, location_key, stock_level, stock_in, stock_out)
SELECT
    fi.inventory_key,
    dp.product_key,
    dd.date_key,
    dloc.location_key,
    fi.stock_level,
    fi.stock_in,
    fi.stock_out
FROM staging.fact_inventory fi
JOIN dim_product dp ON fi.product_key = dp.product_key
JOIN dim_date dd ON fi.date_key = dd.date_key
JOIN dim_location dloc ON fi.location_key = dloc.location_key;

-- Fact Web Activity
INSERT INTO fact_web_activity (web_activity_key,
    customer_key, date_key, session_id, page_views, duration_seconds, converted
)
SELECT fwa.web_activity_key,
    fwa.customer_key,
    dd.date_key,
    NEWID(),                       
    fwa.page_views,
    fwa.duration_seconds,
    fwa.converted
FROM staging.fact_web_activity fwa
JOIN dim_date dd ON fwa.date_key = dd.date_key;

-- Fact Shipments insert with proper conversion
INSERT INTO fact_shipments (
    shipment_key, sales_key, warehouse_key, shipment_date, delivery_date, delay_days, shipping_cost
)
SELECT 
    f.shipment_key,
    fs.sales_key,                    
    w.warehouse_key,
    f.shipment_date,
    f.delivery_date,
    f.delay_days,
    f.shipping_cost
FROM staging.fact_shipments f
JOIN fact_sales fs ON f.sales_key = fs.sales_key     
JOIN dim_warehouse w ON f.warehouse_key = w.warehouse_key
WHERE 
    f.shipment_date IS NOT NULL AND
    f.delivery_date IS NOT NULL;







