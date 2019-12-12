### 1. Przygotowanie środowiska

#install.packages(ggplot2)
library(ggplot2)

#install.packages(dplyr)
library(dplyr)


### 2. Odczyt i obróbka danych


# movie_metadata.csv - dane dotyczące +5000 najpopularniejszych filmów z serwisu IMDb
# Źródło: https://data.world/data-society/imdb-5000-movie-dataset
# Ściąga: https://ggplot2.tidyverse.org/reference/


?read.csv
movies <- read.csv("movie_metadata.csv",
                   stringsAsFactors = FALSE)
movies
head(movies, 10)
colnames(movies)

movies <- select(movies, movie_title, director_name, actor_1_name, num_voted_users,
                 budget, plot_keywords, country, title_year, imdb_score)
head(movies, 10)

movies500 <- arrange(movies, desc(num_voted_users)) %>%
  head(500)
head(movies500, 10)

moviesDecades <- movies
moviesDecades$title_year <- moviesDecades$title_year %/% 10
moviesDecades$title_year <- moviesDecades$title_year * 10
moviesDecades$title_year <- paste0(moviesDecades$title_year, "s")
moviesDecades <- rename(moviesDecades, decade = title_year)
head(moviesDecades, 10)


### 3. Wizualizacje i piękno ggplota


## Problem I - liczba ocen filmów a rok

?ggplot
ggplot(data = movies)

ggplot(data = movies, aes(x = title_year))

?geom_bar
ggplot(data = movies, aes(x = title_year)) +
  geom_bar()

ggplot(data = movies, aes(x = title_year)) +
  geom_bar(fill = "pink")

?geom_density
ggplot(data = movies, aes(x = title_year)) +
  geom_density()

?geom_dotplot
ggplot(data = movies, aes(x = title_year)) +
  geom_dotplot()

ggplot(data = movies500, aes(x = title_year)) +
  geom_dotplot()

ggplot(data = movies500, aes(x = title_year)) +
  geom_dotplot(binwidth = 1.8)

ggplot(data = movies500, aes(x = title_year)) +
  geom_bar() +
  geom_dotplot(binwidth = 1.8)


## Problem II - starsze znaczy lepsze?


ggplot(data = moviesDecades, aes(x = decade, y = imdb_score))

ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_density()

?geom_point
ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_point()

moviesDecades <- moviesDecades[moviesDecades$decade != "NAs",]
ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_point()

ggplot(data = moviesDecades, aes(x = decade, y = imdb_score, color = country)) +
  geom_point()

ggplot(data = movies500, aes(x = title_year, y = imdb_score, color = country)) +
  geom_point()

ggplot(data = movies500, aes(x = title_year, y = imdb_score, color = country)) +
  geom_point()

ggplot(data = movies, aes(x = title_year, y = imdb_score)) +
  geom_point(position = "jitter")

?geom_jitter
ggplot(data = movies, aes(x = title_year, y = imdb_score)) +
  geom_jitter(width = 0.1, height = 0.5)

ggplot(data = movies, aes(x = title_year, y = imdb_score)) +
  geom_point(position = "jitter", size = 0.3)

ggplot(data = movies, aes(x = title_year, y = imdb_score)) +
  geom_point(alpha = 0.3)

?geom_smooth
ggplot(data = movies, aes(x = title_year, y = imdb_score)) +
  geom_point(alpha = 0.3) +
  geom_smooth()

