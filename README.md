# 🛍️ Retail & Warranty Sales Analysis – SQL Projects

## 🗂️ Overview  
Dive into two real-world SQL projects focused on uncovering key business insights from **retail** and **warranty** data. From **data cleaning** to **schema design**, this project showcases end-to-end data analytics using SQL.

---

## 📊 Project 1: Retail Sales Analysis  
**📁 Database**: `p1_retail_db`  
**📋 Table**: `retail_sales`

### 🧱 Schema Fields  
`transaction_id`, `sale_date`, `sale_time`, `customer_id`, `gender`, `age`, `category`, `quantity`, `price_per_unit`, `cogs`, `total_sale`

### 🔧 Key Tasks
- 🧹 Cleaned data by removing null/missing values  
- 📦 Analyzed total sales & unique customer count  
- 🧑‍🤝‍🧑 Segmented sales by **category** & **demographics**  
- 💸 Flagged high-value transactions ( > ₹1000)  
- 📅 Monthly sales trends via **window functions**  
- 💰 Identified **Top 5 revenue-generating** customers  
- 🕐 Segmented performance by **sales shifts** (morning/afternoon/evening)

### ✨ Notable Insights
- 👗 *Clothing* & 💄 *Beauty* dominated in revenue  
- 🥇 Top customers = disproportionately high revenue  
- 📈 Seasonal peaks observed in specific months  
- 🌇 *Afternoon* = busiest time slot for sales
---

## 🛠️ Project 2: Store, Product & Warranty Analysis

### 🧱 Schema Design (Relational DB with Indexes & FKs)  
- 🏬 `stores(store_id, store_name, city, country)`  
- 🏷️ `category(category_id, category_name)`  
- 📦 `products(product_id, product_name, category_id, launch_date, price)`  
- 💰 `sales(sale_id, sale_date, store_id, product_id, quantity)`  
- 🛠️ `warranty(claim_id, claim_date, sale_id, repair_status)`

### 🔧 Key Tasks
- 🏪 Total units sold per store  
- 🔍 Warranty claim rates & "Warranty Void" analysis  
- 📉 Least-selling products by **country**  
- ⏳ Time-based sales pattern & store activity  
- 📆 Claims within 180 days of sale  
- 🚀 Warranty analysis for recently launched products  
- ⚡ Indexed columns for faster queries

### ✨ Notable Insights
- 🏅 Certain stores consistently excelled in sales  
- 📊 Newly launched products had higher claim rates  
- 🇺🇸 Sales spikes across USA in specific months  
- 🚫 Over 10% of claims marked as **Warranty Void**

---

## 🗃️ Files Included
- `PROJECT 1.sql` → Retail DB setup + analysis  
- `PROJECT 2.sql` → Multi-table schema + deep dive + insights

---

## 💼 Skills Demonstrated
- ✅ Data Cleaning & Validation  
- ✅ Complex SQL Queries  
- ✅ Joins | Subqueries | Window Functions  
- ✅ Time-based Aggregations  
- ✅ Schema Design & Normalization  
- ✅ Indexing for Performance  
- ✅ Insight-Driven Analysis

