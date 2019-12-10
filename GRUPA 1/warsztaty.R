library(nycflights13)
library(ggplot2)

# z czego będziemy korzystać
flights
weather
planes
airports
airlines

# wykres jako lista parametrów
plot <- ggplot(planes, aes(year)) + geom_bar() 
plot

# ----------------------------------------- 1 wymiar ---------------------------------------------------------- 
planes

# ile samolotów produkowano w danym roku? 
ggplot(planes, aes(x = year)) +
  geom_bar()  

?ggplot
?aes

?geom_bar

# jakiego typu mają silniki 
ggplot(planes, aes(year, fill = engine)) +
  geom_bar()  

ggplot(planes[planes$year >= 1995,], aes(year, fill = engine)) +
  geom_bar()

# kto tworzy samoloty po 95'
ggplot(planes[planes$year >= 1995,], aes(year, fill = manufacturer)) +
  geom_bar()

# inne geometrie 
ggplot(planes, aes(year)) + 
  geom_line(color = "red",    # kolor lini
            size = 1,         # grubość lini 
            linetype = 2,     # rodzaj lini
            stat = "count")   # statystyka - w tym przypadku musi być


# bez stat
ggplot(planes, aes(year)) +
  geom_line()

# dlaczego
?geom_line

# to były wykresy jednej zmiennej dyskretnej  
# czym jest zmienna dyskretna ? 
# a czym jest ciągła 

# dla ciągłej możemy patrzeć na wykres gęstości 
weather

ggplot(weather, aes(temp)) + geom_density(fill = "blue")

# jak to liczy? 
ggplot(weather, aes(temp)) + geom_density(fill = "blue", adjust = 0.2) # jaka wielkość domyślna kubełka ma być  
ggplot(weather, aes(temp)) + geom_density(fill = "blue", adjust = 0.5) 
ggplot(weather, aes(temp)) + geom_density(fill = "blue", adjust = 3) 

# podobnie jak geom_histogram
ggplot(weather, aes(temp)) + geom_histogram(fill = "blue", bins = 90) # bins jako kubełki 
ggplot(weather, aes(temp)) + geom_histogram(fill = "blue", bins = 40) # ile kubełków
ggplot(weather, aes(temp)) + geom_histogram(fill = "blue", bins = 10)


ggplot(weather, aes(temp)) + geom_density(fill = "blue", alpha = 0.2) # przezroczystość

?geom_density 

# ------------------------------------------------------ 2 wymiary -----------------------------------------------------------
flights

# flights jest dość duży dlatego weźmiemy losowe 10 000 rzędów

set.seed(1234)

smallerFlights <- flights[sample(1:length(flights$year), 10000),]

# wyższy poziom - precyzujemy 2 osie
ggplot(smallerFlights, aes(x = origin, y = air_time)) +
  geom_point(alpha = 0.3)

# dlaczego tak wyszło, co moglibyśmy ulepszyć? 
ggplot(smallerFlights, aes(origin, air_time)) +
  geom_boxplot()

# oś y jest ciągła a oś x dyskretna
# oś dyskretna może być napisem lub factorem, nie może być liczbą 
typeof(smallerFlights$origin) 

# co by było gdyby była liczbą?
ggplot(weather, aes(hour, temp)) + geom_boxplot()   # boxplot - kwartyle + wąsy + outliery

# jak temu zaradzić 
factor(c(1,2,3)) 
ggplot(weather, aes(factor(hour), temp)) + geom_boxplot()


# wracamy do lotów
ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_boxplot()

# czym są outliery
ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_boxplot(outlier.alpha = 0) # alpha - przezroczystość

ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_boxplot(outlier.colour = "red")

?geom_boxplot

# Skale
ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_boxplot(outlier.colour = "red") + 
  coord_flip()

ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_boxplot(outlier.colour = "red") + 
  coord_flip() + 
  scale_x_discrete(limits = c("EWR", "JFK")) 

# nazwijmy nasze lotniska inaczej
ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_boxplot(outlier.colour = "red") + 
  coord_flip() + 
  scale_x_discrete(limits = c("EWR", "JFK"), 
                   labels = c("Lotnisko 1", "Lotnisko 2"))  

# co oprócz boxplota? 
ggplot(smallerFlights, aes(factor(origin), air_time, color = factor(origin))) + 
  geom_point(position = "jitter")

ggplot(smallerFlights, aes(factor(origin), air_time, color = factor(origin))) + 
  geom_point(position = "jitter" , 
             alpha = 0.3)

# geometrie można łączyć dodając + 
ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_point(position = "jitter", alpha = 0.3) + 
  geom_boxplot(outlier.colour = "red")

# Jak zobaczyć rozkłady zmiennych - wykresy skrzypcowe 
ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_violin()  

# Jak zobaczyć rozkłady zmiennych - wykresy skrzypcowe 
ggplot(smallerFlights, aes(factor(origin), air_time, fill = factor(origin))) + 
  geom_violin() + 
  scale_y_continuous(limits = c(0,400))


