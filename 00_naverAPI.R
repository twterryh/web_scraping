install.packages("KoNLP")
install.packages("rJava")
install.packages("XML")
install.packages("rvest")
install.packages("httr")
install.packages("stringr")
  
library("KoNLP")
library("rJava")
library("XML")
library("rvest")
library("httr")
library("stringr")
useSejongDic()

api_url  = "https://openapi.naver.com/v1/search/news.xml"
query = URLencode(iconv("자동차", to="UTF-8"))
query = str_c("?query=", query)
client_id     = "(본인 id 입력)"
client_secret = "(본인 pw 입력)"
display_ = "&display=100"
start_ = "&start=1"
sort_ = "&sort=date"

result = GET(str_c(api_url, query, display_, start_, sort_), 
              add_headers("X-Naver-Client-Id" = client_id
                          , "X-Naver-Client-Secret" = client_secret))
result   


n_xml = xmlParse(result)
n_xml

# See that each news content is wrapped as an <item>
# what is xpath? path : root -> rss -> channel -> title

n_xml_t = xpathApply(n_xml, '/rss/channel/item/title', xmlValue)
View(n_xml_t) 

n_xml_d = xpathApply(n_xml, '/rss/channel/item/description', xmlValue)
View(n_xml_d)

n_xml_all = c(n_xml_t, n_xml_d)

print(class(n_xml_all))   # list
print(typeof(n_xml_all))  # list

View(n_xml_all)

# Split by " "
xml_v = ''
for (v in n_xml_all) {
  xml_v = c(xml_v, strsplit(v, " "))
}
xml_v

# unlist
xml_un = Filter(function(x) { nchar(x) >= 2 }, unlist(xml_v))
print(class(xml_un))
print(xml_un)

# pre-processing
xml_del = xml_un
dels = c('','\\"', '\\','\\,','\\.','&quot;','','"', '<b>', '</b>','&amp;', ']'
         , '[', '?','\\】','\\【' ,'\\◆' )
for (d in dels ) {
  xml_del = gsub(d,  "", xml_del)  
}
xml_del
xml_del = gsub("<b>자동차</b>", "자동차", xml_del)
xml_del = gsub("현대자동차가", "현대자동차", xml_del)
xml_del = gsub("현대차", "현대자동차", xml_del)
xml_del = gsub("현대자동차그룹", "현대자동차", xml_del)
xml_del

xml_del = xml_del[!xml_del %in% c("함께","올해","발생","뒤를","혐의로","등의","것으로","3%","", "...", "자동차", "따르면"
                                  , "있다.", "11일", "기자", "대한", "위해"
                                  , "이번" )]
xml_del

# table of top10
xml_10_tb = table(xml_del)   # 특정단어의 반복 횟수
xml_10 <- head(sort(xml_10_tb, decreasing = T), 10)
xml_10

# plot
barplot(xml_10, main="네이버 자동차 검색시 단어 빈도수", col=rainbow(10))
