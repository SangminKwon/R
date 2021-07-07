# if문

x <- 50
y <- 4
z <- x*y

if(x*y != 40){
  print('크거나 같습니다.')
}else{
  print("작습니다.")
}

score <- scan()
score

test <- c(2,3)
test

result <- '노력'
if(score>=80){
  result <- '우수'
}

# 성적 입력하고 성적에 따른 총점 평균 계산하기
# 성적에 따라 학점 부여(>=90 A, >=70 B, 이하 C)

all_score <- scan()
gpa <- "C"
print(sum(all_score))
avg <- mean(all_score)
print(avg)

if(avg >= 90){
  gpa <- "A"
}else if(avg>=70){
  gpa <- "B"
}

print(gpa)

# for문
for( 변수 in 집합체){
  pass
}

# 함수
f1 <- function(){
  print('함수실행')
}

f1()

add <- function(x, y){
  return(x+y)
}

add(4,5)


# keyword를 주어 인터넷에서 이미지 가져오기

url = "https://search.daum.net/search?w=img&nil_search=btn&DA=NTB&enc=utf8&q="

library(stringr)
library(rvest)


search_img <- function(keyword){
  target <- keyword
  keyword <- URLencode(keyword)
  url <- paste0(url, keyword)
  html <- read_html(url)
  img_node <- html_nodes(html,"#imgColl")
  
  # sink("laboom_img.txt")
  # writeLines(unlist(lapply(img_node,paste,collapse =" ")))
  # sink()
  
  img_mat <- str_match_all(img_node, 'oimgurl: "(.+?)"')[[1]][,2]
  index <- 1
  
  for(keyword_url in img_mat){
    download.file(keyword_url, destfile = paste0(target,"_image",index,".jpg"),method = 'curl')
    index <- index + 1
  }
}

search_img("브레이브걸스")
search_img("라붐")