# zmieńmy zbiorek 
airports

# @TODO 1
# 1. Za pomocą zbioru "airports" narysuj mapę Ameryki północnej (bez Hawajów i Alaski - sam ląd)
# podpowiedź: rozważ skale obie skale continious i narysuj wykres punktowy, oraz odpowiednio ogranicz
# 2. Uwzględnij ukształtownie terenu (podpowiedź: alt - wysokość nad poziomem morza, użyj kolorów )
# 3. Następnie na tej samej mapie wyróżnij kolorem strefy czasowe


#---------------------------------------------- wykres Continious ~ Continious------------------------------------ 

#wybieramy osie i tworzymy punkty
ggplot(weather[weather$month == '12',], aes(pressure, wind_speed)) +
  geom_point(col = "darkred", alpha = 0.3) 

#dodajemy interesujące nas limity
ggplot(weather[weather$month == '12',], aes(pressure, wind_speed)) +
  geom_point(col = "darkred", alpha = 0.3) + 
  xlim(1000,1020)

#dodajemy linie trendu
ggplot(weather[weather$month == '12',], aes(pressure, wind_speed)) +
  geom_point(col = "darkred", alpha = 0.3) + 
  xlim(1000,1020)+
  geom_smooth(col = "darkblue", se = FALSE) 

#doszlifowanie wykresu
ggplot(weather[weather$month == '12',], aes(pressure, wind_speed)) +
  geom_point(col = "darkblue", alpha = 0.3) + 
  xlim(1000,1020)+
  geom_smooth(se = FALSE)

ggplot(weather[weather$month == '12',], aes(pressure, wind_speed)) +
  geom_point(col = "darkblue", alpha = 0.3) + 
  xlim(1000,1020)+
  geom_smooth(se = FALSE, method = lm, formula = y ~ poly(x,3)) 
?geom_smooth()
#Facety

plot <- ggplot(mpg, aes(x = as.factor(year), y = displ)) +
  geom_boxplot() 

#rozdział ze względu na producenta
plot + facet_wrap(~manufacturer)

#uwalnianie osi
plot + facet_wrap(~manufacturer, scales = "free_y")

plot + facet_wrap(~manufacturer, scales = "free")

#ustalanie ułożenia
plot + facet_wrap(~manufacturer, nrow = 2)

#podział na porducenta i liczbę cylindrów
plot + facet_wrap(~manufacturer + cyl)

#uwzględnianie pustych wykresów
plot + facet_wrap(~manufacturer + cyl, drop = FALSE)

#facet grid
plot + facet_grid(manufacturer ~ cyl)

#zamiana położenia labeli
plot + facet_grid(manufacturer ~ cyl, switch = "x")
plot + facet_grid(manufacturer ~ cyl, switch = "both")

#dodanie całościowych wykresów 
plot + facet_grid(manufacturer ~ cyl, margins = c("manufacturer", "cyl"))

# @TODO 2 
#dla każdego lotniska wykresy skrzypcowowe odległości lotu w każdym z pierwszych sześciu miesięcy roku


#---------------------------------------------------TEKST NA WYKRESIE---------------------------------------------------------

#jaki był rozkład temperatury w czerwcu?

plot1 <- ggplot(weather[weather$temp != "" & weather$month == 6,],aes(x = day, y = temp)) + 
  geom_point()
plot1

#aby ułatwić odczytywanie wykresu możemy dodać własne tytuły i podpisy osi

# ?ggtitle
# ?gglabs

plot1 +
  ggtitle("Rozkład temperatury",             #tytuł wykresu
          subtitle = "Czerwiec 2013") +      #podtytuł
  labs(y = "Temperatura (F)",                #tytuł osi y
       x = "Dzień miesiąca",                 #tytuł osi x
       caption = "Źródła: Nycfligghts13")    #źródła na dole wykresu

#a co jeśli chcemy widzieć na osi każdy dzień tygodnia?
plot1 + scale_x_continuous(breaks = seq(1,30, 1))

#możemy manipulować tekstem i go zmieniać
#najpierw zapiszmy do zmiennej wykres, który zrobiliśmy powyżej
plot2 <- plot1 +
  ggtitle("Rozkład temperatury", subtitle = "Czerwiec 2013") +    
  labs(y = "Temperatura (F)", x = "Dzień miesiąca", caption = "Źródła: Nycfligghts13") + 
  scale_x_continuous(breaks = seq(1,30, 1))

# ?theme
# ?element_text

plot2 +
  theme(plot.title = element_text(size = 20, face = "bold.italic"),     #zmieniamy rozmiar i typ czcionki
        axis.title.x = element_text(color = "red"),                     #nadajemy kolor tytułowi osi x
        axis.text.y = element_text(angle = 90, hjust = 0.5))            #przekręcamy tekst i przesuwamy go (dotyczy podpisów dla osi y)

