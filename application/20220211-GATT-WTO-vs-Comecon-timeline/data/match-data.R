library(tidyverse)
library(data.table)
library(magrittr)


############################################################

# 读取联合国的国家和地区代码表
ISO_id_code <- fread("ISO-country-id-code.csv", encoding = "UTF-8") %>%
  mutate(id = str_pad(id, 3, side = "left", pad = "0")) # 国家 id 补成3位字符串，首位不足补零

# 读取 GATT-WTO 成员国的加入/退出时间
timeline_gatt <- fread("GATT-WTO-member-timeline.csv", encoding = "UTF-8") %>%
  left_join(ISO_id_code, by = "name")

# 读取 Comecon 成员国的加入/退出时间
timeline_comecon <- fread("Comecon-member-timeline.csv", encoding = "UTF-8") %>%
  left_join(ISO_id_code, by = "name")


############################################################
## 扩展出一个遍历国家代码和年份的长数据框

# 匹配成员国的国家代码
country_codes <- c(timeline_gatt$code, timeline_comecon$code) %>% unique()
n <- length(country_codes)

# 研究期限
period <- 1948:2021

# 用上述两个向量作为行名、列名，构建宽数据框
wide_table <- rep("white", length(period)) %>%
  rep(n) %>%
  matrix(ncol = n) %>%
  as.data.frame() %>%
  setDT()
colnames(wide_table) <- country_codes

# 宽转长
long_table <- wide_table[, year := period] %>%
  pivot_longer(cols = 1:n, names_to = "code", values_to = "color") %>%
  setDT()


############################################################

# 标记进入/退出年份
long_table[, `:=`(in_gatt = F, in_comecon = F)]
for (i in country_codes) {
  t1 <- timeline_gatt[code == i] %>% extract2("gatt_access")
  t2 <- timeline_gatt[code == i] %>% extract2("gatt_exit")
  t3 <- timeline_gatt[code == i] %>% extract2("re_access")
  t4 <- timeline_comecon[code == i] %>% extract2("comecon_access")
  t5 <- timeline_comecon[code == i] %>% extract2("comecon_exit")
  long_table[code == i & year >= t1, in_gatt := T]
  long_table[code == i & year >= t2, in_gatt := F]
  long_table[code == i & year >= t3, in_gatt := T]
  long_table[code == i & year >= t4, in_comecon := T]
  long_table[code == i & year >= t5, in_comecon := F]
}

# 将不是成员的年份和是成员的年份用不同颜色区分
long_table[
  in_gatt == T & in_comecon == F, color := "lightblue"
][
  in_gatt == F & in_comecon == T, color := "orangered"
][
  in_gatt == T & in_comecon == T, color := "green"
]

# 输出
long_table %>%
  select(code, year, color) %>%
  left_join(ISO_id_code, by = "code") %>%
  mutate(id = str_c("'", id)) %>%
  fwrite("matched-data.csv")