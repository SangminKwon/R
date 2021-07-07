library(KoNLP)
library(dplyr)
library(stringr)

#데이터 로드
txt <- readLines("달빛조각사 01.txt")

head(txt, 20)

# 특수문자 제거
txt <- str_replace_all(txt$rv, "\\W", " ")

# 명사 추출
nouns <- extractNoun(txt)

# 추출한 명사 리스트를 문자열 벡터로 변환하여 단어별 빈도표 생성
wordcount <- table(unlist(nouns))

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringAsFactor = F)

# 변수명 수정
df_word <- rename(df_word, word = Var1, freq = Freq)


# 두글자 이상 단어만 추출
df_word$word <- as.character(df_word$word)

df_word <- filter(df_word, nchar(word) >= 2)

# 상위 20개 추출
pal <- brewer.pal(8,"Dark2")
set.seed(1234)

wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq=2,
          max.words = 200,
          random.order=F,
          rot.per = .1,
          scale = c(4, 0.3),
          colors = pal)
