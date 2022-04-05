library(tidyverse)

# 将data从csv转换为json的函数
csv2json <- function(csvPath, jsonPath) {
  data <- data.table::fread(csvPath, encoding = "UTF-8")

  key <- colnames(data) %>% str_c('\"', ., '\"')

  linkKeyValue <- function(row) {
    value <- row %>% str_c('\"', ., '\"')
    str_c(key, value, sep = ":") %>%
      str_c(collapse = ",") %>%
      str_c("{", ., "}") %>%
      return()
  }

  rows <- apply(data, 1, linkKeyValue)

  rows %>% str_c(collapse = ",") %>%
    str_c("[", ., "]") %>%
    write_lines(file = jsonPath)
}

