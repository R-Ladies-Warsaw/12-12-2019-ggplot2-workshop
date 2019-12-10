# 1. ggplot2: https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# 2. dplyr: https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf

#install.packages("SmarterPoland")
library(SmarterPoland)
library(dplyr)

head(countries)

### Funkcja ggplot()

ggplot(data = countries)

p <- ggplot(data = countries, mapping = aes(x = country, y = death.rate))

str(p)

#Oś x przyjmuje wartości zadeklarowane w mapowaniu
ggplot(countries, aes(x = birth.rate, y = death.rate))

ggplot(countries, aes(x = country, y = population))

### Operator '+':

ggplot2:::`+.gg`

### Geometrie
p <- ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point()
# to samo co
# ggplot(countries, aes(x = birth.rate, y = death.rate)) +
# geom_point(stat = 'identity')
p


p <- ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point()
#to samo co
#ggplot(countries, aes(x = continent, y = death.rate)) +
# geom_point(stat = 'identtity')
p

p <- ggplot(countries, aes(x = continent)) +
  geom_bar()
#to samo co
#ggplot(countries, aes(x = continent)) +
# geom_bar(stat = 'count') #'count' jest domyślną wartością parametru stat funkcji geom_bar()
p


p <- ggplot(countries, aes(x = birth.rate)) +
  stat_bin(binwidth = 3)
#to samo co
#ggplot(countries, aes(x = birth.rate)) +
# stat_bin(binwidth = 3, geom = 'bar')
p

#Bilans ludności:
ggplot(countries, aes(x = country, y = (birth.rate-death.rate)*population/1000)) +
  geom_point() 
#Zauważmy, że oś y zostaje nazwana tak jak określimy ją w aes()

#Jak zmienić tytuł osi y? Funkcja ylab (Dla osi x - xlab()):
ggplot(countries, aes(x = country, y = (birth.rate-death.rate)*population/1000)) +
  geom_point() +
  ylab("Bilans ludności")

#Jak dodać tytuł wykresu? Funkcja ggtitle():

ggplot(countries, aes(x = country, y = (birth.rate-death.rate)*population/1000)) +
  geom_point() +
  ylab("Bilans ludności") +
  ggtitle("Bilans ludności w poszczególnych państwach świata")



# Lista geometrii dotępna jest pod linkiem: https://ggplot2.tidyverse.org/reference/

### ZADANIE: Stwórz wykres pudełkowy (boxplot) prezentujący rozkład współczynnika dzietności w krajach na poszczególnych kontynentach.
# Zatytułuj wykres oraz osi x i y w języku polskim 
# Wskazówka: skorzystaj z funkcji geom_boxplot()


### Mapowanie

help(geom_point)

#kolor i przezroczystość punktów nie jest zależna od danych, więc nie jest częścią mapowania, a własnością geom_point()
ggplot(data = countries, aes(x = birth.rate, y = death.rate)) +
  geom_point(color = "blue", alpha = 0.4)

#kolor i rozmiar punktów jest zależna od danych, więc jest częścią mapowania
ggplot(countries, aes(x = birth.rate, y = death.rate, colour = continent, size = population)) +
  geom_point()

help("stat_density")

#Parametr alpha dla zmiennej dyskretnej:
ggplot(countries, aes(x = birth.rate, alpha = continent)) +
  stat_density()

#Zachowanie parametru color dla zmiennej ciągłej:
ggplot(countries, aes(x = continent, y = birth.rate, color = death.rate)) +
  geom_point()

### ZADANIE: Stwórz wykres punktowy przedstawiający współczynnik dzietności oraz zgonów, prezentując każdy z kontynentów innym kształtem
# i kolorem. Niech rozmiar punktów nie zależy od wartości danych i wynosi zawsze 3. Pamiętaj o oznaczeniu osi i tytule wykresu.


### Dodawanie geometrii
# Warstwy geometrii na wykresie zgadzają sie z kolejnością wywołań
ggplot(countries, aes(x = continent, y = birth.rate, fill = continent)) +
  geom_boxplot(outlier.color = NA) + # w celu unikniecia dublowania outlierow z geom_point
  geom_point()

# A na odwrót?
 ggplot(countries, aes(x = continent, y = birth.rate, fill = continent)) +
   geom_point() +
   geom_boxplot(outlier.color = NA)


# Zauważmy różnicę między fill a color, także w kontekście geom_point:
ggplot(countries, aes(x = continent, y = birth.rate, color = continent)) +
  geom_boxplot(outlier.color = NA) +
  geom_point()

# Oczywiście funkcje geometrii mają swoje parametry - tu: losowe rozmieszczenie punktów względem przedziału osi x
ggplot(countries, aes(x = continent, y = birth.rate, color = continent)) +
  geom_boxplot(outlier.color = NA) +
  geom_point(position = "jitter")

### ZADANIE: Stwórz wykres skrzypcowy dotyczący współczynnika zgonów, z podziałem państw na kontynenty.
# Zadbaj, by 'skrzypce' były różnych kolorów
# Ponadto, zadbaj aby w odpowiadającym miejscu grafiki, wyświetlone zostały nazwy poszczególnych państw. (o rozmiarze 3.5)
# Wskazówka: Funkcje geom_violin() oraz geom_text()


ggplot(countries, aes(x=birth.rate, y=death.rate, label = country)) +
  geom_point() + 
  geom_smooth(se=FALSE, size=2) +
  geom_text(data = countries[which.max(countries[["death.rate"]]),], vjust = 1.5)

ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_point(position = "jitter") +
  geom_boxplot(outlier.color = NA) 


### Przykłady innych elementów gramatyki:

# Miary - funkcja scale_...():
#Miary
ggplot(countries, aes(x = continent, y = birth.rate, color = death.rate)) +
  geom_point() +
  scale_y_continuous(limits = c(0, 100), expand = c(0.1, 0.1))

#Przesuniecia
ggplot(countries, aes(fill = continent, y = population, x = 0)) + 
  geom_bar(position = "stack", stat = "identity")

#Uklad wspolrzednych
ggplot(countries, aes(x = factor(1), fill = continent)) +
  geom_bar(width = 1) +
  coord_polar("y")

#Dekoracje
ggplot(countries, aes(x = factor(1), fill = continent)) +
  geom_bar(width = 1) +
  coord_polar("y") +
  theme_void()

#Panele
ggplot(countries, aes(x = death.rate, y = birth.rate)) +
  geom_point() +
  facet_wrap(vars(continent))
