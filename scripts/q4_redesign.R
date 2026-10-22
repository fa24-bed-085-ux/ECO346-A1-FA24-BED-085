library(ggplot2)

redesigned_plot <- ggplot(
  sample_data,
  aes(x = age, y = earn_annual)
) +
  geom_point(
    alpha = 0.25,
    color = "steelblue",
    position = position_jitter(width = 0.2, height = 0)
  ) +
  geom_smooth(
    method = "loess",
    se = FALSE,
    color = "red"
  ) +
  scale_y_log10() +
  labs(
    title = "Annual Earnings by Age",
    subtitle = "KP Urban Earners, Ages 15–64",
    x = "Age (years)",
    y = "Annual Earnings (Rs, log scale)",
    caption = "Source: PSLM 2019–20"
  ) +
  theme_minimal()

print(redesigned_plot)

ggsave(
  "figures/q4_redesigned.svg",
  plot = redesigned_plot,
  width = 10,
  height = 6
)