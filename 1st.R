df <- read.csv("C:/work_R/easy_r/Assignment/NetflixOriginals.csv")

dim(df)

head(df)

View(df)

str(df)

tail(df)

df_copy <- df

is.na(df_copy)

table(is.na(df_copy))

df_copy$IMDB.Score <- as.numeric(df_copy$IMDB.Score)

str(df_copy)


# 변수 이름 변경
df_copy <- rename(df_copy, Rating = IMDB.Score)
View(df_copy)

hist(df_copy$Rating)
hist(df_copy$Runtime)

# 영화 장르별 평균 상영시간, 영화 숫자, 메디안 상영시간
df_copy %>% 
  group_by(Genre) %>% 
  summarise(mean_runtime = mean(Runtime),
            median_runtime = median(Runtime),
            numbers = n()) %>% 
  arrange(desc(mean_runtime))


# 상영시간이 길면 long, 중간이면 normal, 짧으면 short
# 점수가 높으면 Good, 점수가 중간이면 SoSo, 낮으면 Bad
df_copy %>% 
  mutate(Runtime_Test = ifelse(Runtime >= 130, "long", ifelse(Runtime>93,"normal", "short"))) %>%
  filter(Language == "Korean") %>% # 한국영화만 추출
  arrange(desc(Rating)) %>% 
  select(-Premiere, -Genre) %>% # 시사회, 장르 제외
  head(10)

# 국가별 볼만한 영화 개수
df_copy %>% 
  mutate(Runtime_Test = ifelse(Runtime >= 130, "long", ifelse(Runtime>93,"normal", "short")),
         Rating_Test = ifelse(Rating >= 8, "Good", ifelse(Rating>=7, "SoSo", "Bad"))) %>%
  filter(Rating_Test == "Good") %>%
  group_by(Language) %>%
  summarise(numbers_test = n())


df_copy %>% 
  arrange(Premiere)
str(df_copy)  

df_c2 <- df_copy           
df_c2$Premiere <- as.Date(df_copy$Premiere, format="%B %d %Y")
df_c2
