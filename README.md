# Retail Sales Analysis

# 1. Store Background**
A retail store chain tracks daily sales transactions, including order details, customer info, product categories, order times, and order status. The business wants to optimize operations, improve customer experience, and increase profitability using data-driven decisions.

# 2. Short Description / Purpose
Description:
This project focuses on analyzing retail sales data by integrating SQL Server with Power BI to create an interactive, business-ready dashboard. The data is first cleaned and prepared in SQL, then imported into Power BI where key KPIs, trends, customer behavior, and cancellation patterns are visualized using DAX measures.
It helps business stakeholders monitor revenue, identify top products and customers, analyze cancellation behavior, and understand sales trends over time for better decision-making.

# 3. Tech Stack
**Power BI Desktop** : Main Data Visualization platform used for report creation.
**Power Query**: Data Transformation layer for reshaping and  prepating the data .
**DAX (Data Anaysis Expression)** : Used for calculating Total Revenue , Total Quantity Sold and Total orders.
**SQL Server** : It is used for data cleaning and analysis.

# 4. Feature Highlights

**i. Business Problem Statement**
The store doesn’t have a clear idea about :-
1.	which products sell the most,
2.	customers preference,
3.	which items bring in the most profit,and
4.	where things are going wrong indelivery or operations. Because of this, they aremissing chances to earnmore, losing customers, andmaking poor businessdecisions.

**ii. Solution**
Provide real-time sales insights
✔ Enable data-driven decision making
✔ Reduce dependency on manual reporting
✔ Identify revenue leakage due to cancellations

**iii. Key Visuals**
📄 Page 1: Sales Overview

Goal: High-level performance snapshot

Visual	
1. KPI Cards	Quickly show Total Revenue, Orders & Quantity
2. Donut Chart (Payment Mode)	Understand customer payment preference
3. Bar Chart (Category vs Revenue)	Identify high-revenue categories
   
📄 Page 2: Top Products Analysis

Goal: Product-level performance & risk analysis

Visual	 
1. Bar Chart (Top 5 Products by Quantity)	Identify best-selling products
2. Bar Chart (Top 5 Cancelled Products)	Detect problematic products
3. Status Slicer	Filter completed vs cancelled orders

📄 Page 3: Time & Trend Analysis

Goal: Sales behavior over time

Visual	
1. Line Chart (Monthly Revenue)	Identify seasonal trends
2. Column Chart (Time of Day vs Orders)	Optimize business hours

Custom Time of Day logic improves operational insights.

📄 Page 4: Customer Insights

Goal: Customer segmentation

Visual	
1. Table (Top 5 Customers by Spend)	Identify high-value customers
2. Bar Chart (Age Group vs Purchases)	Understand buying behavior by age

Age grouping helps in targeted marketing strategies.

📄 Page 5: Category & Gender Analysis

Goal: Demographic performance analysis

Visual	
1. Matrix (Category × Gender)	Compare purchase patterns
2. Bar Chart (Cancellation Rate %)	Identify categories with high cancellations

# 5. Snapshot Of a DashBoard

