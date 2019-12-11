library(ggplot2)
library(dplyr)

movies <- read.csv("zadania/data/movie_metadata.csv")

movies_actors <- movies%>%
    group_by(aktor=actor_1_name)%>%
    summarise(ilosc=n())%>%
    arrange(desc(ilosc))%>%
    head(6)


ggplot(movies_actors,aes(aktor,ilosc))+
    geom_col(width = 0.8,fill="#f35f71")+
    geom_text(aes(label=ilosc),nudge_y = -3, color="white",size=6)+
    labs(title="Role pierwszoplanowe",y="Ilość ról pierwszoplanowych")+
    coord_flip()+
    theme(
        
        plot.title = element_text(face="bold",size=24,color="#8d99ae",hjust=0.2),
        plot.margin = unit(c(1,1,1,1),"cm"),
        
        panel.background = element_blank(),
        
        axis.ticks = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_text(size=16,color="#2b2d42",face="italic",hjust=1.1),
        axis.title.x=element_text(size=18,hjust=0.2),
        axis.text.x=element_blank(),
        
        aspect.ratio = 1
    )
