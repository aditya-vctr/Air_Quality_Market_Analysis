# 🌍 Air Quality Market Strategy Analysis

## 📌 Project Overview
**Client:** AirPure Innovations  
**Role:** Data Analyst  
**Tools:** SQL Server, Excel, Power BI  

AirPure Innovations, a startup in the air purification sector, required a data-driven strategy to enter the Indian market. This project analyzes pollution levels (AQI), public health data (IDSP), and vehicle registration data (Vahan) to determine **where to sell**, **what to sell**, and **how to market** their products.

## 🔍 Problem Statement
The client faced three critical uncertainties:
1.  **Target Markets:** Which cities have the most toxic air? [cite: 2]
2.  **Product Design:** Should the filters target Dust (PM10) or Smoke (PM2.5)? [cite: 53]
3.  **Marketing Strategy:** How to sell in "cleaner" cities like Bengaluru or to EV owners? [cite: 168]

## 📊 Key Insights & Solutions

### 1. The "EV Paradox"
* **Hypothesis:** States with high Electric Vehicle (EV) adoption should have cleaner air.
* **Data Reality:** Uttar Pradesh and Delhi have the highest EV registrations but still suffer from "Poor" to "Severe" AQI levels[cite: 326].
* **Strategy:** Target EV owners with the message: *"You bought an EV to save the planet, but the planet hasn't saved you yet. You still need protection."* [cite: 330]

### 2. The "Invisible Killer" in Bengaluru
* **Finding:** Bengaluru rarely sees "Poor" AQI days but has persistent "Satisfactory/Moderate" levels[cite: 199].
* **Strategy:** Shift marketing from "Fear of Smoke" to "Health & Wellness," positioning the product as a lifestyle necessity rather than an emergency fix for visible smog[cite: 201].

### 3. South India Filter Requirements
* **Analysis:** Pollutant frequency analysis revealed that PM10 (Dust) and PM2.5 (Smoke) are the dominant pollutants in Southern states[cite: 72].
* **Recommendation:** A simple Carbon filter is insufficient. [cite_start]The product MUST include a **HEPA filter** to trap fine particulate matter[cite: 72].

### 4. Market Prioritization Matrix
Calculated a **City Risk Score** based on:
`Risk Score = (AQI Severity × Population Density × Disposable Income Proxy)` [cite: 483]
* **Top Priority Markets:** Delhi, Uttar Pradesh (High Volume).
* **Secondary Markets:** Bengaluru, Pune (High Purchasing Power)[cite: 514].

## 🛠️ Technical Approach
* **Data Cleaning:** Filtered data for "Post-Covid" trends (2022 onwards) to ensure relevance[cite: 51].
* **SQL Techniques:**
    * **CTEs (Common Table Expressions):** Used to merge Health and Pollution datasets[cite: 212].
    * **Window Functions (`DENSE_RANK`):** Used to rank top diseases per state[cite: 225].
    * **Date Functions:** Used `DATENAME` to analyze "Weekend vs. Weekday" pollution trends[cite: 86].
* **Dashboarding:** Created a Market Prioritization Matrix to visualize high-value territories.

## 📂 File Structure
* `SQL_Scripts.sql`: Contains all queries used for the analysis (Data extraction, cleaning, and aggregation).
* `Project_Documentation.pdf`: Detailed report containing the problem background, query logic, and extended business insights.

---

*This project was created as part of a Data Analytics Portfolio.*
