# Question 2: Distribution of annual earnings

library(ggplot2)

# Keep earnings within the required histogram range
plot_data <- subset(
  sample_data,
  earn_annual >= 10000 & earn_annual <= 10000000
)

# Create histogram
p <- ggplot(
  plot_data,
  aes(x = log10(earn_annual), weight = hhweight)
) +
  geom_histogram(
    breaks = seq(4, 7, by = 0.1),
    aes(y = after_stat(density)),
    fill = "skyblue",
    color = "white"
  ) +
  geom_vline(
    xintercept = log10(weighted_median),
    linetype = "dashed",
    linewidth = 0.8
  ) +
  geom_vline(
    xintercept = log10(weighted_p90),
    linetype = "dashed",
    linewidth = 0.8
  ) +
  annotate(
    "text",
    x = log10(weighted_median),
    y = Inf,
    label = "Weighted median: Rs 240,000",
    vjust = 2,
    hjust = 1.05,
    size = 3
  ) +
  annotate(
    "text",
    x = log10(weighted_p90),
    y = Inf,
    label = "P90: Rs 588,000",
    vjust = 4,
    hjust = -0.05,
    size = 3
  ) +
  scale_x_continuous(
    breaks = 4:7,
    labels = c("Rs 10,000", "Rs 100,000",
               "Rs 1,000,000", "Rs 10,000,000"),
    limits = c(4, 7)
  ) +
  labs(
    title = "Annual Earnings Are Unequally Distributed",
    subtitle = "KP Urban earners aged 15–64",
    x = "Annual earnings (log10 scale)",
    y = "Weighted density per log10 unit",
    caption = paste(
      "Source: PSLM 2019–20.",
      "Sample: 678 earners, ages 15–64, positive annual earnings.",
      "Histogram excludes 1 earner outside the displayed range.",
      "Weighted by household weight (hhweight)."
    )
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 15, hjust = 1),
    plot.caption = element_text(hjust = 0)
  )

# Display graph
print(p)

# Save graph as SVG
ggsave(
  "figures/q2_earnings_distribution.svg",
  plot = p,
  width = 10,
  height = 6
)