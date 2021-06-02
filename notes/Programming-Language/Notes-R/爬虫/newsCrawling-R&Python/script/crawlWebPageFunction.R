library("pacman")
p_load( # data processing
  tidyverse, lubridate, data.table, magrittr,
  # web crawler
  rvest, reticulate, httr
)


# 构造的爬取页面函数，根据实际情况修改其中的参数
getWebPage <-
  function(url,
           hostname = NULL,
           path = NULL,
           query = NULL,
           username = NULL,
           password = NULL,
           encoding = "utf-8") {
    # 根据传入的参数构造url
    adjustedUrl <- modify_url(
      url,
      scheme = NULL,
      hostname = hostname,
      port = NULL,
      path = path,
      query = query,
      params = NULL,
      fragment = NULL,
      username = username,
      password = password
    )
    # 构造headers
    headers <- c(
      "Accept" = "*/*",
      "Referer" = "https://www.baidu.com/",
      "Connection" =  "keep-alive",
      "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101 Firefox/85.0",
      "Cookie" = ""
    )
    # 爬取页面
    response <-
      GET(adjustedUrl, add_headers(.headers = headers))
    status_code(response) %>% print()
    http_status(response) # 简要描述状态码
    stop_for_status(response) # 若状态码不对，立即终止程序

    htmlBin <-
      content(response, "text", encoding = encoding) %T>%
      writeBin("responseWebPage.html")
    return(htmlBin)
  }