/*
Project: Air Quality Market Analysis for AirPure Innovations
Created By: Aditya Raj
Tool Used: SQL Server
Description: This script analyzes pollution (AQI), health (IDSP), and vehicle (Vahan) data 
to formulate a market entry strategy.
*/

USE AirQualityProject;

-- ---------------------------------------------------------
-- Q1: TARGET MARKET IDENTIFICATION (The "Most Polluted" List)
-- Objective: Identify top 5 cities with highest average AQI to locate high-demand areas.
-- Logic: Filter for Winter 2024-2025 data where pollution peaks.
-- ---------------------------------------------------------
SELECT TOP 5
    state,
    area,
    AVG(aqi_value) as Average_AQI
FROM aqi_final
WHERE date >= '2024-12-01' AND date <= '2025-05-31'
GROUP BY state, area
ORDER BY Average_AQI DESC;

-- ---------------------------------------------------------
-- Q2: PRODUCT STRATEGY (Filter Selection for South India)
-- Objective: Determine if HEPA or Carbon filters are needed based on prominent pollutants.
-- Insight: High PM10/PM2.5 counts indicate a need for HEPA filters over simple Carbon ones.
-- ---------------------------------------------------------
SELECT
    state,
    prominent_pollutants,
    COUNT(*) as Frequency
FROM aqi_final
WHERE state IN ('Andhra Pradesh', 'Karnataka', 'Kerala', 'Tamil Nadu', 'Telangana')
  AND date >= '2022-01-01' -- Post-Covid Era Analysis
GROUP BY state, prominent_pollutants
ORDER BY state, Frequency DESC;

-- ---------------------------------------------------------
-- Q3: MARKETING TIMING (The "Weekend Effect")
-- Objective: Check if pollution drops on weekends to adjust marketing messaging.
-- Insight: If pollution stays high on weekends, market as a "24/7 Home Necessity".
-- ---------------------------------------------------------
SELECT
    area AS City,
    CASE
        WHEN DATENAME(WEEKDAY, date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    AVG(aqi_value) AS Average_AQI
FROM aqi_final
WHERE area IN ('Delhi', 'Mumbai', 'Chennai', 'Kolkata', 'Bengaluru', 'Hyderabad', 'Ahmedabad', 'Pune')
  AND date >= '2024-05-01' -- Last 1 Year
GROUP BY
    area,
    CASE
        WHEN DATENAME(WEEKDAY, date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY area, Day_Type;

-- ---------------------------------------------------------
-- Q4: SEASONALITY ANALYSIS (When to launch?)
-- Objective: Find the month with the worst AQI for the top 10 states to time ad campaigns.
-- ---------------------------------------------------------
WITH TopStates AS (
    SELECT TOP 10 state
    FROM aqi_final
    GROUP BY state
    ORDER BY COUNT(DISTINCT area) DESC
)
SELECT
    state,
    DATENAME(MONTH, date) as Month_Name,
    MONTH(date) as Month_Number,
    AVG(aqi_value) as Average_AQI
FROM aqi_final
WHERE state IN (SELECT state FROM TopStates)
GROUP BY state, DATENAME(MONTH, date), MONTH(date)
ORDER BY state, Average_AQI DESC;

-- ---------------------------------------------------------
-- Q5: HIDDEN MARKET OPPORTUNITIES (Bengaluru Deep Dive)
-- Objective: Analyze AQI categories in Bengaluru.
-- Insight: "Satisfactory" levels imply invisible pollution; Marketing must focus on "Health" not "Smog".
-- ---------------------------------------------------------
SELECT
    air_quality_status AS Category,
    COUNT(*) AS Number_of_Days
FROM aqi_final
WHERE area = 'Bengaluru'
  AND date >= '2025-03-01' AND date <= '2025-05-31'
GROUP BY air_quality_status
ORDER BY Number_of_Days DESC;

-- ---------------------------------------------------------
-- Q6: HEALTH IMPACT ANALYSIS (The "Golden Gun")
-- Objective: Correlate top diseases with average AQI per state using CTEs.
-- Logic: Join IDSP (Health) and AQI (Pollution) tables to find overlaps between sickness and bad air.
-- ---------------------------------------------------------
WITH Disease_Rank AS (
    SELECT
        state,
        disease_illness_name,
        SUM(cases) as Total_Cases,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY SUM(cases) DESC) as Rank
    FROM idsp_final
    WHERE year >= 2022
    GROUP BY state, disease_illness_name
),
Pollution_Stats AS (
    SELECT
        state,
        AVG(aqi_value) as Avg_State_AQI
    FROM aqi_final
    WHERE date >= '2022-01-01'
    GROUP BY state
)
SELECT
    d.state,
    d.Rank,
    d.disease_illness_name,
    d.Total_Cases,
    p.Avg_State_AQI
FROM Disease_Rank d
JOIN Pollution_Stats p ON d.state = p.state
WHERE d.Rank <= 2
ORDER BY d.state, d.Rank;

-- ---------------------------------------------------------
-- Q7: THE EV PARADOX (EV Adoption vs. AQI)
-- Objective: Test if high EV adoption correlates with cleaner air.
-- Insight: High EV states (UP, Delhi) still have high AQI, proving EVs alone aren't enough.
-- ---------------------------------------------------------
WITH EV_Stats AS (
    SELECT
        state,
        SUM(vehicle_count) as Total_EVs
    FROM vahan_final
    WHERE fuel LIKE '%ELECTRIC%' OR fuel LIKE '%EVS'
    GROUP BY state
),
Pollution_Stats AS (
    SELECT
        state,
        AVG(aqi_value) as Avg_AQI
    FROM aqi_final
    WHERE date >= '2022-01-01'
    GROUP BY state
)
SELECT TOP 10
    e.state,
    e.Total_EVs,
    p.Avg_AQI
FROM EV_Stats e
JOIN Pollution_Stats p ON e.state = p.state
ORDER BY e.Total_EVs DESC;