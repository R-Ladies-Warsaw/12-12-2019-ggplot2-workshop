#####################################################################
###### Warsztaty (Workshop) ggplot2 - SPOTKANIA ENTUZJASTÓW R #######
#################### Grupa (Group) 5 ####### 12.12.2019 #############

library("ggplot2")
library("SmarterPoland")
library("dplyr")
library("gridExtra")

#0 ### Struktura używania ggplot2 (Structure of using ggplot2 package)

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



#1 ### Przypomnienie podstaw ggplot2 (Remind basic ggplot2)

## dane (data)
data(countries)

## pierwsza warstwa (first layer)
ggplot(data = countries)

## dodanie osi (adding axis)
ggplot(data = countries, aes(x = birth.rate, y = death.rate))

## wykres punktowy (scatter plot)
ggplot(data = countries, aes(x = birth.rate, y = death.rate)) +
  geom_point()

## równoważna opcja generowania wykresu
wykres <- ggplot(data = countries, aes(x = birth.rate, y = death.rate)) 
wykres + geom_point()

## dodanie opisu osi (adding labels name)
ggplot(data = countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  labs(title = "Title of plot", x = "Birth rate", y = "Death rate") 

## lub (or)
ggplot(data = countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  xlab("Birth rate") + 
  ylab("Death rate") + 
  ggtitle("Title of plot")

## wykres punktowy dla zmiennej typu character (plot for variable which has character type)
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point()

## dodajmy losowe rozmieszenie punktów oraz przezroczystość (adding random position for points and transparency)
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point(position = "jitter", alpha = 0.2) +
  labs(title = "Title of plot", x = "Continent", y = "Death rate") 

## narysujmy wykresy pudełkowe (ploting boxplot)
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_boxplot()

## zaznaczmy outliery inny kolorem (change the color of outlier)
ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_boxplot(outlier.color = "red")

## dodajemy atrybut kolor (adding attriubute color)
ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()

## wykres słupkowy (barplot)
ggplot(data = countries, aes(x = continent)) +
  geom_bar()

## wykres gęstości zmiennej (density plot for variable)
ggplot(data = countries, aes(x = death.rate)) +
  geom_density()

## łączenie wykresów (combine plots)
p1 <- ggplot(data = countries, aes(x = death.rate, fill = continent)) +
  geom_density(alpha = 0.2)

p1

p2 <- ggplot(countries, aes(x = continent, y = death.rate)) +
  geom_violin()

p2

grid.arrange(p1, p2, nrow = 1)

### Zadania (Tasks) ###

## 1
data(maturaExam)
head(maturaExam)

#Narysuj boxplot, który pokazuje liczbę zdobytych punktów z matury w podziale na przedmiot.
#Plotting boxplot, which show numbers of point on matura exam divided by subject.

## 2
#Narysuj rozkład gęstości liczby punktów z matury w roku 2012 w podziele na przedmioty.
#Plotting density plot, which show numbers of point on matura exam in 2012 divided by subject.

## 3
#Połącz powstałe w ## 1 oraz ## 2 wykresy jeden pod drugim.
#Combine plots from ## 1 and ## 2 in one column.


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


## dodawanie etykiet (adding labels)
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text(vjust = -1)

ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text(vjust = -1, size = 5)

## ggrepel - rozszerzenie ggplot2, dodawanie etykiet (ggplot2 package extension, adding labels)

#install.packages("ggrepel")
library("ggrepel")

## wykres jak powyżej (plot as above)
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_text_repel(size = 5, force = 1)
## lub (or)
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, label = continent)) +
  geom_point() +
  geom_label_repel(size = 5, force = 1)
## lub (or)
ggplot(continents, aes(x = birth.rate, y = death.rate, size = population, 
                       label = paste0(continent, "; ", n.countries, " countries"))) +
  geom_point() +
  geom_text_repel(size = 4, force = 1, color = "black") 



# 2 c) facet_...
## przykład (example)
maturaExam_aggregate <- maturaExam %>% 
  group_by(punkty, przedmiot, rok) %>%
  summarise(n = n())
ggplot(maturaExam_aggregate, aes(x = punkty, y = n, fill = rok)) +
  geom_bar(stat = "identity") +
  labs(x = "Punkty", y = "Liczba osób", fill = "Rok") +
  theme_bw()

## lub (or)
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

## dodanie linii trendu (adding smooth)
ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  geom_smooth() 

ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() + 
  geom_smooth() 

## ustawienie se (remove se)

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

#Select any chart from the catalog  https://github.com/R-Ladies-Warsaw/12-12-2019-ggplot2-workshop/tree/master/GRUPA%205/wykresy
#i narysuj go w ggplot2. Dane do poszczególnych wykresów znajdziesz w katalogu data.
#Share your graphics with us (link in README, here: https://github.com/R-Ladies-Warsaw/12-12-2019-ggplot2-workshop)
