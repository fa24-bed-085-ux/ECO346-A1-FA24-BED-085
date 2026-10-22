# Question 3: Age and Annual Earnings

library(ggplot2)

# Create 5-year age bands
sample_data$age_band <- cut(
  sample_data$age,
  breaks = seq(15, 65, by = 5),
  right = FALSE,
  labels = c(
    "15-19", "20-24", "25-29", "30-34", "35-39",
    "40-44", "45-49", "50-54", "55-59", "60-64"
  )
)

# Calculate weighted mean for each age band
band_table <- do.call(
  rbind,
  lapply(split(sample_data, sample_data$age_band), function(d) {
    data.frame(
      age_band = as.character(d$age_band[1]),
      n_earners = nrow(d),
      weighted_mean = weighted.mean(
        d$earn_annual, d$hhweight, na.rm = TRUE
      )
    )
  })
)

# Calculate band midpoints
band_table$midpoint <- seq(17, 62, by = 5)

# Identify the band with the highest weighted mean
highest_band <- band_table[
  which.max(band_table$weighted_mean), ]

print(band_table)
print(highest_band)

# Final Question 3 graph

p3 <- ggplot(sample_data, aes(x = age, y = earn_annual)) +
  geom_point(
    alpha = 0.25,
    position = position_jitter(width = 0.35, height = 0),
    color = "grey40"
  ) +
  geom_line(
    data = band_table,
    aes(x = midpoint, y = weighted_mean, group = 1),
    color = "blue",
    linewidth = 1
  ) +
  geom_point(
    data = subset(band_table, n_earners >= 30),
    aes(x = midpoint, y = weighted_mean),
    color = "blue",
    size = 3
  ) +
  geom_point(
    data = subset(band_table, n_earners < 30),
    aes(x = midpoint, y = weighted_mean),
    shape = 21,
    fill = "white",
    color = "blue",
    size = 3
  ) +
  geom_text(
    data = highest_band,
    aes(
      x = midpoint,
      y = weighted_mean,
      label = paste0(
        age_band, ": Rs ",
        format(round(weighted_mean), big.mark = ",")
      )
    ),
    vjust = -1,
    size = 3.5,
    inherit.aes = FALSE
  ) +
  scale_y_log10(
    limits = c(10000, 10000000),
    labels = scales::label_comma()
  ) +
  scale_x_continuous(
    breaks = seq(15, 65, by = 5),
    limits = c(15, 64)
  ) +
  labs(
    title = "Mean Annual Earnings Peak at Ages 55–59",
    x = "Age (years)",
    y = "Annual earnings (Rs, log scale)",
    caption = paste(
      "Source: PSLM 2019–20.",
      "KP Urban earners aged 15–64; weighted by hhweight.",
      "Hollow markers indicate bands with fewer than 30 earners."
    )
  ) +
  theme_minimal()

print(p3)

ggsave(
  "figures/q3_age_earnings.svg",
  plot = p3,
  width = 10,
  height = 6
)
write.csv(
  band_table,
  "figures/q3_age_band_table.csv",
  row.names = FALSE
)