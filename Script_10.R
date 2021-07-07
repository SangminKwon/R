exam <- read.csv("csv_exam.csv")
exam %>% select(math)
exam %>% select(english)
exam %>% select(class, math, english)
exam %>% select(-math)
exam %>% select(-math, -english)
exam %>% filter(class==1) %>% select(english)
exam %>% 
  filter(class==1) %>% 
  select(english)
exam %>% 
  select(id, math) %>% 
  head
exam %>% 
  select(id, math) %>% 
  head(10)

df <- as.data.frame(ggplot2::mpg)
df_new <- df %>% select(class, cty)
head(df_new, 5)
df_suv <- df_new %>% filter(class == "suv")
df_compact <-  df_new %>% filter(class == "compact")
mean(df_suv$cty)
mean(df_compact$cty)
