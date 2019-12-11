# zadanie 3

ggplot(data = countries, aes(x = continent, y = population)) +
  geom_boxplot(aes(fill = continent), alpha = 0.25, outlier.colour = NA) +
  geom_point(aes(color = continent)) +
  scale_y_log10() +
  guides(color = FALSE, fill = FALSE) +
  xlab("Kontynent") +
  ylab("Populacja") +
  labs(title = "Populacje")
