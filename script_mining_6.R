# httr jsonlite

install.packages("httr")
install.packages("jsonlite")
library(httr)
library(dplyr)
library(jsonlite)

#주소에서 좌표로 추출
key = '5073a533aa519e0c447e24d43e5175e0'
query_ex = '전북 삼성동 100'

data <- data.frame()

result <- GET(url = "https://dapi.kakao.com/v2/local/search/address.json", 
              query = list(query = query_ex),
              add_headers(Authorization=paste0("KakaoAK ", key)))
result


kmap_list <- result %>% 
  content(as='text') %>% 
  fromJSON()

kmap_list

kmap_list$documents$x
kmap_list$documents$y

col <- cbind(kmap_list$documents$x,
             kmap_list$documents$y)
data <- rbind(data,col)

write.csv(data,file='kmap_api.csv')


# 좌표를 주소로 변환
y_point <- 35.53162132066665
x_point <- 129.32202168173953
result2 <- GET(url = "https://dapi.kakao.com/v2/local/geo/coord2address.json",
               query= list(x = x_point, y = y_point ),
               add_headers(Authorization=paste0("KakaoAK ", key)))
result2

kmap_list2 <- result2 %>% 
  content(as='text') %>% 
  fromJSON()


# 반경 내 매장 검색 
query_cgv = "cgv"
radius = 20000
y_p <- 35.22960309550313
x_p <- 129.08936714354857
category_group_code = 'CT1'

result2 <- GET(url = "https://dapi.kakao.com/v2/local/search/keyword.json",
               query= list(x = x_p, y = y_p, 
                           query=query_cgv,
                           radius=radius,
                           category_group_code=category_group_code),
               add_headers(Authorization=paste0("KakaoAK ", key)))
result2

kmap_list2 <- result2 %>% 
  content(as='text') %>% 
  fromJSON()
kmap_list2