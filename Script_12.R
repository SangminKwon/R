exam <- read.csv("csv_exam.csv")
exam %>% summarise(mean_math = mean(math))
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math))
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math),
            sum_math = sum(math),
            median_math = median(math),
            n=n())

mpg <- as.data.frame(ggplot2::mpg)

mpg %>% 
  group_by(manufacturer, drv) %>% 
  summarise(mea_cty = mean(cty)) %>% 
  head

mpg %>% 
  group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  mutate(tot=(cty+hwy)/2) %>% 
  summarise(mean_tot = mean(tot)) %>% 
  arrange(desc(mean_tot)) %>% 
  head(5)

mpg %>% 
  group_by(class) %>% 
  summarise(cty_avg = mean(cty))

mpg %>% 
  group_by(class) %>% 
  summarise(cty_avg = mean(cty)) %>% 
  arrange(desc(cty_avg))

mpg %>% 
  group_by(manufacturer, class) %>% 
  summarise(hwy_avg = mean(hwy)) %>% 
  arrange(desc(hwy_avg)) %>% 
  head(3)

mpg %>% 
  filter(class == "compact") %>% 
  group_by(manufacturer) %>% 
  summarise(numbers = n()) %>% 
  arrange(desc(numbers))
















