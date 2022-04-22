# import modules
library(tidyverse)
library(bruceR)
library(data.table)
library(magrittr)
library(kableExtra) # 表格美化
library(plotly) # 绘图
library(htmlwidgets)
library(downloadthis) # 提供资源下载的html部件
library(zeallot) # 解构赋值
library(ivreg) # 做 2SLS regression 很方便
library(numDeriv) # Package for computing f'(x)
library(rootSolve) # 求解非线性方程（组）和最优化


# .Rmd 配置参数
config <- list(
  width = 80,
  fig.width = 6,
  fig.asp = 0.618,
  out.width = "90%",
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


# 自定义表格样式
prettify <- function(table, ...) {
  align_vector <- c("l", rep("c", ncol(table) - 1))

  kable(table, "html", align = align_vector, ...) %>%
    kable_styling(
      bootstrap_options = c(
        "striped", # 明暗条纹
        "hover", # 鼠标划过高亮
        "condensed", # 紧凑行高
        "responsive" # 响应屏幕宽度
      ),
      # font_size = 14,
      full_width = F
    )
}

# 自定义 plotly 主题
canvas <- plot_ly(
  width = 800,
  height = 600
) %>% config(
  mathjax = "cdn",
  toImageButtonOptions = list(
    format = "svg", # one of png, svg, jpeg, webp
    filename = "download_figure",
    width = 800,
    height = 600,
    scale = 1
  )
)

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
        # family = "Times New Roman",
        size = 20
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