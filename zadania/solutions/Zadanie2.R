
# zadanie 2

ggplot(data = countries, aes(x = death.rate, fill = continent)) +
  geom_density(alpha = 0.5, linetype = 3) +
  theme_bw() +
  facet_wrap(nrow = 5, vars(continent)) +
  xlab("Wspołczynnik zgonów") +
  ylab("") +
  labs(title = "Gęstości")