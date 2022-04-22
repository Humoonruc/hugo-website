library(tidyverse)
library(data.table)
library(magrittr)
library(plotly)
library(htmlwidgets)
library(xfun)
library(downloadthis)

library(haven)
library(ivreg)
library(lmtest)
library(sandwich)



grilic <- read_dta("./data/grilic.dta")
names(grilic)

# OLS
fit_ols1 <- lm(lw ~ s + expr + tenure + rns + smsa, data = grilic) # 没有加入智商iq变量
slm1 <- summary(fit_ols1)
slm1

fit_ols2 <- lm(lw ~ iq + s + expr + tenure + rns + smsa, data = grilic)
slm2 <- summary(fit_ols2)
slm2

coeftest(fit_ols2, vcov = vcovHC, type = "HC1") # 异方差稳健标准误

# IV
# 将 med、kww、mrt、age 作为 iq 的工具变量
fit_iv <- ivreg(lw ~ iq + s + expr + tenure + rns + smsa |
  med + kww + mrt + age + s + expr + tenure + rns + smsa, data = grilic)

# 提取稳健标准误
coeftest(fit_iv, vcov = vcovHC, type = "HC0") # 异方差稳健标准误

# 工具变量法回归还要进行诊断
summary(fit_iv, test = TRUE) # 诊断

# 工具变量过度识别检验未通过，因此需要调整工具变量
# 这里怀疑 mrt, age 与 tenure 可能存在过度识别，剔除后进行 ivreg 回归

fit_iv2 <- ivreg(lw ~ iq + s + expr + tenure + rns + smsa |
  med + kww + s + expr + tenure + rns + smsa, data = grilic)

summary(fit_iv2, test = TRUE)
# 三项检验均通过