## investing.com

install.packages("revst")
install.packages("stringr")
install.packages("dplyr")

library(rvest)
library(stringr)
library(dplyr)

URL = "https://www.investing.com/indices/major-indices"
res = read_html(URL)
View(res)

tab = res %>%
  html_table() %>%
  .[[1]]
View(tab)

names(tab)[1] = "v1"
names(tab)[dim(tab)[2]] = "v.last"
names(tab)

major.indice = tab %>%
  select(-v1, -v.last)
major.indice

major.indice.core = major.indice %>%
  slice(1:5, 9:12, 39)
major.indice.core
