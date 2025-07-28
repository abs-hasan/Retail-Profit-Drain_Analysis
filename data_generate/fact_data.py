import pandas as pd
import numpy as np
import random
from faker import Faker
from datetime import timedelta
import uuid
import os

fake = Faker()

# Load dimension tables
dim_customer = pd.read_csv("../raw_data/dim_customer.csv")
dim_product = pd.read_csv("../raw_data/dim_product.csv")
dim_campaign = pd.read_csv("../raw_data/dim_campaign.csv")
dim_date = pd.read_csv("../raw_data/dim_date.csv")
dim_location = pd.read_csv("../raw_data/dim_location.csv")
dim_warehouse = pd.read_csv("../raw_data/dim_warehouse.csv")

# FACT 1: fact_sales
def generate_fact_sales(n=5000):
    rows = []
    for i in range(n):

        customer = dim_customer.sample(1).iloc[0]
        product = dim_product.sample(1).iloc[0]
        campaign = dim_campaign.sample(1).iloc[0]
        date = dim_date.sample(1).iloc[0]
        location = dim_location.sample(1).iloc[0]

        quantity = random.randint(1, 5)
        unit_price = round(random.uniform(10, 500), 2)
        discount = round(random.uniform(0, unit_price * quantity * 0.3), 2)
        total = round(unit_price * quantity - discount, 2)
        payment_method = random.choice(["Visa", "MasterCard", "PayPal", "Afterpay", "Cash"])

        rows.append({
            "sales_key": i + 1,
            "order_id": f"O-{uuid.uuid4().hex[:8]}",
            "customer_key": customer["customer_key"],
            "product_key": product["product_key"],
            "campaign_key": campaign["campaign_key"],
            "date_key": date["date_key"],
            "quantity": quantity,
            "unit_price": unit_price,
            "discount_amount": discount,
            "total_amount": total,
            "location_key": location["location_key"],
            "payment_method": payment_method,
            "created_at": pd.Timestamp.now()
        })
    return pd.DataFrame(rows)

# FACT 2: fact_returns
def generate_fact_returns(sales_df, n=1000):
    rows = []
    for i in range(n):
        sale = sales_df.sample(1).iloc[0]
        date_index = dim_date[dim_date["date_key"] >= sale["date_key"]].sample(1).iloc[0]
        quantity_returned = random.randint(1, min(3, sale["quantity"]))
        return_amount = round((sale["unit_price"] * quantity_returned) * random.uniform(0.8, 1), 2)

        rows.append({
            "return_key": i + 1,
            "return_id": f"R-{uuid.uuid4().hex[:8]}",
            "sales_key": sale["sales_key"],
            "product_key": sale["product_key"],
            "date_key": date_index["date_key"],
            "quantity_returned": quantity_returned,
            "return_amount": return_amount,
            "return_reason": random.choice(["Damaged", "Wrong Size", "Late Delivery", "Changed Mind"]),
            "created_at": pd.Timestamp.now()
        })
    return pd.DataFrame(rows)

# FACT 3: fact_marketing
def generate_fact_marketing(n=1000):
    rows = []
    for i in range(n):
        campaign = dim_campaign.sample(1).iloc[0]
        date = dim_date.sample(1).iloc[0]
        impressions = random.randint(1000, 100000)
        clicks = int(impressions * random.uniform(0.01, 0.15))
        conversions = int(clicks * random.uniform(0.05, 0.3))
        spend = round(impressions * random.uniform(0.01, 0.10), 2)

        rows.append({
            "marketing_key": i + 1,
            "campaign_key": campaign["campaign_key"],
            "date_key": date["date_key"],
            "spend_amount": spend,
            "impressions": impressions,
            "clicks": clicks,
            "conversions": conversions,
            "created_at": pd.Timestamp.now()
        })
    return pd.DataFrame(rows)

# FACT 4: fact_inventory
def generate_fact_inventory(n=3000):
    rows = []
    for i in range(n):
        product = dim_product.sample(1).iloc[0]
        date = dim_date.sample(1).iloc[0]
        location = dim_location.sample(1).iloc[0]

        stock_in = random.randint(10, 500)
        stock_out = random.randint(5, stock_in)
        stock_level = max(0, stock_in - stock_out)

        rows.append({
            "inventory_key": i + 1,
            "product_key": product["product_key"],
            "date_key": date["date_key"],
            "location_key": location["location_key"],
            "stock_level": stock_level,
            "stock_in": stock_in,
            "stock_out": stock_out,
            "created_at": pd.Timestamp.now()
        })
    return pd.DataFrame(rows)

# FACT 5: fact_web_activity
def generate_fact_web_activity(n=3000):
    rows = []
    for i in range(n):
        customer = dim_customer.sample(1).iloc[0]
        date = dim_date.sample(1).iloc[0]
        duration = random.randint(30, 900)
        page_views = random.randint(1, 15)

        rows.append({
            "web_activity_key": i + 1,
            "customer_key": customer["customer_key"],
            "date_key": date["date_key"],
            "session_id": str(uuid.uuid4()),
            "page_views": page_views,
            "duration_seconds": duration,
            "converted": random.choice([0, 1]),
            "created_at": pd.Timestamp.now()
        })
    return pd.DataFrame(rows)

# FACT 6: fact_shipments
def generate_fact_shipments(sales_df, n=3000):
    rows = []
    for i in range(n):
        sale = sales_df.sample(1).iloc[0]
        shipment_date = pd.to_datetime(sale["date_key"]) + timedelta(days=random.randint(1, 3))
        delay_days = random.randint(0, 5)
        delivery_date = shipment_date + timedelta(days=delay_days)
        warehouse = dim_warehouse.sample(1).iloc[0]

        rows.append({
            "shipment_key": i + 1,
            "sales_key": sale["sales_key"],
            "warehouse_key": warehouse["warehouse_key"],
            "shipment_date": shipment_date.date(),
            "delivery_date": delivery_date.date(),
            "delay_days": delay_days,
            "shipping_cost": round(random.uniform(5, 50), 2),
            "created_at": pd.Timestamp.now()
        })
    return pd.DataFrame(rows)

# Generate all fact tables
fact_sales_df = generate_fact_sales()
fact_returns_df = generate_fact_returns(fact_sales_df)
fact_marketing_df = generate_fact_marketing()
fact_inventory_df = generate_fact_inventory()
fact_web_activity_df = generate_fact_web_activity()
fact_shipments_df = generate_fact_shipments(fact_sales_df)

# Save all
fact_sales_df.to_csv("../raw_data/fact_sales.csv", index=False)
fact_returns_df.to_csv("../raw_data/fact_returns.csv", index=False)
fact_marketing_df.to_csv("../raw_data/fact_marketing.csv", index=False)
fact_inventory_df.to_csv("../raw_data/fact_inventory.csv", index=False)
fact_web_activity_df.to_csv("../raw_data/fact_web_activity.csv", index=False)
fact_shipments_df.to_csv("../raw_data/fact_shipments.csv", index=False)