#---------------------------------------------------------LEGENDA------------------------------------------------------------

#tworzymy wykres dla lotów w czerwcu - opóźnienia odlotów i przylotów
p <- ggplot(flights[flights$month ==6,], aes(y = arr_delay, x = dep_delay, color = origin)) +geom_point()
p


#możemy zmienić tekst w legendzie

# ?scale_color_discrete

plot3 <- p + 
  labs(color = "Pochodzenie") +                                             #zmiana tytułu legendy                        
  scale_color_discrete(labels = c("Lotnisko1", "Lotnisko2", "Lotnisko3"))   #zmiana nazw elementów w legendzie
plot3

#zmiana pozycji legendy i wyglądu tekstu
plot3 + theme(legend.position = "bottom",             #legenda jest na dole, ale może w różnych miejscach (?theme i patrz na opis legend.position)
              legend.title = element_text(size = 15, color = "blue", face = "bold"),        #zmiana wyglądu tytułu - rozmiar, kolor i typ czcionki
              legend.text = element_text(size = 12, color = "darkred", face = "italic"))    #zmiana wyglądu tekstu

#pudełko legendy
plot3 + theme(legend.position = "bottom",
              legend.title = element_text(size = 15, color = "blue", face = "bold"),
              legend.text = element_text(size = 12, color = "darkred", face = "italic"),
              legend.background = element_rect(fill = "pink"))                           #zmieniamy kolor tła legendy

#co zrobić aby zniknęły białe kwadraty pod oznaczeniami w legendzie?
#w tym przypadku zapisujemy wykres aby później dodać do niego coś jeszcze i nie powtarzać kodu
plot4 <- plot3 + theme(legend.position = "bottom",
                       legend.title = element_text(size = 15, color = "blue", face = "bold"),
                       legend.text = element_text(size = 12, color = "darkred", face = "italic"),
                       legend.background = element_rect(fill = "pink"),
                       legend.key = element_blank())                     #tło oznaczenia - usuwamy je
plot4

#czy możemy zmienić wielkość oznaczeń - TAK

# ?guides

plot4 + guides(color = guide_legend(override.aes = list(size = 6)))  #zmieniamy wielkość "kółek" oznaczających kolory w legendzie na 6

#możemy też nie chcieć legendy wcale

#ma legendę
ggplot(flights[flights$month ==6,], aes(y = arr_delay, x = dep_delay, color = origin)) +
  geom_point()

#nie ma legendy - zaznaczamy że jej nie chcemy
  ggplot(flights[flights$month == 6,], aes(y = arr_delay, x = dep_delay, color = origin)) +
  geom_point(show.legend = FALSE)    #w ten sposób nie pokazujemy legendy dl adanej geometrii
#przydatne gdy nanosimy dwie lub więcej geometrii i chcemy jakąś legendę ukryć

#--------------------------------------------------------------KOLORY------------------------------------------------------------

#tworzymy nowy wykres, dotyczący samolotów do 1980 
ggplot(planes[planes$year <1980,],aes(x = year, y = type, color = engine)) +
  geom_point()

#możemy zmieniać kolory tła panelu jak i wykresu

ggplot(planes[planes$year <1980,], aes(x = year, y = type, color = engine)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "gray"), #robimy tło wykresu na szaro 
        plot.background = element_rect(fill = "pink"))  #a tło obrazka na różowo

#kolory jakie daje nam ggplot na wykresie możemy też zmienić
ggplot(planes[planes$year <=1980,],aes(x = year, y = type)) +
  geom_point(color = "navy")       #możemy ustawić kolor w geometrii gdy nie mamy mapowania na kolor

# ?scale_discrete_manual

ggplot(planes[planes$year <1980,],aes(x = year, y = type, color = engine)) + #mapowanie na kolor - tworzy się legenda przypisująca kolor danemu silnikowi
  geom_point() +
  scale_discrete_manual(aes = "color",                                                   #wybieramy co chcemy nadpisać, w naszym przypadku mamy color
                        values = c("yellow", "red", "green", "blue", "orange", "brown")) #tutaj nadpisujemy ich wartości i ustawiamy własne kolory

# @TODO 3

ggplot(planes[planes$year >= 1995,], aes(year, fill = engine)) +
  geom_bar()

#Do danego wykresu (patrz wyżej) nanieś:
#tytuł "Samoloty i ich silniki od 1995"
#podpisy osi i tytuł legendy (podpowiedź - są w tej samej funkcji)
#zmień kolor tła wykresu na biały używając theme_bw()
#usuń linie na wykresie (minor i major), ale tylko dla osi x, poszukaj tego w ?theme()
#wytłuszcz tytuł legendy (nadaj mu face = "bold w odpowiednim miejscu)
#zmień kolory w legendzie na "pink", "orange", "navy", "green" (w funkcji scale_fill_manual)



