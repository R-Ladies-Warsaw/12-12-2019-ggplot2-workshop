library(nycflights13)
library(ggplot2)

# 1
ggplot(airports, aes(lon,lat)) +
    geom_point() + 
    scale_x_continuous(limits = c(-120,-67)) + 
    scale_y_continuous(limits = c(24,55))

#2
ggplot(airports, aes(lon,lat, col = alt)) +
  geom_point() + 
  scale_x_continuous(limits = c(-120,-67)) + 
  scale_y_continuous(limits = c(24,55))

#3 
ggplot(airports, aes(lon,lat, col = tzone)) +
  geom_point() + 
  scale_x_continuous(limits = c(-120,-67)) + 
  scale_y_continuous(limits = c(24,55))










