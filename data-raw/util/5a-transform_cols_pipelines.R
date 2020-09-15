#!/usr/bin/env Rscript
suppressMessages(library(tidyverse))
suppressMessages(library(magrittr))
suppressMessages(library(here))

data_folder <- purrr::partial(here, "data-raw", ".temp", "data")
p_04 <- readRDS(data_folder("pipelines_2004_fixed.rds"))
p_10 <- readRDS(data_folder("pipelines_2010_cleaned.rds"))

na_sum <- purrr::partial(rowSums, na.rm=T)

# Pipelines 2004
p_04$offshore_share <- p_04$miles_offshore/(p_04$miles_onshore + p_04$miles_offshore)

p_04$volume_crude_offshore <- ifelse(p_04$offshore_share == 0, 0, NA)
p_04$volume_hvl_offshore <-   ifelse(p_04$offshore_share == 0, 0, NA)
p_04$volume_rpp_offshore <-   ifelse(p_04$offshore_share == 0, 0, NA)
p_04$volume_other_offshore <- ifelse(p_04$offshore_share == 0, 0, NA)
p_04$volume_crude_onshore <-  ifelse(p_04$offshore_share == 0, p_04$volume_crude_total, NA)
p_04$volume_hvl_onshore <-    ifelse(p_04$offshore_share == 0, p_04$volume_hvl_total, NA)
p_04$volume_rpp_onshore <-    ifelse(p_04$offshore_share == 0, p_04$volume_rpp_total, NA)
p_04$volume_other_onshore <-  ifelse(p_04$offshore_share == 0, p_04$volume_other_total, NA)

p_04$estimate_volume_crude_offshore <- p_04$volume_crude_total * p_04$offshore_share
p_04$estimate_volume_hvl_offshore <-   p_04$volume_hvl_total   * p_04$offshore_share
p_04$estimate_volume_rpp_offshore <-   p_04$volume_rpp_total   * p_04$offshore_share
p_04$estimate_volume_other_offshore <- p_04$volume_other_total * p_04$offshore_share
p_04$estimate_volume_crude_onshore <-  p_04$volume_crude_total * (1 - p_04$offshore_share)
p_04$estimate_volume_hvl_onshore <-    p_04$volume_hvl_total   * (1 - p_04$offshore_share)
p_04$estimate_volume_rpp_onshore <-    p_04$volume_rpp_total   * (1 - p_04$offshore_share)
p_04$estimate_volume_other_onshore <-  p_04$volume_other_total * (1 - p_04$offshore_share)

# Providing these for completness, although we have the true values on these.
identical_cols <- c("volume_crude_total", "volume_hvl_total",
                    "volume_rpp_total", "volume_other_total")
p_04 %<>% mutate(across({{identical_cols}}, ~ .x, .names = "estimate_{.col}"))

p_04$volume_all_total <- rowSums(select(p_04,
                                        volume_crude_total,
                                        volume_hvl_total,
                                        volume_rpp_total,
                                        volume_other_total))
p_04$volume_all_offshore <- rowSums(select(p_04,
                                           volume_crude_offshore,
                                           volume_hvl_offshore,
                                           volume_rpp_offshore,
                                           volume_other_offshore))
p_04$volume_all_onshore <- rowSums(select(p_04,
                                          volume_crude_onshore,
                                          volume_hvl_onshore,
                                          volume_rpp_onshore,
                                          volume_other_onshore))
p_04$estimate_volume_all_offshore <- rowSums(select(p_04,
                                                    estimate_volume_crude_offshore,
                                                    estimate_volume_hvl_offshore,
                                                    estimate_volume_rpp_offshore,
                                                    estimate_volume_other_offshore))
p_04$estimate_volume_all_onshore <-  rowSums(select(p_04,
                                                    estimate_volume_crude_onshore,
                                                    estimate_volume_hvl_onshore,
                                                    estimate_volume_rpp_onshore,
                                                    estimate_volume_other_onshore))

# Pipelines 2010
p_10$volume_co2_total   <- na_sum(select(p_10, volume_co2_offshore, volume_co2_onshore))
p_10$volume_crude_total <- na_sum(select(p_10, volume_crude_offshore, volume_crude_onshore))
p_10$volume_fge_total   <- na_sum(select(p_10, volume_fge_offshore, volume_fge_onshore))
p_10$volume_hvl_total   <- na_sum(select(p_10, volume_hvl_offshore, volume_hvl_onshore))
p_10$volume_rpp_total   <- na_sum(select(p_10, volume_rpp_offshore, volume_rpp_onshore))

p_10$offshore_share <- p_10$miles_offshore/ (p_10$miles_offshore + p_10$miles_onshore)

p_10$volume_other_total <-    na_sum(select(p_10, volume_co2_total, volume_fge_total))
p_10$volume_other_offshore <- na_sum(select(p_10, volume_co2_offshore, volume_fge_offshore))
p_10$volume_other_onshore <-  na_sum(select(p_10, volume_co2_onshore, volume_fge_onshore))

p_10$volume_all_total <-    rowSums(select(p_10, volume_crude_total, volume_hvl_total,
                                           volume_rpp_total, volume_other_total))
p_10$volume_all_offshore <- rowSums(select(p_10, volume_crude_offshore, volume_hvl_offshore,
                                           volume_rpp_offshore, volume_other_offshore))
p_10$volume_all_onshore <-  rowSums(select(p_10, volume_crude_onshore, volume_hvl_onshore,
                                           volume_rpp_onshore, volume_other_onshore))

#We have this information for this dataset, but not for the data on the years before. So we add this column to be able to check the estimated data.
p_10_identical_cols <- c("volume_crude_offshore", "volume_hvl_offshore",
                         "volume_rpp_offshore", "volume_crude_onshore",
                         "volume_hvl_onshore", "volume_rpp_onshore",
                         "volume_other_offshore", "volume_all_onshore",
                         "volume_all_total", "volume_crude_total",
                         "volume_hvl_total", "volume_rpp_total",
                         "volume_other_total")
p_10 %<>% mutate(across({{p_10_identical_cols}}, ~ .x, .names = "estimate_{.col}"))

# Safe to disk
readr::write_rds(p_04, data_folder("pipelines_2004_transformed.rds"))
readr::write_rds(p_10, data_folder("pipelines_2010_transformed.rds"))

print("5a - Transformed columns in the pipelines dataset.")
