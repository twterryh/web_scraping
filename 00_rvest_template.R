########### rvest template ############
install.packages("revst")
install.packages("stringr")
install.packages("dplyr")

library(rvest)
library(stringr)
library(dplyr)

URL = ""

# Table
res = read_html(URL)
res %>%
  html_table()

# Pattern
pattern = ""
res %>%
  html_nodes() %>%
  html_text()

# Attribute's value
pattern = ""
res %>%
  html_nodes() %>%
  html_attr("href")

