#!/usr/bin/env Rscript
library(magrittr)
library(tidyverse)

p_04 <- readRDS("data-raw/.temp/data/pipelines_2004_renamed.rds")
p_10 <- readRDS("data-raw/.temp/data/pipelines_2010_renamed.rds")

# 1. Recode
p_04 %<>% mutate(commodity = oildata:::fix_commodities(commodity))
p_10 %<>% mutate(commodity = oildata:::fix_commodities(commodity))

# 2. String cosmetics
p_04 <- p_04 %>%
  mutate(name = str_to_title(name)) %>%
  mutate(name = DataAnalysisTools::remove_company_suffixes(name))
p_10 <- p_10 %>%
  mutate(name = str_to_title(name)) %>%
  mutate(name = DataAnalysisTools::remove_company_suffixes(name))

# 3. Fill NAs
p_10_na_cols <-
  c("hca_onshore", "hca_offshore", "volume_co2_offshore",
    "volume_crude_offshore", "volume_fge_offshore", "volume_hvl_offshore",
    "volume_rpp_offshore", "volume_co2_onshore", "volume_crude_onshore",
    "volume_fge_onshore", "volume_hvl_onshore", "volume_rpp_onshore")
p_10 %<>% mutate(across( {{p_10_na_cols}} , ~ replace_na(., 0)))

# 4. Bools

# 5. Write to disk
readr::write_rds(p_04, "data-raw/.temp/data/pipelines_2004_cleaned.rds")
readr::write_rds(p_10, "data-raw/.temp/data/pipelines_2010_cleaned.rds")
