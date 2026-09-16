library(dplyr)
library(ggplot2)

# Load cleaned data (no header row, so we name columns manually)
df <- read.csv("data/cleaned_yearly.csv", header = FALSE,
               col.names = c("City", "Year", "Avg_AQI", "Avg_PM25", "Avg_PM10"))

# --- 1. Trend analysis: AQI over years for top polluted cities ---
top_cities <- df %>%
  group_by(City) %>%
  summarise(Overall_AQI = mean(Avg_AQI, na.rm = TRUE)) %>%
  arrange(desc(Overall_AQI)) %>%
  head(6) %>%
  pull(City)

trend_data <- df %>% filter(City %in% top_cities)

p1 <- ggplot(trend_data, aes(x = Year, y = Avg_AQI, color = City, group = City)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "AQI Trend Over Years — Top 6 Most Polluted Cities",
       x = "Year", y = "Average AQI") +
  theme_minimal()
ggsave("outputs/aqi_trend_top6.png", p1, width = 9, height = 5)

# --- 2. Comparative ranking: top 10 most polluted cities overall ---
top10 <- df %>%
  group_by(City) %>%
  summarise(Overall_AQI = mean(Avg_AQI, na.rm = TRUE)) %>%
  arrange(desc(Overall_AQI)) %>%
  head(10)

p2 <- ggplot(top10, aes(x = reorder(City, Overall_AQI), y = Overall_AQI)) +
  geom_col(fill = "#2C5F2D") +
  coord_flip() +
  labs(title = "Top 10 Most Polluted Cities (Average AQI)",
       x = "City", y = "Average AQI") +
  theme_minimal()
ggsave("outputs/top10_cities.png", p2, width = 8, height = 5)

# --- 3. Correlation: PM2.5 vs AQI ---
p3 <- ggplot(df, aes(x = Avg_PM25, y = Avg_AQI)) +
  geom_point(color = "#4C8067", alpha = 0.6) +
  geom_smooth(method = "lm", color = "#E67E22", se = FALSE) +
  labs(title = "Correlation: PM2.5 vs AQI",
       x = "Average PM2.5", y = "Average AQI") +
  theme_minimal()
ggsave("outputs/pm25_vs_aqi_correlation.png", p3, width = 8, height = 5)

correlation_value <- cor(df$Avg_PM25, df$Avg_AQI, use = "complete.obs")
print(paste("Correlation between PM2.5 and AQI:", round(correlation_value, 3)))

cat("Analysis complete. Charts saved to /outputs\n")