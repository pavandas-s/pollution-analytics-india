import streamlit as st
import pandas as pd
import plotly.express as px
import os

st.set_page_config(page_title="India Air Quality Dashboard", layout="wide")
st.title("🌫️ Pollution Percentage Analysis in India")
st.caption("PB ADT 504 – Big Data Analytics | Group 2")

# Build paths relative to this script's own location, not the working directory
APP_DIR = os.path.dirname(os.path.abspath(__file__))

df = pd.read_csv(os.path.join(APP_DIR, "cleaned_yearly.csv"), header=None,
                  names=["City", "Year", "Avg_AQI", "Avg_PM25", "Avg_PM10"])
seasonal_df = pd.read_csv(os.path.join(APP_DIR, "cleaned_seasonal.csv"), header=None,
                           names=["City", "Season", "Avg_AQI"])

cities = sorted(df["City"].unique())
selected_city = st.sidebar.selectbox("Select a city", cities)

st.subheader(f"AQI Trend — {selected_city}")
city_df = df[df["City"] == selected_city].sort_values("Year")
st.plotly_chart(px.line(city_df, x="Year", y="Avg_AQI", markers=True), use_container_width=True)

st.subheader("Top 10 Most Polluted Cities (Average AQI)")
top10 = df.groupby("City")["Avg_AQI"].mean().sort_values(ascending=False).head(10)
st.plotly_chart(px.bar(top10, orientation="h", labels={"value": "Average AQI", "City": ""}), use_container_width=True)

st.subheader("Correlation: PM2.5 vs AQI")
st.plotly_chart(px.scatter(df, x="Avg_PM25", y="Avg_AQI", trendline="ols",
                 labels={"Avg_PM25": "Average PM2.5", "Avg_AQI": "Average AQI"}), use_container_width=True)
st.metric("PM2.5 – AQI Correlation", f"{df['Avg_PM25'].corr(df['Avg_AQI']):.3f}")

st.subheader("Seasonal AQI Patterns")
season_order = ["Winter", "Summer", "Monsoon", "Autumn"]
city_seasonal = seasonal_df[seasonal_df["City"] == selected_city].copy()
city_seasonal["Season"] = pd.Categorical(city_seasonal["Season"], categories=season_order, ordered=True)
city_seasonal = city_seasonal.sort_values("Season")
st.plotly_chart(px.bar(city_seasonal, x="Season", y="Avg_AQI", color="Season"), use_container_width=True)

st.divider()
st.caption("Data source: CPCB via Kaggle (Air Quality Data in India, 2015–2020) | Processed with Hadoop, Pig, and R")