USE watt_watch;

CREATE TABLE smartcityenergy (
    MeterID VARCHAR(20),
    Zone VARCHAR(10),
    ConsumerType VARCHAR(20),
    Date DATE,
    EnergyConsumed_kWh FLOAT,
    PeakUsage_kWh FLOAT,
    OutageMinutes INT,
    MeterStatus VARCHAR(20),
    TariffRate FLOAT
);

SHOW TABLES;

SELECT * FROM smartcityenergy LIMIT 10;

--Query 1: Total and Average Energy Consumption by Zone
SELECT Zone, 
    ROUND(SUM(EnergyConsumed_kWh),2) AS TotalEnergy, 
    ROUND(AVG(EnergyConsumed_kWh),2) AS AvgEnergy
FROM smartcityenergy GROUP BY Zone ORDER BY TotalEnergy DESC;

--Query 2: Top 5 Consumers by Energy Consumption
SELECT MeterID, ConsumerType, 
    ROUND(SUM(EnergyConsumed_kWh),2) AS TotalConsumption
FROM smartcityenergy GROUP BY MeterID, ConsumerType ORDER BY TotalConsumption DESC LIMIT 5;

--Query 3: Monthly Energy Consumption Trends
SELECT MONTH(Date) AS Month,
    ROUND(SUM(EnergyConsumed_kWh),2) AS MonthlyConsumption
FROM smartcityenergy GROUP BY MONTH(Date) ORDER BY Month;

--Query 4: Average Cost of Energy Consumption by Zone
SELECT Zone,
    ROUND(AVG(EnergyConsumed_kWh * TariffRate),2) AS AvgCost
FROM smartcityenergy GROUP BY Zone ORDER BY AvgCost DESC;

--Query 5: Percentage of Faulty Meters by Zone
SELECT Zone, COUNT(*) AS FaultyMeterCount
FROM smartcityenergy WHERE MeterStatus = 'Faulty'
GROUP BY Zone ORDER BY FaultyMeterCount DESC;

--Query 6: Correlation between Peak Usage and Outages
SELECT Zone,
    ROUND(SUM(EnergyConsumed_kWh),2) AS TotalEnergy,
    SUM(OutageMinutes) AS TotalOutages
FROM smartcityenergy GROUP BY Zone ORDER BY TotalEnergy DESC, TotalOutages DESC;


--Query 7: Average Peak Usage on Weekdays vs Weekends
SELECT 
    CASE
        WHEN DAYOFWEEK(Date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    ROUND(AVG(PeakUsage_kWh),2) AS AvgPeakUsage
FROM smartcityenergy GROUP BY DayType;