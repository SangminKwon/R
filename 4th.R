# httr jsonlite

install.packages("httr")
install.packages("jsonlite")
library(httr)
library(dplyr)
library(jsonlite)


# 공공데이터포털의 주소 데이터를 카카오API를 활용해 좌표 정보 얻어와서 csv파일로 저장하기
raw_data <- read.csv('보건복지부_전국 지역보건의료기관 현황_20191227.csv')

# 주소데이터 추출
raw_address <- raw_data$주소


# API Key 및 응답결과를 저장할 데이터 프레임
key = '5073a533aa519e0c447e24d43e5175e0'
csV_result <- data.frame()


# 3564개의 의료기관 전부에 대해서 정보 수집
leng <- length(raw_address)
for(i in c(1:leng)){
  query_trial <- raw_address[i]
  
  result <- GET(url = "https://dapi.kakao.com/v2/local/search/address.json", 
                query = list(query = query_trial),
                add_headers(Authorization=paste0("KakaoAK ", key)))
  
  kmap_list <- result %>% 
    content(as='text') %>% 
    fromJSON()
  
  col <- cbind(kmap_list$documents$x,
               kmap_list$documents$y)
  csV_result <- rbind(csV_result,col)
}

csv_result <- rename(csV_result,
                     Longitude = V1,
                     Latitude = V2)

# csv 파일로 저장
write.csv(csV_result,file='local_medical_institution.csv')






