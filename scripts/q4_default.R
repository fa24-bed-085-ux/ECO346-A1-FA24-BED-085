# Question 4: Default graph before redesign

library(ggplot2)

default_plot <- ggplot(
  sample_data,
  aes(x = age, y = earn_annual)
) +
  geom_point()

print(default_plot)

ggsave(
  "figures/default.svg",
  plot = default_plot,
  width = 10,
  height = 6
)