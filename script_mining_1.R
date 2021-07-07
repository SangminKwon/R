useNIADic()
useSejongDic()

txt <- readLines("hiphop.txt")
head(txt)

install.packages("stringr")
library(stringr)
library(KoNLP)
library(dplyr)
txt <- str_replace_all(txt, "\\W"," ")

nouns <- extractNoun(txt)
nouns

wordcount <- table(unlist(nouns))
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)
df_word <- filter(df_word, nchar(word)>=2)

top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

top20

install.packages("wordcloud")
library(wordcloud)
library(RColorBrewer)

pal <-  brewer.pal(9, "Dark2")
set.seed(1234)
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq=2,
          max.words=200,
          random.order = F,
          rot.per = .1,
          scale = c(4,0.3),
          colors = pal)

twitter <- read.csv("twitter.csv", header = T, stringsAsFactors = F, fileEncoding = "UTF-8")

twitter <- rename(twitter, no=번호, id = 계정이름, date = 작성일, tw = 내용)

twitter$tw <- str_replace_all(twitter$tw, "\\W"," ")

head(twitter$tw)

nouns <- extractNoun(twitter$tw)
wordcount <- table(unlist(nouns))
df_word <-  as.data.frame(wordcount, stringsAsFactors = F)
df_word <-  rename(df_word, word=Var1, freq=Freq)
df_word <- filter(df_word, nchar(word)>=2)
top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20

library(ggplot2)
library(dplyr)

order <-  arrange(top20, freq)$word

wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq=10,
          max.words=200,
          random.order = F,
          rot.per = .1,
          scale = c(6, 0.2),
          colors = pal)
