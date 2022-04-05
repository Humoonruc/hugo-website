# import modules
library(tidyverse)
library(data.table)
library(magrittr)
library(plotly)
library(htmlwidgets)
library(downloadthis)

# ivreg包，直接做 2SLS 回归
library(ivreg)


# .Rmd 配置参数
config <- list(
  width = 80,
  fig.width = 6,
  fig.asp = 0.618,
  out.width = "70%",
  fig.align = "center",
  fig.path = "../img/",
  fig.show = "asis",
  warn = 1,
  warning = FALSE,
  message = FALSE,
  echo = TRUE, # 是否显示代码
  eval = TRUE, # 是否运行代码块
  tidy = F, # 代码排版
  comment = "#>", # 每行输出的前缀，为了方便复制粘贴时不会污染代码
  collapse = F, # 代码与结果是否显示在同一代码块，选否可避免打印图形后，同一代码块中后面的行被落在块外
  cache = T, # 代码块运行结果缓存
  cache.comments = T,
  autodep = T # 自动获得模块间依赖，cache 用
)


# 自定义 plotly 主题
canvas <- plot_ly(
  width = 960,
  height = 720
) %>% config(mathjax = "cdn")

axis_style <- list(
  zeroline = FALSE,
  ticks = "outside",
  tickfont = list(family = "Times New Roman"),
  tickformat = ",",
  gridcolor = "white",
  showline = TRUE
)

academic_layout <- function(p) {
  layout(p,
    margin = list(b = 110, t = 20, l = 90, r = 0),
    title = list(
      font = list(
        family = "Times New Roman",
        size = 24
      ),
      pad = list(t = 80),
      y = 0,
      yanchor = "top",
      yref = "paper"
    ),
    # colorway = list("black"),
    paper_bgcolor = "white",
    # plot_bgcolor = "#e5ecf6",
    xaxis = c(
      axis_style,
      list(title = list(
        standoff = 15L,
        font = list(size = 17, family = "Times New Roman")
      ))
    ),
    yaxis = c(
      axis_style,
      list(title = list(
        standoff = 5L,
        font = list(size = 17, family = "Times New Roman")
      ))
    ),
    legend = list(xanchor = "right")
  )
}
