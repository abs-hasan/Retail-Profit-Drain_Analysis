
---
## 📊 Q1: Who are our most valuable customers (lifetime value)?
**▶️ Script:** [`customer_lifetime_value.sql`](https://github.com/abs-hasan/Retail-Profit-Drain_Analysis/blob/main/Retail-Profit-Drain-Analysis/analysis/1.customer_lifetime_value.sql)

**📊 Sample Output:**
| customer_key | total_orders | total_spent | total_returns | net_spent | active_days | avg_spend_per_order |
|--------------|--------------|-------------|---------------|-----------|-------------|---------------------|
| 2630         | 5            | 5726.65     | 705.03        | 5021.62   | 750         | 1004.32             |
| 2636         | 3            | 4729.99     | 72.86         | 4657.13   | 677         | 1552.38             |
| 4922         | 3            | 4608.50     | 0.00          | 4608.50   | 423         | 1536.17             |
| 1319         | 4            | 4597.87     | 0.00          | 4597.87   | 568         | 1149.47             |
| 4603         | 4            | 5414.42     | 1011.68       | 4402.74   | 569         | 1100.69             |

**💡 Insight:**
- Identified top VIP customers by net spend.
- Long-term loyal customers spend consistently high per order, indicating strong retention potential.


**✅ Next Action:**
- Use this segment for loyalty and early access campaigns to further reward and retain them.
- **Further Analysis:** Segment these VIPs into CLV tiers (e.g., Platinum, Gold) and analyze their specific product preferences, engagement patterns, and marketing responsiveness for hyper-targeted strategies.

---

## ↺ Q2: How many customers are active, dormant, or at risk of churn?
**▶️ Script:** [`churn_risk_by_segment.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/2.churn_risk_by_segment.sql)

**📊 Churn Distribution:**
| churn_status        | customer_count |
|---------------------|----------------|
| At Risk (180+d)     | 1774           |
| Active (=90d)       | 237            |
| Dormant (91–179d)   | 217            |

**💡 Insight:**
- Nearly **77% of customers are at risk of churn or dormant**, posing a significant threat to long-term profitability. This highlights a critical need for proactive retention efforts.

**✅ Next Action:**
- Launch win-back campaigns for dormant and at-risk segments, tailored with incentives.
- **Further Analysis:** Cross-reference "At Risk" customers with their purchase history and interaction data (from Q1, Q4, Q8, Q9) to uncover specific triggers for churn, such as high return rates, delayed shipments, or lack of recent engagement. Prioritize retention efforts on high-CLV customers at risk.

---

## 📢 Q3: Campaign ROI Analysis
**▶️ Script:** [`campaign_roi_analysis.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/3_campaign_roi_analysis.sql)

**🔍 Business Question** Which marketing campaigns are yielding the lowest ROI?

**📊 Sample Output:**
| campaign_key | total_revenue | units_sold | unique_customers | campaign_name                      | campaign_type | start_date | end_date   | total_spend | total_impressions | roas | cpa |
|--------------|---------------|------------|------------------|------------------------------------|---------------|------------|------------|-------------|-------------------|------|-----|
| 64           | 5751.96       | 25         | 11               | Synchronized executive superstructure | Referral      | 2023-09-06 | 2025-06-07 | 28257.73    | 452956            | 0.20 | 2568.88 |
| 120          | 9349.66       | 29         | 9                | Ameliorated holistic task-force    | Referral      | 2024-04-12 | 2024-05-29 | 36937.19    | 633103            | 0.25 | 4104.13 |
| 4            | 6106.94       | 26         | 9                | Expanded national alliance         | Referral      | 2024-04-02 | 2025-01-24 | 22230.99    | 302211            | 0.27 | 2470.11 |
| 132          | 5850.22       | 28         | 10               | Cloned bifurcated project          | Referral      | 2024-01-24 | 2025-08-09 | 21480.61    | 422895            | 0.27 | 2148.06 |
| 151          | 3272.58       | 14         | 7                | Inverse scalable help-desk         | Referral      | 2025-07-18 | 2025-07-24 | 11335.41    | 170121            | 0.29 | 1619.34 |

**💡 Insight:**
- Several referral campaigns have **very poor ROAS (< 0.3)** and **sky-high CPA (> $2,000)**, indicating significant wasted marketing spend.

**✅ Next Action:**
- Immediately **pause or redesign** these underperforming campaigns to prevent further profit drain.
- **Further Analysis:** Move beyond ROAS to **POAS (Profit Over Ad Spend)** by factoring in COGS and returns. This provides a truer measure of marketing campaign effectiveness. Explore multi-touch attribution to understand the full customer journey impact.

---

## ↺ Q4: Return Rate by Product
**▶️ Script:** [`return_rate_by_product.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/4._return_rate_by_product.sql)

**🔍 Business Question** Which products are being returned most, and how do they affect profitability?

**📊 Sample Output:**
| product_key | product_name           | category        | total_sold | total_returned | return_rate_pct |
|-------------|------------------------|-----------------|------------|----------------|-----------------|
| 344         | Society Electronic     | Electronics     | 21         | 7              | 33.33           |
| 1175        | Despite Beaut          | Beauty          | 25         | 6              | 24.00           |
| 328         | Later Home Appliance   | Home Appliances | 23         | 5              | 21.74           |
| 644         | Often Beaut            | Beauty          | 21         | 4              | 19.05           |
| 1388        | Important Home Appliance | Home Appliances | 22         | 3              | 13.64           |

**💡 Insight:**
- Some products have a **return rate above 30%**, signaling potential quality, fit, or expectation issues that directly impact gross margins.

**✅ Next Action:**
- Perform quality audits and in-depth reviews of customer complaints/feedback for these high-return SKUs to address root causes.
- **Further Analysis:** Calculate the **true net profitability per product**, including COGS and estimated return processing costs. This will show which high-return products are genuine profit drains versus those with high volume that can absorb returns.

---

## 📦 Q5: Inventory Drift Analysis
**▶️ Script:** [`inventory_drift_analysis.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/5_inventory_drift_analysis.sql)

**🔍 Business Question** Which products are being sold more than they are restocked — creating a risk of stockouts or forecasting error?

**📊 Sample Output:**
| product_key | product_name       | category    | total_sold | total_available | drift_units | drift_pct |
|-------------|--------------------|-------------|------------|-----------------|-------------|-----------|
| 28          | Total Clothin      | Clothing    | 23         | 0               | 23          | 100.00    |
| 1371        | Thus Furnitur      | Furniture   | 21         | 0               | 21          | 100.00    |
| 909         | Million Electronic | Electronics | 22         | 0               | 22          | 100.00    |
| 814         | Follow Clothin     | Clothing    | 21         | 0               | 21          | 100.00    |

**💡 Insight:**
- High-selling products like `Total Clothin` and `Million Electronic` have **zero stock replenishment**, showing **100% drift**, indicating critical stockout risks and significant forecasting errors. This directly impacts potential sales and customer satisfaction.

**✅ Next Action:**
- Conduct immediate demand-supply review for these SKUs and implement urgent reordering.
- **Further Analysis:** Quantify the **opportunity cost** of lost sales due to stockouts for these high-drift products. Conversely, identify products with significant *positive* drift (overstocking) and quantify their **inventory holding costs** to address capital tied up in slow-moving inventory.

---

## 🌎 Q6: Profit by State
**▶️ Script:** [`profit_by_state.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/6.profit_by_state.sql)

**🔍 Business Question** Which U.S. states are generating the highest net revenue after returns?

**📊 Sample Output:**
| state         | total_orders | gross_revenue | total_returns | net_revenue | avg_order_value |
|---------------|--------------|---------------|---------------|-------------|-----------------|
| Michigan      | 142          | 107438.36     | 12423.25      | 95015.11    | 669.12          |
| West Virginia | 107          | 79549.64      | 4621.57       | 74928.07    | 700.26          |
| Indiana       | 100          | 81948.92      | 8542.69       | 73406.23    | 734.06          |
| Illinois      | 94           | 75790.74      | 6833.95       | 68956.79    | 733.58          |
| Idaho         | 123          | 77906.65      | 9485.20       | 68421.45    | 556.27          |

**💡 Insight:**
- Michigan and West Virginia are the top-performing states based on **net profit**, suggesting strong market fit or operational efficiency in these regions.

**✅ Next Action:**
- Consider allocating more targeted marketing budget or inventory to these high-performing states to capitalize on their potential.
- **Further Analysis:** Investigate what differentiates these top states from lower performers. Are there correlations with specific store types (Q7), lower return rates (Q4), or better delivery efficiency (Q8)? This could reveal best practices to replicate.

---

## 🏬 Q7: Profit by Store Type
**▶️ Script:** [`profit_by_store.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/7.profit_by_store.sql)

**🔍 Business Question** Do warehouse stores generate more net revenue than retail outlets?

**📊 Sample Output:**
| store_type   | total_orders | gross_revenue | total_returns | net_revenue   | avg_order_value |
|--------------|--------------|---------------|---------------|---------------|-----------------|
| Warehouse    | 1517         | 1152968.21    | 121084.83     | 1031883.38    | 680.21          |
| Retail Store | 1443         | 1062126.31    | 106577.26     | 955549.05     | 662.20          |

**💡 Insight:**
- Warehouses generate higher revenue and average order value compared to retail stores, suggesting potential cost efficiencies or higher volume capacity for larger orders.

**✅ Next Action:**
- Assess if shifting more operational focus or expanding warehouse capabilities could improve overall margins.
- **Further Analysis:** Explore if warehouse vs. retail store performance varies significantly by **product category** or **state/region** (connecting to Q4 and Q6). Identify specific cost drivers within each store type to pinpoint areas for operational efficiency improvements.

---

## 🚚 Q8: Shipping Delay and Risk Impact
**▶️ Script:** [`shipping_delay_impact.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/8.shipping_delay_impact.sql)

**🔍 Business Question** Which products are facing shipping delays, and could they contribute to higher returns or churn?

**📊 Sample Output:**
| product_key | product_name            | category        | delayed_orders | avg_delay | late_shipments |
|-------------|-------------------------|-----------------|----------------|-----------|----------------|
| 7           | Day Furnitur            | Furniture       | 1              | 5.0       | 1              |
| 10          | Identify Home Appliance | Home Appliances | 1              | 5.0       | 1              |
| 3           | How Electronic          | Electronics     | 1              | 5.0       | 1              |
| 15          | Town Clothin            | Clothing        | 1              | 5.0       | 1              |
| 30          | Section Electronic      | Electronics     | 1              | 5.0       | 1              |

**💡 Insight:**
- A few products show consistent delays over **3+ days**, indicating potential logistical bottlenecks or supplier issues for these specific SKUs.

**✅ Next Action:**
- Monitor shipping delay trends for these affected products and audit their fulfillment process to identify root causes.
- **Further Analysis:** Beyond correlation, investigate the *exact reason* for these delays (e.g., origin warehouse, specific carrier, order volume spikes). Implement process improvements or engage with new logistics partners to mitigate future delays.

---

## 🔁 Q9: Shipping Delay vs Return Rate
**▶️ Script:** [`shipping_delay_vs_return.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/9.shipping_delay_vs_return.sql)

**🔍 Business Question** Are delayed shipments (>3 days) more likely to result in returned products?

**📊 Sample Output:**
| shipping_status   | total_orders | returned_orders | return_rate_pct |
|-------------------|--------------|-----------------|-----------------|
| On-time (=3 days) | 1189         | 224             | 18.84           |
| Delayed (>3 days) | 623          | 129             | 20.71           |

**💡 Insight:**
- Orders delayed over 3 days have a **higher return rate (20.7%)** compared to on-time orders (18.8%), clearly showing that shipping delays contribute to profit erosion through increased returns.

**✅ Next Action:**
- Reprioritize logistics strategies to significantly reduce shipping delays, directly impacting return rates and improving customer satisfaction.
- **Further Analysis:** Combine this with CLV data (Q1). Do delayed shipments disproportionately affect high-value customers, potentially accelerating churn (Q2)? Quantify the revenue risk associated with these delay-linked returns across different customer segments and product categories.

---

## 💣 Q10: Low Revenue Per Unit Products (Profit Risk)

**▶️ Script:** [`revenue_per_unit_net.sql`](https://github.com/abs-hasan/testtesttest/blob/main/Retail-Profit-Drain-Analysis/analysis/10.%20Revenue%20Per%20Unit.sql)

**🔍 Business Question:** Which popular products are generating weak returns **per unit sold** — and might be driving hidden margin losses?

**📊 Sample Output:**
| product_key | product_name           | category        | order_count | units_sold | total_revenue | total_returns | net_revenue | revenue_per_unit |
|-------------|------------------------|-----------------|-------------|------------|---------------|---------------|-------------|------------------|
| 909         | Million Electronic     | Electronics     | 7           | 22         | 1289.91       | 105.93        | 1183.98     | 53.82            |
| 1371        | Thus Furnitur          | Furniture       | 5           | 21         | 3814.05       | 450.50        | 3363.55     | 160.17           |
| 859         | Whatever Beaut         | Beauty          | 6           | 21         | 3705.96       | 76.42         | 3629.54     | 172.84           |
| 328         | Later Home Appliance   | Home Appliances | 6           | 23         | 5153.16       | 1176.89       | 3976.27     | 172.88           |
| 1031        | Avoid Beaut            | Beauty          | 7           | 20         | 4003.46       | 411.66        | 3591.80     | 179.59           |

**💡 Insight:**
- Among top-selling SKUs, we found several with **very low net revenue per unit** (e.g., `Million Electronic` at $53.82 per unit after returns).
- Despite decent sales volume, their **adjusted earnings are weak**, likely due to excessive promotions, high return rates (as seen with `Society Electronic` which lost over $2,000 due to returns), or poor initial pricing strategies. These products are silently eroding profit margins.

**✅ Next Action:**
- Flag these SKUs for **urgent margin improvement audits**:
  - Re-evaluate **pricing and discounting policies** to ensure adequate profitability.
  - Conduct **targeted cost renegotiations with suppliers** for products with thin margins.
  - **Re-evaluate marketing campaigns** for these products to ensure they're not driving unprofitable sales.
- **Further Analysis:** Model product-level **POAS (Profit over Ad Spend)** for these low-revenue-per-unit products, and analyze their overall contribution to net profit across different channels and regions (Q6 & Q7).

---
