library(nycflights13)
library(ggplot2)

ggplot(flights[flights$month < 7 ,], aes(x= as.factor(month), y = distance)) + geom_violin() + facet_wrap(~origin)


