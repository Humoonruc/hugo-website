library(tidyverse)
library(data.table)
library(magrittr)

# 读取联合国的国家和地区代码表
ISO_id_code <- read_csv("ISO-country-id-code.csv") %>%
  # 国家 id 补成3位字符串，首位不足补零
  mutate(id = str_pad(id, 3, side = "left", pad = "0"))

# 读取 GATT-WTO 成员国的加入/退出时间
timeline_gatt <- read_csv("GATT-WTO-member-timeline.csv") %>%
  left_join(ISO_id_code, by = "name") %>%
  setDT()

# 读取 Comecon 成员国的加入/退出时间
timeline_comecon <- read_csv("Comecon-member-timeline.csv") %>%
  left_join(ISO_id_code, by = "name") %>%
  setDT()

# 匹配成员国的国家代码
country_codes <- c(timeline_gatt$code, timeline_comecon$code) %>% unique()

# 研究期限
period <- 1948:2021

# 遍历国家代码和期限，扩展出一个长数据框
full_table <- data.table(code = "", year = 0, in_gatt = F, in_comecon = F)
for (n in country_codes) {
  for (t in period) {
    line <- data.table(code = n, year = t, in_gatt = F, in_comecon = F)
    full_table <- bind_rows(full_table, line)
  }
}
full_table <- full_table %>% filter(year > 0)


# 将不是成员的年份和是成员的年份用不同颜色区分
for (n in country_codes) {
  t1 <- timeline_gatt[code == n] %>% extract2("gatt_access")
  t2 <- timeline_gatt[code == n] %>% extract2("gatt_exit")
  t3 <- timeline_gatt[code == n] %>% extract2("re_access")
  t4 <- timeline_comecon[code == n] %>% extract2("comecon_access")
  t5 <- timeline_comecon[code == n] %>% extract2("comecon_exit")
  full_table[code == n & year >= t1, in_gatt := T]
  full_table[code == n & year >= t2, in_gatt := F]
  full_table[code == n & year >= t3, in_gatt := T]
  full_table[code == n & year >= t4, in_comecon := T]
  full_table[code == n & year >= t5, in_comecon := F]
}


full_table <- full_table[
  in_gatt == F & in_comecon == F, color := "white"
][
  in_gatt == T & in_comecon == F, color := "lightblue"
][
  in_gatt == F & in_comecon == T, color := "orangered"
][
  in_gatt == T & in_comecon == T, color := "green"
]

output <- full_table %>%
  select(code, year, color) %>%
  left_join(ISO_id_code, by = "code") %>%
  select(-chinese_name)

output %>%
  mutate(id = str_c("'", id)) %>%
  write_csv("matched-data.csv")
