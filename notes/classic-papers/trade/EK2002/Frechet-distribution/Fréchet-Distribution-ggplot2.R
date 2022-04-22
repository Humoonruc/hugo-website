library(tidyverse)
library(gridExtra)

num_row = 3
num_col = 3

p <- list()
n <- 0
for (i in 1:num_row) {
  t <- 10*10^i
  string_t <- str_c('T = ', t)
  for (j in 1:num_col) {
    n = n + 1
    theta <- 1 + j*0.3
    string_theta <- str_c(', θ = ', theta)
    
    x <- 1:10000 / 10
    y <- t*theta*x^(-theta - 1)*exp(-t*(x^(-theta)))
    data <- tibble(z = x, f = y)
    p[[n]] <- ggplot(data, aes(x = z, y = f)) + 
      geom_point(size = 0.2) + 
      labs(title = str_c(string_t, string_theta))
  }
}

graph <- arrangeGrob(grobs = p, ncol = num_row)
grid.arrange(graph)
ggsave(file = "Frechet.png", plot = graph, dpi = 600)
