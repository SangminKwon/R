library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_welfare <- read.spss(file="Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = T)

welfare <- raw_welfare

head(welfare)
tail(welfare)
View(welfare)
dim(welfare)
str(welfare)
summary(welfare)

welfare <- rename(welfare,
                  sex = h10_g3,
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  income = p1002_8aq1,
                  code_job = h10_eco9,
                  code_region = h10_reg7)

# 직업별 월급 차이
list_job <- read_excel("Koweps_Codebook.xlsx", col_names =T, sheet = 2)

head(list_job)
dim(list_job)

welfare <- left_join(welfare, list_job, id = "code_job")

welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)

job_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))

head(job_income)

top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)
top10

ggplot(data = top10, aes(x = reorder(x = job, mean_income), y = mean_income)) +
  geom_col()+
  coord_flip()

bottom10 <- job_income %>% 
  arrange(mean_income) %>% 
  head(10)
bottom10

ggplot(data=bottom10, aes(x=reorder(job, -mean_income), y=mean_income)) +
  geom_col()+
  coord_flip()+
  ylim(0, 850)


# 성별 직업 빈도
welfare$sex <- ifelse(welfare$sex == 1, "male","female")

job_male <- welfare %>% 
  filter(!is.na(job) & sex == "male") %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)
job_male

job_female <- welfare %>% 
  filter(!is.na(job) & sex == "female") %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)
job_female

ggplot(data = job_male, aes(x=reorder(job, n),y=n))+
  geom_col()+
  coord_flip()

ggplot(data = job_female, aes(x=reorder(job, n),y=n))+
  geom_col()+
  coord_flip()

# 종교 유무에 따른 이혼율
class(welfare$religion)

table(welfare$religion)
welfare$religion <- ifelse(welfare$religion == 1, "yes", "no")

table(welfare$religion)

qplot(welfare$religion)

class(welfare$marriage)
table(welfare$marriage)

welfare$group_marriage <- ifelse(welfare$marriage == 1, "marriage",
                                ifelse(welfare$marriage == 3, "divorce", NA))

table(welfare$group_marriage)
table(is.na(welfare$group_marriage))

qplot(welfare$group_marriage)

religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100, 1))

religion_marriage

divorce <- religion_marriage %>% 
  filter(group_marriage == "divorce") %>% 
  select(religion, pct)
divorce

ggplot(data = divorce, aes(x=religion, y=pct)) + geom_col()

# 연령대 및 종교 유무에 따른 이혼율 분석
welfare$age <- 2015-welfare$birth+1
welfare <- welfare %>% 
  mutate(age_g = ifelse(age <30 , "young",
                        ifelse(age<59, "middle", "olde")))
welfare <- renmae(welfare, nothing = group_marrige)

age_g_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(age_g,group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100, 1))

age_g_marriage
age_g_divorce <- age_g_marriage %>% 
  filter(age_g != "young" & group_marriage == "divorce") %>% 
  select(age_g,pct)
age_g_divorce
ggplot(data = age_g_divorce, aes(x=age_g, y=pct)) + geom_col()

age_g_religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage) & age_g!="young") %>% 
  group_by(age_g, religion, group_marriage) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100))
age_g_religion_marriage

df_divorce <- age_g_religion_marriage %>% 
  filter(group_marriage == "divorce") %>% 
  select(age_g, religion, pct)

df_divorce

ggplot(data= df_divorce, aes(x = age_g, y=pct, fill = religion))+
  geom_col(position = "dodge")

# 지역별 연령대 비율

table(welfare$code_region)

list_region <- data.frame(code_region = c(1:7),
                          region = c("서울",
                                     "수도권(인천/경기)",
                                     "부산/울산/경남",
                                     "대구/경북",
                                     "대전/충남",
                                     "강원/충북",
                                     "광주/전남/전북/제주도"))
list_region

welfare <- left_join(welfare, list_region, id="code_region")

welfare %>% 
  select(code_region, region) %>% 
  head

region_age_g <- welfare %>% 
  group_by(region, age_g) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group=sum(n)) %>% 
  mutate(pct=round(n/tot_group*100, 2))

head(region_age_g)

ggplot(data = region_age_g, aes(x = region, y = pct, fill = age_g))+
  geom_col()+
  coord_flip()

welfare$age_g <- ifelse(welfare$age_g == "olde", "old", welfare$age_g)

list_order_old <- region_age_g %>% 
  filter(age_g=="old") %>% 
  arrange(pct)

list_order_old

order <- list_order_old$region

order

ggplot(data = region_age_g, aes(x = region, y = pct, fill = age_g))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits = order)

class(region_age_g$age_g)

levels(region_age_g$age_g)

region_age_g$age_g <- factor(region_age_g$age_g, level=c("old", "middle", "young"))

levels(region_age_g$age_g)

ggplot(data = region_age_g, aes(x = region, y = pct, fill = age_g))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits = order)
