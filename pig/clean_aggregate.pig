-- Load the raw CSV, skipping the header row logic (Pig treats all rows as data, so we filter carefully)
raw_data = LOAD 'C:/Users/user/Documents/pollution-analytics-india/data/city_day.csv' 
    USING PigStorage(',') 
    AS (City:chararray, Date:chararray, PM25:double, PM10:double, NO:double, NO2:double, 
        NOx:double, NH3:double, CO:double, SO2:double, O3:double, Benzene:double, 
        Toluene:double, Xylene:double, AQI:double, AQI_Bucket:chararray);

-- Remove the header row and rows with missing AQI
clean_data = FILTER raw_data BY City != 'City' AND AQI IS NOT NULL;

-- Extract year from date for grouping
with_year = FOREACH clean_data GENERATE City, SUBSTRING(Date, 0, 4) AS Year, AQI, PM25, PM10;

-- Group by city and year, compute average AQI
grouped = GROUP with_year BY (City, Year);
yearly_avg = FOREACH grouped GENERATE 
    FLATTEN(group) AS (City, Year), 
    AVG(with_year.AQI) AS Avg_AQI, 
    AVG(with_year.PM25) AS Avg_PM25,
    AVG(with_year.PM10) AS Avg_PM10;

-- Save the result
STORE yearly_avg INTO 'C:/Users/user/Documents/pollution-analytics-india/data/cleaned_output' 
    USING PigStorage(',');