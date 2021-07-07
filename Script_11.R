exam <- read.csv("csv_exam.csv")
exam %>% arrange(math)
exam %>% arrange(desc(math))
exam %>% arrange(class, math)

df <- as.data.frame(ggplot2::mpg)
df_audi <- df %>% filter(manufacturer == "audi")
df_audi %>% arrange(desc(hwy)) %>% head

exam %>% 
  mutate(total = math + english + science) %>% 
  head
head(exam)
exam %>% 
  mutate(total = math + english + science,
         mean = (math+english+science)/3) %>% 
  head
Z^^Z^Z
exam %>% 
  mutate(test = ifelse(science>=60, "pass", "fail")) %>% 
  head
^Z
exam %>% 
  mutate(total = math + english + science) %>% 
  arrange(total) %>% 
  head

df <- as.data.frame(ggplot2::mpg)
df %>% 
  mutate(total_y = cty + hwy,
         avg_y = total_y/2) %>%
  arrange(desc(avg_y)) %>% 
  head
head(df)
