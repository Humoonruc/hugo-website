# Rmarkdown 文件配置参数
config <- list(
  width = 80,
  fig.width = 6,
  fig.asp = 0.618,
  out.width = "90%",
  fig.align = "center",
  fig.path = "figure/",
  fig.show = "asis",
  warn = 1,
  warning = FALSE,
  message = FALSE,
  echo = TRUE, # 是否显示代码
  eval = TRUE, # 是否运行代码块
  tidy = F, # 代码排版
  comment = "#", # 每行输出的前缀，为了方便复制粘贴时不会污染代码
  collapse = F, # 代码与结果是否显示在同一代码块
  cache = T, # 代码块运行结果缓存
  cache.comments = T,
  autodep = T # 自动获得模块间依赖，cache 用
)


# 自定义 ggplot2 主题
library(tidyverse)
library(ggthemes)
my_theme <- theme_economist_white() +
  theme(
    text = element_text(family = "Microsoft YaHei"),
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 14),
    plot.caption = element_text(
      hjust = 0,
      size = 12,
      margin = margin(2, 0, 0, 0, "pt")
    ),
    plot.margin = margin(12, 10, 12, 0, "pt"),
    legend.position = "top",
    legend.justification = "left",
    legend.margin = margin(4, 0, 0, 0, "pt"),
    legend.key.size = unit(1, "lines"),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10, margin = margin(0, 0, 0, 0, "pt")),
    axis.title = element_text(face = "bold", size = 12),
    axis.text = element_text(size = 10, margin = margin(2, 0, 2, 0, "pt")),
    axis.ticks.length = unit(-4, "pt")
  )