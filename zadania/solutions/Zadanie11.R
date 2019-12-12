library(nycflights13)
library(ggplot2)

ggplot(planes[planes$year >= 1995,], aes(year, fill = engine)) + 
  geom_bar() + 
  ggtitle("Samoloty i ich silniki od 1995") + 
  labs(x = "Rok", y = "Liczba samolotów", fill = "Typ silnika") + 
  theme_bw() + 
  theme(panel.grid = element_blank(), 
        legend.title = element_text(face= "bold")) + 
  scale_fill_manual(values = c("pink", "orange", "navy","green"))
