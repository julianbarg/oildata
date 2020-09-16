#!/usr/bin/env Rscript
suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(here))
options(dplyr.summarise.inform = FALSE)

p_04 <- readRDS(here("data-raw", ".temp", "data", "pipelines_2004_cleaned.rds"))
parameters <- readRDS(here("data-raw", ".temp", "parameters.RDS"))

# Currently, miles cutoff is at 0. Only retaining observations with any pipeline miles.
p_04 <- subset(p_04, miles_total > parameters[["miles_cutoff"]])

# Create some missing vars before consolidation for convenience.
p_04 %<>% mutate(miles_onshore = CPBONM + CPCONM + CUBONM + CUCONM)
p_04 %<>% mutate(miles_offshore = CPBOFFM + CPCOFFM + CUBOFFM + CUCOFFM)

# Consolidation rules
take_first_cols <- c("name", "state")
sum_na_rm_cols <-
  c("hca_offshore", "hca_onshore", "hca_total", "miles_onshore",
    "miles_offshore", "miles_total", "volume_crude_total",
    "volume_hvl_total", "volume_rpp_total", "volume_other_total")

# Grab duplicates
duplicates <- duplicated(select(p_04, ID, year, commodity))
p_04_duplicates <- subset(p_04, duplicates)
p_04_unique <- subset(p_04, !duplicates)

# Consolidate
p_04 <- p_04_duplicates %>%
  group_by(ID, year, commodity) %>%
  summarize(across({{ take_first_cols }}, first),
            across({{ sum_na_rm_cols }}, ~ sum(.x, na.rm = T))) %>%
  bind_rows(p_04_unique) %>%
  ungroup()

# Write to disk
readr::write_rds(p_04,
                 here("data-raw", ".temp", "data", "pipelines_2004_fixed.rds"))

print("4 - Fixed duplicate observations in pipelines dataset.")
