# Beyond Revenue: A SQL Deep Dive into Profit Leakage

## 📊 Project Overview

**Beyond Revenue** is an advanced SQL-powered data analytics solution designed to identify and quantify profit leakage in a mid-size omnichannel retail company. Despite growing revenue, particularly through online channels, the company faces stagnating or declining profit margins. This project consolidates disparate data sources into a unified star schema data mart, delivers actionable insights through sophisticated SQL queries, and provides dashboard-ready views to empower data-driven decision-making.

The project focuses on three key areas of profit erosion:
- **High Product Returns**: Impacting gross margins across product categories and channels.
- **Inefficient Marketing Spend**: Low ROI from marketing campaigns.
- **Operational Inefficiencies**: High costs in inventory and returns processing.

## 🎯 Business Impact
By implementing this analytics framework, the company can:
- **Pinpoint Profit Leaks**: Identify specific products, channels, or customer segments driving losses.
- **Optimize Marketing Budgets**: Focus on high-ROI campaigns and customer segments.
- **Reduce Return Rates**: Address problematic products or customer behaviors.
- **Enhance Operational Efficiency**: Streamline inventory and returns processing.
- **Increase Net Profit Margins**: Ensure sustainable growth through data-driven strategies.

## 🔍 Project Objective
To uncover the hidden causes of **profit erosion** in a mid-sized retail operation by using advanced SQL queries to analyze:
- Customer behavior
- Return trends
- Campaign inefficiencies
- Operational costs
- Inventory mismatches

## Database Overview

Before we jump into our work, it would be better if have a look at the data which will be used to complete our task.
<p align="center">
<img src="https://github.com/abs-hasan/Retail-Profit-Drain_Analysis/blob/main/schema/data_model.png" width=70% height=70%> </p>
<br>

## 🧠 Key Business Questions
1. Who are our most valuable customers (lifetime value)?
2. How many customers are at risk of churn?
3. Which campaigns wasted marketing dollars?
4. What products are returned most frequently?
5. Where is inventory not matching demand?
6. Which regions and store types drive the most profit?
7. How does shipping delay affect returns?
8. Does shipping delay increase return likelihood?
9. Which products are facing shipping delays, and could they contribute to higher returns or churn?
10. Which popular products are generating weak returns per unit sold?
---

# Solution
---
Let's Have a look at our solution: [![solution](https://img.shields.io/badge/Final_SQL_Script-green?)](https://github.com/abs-hasan/Retail-Profit-Drain-Analysis/blob/main/Retail-Profit-Drain-Analysis/SOLUTION.md)

---

## 📌 So The Real Question is: Why Is Profit Draining?

From this complete investigation, profit is draining due to **multiple, interconnected factors** that are actively eroding margins:

1.  **Customer Attrition:** A large segment of customers (**nearly 77% at risk or dormant**, Q2) signifies a leaky bucket. This problem is exacerbated if these at-risk customers include high-value individuals (Q1), leading to a significant loss of potential lifetime revenue.
   
2.  **Ineffective Marketing Spend:** Campaigns with **abysmal ROAS and high CPA** (Q3) are wasting valuable marketing dollars, failing to acquire profitable customers and contributing to the overall profit drain.
   
2.  **High Product Return Costs & Low Profitability Per Unit:** Specific products demonstrate **unacceptably high return rates (over 30%** for some, Q4) and also show **extremely low net revenue per unit** (Q10). These products are direct profit drains due to quality issues, expectation gaps, or inadequate pricing strategies.
   
4.  **Operational Supply-Demand Mismatches:** Critical **inventory drift (100% stockout risk** for key products, Q5) means lost sales opportunities. Simultaneously, potential overstocking of other products ties up capital and incurs holding costs.

5.  **Logistical Inefficiencies:** The clear link between **shipping delays and higher return rates** (Q8 & Q9) reveals that inefficient delivery directly translates into increased operational costs and reduced net revenue.

6.  **Regional and Channel Variances:** While warehouse stores generally perform better, the analysis hints at **profitability disparities across states and store types** (Q6 & Q7). This suggests localized inefficiencies or missed opportunities that prevent optimal profit generation.


### 💡 Final Suggestions

The root of the profit drain is a combination of **customer retention failures, inefficient resource allocation (marketing & inventory), product-level profitability issues, and sub-optimal operational logistics.** To address this, the company must:

* Prioritize **proactive churn prevention strategies** targeting high-value customers.
* Immediately **redirect or eliminate low-ROAS marketing campaigns**.
* Conduct **deep dives into high-return AND low-revenue-per-unit products** to fix quality, pricing, or expectation gaps.
* Optimize **inventory forecasting and replenishment** to minimize both stockouts and holding costs.
* Invest significantly in **streamlining shipping and fulfillment processes** to reduce delays and associated returns.
* Analyze **regional and channel-specific profit drivers** to replicate successes and address underperformance.

---
### 🧠 Skills Demonstrated Through This Project

By completing this project, we demonstrated:
- **Database Design**: Created normalized star-schema with well-defined primary and foreign keys
- **Data Modeling**: Mapped real-world business processes into dimensional models
- **ETL Development (via Python)**: Loaded CSV files into SQL tables using Python-based data loaders.[![Script](https://img.shields.io/badge/Python_Script-blue?)](https://github.com/abs-hasan/Retail-Profit-Drain-Analysis/blob/main/Retail-Profit-Drain-Analysis/data_uploading/load_dimensions.py)

- **Advanced SQL**: Window functions, CTEs, joins, aggregations, date logic
- **Dimensional Modeling**: Star schema design with fact & dimension tables
- **Profitability Analysis**: Return rates, campaign ROI, churn metrics, etc.
- **ETL Simulation**: Data summarization and transformation using SQL scripts
- **Performance Optimization**: Filtering, aggregation, best-practice query design
- **Storytelling with Data**: Progressive narrative from data to insights to action

## 🔍 Areas for Improvement

- ❌ No **data pipeline (ETL)** orchestration — consider adding **Airflow or Azure Data Factory**
- ❌ Not connected to **BI dashboards** yet — integrate with Power BI or Tableau for stakeholders
- ❌ Not automated — can add **SQL stored procedures** to refresh data periodically

## 🚀 What’s Next?

- 🔧 **Build an interactive Power BI dashboard** for real-time insights
- 📦 **Package into an Azure Data Factory pipeline** for end-to-end automation
- 🧪 **Incorporate A/B testing or time-series forecasting** (e.g., campaign ROI over time)
- 📈 Add **KPI Alerts** and generate **automated reports via SQL Agent / Fabric**
- 🤖 Future stretch goal: Train a churn prediction model using customer behavior data

