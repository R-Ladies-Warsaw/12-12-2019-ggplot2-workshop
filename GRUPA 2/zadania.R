# zadanie 1

ggplot(countries, aes(x = death.rate, y = birth.rate, label = country)) +
  geom_point(shape = 1, color = "red") +
  geom_text(data = countries[c(which.min(countries[["birth.rate"]]), which.max(countries[["birth.rate"]])),],
            size = 3, vjust = 1.5) +
  xlab("Współczynnik zgonów") +
  ylab("Współczynnik urodzeń") +
  labs(title = "Skrajności")

# zadanie 2

ggplot(data = countries, aes(x = death.rate, fill = continent)) +
  geom_density(alpha = 0.5, linetype = 3) +
  theme_bw() +
  facet_wrap(nrow = 5, vars(continent)) +
  xlab("Wspołczynnik zgonów") +
  ylab("") +
  labs(title = "Gęstości")

# zadanie 3

ggplot(data = countries, aes(x = continent, y = population)) +
  geom_boxplot(aes(fill = continent), alpha = 0.25, outlier.colour = NA) +
  geom_point(aes(color = continent)) +
  scale_y_log10() +
  guides(color = FALSE, fill = FALSE) +
  xlab("Kontynent") +
  ylab("Populacja") +
  labs(title = "Populacje")

# zadanie 4*
# wskazówka: użyć melt z biblioteki reshape2

library(reshape2)
iris2 <- melt(iris, id.vars="Species")

ggplot(data=iris2, aes(x=Species, y=value, fill=variable)) +
  geom_bar(stat="identity", position="dodge") + 
  scale_fill_manual(values=c("orange", "blue", "darkgreen", "purple"),
                    name="Iris\nMeasurements",
                    breaks=c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"),
                    labels=c("Sepal Length", "Sepal Width", "Petal Length", "Petal Width"))
