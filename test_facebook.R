library(quanteda)
library(tidyverse)

# Daten einlesen 

fb <- read_csv("data/facebook_europawahl.csv")
bt_parteien <- c("alternativefuerde", "B90DieGruenen", "CDU", "CSU", "FDP", "linkspartei", "SPD")

reduced <- fb %>% 
  filter(party %in% bt_parteien) %>% 
  select(id, party, message)


# Korpus

fb_corpus <- corpus(reduced, docid_field = "id", text_field = "message")


# Tokens

fb_tokens <- tokens(fb_corpus,
                    remove_punct = TRUE,
                    remove_numbers = TRUE,
                    remove_symbols = TRUE,
                    remove_url = TRUE) %>% 
  tokens_tolower() %>% 
  tokens_remove(stopwords("german")) %>% 
  tokens_ngrams(n = 1:3)


# DFM

fb_dfm <- dfm(fb_tokens)

topfeatures(fb_dfm, groups = "party")

dfm_select(fb_dfm, pattern = "#*") %>% 
  topfeatures(groups = "party")
