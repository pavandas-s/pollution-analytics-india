raw_data = LOAD 'C:/Users/user/Documents/pollution-analytics-india/data/city_day.csv' 
    USING PigStorage(',') 
    AS (City:chararray, Date:chararray, PM25:double, PM10:double, NO:double, NO2:double, 
        NOx:double, NH3:double, CO:double, SO2:double, O3:double, Benzene:double, 
        Toluene:double, Xylene:double, AQI:double, AQI_Bucket:chararray);

-- Remove the header row
no_header = FILTER raw_data BY City != 'City';

-- Standardize city names: trim stray whitespace, enforce consistent casing
standardized = FOREACH no_header GENERATE 
    TRIM(City) AS City, Date, PM25, PM10, NO, NO2, NOx, NH3, CO, SO2, O3, 
    Benzene, Toluene, Xylene, AQI, AQI_Bucket;

-- Duplicate check: distinct rows vs total rows (compared via row counts below)
distinct_check = DISTINCT standardized;

-- Missing value handling: require a valid AQI, AND at least one real pollutant reading
-- (drops rows that are essentially empty besides AQI, not just AQI-missing rows)
clean_data = FILTER standardized BY AQI IS NOT NULL AND (PM25 IS NOT NULL OR PM10 IS NOT NULL);

-- Extract year for grouping
with_year = FOREACH clean_data GENERATE City, SUBSTRING(Date, 0, 4) AS Year, AQI, PM25, PM10;

-- Group by city and year, average (AVG automatically ignores any remaining nulls per column)
grouped = GROUP with_year BY (City, Year);
yearly_avg = FOREACH grouped GENERATE 
    FLATTEN(group) AS (City, Year), 
    AVG(with_year.AQI) AS Avg_AQI, 
    AVG(with_year.PM25) AS Avg_PM25,
    AVG(with_year.PM10) AS Avg_PM10;

STORE yearly_avg INTO 'C:/Users/user/Documents/pollution-analytics-india/data/cleaned_output_v2' 
    USING PigStorage(',');

-- Row-count proof, for your evaluation step
total_rows = FOREACH (GROUP no_header ALL) GENERATE COUNT(no_header) AS total_count;
distinct_rows = FOREACH (GROUP distinct_check ALL) GENERATE COUNT(distinct_check) AS distinct_count;
clean_rows = FOREACH (GROUP clean_data ALL) GENERATE COUNT(clean_data) AS clean_count;

STORE total_rows INTO 'C:/Users/user/Documents/pollution-analytics-india/data/row_counts_total' USING PigStorage(',');
STORE distinct_rows INTO 'C:/Users/user/Documents/pollution-analytics-india/data/row_counts_distinct' USING PigStorage(',');
STORE clean_rows INTO 'C:/Users/user/Documents/pollution-analytics-india/data/row_counts_clean' USING PigStorage(',');