ggplot(data = movies, aes(x = title_year, y = imdb_score)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm")


## Problem III - wyjątkowo dobre / złe filmy w kolejnych dekadach


?geom_boxplot
ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_boxplot()

ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_boxplot(outlier.color = "red")

?geom_text
ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_boxplot(outlier.color = "red") +
  geom_text(label = moviesDecades$movie_title)

is_outlier <- function(x) {
  return(x < quantile(x, 0.25) - 1.5 * IQR(x) | x > quantile(x, 0.75) + 1.5 * IQR(x))
}
moviesDecades <- mutate(moviesDecades, outlier = ifelse(is_outlier(imdb_score), movie_title, NA))

ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_boxplot(outlier.color = "blue") + # pokolorujmy sobie btw. na niebiesko, czemu nie
  geom_text(aes(label = outlier), na.rm = TRUE, hjust = 1, vjust = -1)

ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_boxplot(outlier.shape = NA) +
  geom_text(aes(label = outlier)) +
  geom_point(data = moviesDecades[!is.na(moviesDecades$outlier),], color = "blue")

is_outlier2 <- function(x) {
  return(x < quantile(x, 0.05) - 1.75 * IQR(x) | x > quantile(x, 0.75) + 1.25 * IQR(x))
}
moviesDecades <- mutate(moviesDecades, outlier = ifelse(is_outlier2(imdb_score), movie_title, NA))
ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_boxplot(outlier.shape = NA) +
  geom_text(aes(label = outlier)) +
  geom_point(data = moviesDecades[!is.na(moviesDecades$outlier),], color = "blue")

ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_boxplot(outlier.shape = NA) +
  geom_text(aes(label = outlier), size = 3.5, hjust = 1, vjust = -0.5) +
  geom_point(data = moviesDecades[!is.na(moviesDecades$outlier),], color = "blue")

?geom_violin
ggplot(data = moviesDecades, aes(x = decade, y = imdb_score)) +
  geom_violin()


### 4. Stylizacja
# Przykład 1 - Zróbmy go razem!

# najpierw dane. obliczmy średnią ocene filmów z każdego roku
movies_year <- movies%>%
  group_by(title_year)%>%
  summarise(score=mean(imdb_score))

# To chcemy otrzymać
ggplot(data=movies_year,aes(x=title_year,y=score))+
  geom_smooth(size=3,color="#a30000",fill="grey")+
  labs(title="Filmy są coraz gorsze?", subtitle = "Średnia ocena filmów na portalu IMDB z różnych lat\n",
       caption ="Source: www.imdb.com", x="", y=" Średnia ocena\n")+
  scale_x_continuous(breaks = c(1950,1970,1990,2010))+
  coord_cartesian(xlim = c(1943,2015),ylim=c(6,8),expand=FALSE)+
  theme(
    
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill="#f5e8e4"),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(size=1,linetype = "dashed"),
    
    axis.text=element_text(size = 14),
    axis.title.y = element_text(color="grey",size=14),
    
    plot.title = element_text(size = 24,face="bold", hjust=0.5),
    plot.subtitle = element_text(size=14,color = "grey", hjust=0.5),
    plot.caption = element_text(color="grey",face="italic"),
    plot.margin = unit(c(1,1,1,1),"cm"),
    
    aspect.ratio = 0.6
  )

# stwórzmy go jeszcze raz krok po kroku!
# by dowiedzieć się co każda linijka znaczy

ggplot(data=movies_year,aes(x=title_year,y=score))





# Przykład 2 - Spróbujcie odtworzyć wykres z zdjęcia! 
# Wykres pokazujący 6 aktorów, 
# którzy zagrali w największej ilości filmów 


# wyciągnijmy z bazy to co nas interesuje

movies_actors <- movies%>%
  group_by(aktor=actor_1_name)%>%
  summarise(ilosc=n())%>%
  arrange(desc(ilosc))%>%
  head(6)

# zobaczymy jak to wygląda 
head(movies_actors)

# ok teraz chcemy to przerobić w wykres słupkowy
# 2 nowe rzeczy, których użycie będzie konieczne

?geom_col
?coord_flip

# do dzieła!












### 5. DODATEK dla tych co już skończyli i się nudzą 

# ANIMACJE W R i kilka kolejnych technik 
#super temat, ale trzeba dobrze rozumieć ggplot

#install.packages(gganimate)
library(gganimate)

#install.packages(gapminder)
library(gapminder)
head(gapminder)


?scale_size             # przeskalowuje wielkośc punktów
?scale_color_continuous # zmiana gradientu kolorów używanych przy color (czyli kolorowaniu tekstów)
?scale_color_viridis_d


# wykres przedsawia zależność średniej długości życia od PKB na osobe
p <- ggplot(data= gapminder, aes(x = gdpPercap, y=lifeExp, size = pop, colour = country)) +
  geom_point(show.legend = FALSE, alpha = 0.7) +
  scale_color_viridis_d() +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  labs(x = "PKB na osobe", y = "Średnia długość życia")



p

### Podstawowa animacja
# taki gif musi wcześniej zostać wyrenderowany
# im większa jakość, ilośc klatek itd tym dłużej to zajmie 

p + transition_time(year) +
  labs(title = "Year: {frame_time}")

# dobrze to wygląda, nieprawdaż? 


# dzielimy jeden wykres na tyle, ile jest kontynentów w ramce danych 
p + facet_wrap(~continent)

# i animacja
p + facet_wrap(~continent)+ 
  transition_time(year) +
  labs(title = "Year: {frame_time}")


# ta część warsztatów była zainspirowana artykułem 
# w nim możesz znaleźć kontynuację tematu animacji,
# do czego zachęcamy, bo temat jest naprawdę ciekawy 
# https://www.datanovia.com/en/blog/gganimate-how-to-create-plots-with-beautiful-animation-in-r/