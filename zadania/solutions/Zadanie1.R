# zadanie 1

ggplot(countries, aes(x = death.rate, y = birth.rate, label = country)) +
  geom_point(shape = 1, color = "red") +
  geom_text(data = countries[c(which.min(countries[["birth.rate"]]), which.max(countries[["birth.rate"]])),],
            size = 3, vjust = 1.5) +
  xlab("Współczynnik zgonów") +
  ylab("Współczynnik urodzeń") +
  labs(title = "Skrajności")
