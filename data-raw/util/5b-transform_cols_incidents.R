#!/usr/bin/env Rscript
suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(here))

data_folder <- purrr::partial(here, "data-raw", ".temp", "data")
dfs <- readRDS(data_folder("incidents_cleaned.rds"))

dfs[["i_86"]] <- dfs[["i_86"]] %>%
  mutate(net_loss = volume - recovered,
         year = lubridate::year(IDATE),
         date = lubridate::date(IDATE),
         # The ones below are just to achieve consistent columns between datasets.
         long = NA,
         lat = NA,
         water_contamination = NA,
         manufacture_year = NA,
         surface_water_remediation = NA,
         groundwater_remediation = NA,
         soil_remediation = NA,
         vegetation_remediation = NA,
         wildlife_remediation = NA,
         water_contamination = NA
         )

dfs[["i_02"]] <- dfs[["i_02"]] %>%
  mutate(volume = ifelse(SPUNIT_TEXT == "BARRELS",
                         LOSS, LOSS / 31.5),
         recovered = ifelse(SPUNIT_TEXT == "BARRELS",
                            RECOV, RECOV / 31.5),
         date = lubridate::date(IDATE),
         state = ifelse(on_offshore == "onshore",
                        ACSTATE,
                        OFFST)
  ) %>%
  mutate(net_loss = volume - recovered)

dfs[["i_10"]] <- dfs[["i_10"]] %>%
    mutate(date = lubridate::date(LOCAL_DATETIME),
           lat = as.character(lat),
           long = as.character(long),
           state = ifelse(on_offshore == "offshore",
                          OFFSHORE_STATE_ABBREVIATION,
                          ONSHORE_STATE_ABBREVIATION),
           manufacture_year = case_when(
             str_to_lower(item) == "pipe" ~ as.integer(PIPE_MANUFACTURE_YEAR),
             str_to_lower(item) == "valve" ~ as.integer(VALVE_MANUFACTURE_YEAR)
           )) %>%
    mutate(manufacture_year = as.integer(manufacture_year))

readr::write_rds(dfs, data_folder("incidents_transformed.rds"))

print("5b - Transformed columns in the incidents dataset.")
