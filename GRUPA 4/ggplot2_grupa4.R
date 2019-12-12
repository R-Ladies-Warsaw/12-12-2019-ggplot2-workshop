#####################################################################
############ Warsztaty ggplot2 - SPOTKANIA ENTUZJASTÓW R ############
##################### Grupa  4 ####### 12.12.2019 ###################

library("ggplot2")
library("SmarterPoland")
library("dplyr")
library("gridExtra")

#0 ### Struktura używania ggplot2 

# ggplot(data(data.frame object), aes(x = ?, y = ?, color = ?, fill = ?, label = ?, 
#                            shape = ?, size = ?)) +
#   geom_point(...) +
#   geom_bar(...) +
#   geom_line(...) +
#   geom_text(...) +
#   ...
# coord_flip(...) +
#   ...
# facet_grid(...) +
#   ...     
# theme_(bw/minimal/gray/...) +
#   theme(axis.title = element_text(...),
#         axis.text = element_text(...),
#         legend.position = "top/bottom/...") +
#   labs(title = "...", x = "...", y = "...") +
#   ...
# scale_y_manual(values = ..., name = "...", label = ...) +
#   scale_y_discrete() +
#   scale_color_manual() +
#   ...

## ggplot2 cheatsheet: https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf



#1 ### Przypomnienie podstaw ggplot2 

## dane 
data(countries)

## pierwsza warstwa 
ggplot(data = countries)

## dodanie osi 
ggplot(data = countries, aes(x = birth.rate, y = death.rate))

## wykres punktowy 
ggplot(data = countries, aes(x = birth.rate, y = death.rate)) +
  geom_point()

## równoważna opcja generowania wykresu
wykres <- ggplot(data = countries, aes(x = birth.rate, y = death.rate)) 
wykres + geom_point()

## dodanie opisu osi 
ggplot(data = countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  labs(title = "Title of plot", x = "Birth rate", y = "Death rate") 

## lub 
ggplot(data = countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  xlab("Birth rate") + 
  ylab("Death rate") + 
  ggtitle("Title of plot")

## wykres punktowy dla zmiennej typu character 
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point()

## dodajmy losowe rozmieszenie punktów oraz przezroczystość 
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point(position = "jitter", alpha = 0.2) +
  labs(title = "Title of plot", x = "Continent", y = "Death rate") 

## narysujmy wykresy pudełkowe 
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_boxplot()

## zaznaczmy outliery inny kolorem 
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_boxplot(outlier.color = "red")

## dodajemy atrybut kolor 
ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()

## wykres słupkowy 
ggplot(data = countries, aes(x = continent)) +
  geom_bar()

## wykres gęstości zmiennej 
ggplot(data = countries, aes(x = death.rate)) +
  geom_density()

## łączenie wykresów 
p1 <- ggplot(data = countries, aes(x = death.rate, fill = continent)) +
  geom_density(alpha = 0.2)

p1

p2 <- ggplot(countries, aes(x = continent, y = death.rate)) +
  geom_violin()

p2

grid.arrange(p1, p2, nrow = 1)

### Zadania ###

## 1
data(maturaExam)
head(maturaExam)

#Narysuj boxplot, który pokazuje liczbę zdobytych punktów z matury w podziale na przedmiot.

## 2
#Narysuj rozkład gęstości liczby punktów z matury w roku 2012 w podziele na przedmioty.

## 3
#Połącz powstałe w ## 1 oraz ## 2 wykresy jeden pod drugim.


#2 ### ggplot2  (scale_..., text_..., facet_..., smooth, coord)

# 2 a) scale_...

p <- ggplot(data = countries, aes(x = continent, fill = continent)) +
  geom_bar()
p

## scale_x_discrete
p + scale_x_discrete(position = "top")

## scale_y_continuous
p + scale_y_continuous(position = "right")

## scale_x_discrete
p + scale_x_discrete(limits = sort(unique(countries$continent), decreasing = TRUE))

## scale_y_reverse
p + scale_y_reverse()

## scale_fill_manual
p + scale_fill_manual(values = c("red", "navyblue", "orange", "pink", "green"))



# 2 b) text_...

continents <- group_by(countries, continent) %>% 
  na.omit %>% 
  summarise(death.rate = mean(death.rate),
            birth.rate = mean(birth.rate, na.rm = TRUE),
            population = mean(population),
            n.countries = length(country))


## dodawanie etykiet 
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text(vjust = -1)

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text(vjust = -1, size = 5)

## ggrepel - rozszerzenie ggplot2, dodawanie etykiet

#install.packages("ggrepel")
library("ggrepel")

## wykres jak powyżej 
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text_repel(size = 5, force = 1)
## lub 
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_label_repel(size = 5, force = 1)
## lub 
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, 
                       label = paste0(continent, "; ", n.countries, " countries"))) +
  geom_point() +
  geom_text_repel(size = 4, force = 1, color = "black") 



# 2 c) facet_...
## przykład 
maturaExam_aggregate <- maturaExam %>% 
  group_by(punkty, przedmiot, rok) %>%
  summarise(n = n())
ggplot(maturaExam_aggregate, aes(x = punkty, y = n, fill = rok)) +
  geom_bar(stat = "identity") +
  labs(x = "Punkty", y = "Liczba osób", fill = "Rok") +
  theme_bw()

## lub 
maturaExam %>% 
  group_by(punkty, przedmiot, rok) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = punkty, y = n, fill = rok)) +
  geom_bar(stat = "identity") +
  labs(x = "Punkty", y = "Liczba osób", fill = "Rok") +
  theme_bw()


## facet_wrap
ggplot(maturaExam_aggregate, aes(x = punkty, y = n, fill = rok)) +
  geom_bar(stat = "identity") +
  labs(x = "Punkty", y = "Liczba osób", fill = "Rok") +
  theme_bw() +
  facet_wrap(~rok)

ggplot(maturaExam_aggregate, aes(x = punkty, y = n, fill = rok)) +
  geom_bar(stat = "identity") +
  labs(x = "Punkty", y = "Liczba osób", fill = "Rok") +
  theme_bw() +
  facet_wrap(~przedmiot)

## facet_grid

ggplot(maturaExam_aggregate, aes(x = punkty, y = n, fill = rok)) +
  geom_bar(stat = "identity") +
  labs(x = "Punkty", y = "Liczba osób", fill = "Rok") +
  theme_bw() +
  facet_grid(rok~przedmiot)

# 2 d) smooth

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() 

## dodanie linii trendu 
ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  geom_smooth() 

ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() + 
  geom_smooth() 

## ustawienie se 

ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() +  
  theme_bw() + 
  geom_smooth(se = FALSE) 

# 2 e) coord

p <- ggplot(data = countries, aes(x = continent)) +
  geom_bar()

p

p + coord_flip()

p + coord_flip() + scale_y_reverse()

p + coord_polar()

### ZADANIE KOŃCOWE ###

#Wybierz dowolny wykres z katalogu https://github.com/R-Ladies-Warsaw/12-12-2019-ggplot2-workshop/tree/master/GRUPA%205/wykresy
#and draw it in ggplot2. Data for individual charts can be found in the data catalog.
#Podziel się z nami swoją grafiką (link w README, tutaj: https://github.com/R-Ladies-Warsaw/12-12-2019-ggplot2-workshop)
