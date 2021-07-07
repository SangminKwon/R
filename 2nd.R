df_original <- read.csv("EPL_20_21.csv", stringsAsFactors = F)

#모양 체크
dim(df_original)

#헤드 체크
head(df_original)

#테일 체크
tail(df_original)

#구조 체크
str(df_original)

#뷰 체크
View(df_original)

#통계 요약 정보 체크
summary(df_original)

#복사본 생성
df <- df_original

#각종 패키지 호출
library(foreign)
library(dplyr)
library(ggplot2)

#변수명 변경
df <- rename(df, Num_Start = Starts, Playing_time = Mins)

# 1. 팀별 공격포인트

class(df$Club)
table(df$Club)

class(df$Goals)
table(df$Goals)
is.na(df$Goals)
table(is.na(df$Goals))

class(df$Assists)
table(df$Assists)
is.na(df$Assists)
table(is.na(df$Assists))

summary(df$Goals)

df_ap <- df %>% 
  mutate(Attack_Points = Goals + Assists) %>% 
  group_by(Club) %>% 
  summarise(total_AP = sum(Attack_Points))

df_ap

ggplot(data = df_ap, aes(x = Club, y = total_AP)) + geom_col() + coord_flip()

# 2. 연령별 공격포인트

class(df$Age)
table(df$Age)

df_ap_2 <- df %>% 
  mutate(Attack_Points = Goals + Assists) %>%
  group_by(Age) %>% 
  summarise(total_AP = sum(Attack_Points))

ggplot(data = df_ap_2, aes(x = Age, y = total_AP)) + geom_line()


# 3. 연령대별 공격포인트
summary(df$Age)
df <- df %>% 
  mutate(Attack_Points = Goals + Assists)


df <- df %>% 
  mutate(Age_g = ifelse(Age<26, "young",ifelse(Age<30,"middle","old")))
table(df$Age_g)

df_ap_temp <- df %>% 
  group_by(Age_g)%>%
  summarise(total_AP = sum(Attack_Points))

ggplot(data = df_ap_temp, aes(x = reorder(Age_g, total_AP), y = total_AP)) + geom_col()

# 4. 팀에서 연령대별 공격포인트 현황
df_ap_3 <- df %>% 
  group_by(Club, Age_g) %>%
  summarise(total_AP = sum(Attack_Points))

df_ap_3  

ggplot(data = df_ap_3, aes(x=Club, y = total_AP, fill= Age_g))+
  geom_col()+
  coord_flip()
