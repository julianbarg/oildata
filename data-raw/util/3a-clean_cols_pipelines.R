#!/usr/bin/env Rscript
suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(here))

data_folder <- purrr::partial(here, "data-raw", ".temp", "data")
p_04 <- readRDS(data_folder("pipelines_2004_renamed.rds"))
p_10 <- readRDS(data_folder("pipelines_2010_renamed.rds"))

# 1. Recode
na_function <- function(x) ifelse(x %in% c("nan", "NULL", "UNKNOWN"), NA, x)
p_04 %<>% mutate(across(where(is.character), na_function))
p_10 %<>% mutate(across(where(is.character), na_function))

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
# Filling in some columns that operators typically leave empty
p_10_na_cols <-
  c("hca_onshore", "hca_offshore", "volume_co2_offshore",
    "volume_crude_offshore", "volume_fge_offshore", "volume_hvl_offshore",
    "volume_rpp_offshore", "volume_co2_onshore", "volume_crude_onshore",
    "volume_fge_onshore", "volume_hvl_onshore", "volume_rpp_onshore")
custom_na <- function(x)
p_10 %<>% mutate(across({{ p_10_na_cols }}, ~ replace_na(., 0)))

# 4. ID
p_04$ID <- as.character(p_04$ID)
p_10$ID <- as.character(p_10$ID)

# 5. Write to disk
readr::write_rds(p_04, data_folder("pipelines_2004_cleaned.rds"))
readr::write_rds(p_10, data_folder("pipelines_2010_cleaned.rds"))

print("3a - Cleaned pipelines dataset.")
