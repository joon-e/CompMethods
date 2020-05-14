library(tidyverse)

data <- readxl::read_xlsx("data/2020_05_06_Daten_Julian_D.xlsx")


short <- data %>% 
  select(URL = URL_new, party = SOURCE_NAME, type, message, link)

times <- data %>% 
  select(starts_with("created")) %>% 
  mutate_all(as.character) %>% 
  mutate(created_hour = str_sub(created_hour, 12, 19)) %>% 
  mutate(timestamp = lubridate::ymd_hms(paste(created_time, created_hour)))


reactions <- data %>% 
  select(starts_with("later")) %>%
    rename_all(~ str_replace(., "later_", "")) %>% 
    rename_all(~ str_replace(., "summary.total_", "")) %>% 
    rename_all(~ str_replace(., "\\.", "_"))


sample_data <- bind_cols(short, times, reactions) %>% 
  mutate(id = 1:nrow(.)) %>% 
  select(id, URL, party, timestamp, type, message, link, ends_with("count"))

write_csv(sample_data, "data/facebook_europawahl.csv")

# Topics

data %>% 
  select(starts_with("topic")) %>% 
  select(-topic_new) %>% 
  mutate(id = 1:nrow(.)) %>% 
  select(id, everything()) %>%
  arrange(desc(topic330)) %>% 
  write_csv("data/facebook_codings.csv")


test <- read_csv("data/facebook_codings.csv")

facebook_europawahl %>% 
  left_join(test)
