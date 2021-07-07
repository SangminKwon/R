install.packages("foreign")

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

class(welfare$sex)
table(welfare$sex)

welfare$sex <- ifelse(welfare$sex==1, "male", "female")
table(welfare$sex)

qplot(welfare$sex)

class(welfare$income)
summary(welfare$income)

qplot(welfare$incom) + xlim(0,1000)

welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)

table(is.na(welfare$income))

sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income = mean(income))

sex_income

ggplot(data = sex_income, aes(x=sex, y=mean_income)) + geom_col()
class(welfare$birth)
summary(welfare$birth)
qplot(welfare$birth)

summary(welfare$birth)
table(is.na(welfare$birth))

welfare$age <- 2015-welfare$birth + 1
table(is.na(welfare$age))
summary(welfare$birth)

qplot(welfare$age)
summary(welfare$age)

age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))

head(age_income)

ggplot(data = age_income, aes(x=age, y=mean_income)) + geom_line()

welfare <- welfare %>% 
  mutate(agag=ifelse(age<30, "young",ifelse(age<=59, "middle", "old")))
table(welfare$agag)

ageg_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(agag) %>% 
  summarise(mean_income = mean(income))
ageg_income

ggplot(data = ageg_income, aes(x = agag, y = mean_income)) + geom_col()

ggplot(data = ageg_income, aes(x = agag, y = mean_income)) + geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old"))

welfare <- welfare %>% 
  mutate(ageg_ext=ifelse(age<20, "students",ifelse(age<30, "youth", ifelse(age<40,"30대", ifelse(age<50, "40대", 
                                                                                                ifelse(age<60, "50대", "old"))))))

ageg_income_2 <-  welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg_ext) %>% 
  summarise(mean_income = mean(age))
ageg_income_2
ggplot(data = ageg_income_2, aes(x=ageg_ext, y=mean_income))+
  geom_col()

sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(agag, sex) %>% 
  summarise(mean_income = mean(income))

ggplot(data = sex_income, aes(x = agag, y=mean_income, fill = sex)) +
  geom_col(position = "dodge")+
  scale_x_discrete(limits= c("young", "middle", "old"))

sex_age <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income = mean(income))

head(sex_age)

ggplot(data = sex_age, aes(x = age, y = mean_income, col = sex)) + geom_line()


class(welfare$code_job)
table(welfare$code_job)

library(readxl)
list_job <- read_excel("Koweps_Codebook.xlsx", col_names =T, sheet = 2)
head(list_job)
welfare <- left_join(welfare, list_job, id="code_job")

welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)
job_income <- welfare %>%
  filter(!is.na(income) & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))

head(job_income)


top10 <- job_income l10, aes(x=reorder(job, -mean_income)))+
  geom_col() +
  corrd_flip()+
  ylim(0,850)