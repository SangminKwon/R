test1 <- data.frame(id = c(1,2,3,4,5),
                    midterm = c(60,80,70,90,85))

test2 <- data.frame(id = c(1,2,3,4,5),
                    final = c(70,83, 65, 95, 80))

test1

test2

total <- left_join(test1, test2, by ="id")
total
total_2 <- right_join(test1, test2, by="id")
total_2

name <- data.frame(class= c(1,2,3,4,5),
                   teacher = c("kim", "lee", "park", "choi", "jung"))

name
exam <- read.csv("csv_exam.csv")
head(exam)
tail(exam)
exam_new <- left_join(exam,name, by="class")
exam_new

group_a <- data.frame(id=c(1,2,3,4,5),
                      test=c(60,80,70,90,85))
group_b <- data.frame(id=c(6,7,8,9,10),
                      test=c(70,83,65,95,80))
group_a
group_b
group_all <- bind_rows(group_a, group_b)
group_all

fuel <- data.frame(fl = c("c","d","e","p","r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22),
                   stringsAsFactors = F)
fuel

mpg <- as.data.frame(ggplot2::mpg)
q1 <- left_join(mpg,fuel, by="fl")
head(q1)
q1 %>% 
  select(model, fl, price_fl) %>% 
  head

midwest <- as.data.frame(ggplot2::midwest)

midwest %>% 
  mutate(kids_rate = (poptotal-popadults)/poptotal,
         classification = ifelse(kids_rate>=0.4, "large",
                                 ifelse(kids_rate>=0.3, "middle","small"))) %>%
  group_by(classification) %>% 
  summarise(counting = n())

midwest %>% 
  mutate(asian_rate = popasian/poptotal) %>% 
  arrange(desc(asian_rate)) %>% 
  select(state, county, asian_rate) %>% 
  tail(10)
