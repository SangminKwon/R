library(rvest)
library(dplyr)
library(stringr)
library(KoNLP)
library(wordcloud)
library(RColorBrewer)

url <- "https://news.daum.net/ranking/popular/all"

news <- read_html(url)

news

news_url <- news %>% 
  html_nodes('strong.tit_thumb a') %>% 
  html_attr('href')
news_url

# 기사 통째로 href속성을 활용해 raw data 생성
result <- ''
for(i in c(1:length(news_url))){
  a <- read_html(news_url[i])
  text <- a %>% 
    html_nodes('section p') %>% 
    html_text()
  result <- paste(result, text, sep = ' ')
}

result

# 데이터 전처리
result <- str_replace_all(result, '\\W', " ")
result
result <- str_trim(result, side = 'both')

# 명사 추출
nouns <- extractNoun(result)

wordcount <- table(unlist(nouns))

df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word <- rename(df_word, word=Var1, freq=Freq)
df_word <- filter(df_word, nchar(word)>=2)

#비니도별 추출
top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

top20

# 워드 클라우드 생성
pal <-  brewer.pal(8, "Dark2")
set.seed(1234)
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq=2,
          max.words=200,
          random.order = F,
          rot.per = .1,
          scale = c(4,0.3),
          colors = pal)




