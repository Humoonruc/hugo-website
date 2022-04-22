rm(list = ls(all = TRUE))
source("../config/Rmarkdown_config.R")


T_list <- c(100, 1000, 10000)
theta_list <- c(3.60, 8.28, 12.86)

# 概率密度函数图像

figs_list <- list()

for (T in T_list) {
  for (theta in theta_list) {
    parameters <- str_c("T_i=", T, ", \\theta=", sprintf("%0.2f", theta)) %>%
      TeX()
    x <- seq(0, 21, length.out = 1000)
    y <- T * theta * x^(-theta - 1) * exp(-T * (x^(-theta)))

    fig <- canvas %>%
      add_lines(x = x, y = y) %>%
      add_annotations(
        text = parameters,
        xref = "x", yref = "y",
        x = 20, y = 2.8,
        xanchor = "right", yanchor = "top",
        showarrow = FALSE
      ) %>%
      academic_layout() %>%
      layout(
        # colorway = list("black"),
        xaxis = list(
          showline = FALSE,
          range = c(0, 21), nticks = 5
        ),
        yaxis = list(
          showline = FALSE,
          range = c(-0.1, 3), nticks = 4
        )
      )

    figs_list[[length(figs_list) + 1]] <- fig
  }
}

p <- subplot(figs_list,
  nrows = length(T_list), widths = c(0.32, 0.34, 0.33),
  shareX = TRUE, shareY = TRUE
) %>%
  add_annotations(
    text = TeX("\\text{Probability density of country i's efficiency on good j, }Z_i(j)"),
    xref = "paper", yref = "paper",
    x = -0.02, y = -0.12,
    showarrow = FALSE
  ) %>%
  add_annotations(
    text = TeX("\\boldsymbol{f_i(z)}"),
    xref = "paper", yref = "paper",
    x = -0.06, y = 0.5,
    showarrow = FALSE
  ) %>%
  add_annotations(
    text = TeX("\\boldsymbol{z}"),
    xref = "paper", yref = "paper",
    x = 0.491, y = -0.05,
    yanchor = "top",
    showarrow = FALSE
  ) %>%
  layout(
    margin = list(b = 140, t = 20, l = 65, r = 0),
    showlegend = FALSE,
    plot_bgcolor = "#e5ecf6",
    title = list(
      text = "<b>Fréchet Distribution: Probability Density Function</b>"
      # font = list(size = 24, family = "Microsoft YaHei"),
      # pad = list(t = 113),
      # x = 0.527
    )
  ) %>%
  config(mathjax = "cdn")

p

saveWidget(p, "Fréchet-distribution-density.html",
  selfcontained = F, libdir = "lib"
)

# 若为了嵌入其他网页，还是 selfcontained = T 更方便
# saveWidget(p, "../export/Fréchet-distribution-density-selfcontained.html")



# 分布函数图像

figs_list <- list()

for (T in T_list) {
  for (theta in theta_list) {
    parameters <- str_c("T_i=", T, ", \\theta=", sprintf("%0.2f", theta)) %>%
      TeX()
    x <- seq(0, 26, length.out = 1000)
    y <- exp(-T * (x^(-theta)))

    fig <- canvas %>%
      add_lines(x = x, y = y) %>%
      add_annotations(
        text = parameters,
        xref = "x", yref = "y",
        x = 25, y = 0.8,
        xanchor = "right", yanchor = "top",
        showarrow = FALSE
      ) %>%
      academic_layout() %>%
      layout(
        # colorway = list("black"),
        xaxis = list(
          showline = FALSE,
          range = c(0, 26), nticks = 6
        ),
        yaxis = list(
          showline = FALSE,
          range = c(-0.05, 1.05), nticks = 4
        )
      )

    figs_list[[length(figs_list) + 1]] <- fig
  }
}

p <- subplot(figs_list,
  nrows = length(T_list), widths = c(0.32, 0.34, 0.33),
  shareX = TRUE, shareY = TRUE
) %>%
  add_annotations(
    text = TeX("\\text{Distribution of country i's efficiency on good j, }Z_i(j)"),
    xref = "paper", yref = "paper",
    x = -0.02, y = -0.14,
    showarrow = FALSE
  ) %>%
  add_annotations(
    text = TeX("\\boldsymbol{F_i(z)}"),
    xref = "paper", yref = "paper",
    x = -0.066, y = 0.5,
    showarrow = FALSE
  ) %>%
  add_annotations(
    text = TeX("\\boldsymbol{z}"),
    xref = "paper", yref = "paper",
    x = 0.491, y = -0.05,
    yanchor = "top",
    showarrow = FALSE
  ) %>%
  layout(
    margin = list(b = 140, t = 20, l = 65, r = 0),
    showlegend = FALSE,
    plot_bgcolor = "#e5ecf6",
    title = list(
      text = "<b>Fréchet Distribution Function</b>",
      font = list(size = 28, family = "Microsoft YaHei"),
      pad = list(t = 113),
      x = 0.527
    )
  ) %>%
  config(mathjax = "cdn")

p

saveWidget(p, "Fréchet-distribution.html",
  selfcontained = F, libdir = "lib"
)
