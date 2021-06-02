# PeopleDaily.R

## use necessary packages
library('pacman')
p_load(
  # data processing
  tidyverse, lubridate, data.table, magrittr,
  # I/O 
  sqldf,
  # web crawler
  rvest, reticulate
)

## database engine
options(sqldf.driver = "SQLite")


source('./Rscript/crawlWebPageFunction.R') 

# 定义getReviewPage()，获取评论版的链接

getReviewPage <- function(yearMonth, day) {
  
  # 拼接对应日期的报纸页面 url
  url <-
    str_c(
      "http://paper.people.com.cn/rmrb/html/",
      yearMonth,
      "/",
      day,
      "/nbs.D110000renmrb_01.htm"
    )
  
  # 获取评论版的版数
  rootNode <- getWebPage(url) %>% read_html()
  pageNumber <- rootNode %>%
    html_nodes("div.swiper-slide>a#pageLink") %>%
    html_text() %>%
    str_subset("评论$") %>% # 挑选以“评论”结尾的版
    str_sub(end = 2)
  
  # 若该期无评论版，则返回NULL，否则返回评论版的url
  if (length(pageNumber) != 0) {
    reviewPageUrl <-
      str_c(
        "http://paper.people.com.cn/rmrb/html/",
        yearMonth,
        "/",
        day,
        "/nbs.D110000renmrb_",
        pageNumber,
        ".htm"
      )
  } else{
    reviewPageUrl <- NULL
  }
  return(reviewPageUrl)
}

# 定义parseReviewPage()，解析和整理评论版文章
parseReviewPage <- function(reviewPageUrl) {
  # 只有该期存在评论版，才继续爬取
  if (reviewPageUrl %>% length() != 0) {
    reviewTable <- data.table()
    
    articleLinkNodes <- getWebPage(reviewPageUrl) %>%
      read_html() %>%
      html_nodes("ul.news-list>li>a")
    
    # 遍历评论版所有文章
    for (i in 1:length(articleLinkNodes)) {
      articleTitle <- articleLinkNodes %>% html_text() %>% extract(i)
      # 只爬取人民时评、人民观点、评论员观察这三个栏目文章的详情
      if (str_detect(articleTitle, "(人民时评|人民观点|评论员观察)")) {
        print("Crawling an article!")
        
        articleLink <- articleLinkNodes %>%
          html_attrs() %>%
          extract2(i) %>%
          str_c("http://paper.people.com.cn/rmrb/html/",
                yearMonth,
                "/",
                day,
                "/",
                .)
        
        arcticleNode <- getWebPage(articleLink) %>%
          read_html() %>%
          html_node("div.article")
        
        title <- arcticleNode %>% html_node("h1") %>% html_text() %>% 
          str_replace("\\(", "（") %>% str_replace("\\)", "）") # 更换不规范括号
        author <-
          arcticleNode %>% html_node("p.sec") %>% html_text() %>%
          str_split("《") %>% unlist() %>% extract(1) %>% str_trim()
        text <-
          arcticleNode %>% html_nodes("div#ozoom>p") %>% html_text() %>%
          str_c("\n") %>% reduce(str_c)
        
        reviewTable <- data.table(title = title,
                                  author = author,
                                  text = text) %>%
          bind_rows(reviewTable, .)
        
        Sys.sleep(0.1)
      }
    }
    return(reviewTable)
  } else {
    return(NULL)
  }
}


# 主程序。给出爬取天数（从当天开始向前倒推），循环爬取并将结果保存为表格。

# 本脚本可以爬取人民日报2020年7月1日至今的评论版文章，故timeSpan最大可取229。

# 再之前的页面格式与最近的不同，需要微调代码才能爬取。


timeSpan <- 200

# 创建空数据框作为容器
peopleDaily <- data.table()

# 循环爬取
for (i in 1:timeSpan) {
  date <- (today() - timeSpan - 1 + i)
  yearMonth <- date %>% format("%Y-%m")
  day <- date %>% format("%d")
  
  reviewDataTable <- getReviewPage(yearMonth, day) %>% 
    parseReviewPage()
  
  if (reviewDataTable %>% length() != 0) {
    reviewDataTable <- reviewDataTable %>%
      mutate(date = date) %>%
      select(date, everything())
    peopleDaily <- bind_rows(peopleDaily, reviewDataTable)
    
    print(str_c("Review page exists on ", date, "."))
    Sys.sleep(1)
  }
}


startDate <- (today() - timeSpan) %>% format("%Y%m%d")
endDate <- (today() - 1) %>% format("%Y%m%d")
filePath <-
  str_c("../data/People'sDaily-", startDate, "-", endDate, ".csv")


if (peopleDaily %>% count() %>% unlist() != 0) {
  peopleDaily <- peopleDaily %>%
    mutate(subject =  title %>% str_extract("（.*?）") %>% str_sub(2, -2)) %>%
    mutate(title = title %>% str_replace("（.*?）", "")) %>%
    select(date, subject, everything())
  
  # 防止中文乱码，只能用write_excel_csv()，且append必须为F
  write_excel_csv(peopleDaily, filePath)
}

