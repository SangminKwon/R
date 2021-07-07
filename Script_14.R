mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65,124,131,153,212), "hwy"] <- NA

table(is.na(mpg$drv))
table(is.na(mpg$hwy))

library(dplyr)

mpg %>% 
  filter(is.na(hwy)==F) %>% 
  group_by(drv) %>% 
  summarise(mean(hwy))

table(is.na(mpg$hwy))
