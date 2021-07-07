library(stringr)
x <- c("why", "video", "cross", "extra", "deal", "authority")
class(x)
str_length(x)
length(x)

str_c(x, collapse = ',')
str_sub(x, 1, 2)

str_subset(x, "[aeiou]")

str_count(x, '[aeiou]')

str_detect(x, "[aeiou]")
str_locate(x, '[aeiou]')

install.packages('rvest')
library(rvest)

lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")
lego_movie

rating <- lego_movie %>% 
  html_nodes("strong span") %>%
  html_text() %>%
  as.numeric()
rating

cast <- lego_movie %>%
  html_nodes("#titleCast .primary_photo img") %>%
  html_attr("alt")
cast

poster <- lego_movie %>%
  html_nodes(".poster img") %>%
  html_attr("src")
poster

lego_movie <- read_html("http://news.daum.net/")

rating <- lego_movie %>% 
  html_nodes("strong.tit_thumb a") %>%
  html_text()
rating

# 해외축구 기사 크롤링

wfootball_news <- read_html("https://sports.news.naver.com/news?oid=029&aid=0002684445")

wfootball_news

contents <- wfootball_news %>% 
  html_nodes("div#newsEndContents") %>% 
  html_text()

contents <- str_replace_all(contents, "\\W"," ")
contents

nouns <- extractNoun(contents)
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