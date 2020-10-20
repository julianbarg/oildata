#!/usr/bin/env Rscript
suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(purrr))
suppressMessages(library(here))

data_folder <- purrr::partial(here, "data-raw", ".temp", "data")
i_86 <- readRDS(data_folder("incidents_1986_renamed.rds"))
i_02 <- readRDS(data_folder("incidents_2002_renamed.rds"))
i_10 <- readRDS(data_folder("incidents_2010_renamed.rds"))

dfs <- list(i_86 = i_86, i_02 = i_02, i_10 = i_10)

# 1. Recode
na_function <- function(x) ifelse(x %in% c("nan", "NULL", "UNKNOWN"), NA, x)
dfs <- dfs %>%
  map(~mutate(.x, across(where(is.character), na_function))) %>%
  map(~mutate(.x, commodity = oildata:::fix_commodities(commodity))) %>%
  map(~mutate(.x, incident_ID = as.character(incident_ID)))

dfs[["i_86"]] %<>% mutate(on_offshore = recode(
  on_offshore, YES = "offshore", NO = "onshore"))
dfs[["i_02"]] %<>% mutate(on_offshore = recode(
  on_offshore, YES = "offshore", NO = "onshore"))
dfs[["i_10"]] %<>% mutate(on_offshore = recode(
  on_offshore, OFFSHORE = "offshore", ONSHORE = "onshore"))

dfs[["i_02"]] <- dfs[["i_02"]] %>%
  mutate(cause = recode(cause,
                        CORROSION = "corrosion",
                        EQUIPMENT = "equipment",
                        `EXCAVATION DAMAGE` = "damage",
                        `INCORRECT_OPERATION` = "operations",
                        `MATERIAL AND/OR WELD FAILURES` = "material",
                        `NATURAL FORCES` = "natural_forces",
                        OTHER = "other",
                        `OTHER OUTSIDE FORCE DAMAGE` = "other"))
dfs[["i_10"]] <- dfs[["i_10"]] %>%
  mutate(cause = recode(cause,
                        `CORROSION FAILURE` = "corrosion",
                        `EQUIPMENT FAILURE` = "equipment",
                        `EXCAVATION DAMAGE` = "damage",
                        `INCORRECT OPERATION` = "operation",
                        `MATERIAL FAILURE OF PIPE OR WELD` = "material",
                        `NATURAL FORCE DAMAGE` = "natural forces",
                        `OTHER INCIDENT CAUSE` = "other",
                        `OTHER OUTSIDE FORCE DAMAGE` = "other outside"))

# 2. String cosmetics
dfs <- dfs %>%
  map(~ mutate(.x,
               name = str_to_title(name),
               narrative = str_to_sentence(narrative),
               system = str_to_title(system),
               item = str_to_title(item),
               cause = tolower(cause),
               subcause = tolower(subcause))) %>%
  map(~ mutate(.x, name = DataAnalysisTools::remove_company_suffixes(name)))

# 3. Fill NAs
bools_i_86 <- c("serious", "significant", "fire", "explosion")
dfs[["i_86"]] %<>% mutate(across( {{bools_i_86}} , ~. == "YES"))

dfs[["i_10"]] <- dfs[["i_10"]] %>%
  mutate(fatalities = ifelse(FATALITY_IND == "NO", 0, fatalities),
         injuries   = ifelse(INJURY_IND   == "NO", 0, injuries))

# 4. Bools
bools_i_02_10 <-
  c("serious", "significant", "fire", "explosion", "surface_water_remediation",
    "groundwater_remediation", "soil_remediation", "vegetation_remediation",
    "wildlife_remediation", "water_contamination")
dfs[["i_02"]] %<>% mutate(across( {{bools_i_02_10}} , ~. == "YES"))
dfs[["i_10"]] %<>% mutate(across( {{bools_i_02_10}} , ~. == "YES"))

# 5. Write to disk
readr::write_rds(dfs, data_folder("incidents_cleaned.rds"))

print("3b - Cleaned incidents dataset.")
