import pandas as pd
import numpy as np
from faker import Faker
import random
import datetime

fake = Faker()

def generate_dim_date(start_year=2019, end_year=2022):
    start_date = datetime.date(start_year, 1, 1)
    end_date = datetime.date(end_year, 12, 31)
    dates = pd.date_range(start=start_date, end=end_date).to_pydatetime().tolist()
    data = []
    for dt in dates:
        data.append({
            'date_key': dt.date(),
            'day': dt.day,
            'month': dt.month,
            'quarter': (dt.month - 1) // 3 + 1,
            'year': dt.year,
            'day_of_week': dt.strftime('%A'),
            'is_weekend': 1 if dt.weekday() >= 5 else 0
        })
    return pd.DataFrame(data)

def generate_dim_customer(num_customers=10000):
    data = []
    loyalty_statuses = ['Bronze', 'Silver', 'Gold', 'Platinum']
    segments = ['Segment A', 'Segment B', 'Segment C']
    regions = ['North', 'South', 'East', 'West']

    for i in range(num_customers):
        data.append({
            'customer_key': i + 1,
            'customer_id': fake.unique.uuid4(),
            'first_name': fake.first_name(),
            'last_name': fake.last_name(),
            'email': fake.email(),
            'loyalty_status': random.choice(loyalty_statuses),
            'segment': random.choice(segments),
            'region': random.choice(regions)
        })
    return pd.DataFrame(data)

def generate_dim_product(num_products=1000):
    data = []
    categories = ['Electronics', 'Apparel', 'Home Goods', 'Sports', 'Toys']
    brands = ['BrandX', 'BrandY', 'BrandZ', 'BrandA']
    supplier_ids = [f'SUP{str(i).zfill(4)}' for i in range(1, 201)]

    for i in range(num_products):
        data.append({
            'product_key': i + 1,
            'product_id': f'PROD{str(i+1).zfill(6)}',
            'product_name': fake.word().title(),
            'category': random.choice(categories),
            'brand': random.choice(brands),
            'supplier_id': random.choice(supplier_ids)
        })
    return pd.DataFrame(data)

def generate_dim_campaign(num_campaigns=100):
    data = []
    campaign_types = ['Email', 'Social Media', 'TV', 'Radio', 'Billboard']
    start_date = datetime.date(2019, 1, 1)
    end_date = datetime.date(2022, 12, 31)

    for i in range(num_campaigns):
        sd = fake.date_between(start_date=start_date, end_date=end_date - datetime.timedelta(days=30))
        ed = sd + datetime.timedelta(days=random.randint(7, 60))
        data.append({
            'campaign_key': i + 1,
            'campaign_id': f'CAMPAIGN{str(i+1).zfill(4)}',
            'campaign_name': f'Campaign {i+1}',
            'campaign_type': random.choice(campaign_types),
            'start_date': sd,
            'end_date': ed,
            'budget': round(random.uniform(5000, 50000), 2)
        })
    return pd.DataFrame(data)

def generate_dim_location(num_locations=50):
    data = []
    for i in range(num_locations):
        data.append({
            'location_key': i + 1,
            'store_id': f'STORE{str(i+1).zfill(4)}',
            'city': fake.city(),
            'state': fake.state(),
            'country': fake.country(),
            'warehouse_flag': random.choice([0, 1])
        })
    return pd.DataFrame(data)

def generate_dim_supplier(num_suppliers=200):
    data = []
    for i in range(num_suppliers):
        data.append({
            'supplier_key': i + 1,
            'supplier_id': f'SUP{str(i+1).zfill(4)}',
            'supplier_name': fake.company(),
            'contact_email': fake.company_email(),
            'contact_phone': fake.phone_number()
        })
    return pd.DataFrame(data)

def generate_dim_payment_method():
    methods = ['Credit Card', 'PayPal', 'AfterPay', 'Bank Transfer', 'Gift Card']
    data = []
    for i, method in enumerate(methods):
        data.append({
            'payment_method_key': i + 1,
            'payment_method_id': f'PM{str(i+1).zfill(3)}',
            'method_name': method,
            'card_type': random.choice(['Visa', 'MasterCard', 'Amex', None]),
            'created_at': datetime.datetime.utcnow()
        })
    return pd.DataFrame(data)

def generate_dim_address(num_addresses=1000):
    data = []
    for i in range(num_addresses):
        data.append({
            'address_key': i + 1,
            'address_id': f'ADDR{str(i+1).zfill(4)}',
            'street': fake.street_address(),
            'city': fake.city(),
            'state': fake.state(),
            'postcode': fake.postcode(),
            'country': fake.country()
        })
    return pd.DataFrame(data)

def generate_dim_warehouse(num_warehouses=20, num_addresses=1000):
    address_keys = list(range(1, num_addresses + 1))

    city_region_country = [
        ("Sydney", "NSW", "Australia"),
        ("Melbourne", "VIC", "Australia"),
        ("Brisbane", "QLD", "Australia"),
        ("Perth", "WA", "Australia"),
        ("Adelaide", "SA", "Australia"),
        ("Auckland", "AUK", "New Zealand"),
        ("Wellington", "WLG", "New Zealand"),
        ("London", "ENG", "United Kingdom"),
        ("Toronto", "ON", "Canada"),
        ("New York", "NY", "USA")
    ]

    data = []
    for i in range(num_warehouses):
        city, region, country = random.choice(city_region_country)
        data.append({
            'warehouse_key': i + 1,
            'warehouse_id': f'WH{str(i+1).zfill(4)}',
            'address_key': random.choice(address_keys),
            'city': city,
            'region': region,
            'country': country,
            'sla_days': random.randint(1, 7),
            'created_at': datetime.datetime.utcnow()
        })

    df = pd.DataFrame(data)
    return df

def generate_dim_marketing_segment():
    segments = [
        {'segment_key': 1, 'segment_id': 'SEG001', 'segment_name': 'High Value', 'segment_description': 'Frequent high spenders'},
        {'segment_key': 2, 'segment_id': 'SEG002', 'segment_name': 'Promo Sensitive', 'segment_description': 'Responsive to discounts'},
        {'segment_key': 3, 'segment_id': 'SEG003', 'segment_name': 'Churn Risk', 'segment_description': 'At risk of churning'}
    ]
    return pd.DataFrame(segments)

def main():
    generate_dim_date().to_csv('../raw_data/dim_date.csv', index=False)
    generate_dim_customer().to_csv('../raw_data/dim_customer.csv', index=False)
    generate_dim_product().to_csv('../raw_data/dim_product.csv', index=False)
    generate_dim_campaign().to_csv('../raw_data/dim_campaign.csv', index=False)
    generate_dim_location().to_csv('../raw_data/dim_location.csv', index=False)
    generate_dim_supplier().to_csv('../raw_data/dim_supplier.csv', index=False)
    generate_dim_payment_method().to_csv('../raw_data/dim_payment_method.csv', index=False)
    generate_dim_address().to_csv('../raw_data/dim_address.csv', index=False)
    generate_dim_warehouse().to_csv('../raw_data/dim_warehouse.csv', index=False)
    generate_dim_marketing_segment().to_csv('../raw_data/dim_marketing_segment.csv', index=False)

main()
