# 네이버 영화 리뷰수집
library(stringr)
library(rvest)
library(dplyr)
library(KoNLP)
library(wordcloud)
library(RColorBrewer)

url <- 'https://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=190726&target=after&page='

url <- paste0(url,4)
url

htxt <- read_html(url)
htxt

content <- html_nodes(htxt, '.list_netizen .title')
content

reviews <- html_text(content)
reviews

all.reviews <- c()
for(page in c(1:30)){
  url <- paste0(url, page)
  htxt <- read_html(url)
  content <- html_nodes(htxt,'.list_netizen .title')
  reviews <- html_text(content)
  if(length(reviews)==0){break}
  all.reviews <- c(all.reviews, reviews)
  print(page)
}
all.reviews

txt <- str_replace_all(all.reviews, '\\W'," ")
txt
txt <- str_trim(txt,side='both')
txt
txt <- str_replace_all(txt, '신고','')
txt
txt <- str_replace_all(txt,'별점   총 10점 중[0-9]{1,2}',"")
txt <- str_replace_all(txt,'[:space:]{1,}',' ')
txt
txt <- str_trim(txt,side='both')
txt

















