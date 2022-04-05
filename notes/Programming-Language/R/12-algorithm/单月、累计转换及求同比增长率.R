library(tidyverse)
library(lubridate)
library(sqldf)
options(sqldf.driver = "SQLite")

## 读取数据
channel <- dbConnect(SQLite(), dbname = "C:/Users/Humoonruc/OneDrive/ICT/DataBase/SQLite/trade.db")
total <- dbReadTable(channel, "total")


## 1 由单月值获取累计值，两种方法很可能是一致的-----------------

# (1) 使用 SQL 语言

# SQL 累计算法
sqldf(
  "SELECT *, SUM(export)
  OVER (PARTITION BY year ORDER BY month) acc_ex
  FROM total t
  ORDER BY year, month"
)

# 建立一个循环
index <- c("export", "import", "trade", "surplus")
for (i in 1:4) {
  query <- str_c(
    "SELECT *, SUM(",
    index[i],
    ") OVER (PARTITION BY year ORDER BY month) acc_",
    str_sub(index[i], 1, 3),
    " FROM total t ORDER BY year, month"
  )
  total <- sqldf(query)
}
total_sql <- total
total <- dbReadTable(channel, "total")
dbDisconnect(channel)

# (2) 使用 R 基本包内置的 cumsum() 函数，一步求累计
total_cumsum <-
  total %>%
  arrange(year, month) %>%
  group_by(year) %>%
  mutate(
    acc_ex = cumsum(export),
    acc_im = cumsum(import),
    acc_tra = cumsum(trade),
    acc_sur = cumsum(surplus)
  ) %>%
  ungroup()


## 2 由累计值求单月值------------------------------------------------------

# 自定义求单月值的差分函数
dif_mon <- function(acc) {
  c(acc[1], diff(acc)) %>% return()
}

total_month <- total_cumsum %>%
  arrange(year, month) %>%
  group_by(year) %>%
  mutate(
    export = dif_mon(acc_ex),
    import = dif_mon(acc_im),
    trade = dif_mon(acc_tra),
    surplus = dif_mon(acc_sur)
  ) %>%
  ungroup()


## 3 求同比增长率------------------------------------------------------

# 自定义增长率函数
growth <- function(a, n) {
  Fai <- rep(NA, n)
  b <- c(Fai, diff(a, n))
  round(100 * b / (a - b), 2) %>% return()
}

index <- colnames(total_cumsum)[-c(1:3)]

for (i in 1:length(index)) {
  total_cumsum[[str_c("g_", index[i])]] <-
    growth(total_cumsum[[index[i]]], 12)
}