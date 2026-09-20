\# Pollution Percentage Analysis in India using Big Data Tools

🔗 **Live Dashboard:** https://pollution-analytics-india-pav.streamlit.app


\## Overview

Analyzing air quality trends across Indian cities using CPCB pollution data,

processed through a Hadoop/Pig/R pipeline, with results presented in a

Streamlit web dashboard.



\## Dataset

\- Source: CPCB (Central Pollution Control Board), via Kaggle

&#x20; "Air Quality Data in India (2015–2020)"

\- File used: city\_day.csv (\~750 KB, 26 cities, daily readings 2015–2020)



\## Tools

\- Hadoop / HDFS — distributed storage

\- Apache Pig — data cleaning and aggregation

\- R + RStudio — trend and correlation analysis

\- Streamlit — final interactive dashboard



\## Folder Structure

\- /data — raw and cleaned datasets

\- /pig — Pig scripts

\- /r — R analysis scripts

\- /app — Streamlit dashboard

\- /docs — proposal, presentation, evaluation notes



\## How to Run

1\. Load data/city\_day.csv into HDFS

2\. Run pig/clean\_aggregate.pig to clean and aggregate

3\. Run r/trend\_analysis.R to generate charts

4\. Run `streamlit run app/app.py` to launch the dashboard

