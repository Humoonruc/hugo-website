## use necessary packages
library('pacman')
p_load(
  # data processing
  tidyverse,
  lubridate,
  data.table,
  magrittr,
  # visualization
  ggthemes,
  showtext,
  gridExtra,
  r2d3,
  # 可交互表格 DT::datatable()
  DT,
  # I/O
  sqldf,
  jsonlite,
  # web crawler
  rvest,
  httr,
  reticulate
)

## database engine
options(sqldf.driver = "SQLite")



# 调用封装好的爬虫函数 getWebPage()
# 注意，要用相对于项目根目录的地址，而非相对于脚本文件的地址
source('./Rscript/crawlWebPageFunction.R')


# 解析和整理单日数据
getDailyNews <- function(date) {
  ## 1. 构建对摘要数据真实地址的请求
  url <- str_c("https://tv.cctv.com/lm/xwlb/day/", date, ".shtml")
  
  
  ## 2. 爬取摘要页的文本和链接信息
  rootNode <- getWebPage(url) %>% # 爬取，返回字符串
    read_html() %T>% # 解析为xml_document类
    xml2::write_html("successOrFail.html") # 写至本地，观察测试
  
  # 新闻标题
  titles <- rootNode %>%
    html_nodes("div.title") %>%
    html_text()
  
  # 详情链接
  links <- rootNode %>%
    html_nodes("li>a") %>%
    html_attrs() %>%
    map_chr(extract("href")) # 传给map_chr的是列表的各个元素
  
  
  ## 3. 用数据框的方式组织数据
  indexPage <-
    data.table(title = titles, link = links) %>%
    filter(str_detect(title, "[视频]")) %>%
    mutate(title = str_replace(title, "\\[视频\\]", "")) #若不转义会被理解为正则表达式
  indexPage[, id := 1:.N] # 增加一列编号
  # 或者写成: %>% rownames_to_column(var = "id")
  
  # 国内联播快讯和国际联播快讯，需要进一步爬取具体内容
  domesticExpressLink <-
    indexPage[title == "国内联播快讯", link]
  foreignExpressLink <-
    indexPage[title == "国际联播快讯", link]
  
  
  ## 4. 跳转页面，爬取国内和国际联播快讯的具体条目
  if (length(domesticExpressLink) > 0) {
    domesticExpress <- domesticExpressLink %>%
      getWebPage() %>%
      read_html() %>%
      html_nodes("div.cnt_bd>p>strong") %>%
      html_text()
    
    domesticPage <- data.table(title = "国内联播快讯",
                               detail = domesticExpress) %>%
      filter(detail != "央视网消息" & detail != "") %>%
      inner_join(indexPage) %>%
      mutate(title = str_c("【国内联播快讯】", detail)) %>%
      select(-detail)
  } else{
    domesticPage <- data.table()
  }
  
  if (length(foreignExpressLink) > 0) {
    foreignExpress <- foreignExpressLink %>%
      getWebPage() %>%
      read_html() %>%
      html_nodes("div.cnt_bd>p>strong") %>%
      html_text()
    
    foreignPage <- data.table(title = "国际联播快讯",
                              detail = foreignExpress) %>%
      filter(detail != "央视网消息" & detail != "") %>%
      inner_join(indexPage) %>%
      mutate(title = str_c("【国际联播快讯】", detail)) %>%
      select(-detail)
  } else{
    foreignPage <- data.table()
  }
  
  
  ## 5. 表的合并
  newsTable <- bind_rows(indexPage, domesticPage, foreignPage) %>%
    unique() %>%
    arrange(id) %>%
    filter(!title %in% c("国内联播快讯", "国际联播快讯")) %>%
    mutate(
      date = ymd(date) %>% as.character(),
      year = year(ymd(date)),
      month = month(ymd(date)),
      day = day(ymd(date))
    ) %>%
    select(date, title, link, year, month, day)
  
  return(newsTable)
}


# 主函数
main <- function(timeSpan) {
  # 创建空数据框作为容器
  XinwenLianbo <- data.table()
  
  # 循环爬取
  for (i in 1:timeSpan) {
    date <- (today() - timeSpan - 1 + i) %>%
      format("%Y%m%d") # 日期格式化
    dailyNews <- getDailyNews(date)
    XinwenLianbo <-  bind_rows(XinwenLianbo, dailyNews)
    Sys.sleep(1)
  }
  
  startDate <- (today() - timeSpan) %>% format("%Y%m%d")
  endDate <- (today() - 1) %>% format("%Y%m%d")
  
  # 同样要小心，文件路径要相对于项目根目录
  filePath <-
    str_c("./data/XinwenLianbo.csv")
  
  # 防止中文乱码，只能用write_excel_csv()，且append必须为F
  write_excel_csv(XinwenLianbo, filePath, append = T, col_names = T,)
}


# 提交配置并运行程序
timeSpan <- 1
main(timeSpan)