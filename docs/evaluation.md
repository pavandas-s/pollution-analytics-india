# Evaluation Notes

- Verified 0 duplicate rows in raw dataset (29,531 total = 29,531 distinct)
- Removed 4,741 rows (16%) with missing AQI or pollutant readings; retained 24,790 clean records
- Cross-checked Ahmedabad's AQI trend: rose sharply 2015–2018, dropped notably in 2019–2020,
  consistent with the real-world 2020 COVID lockdown reducing emissions
- PM2.5–AQI correlation calculated at 0.659, a moderate-to-strong positive relationship,
  consistent with PM2.5 being a major contributor to overall AQI
- Reviewed all dashboard visualizations for readability and accuracy before deployment