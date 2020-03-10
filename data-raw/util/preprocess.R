#!/usr/bin/env Rscript
library(tidyverse)
library(devtools)

##################################################################
###     About     ################################################
##################################################################

# Preprocesses 4 raw datasets
# 1. Pipelines 2004-2009
# 2. Pipelines 2010-today
# 3. Pipeline incidents 2002-2009
# 4. Pipeline incidents 2010-today

# The dataset is cleaned in 8 steps
#   a. Rename columns
#   b. Consolidate observations that use the same ID (for pipline datasets before 2010)
#   c. Create new columns (by transforming existing columns)
#   d. Recode factor variables
#     - By using provided list
#     - Using oildata:::fix_commodities for commodities
#     - Yes/no to bool
#   e. Clean strings
#     - Clean company names
#     - Sentence case where applicable

##################################################################
###     Setup     ################################################
##################################################################

# Input
dataset_input <- commandArgs(trailingOnly = TRUE)
redownload <- "--download" %in% dataset_input
dataset_input <- dataset_input[! startsWith(dataset_input, "--")]
temp_data_folder <- "data-raw/.temp-data"

# Aim - list as many columns that could be encountered as possible.
preprocess_consolidation = list(hca_offshore =          quo(sum(hca_offshore,          na.rm = T)),
                                hca_onshore =           quo(sum(hca_onshore,           na.rm = T)),
                                hca_total =             quo(sum(hca_total,             na.rm = T)),
                                miles_onshore =         quo(sum(miles_onshore,         na.rm = T)),
                                miles_offshore =        quo(sum(miles_offshore,        na.rm = T)),
                                miles_total =           quo(sum(miles_total,           na.rm = T)),
                                volume_crude_offshore = quo(sum(volume_crude_offshore, na.rm = T)),
                                volume_hvl_offshore =   quo(sum(volume_hvl_offshore,   na.rm = T)),
                                volume_rpp_offshore =   quo(sum(volume_rpp_offshore,   na.rm = T)),
                                volume_crude_onshore =  quo(sum(volume_crude_onshore,  na.rm = T)),
                                volume_hvl_onshore =    quo(sum(volume_hvl_onshore,    na.rm = T)),
                                volume_rpp_onshore =    quo(sum(volume_rpp_onshore,    na.rm = T)),
                                volume_crude_total =    quo(sum(volume_crude_total,    na.rm = T)),
                                volume_hvl_total =      quo(sum(volume_hvl_total,      na.rm = T)),
                                volume_rpp_total =      quo(sum(volume_rpp_total,      na.rm = T)),
                                CPBONM =                quo(sum(CPBONM,                na.rm = T)),
                                CPCONM =                quo(sum(CPCONM,                na.rm = T)),
                                CUBONM =                quo(sum(CUBONM,                na.rm = T)),
                                CUCONM =                quo(sum(CUCONM,                na.rm = T)),
                                CPBOFFM =               quo(sum(CPBOFFM,               na.rm = T)),
                                CPCOFFM =               quo(sum(CPCOFFM,               na.rm = T)),
                                CUBOFFM =               quo(sum(CUBOFFM,               na.rm = T)),
                                CUCOFFM =               quo(sum(CUCOFFM,               na.rm = T))
                                )

input <-
  list(
    ##################################################################
    ###     Pipelines 2004    ########################################
    ##################################################################
    pipelines_2004 = list(
      rename_colnames = function(x) {x %>%
          rename(ID = OPERATOR_ID,
                 name = NAME,
                 year = YR,
                 commodity = SYSTEM_TYPE,
                 hca_onshore = HCAONM,
                 hca_offshore = HCAOFFM,
                 hca_total = HCAMT,
                 miles_total = DINSTMT,
                 volume_crude_total = VTM_1,
                 volume_hvl_total = VTM_2,
                 volume_rpp_total = VTM_4,
                 volume_other_total = VTM_5)
      },
      duplicate_consolidation = function(x) {
        consolidation_rules = preprocess_consolidation[
          names(preprocess_consolidation) %in% colnames(x)]
        x <- DataAnalysisTools::consolidate_duplicates(x,
                                                       summary_parsing = consolidation_rules,
                                                       by_cols = vars(ID, year, commodity))
        x
      },
      column_creation = function(x) {x %>%
          mutate(miles_onshore = (CPBONM + CPCONM + CUBONM + CUCONM),
                 miles_offshore = (CPBOFFM + CPCOFFM + CUBOFFM + CUCOFFM)) %>%
          mutate(offshore_share = miles_offshore/(miles_onshore + miles_offshore)) %>%
          mutate(volume_crude_offshore = ifelse(offshore_share == 0, 0, NA),
                 volume_crude_onshore = ifelse(offshore_share == 0, volume_crude_total, NA),
                 volume_hvl_offshore = ifelse(offshore_share == 0, 0, NA),
                 volume_hvl_onshore = ifelse(offshore_share == 0, volume_hvl_total, NA),
                 volume_rpp_offshore = ifelse(offshore_share == 0, 0, NA),
                 volume_rpp_onshore = ifelse(offshore_share == 0, volume_rpp_total, NA),
                 volume_other_offshore = ifelse(offshore_share == 0, 0, NA),
                 volume_other_onshore = ifelse(offshore_share == 0, volume_other_total, NA)) %>%
          mutate(estimate_volume_crude_offshore = volume_crude_total * offshore_share,
                 estimate_volume_crude_onshore = volume_crude_total * (1 - offshore_share),
                 estimate_volume_hvl_offshore = volume_hvl_total * offshore_share,
                 estimate_volume_hvl_onshore = volume_hvl_total * (1 - offshore_share),
                 estimate_volume_rpp_offshore = volume_rpp_total * offshore_share,
                 estimate_volume_rpp_onshore = volume_rpp_total * (1 - offshore_share),
                 estimate_volume_other_offshore = volume_other_total * offshore_share,
                 estimate_volume_other_onshore = volume_other_total * (1 - offshore_share))
      },
      refactor = function(x) {x %>%
          mutate(commodity = oildata:::fix_commodities(commodity))
      },
      string_cleaning = function(x) {x %>%
          mutate(name = str_to_title(name)) %>%
          mutate(name = DataAnalysisTools::remove_company_suffixes(name))
      }
    ),
    ##################################################################
    ###     Pipelines 2010    ########################################
    ##################################################################
    pipelines_2010 = list(
      rename_colnames = function(x) {x %>%
          rename(ID = OPERATOR_ID,
                 name = PARTA2NAMEOFCOMP,
                 year = REPORT_YEAR,
                 commodity = PARTA5COMMODITY,
                 hca_onshore = PARTBHCAONSHORE,
                 hca_offshore = PARTBHCAOFFSHORE,
                 hca_total = PARTBHCATOTAL,
                 miles_onshore = PARTDONTOTAL,
                 miles_offshore = PARTDOFFTOTAL,
                 miles_total = PARTDTOTALMILES,
                 volume_co2_offshore = PARTCOFFCO2,
                 volume_crude_offshore = PARTCOFFCRUDE,
                 volume_fge_offshore = PARTCOFFETHANOL,
                 volume_hvl_offshore = PARTCOFFHVL,
                 volume_rpp_offshore = PARTCOFFRPP,
                 volume_co2_onshore = PARTCONCO2,
                 volume_crude_onshore = PARTCONCRUDE,
                 volume_fge_onshore = PARTCONETHANOL,
                 volume_hvl_onshore = PARTCONHVL,
                 volume_rpp_onshore = PARTCONRPP
                 )
      },
      # duplicate_consolidation = function(x) {},
      column_creation = function(x) {x %>%
          rowwise() %>%
          mutate(volume_co2_total = sum(volume_co2_offshore, volume_co2_onshore, na.rm = T),
                 volume_crude_total = sum(volume_crude_offshore, volume_crude_onshore, na.rm = T),
                 volume_fge_total = sum(volume_fge_offshore, volume_fge_onshore, na.rm = T),
                 volume_hvl_total = sum(volume_hvl_offshore, volume_hvl_onshore, na.rm = T),
                 volume_rpp_total = sum(volume_rpp_offshore, volume_rpp_onshore, na.rm = T),
                 estimate_volume_crude_offshore = volume_crude_offshore,
                 estimate_volume_hvl_offshore = volume_hvl_offshore,
                 estimate_volume_rpp_offshore = volume_rpp_offshore,
                 estimate_volume_crude_onshore = volume_crude_onshore,
                 estimate_volume_hvl_onshore = volume_hvl_onshore,
                 estimate_volume_rpp_onshore = volume_rpp_onshore,
                 offshore_share = miles_offshore/ (miles_offshore + miles_onshore)) %>%
          mutate(volume_other_total = sum(volume_co2_total, volume_fge_total, na.rm = T),
                 volume_other_offshore = sum(volume_co2_offshore, volume_fge_offshore, na.rm = T),
                 volume_other_onshore = sum(volume_co2_onshore, volume_fge_onshore, na.rm = T)) %>%
          mutate(estimate_volume_other_offshore = volume_other_offshore,
                 estimate_volume_other_onshore = volume_other_onshore) %>%
          ungroup()
      },
      refactor = function(x) {x %>%
          mutate(commodity = oildata:::fix_commodities(commodity))
      },
      string_cleaning = function(x) {x %>%
          mutate(name = str_to_title(name)) %>%
          mutate(name = DataAnalysisTools::remove_company_suffixes(name))
      }
    ),
    ##################################################################
    ###     Incidents 2002    ########################################
    ##################################################################
    incidents_2002 = list(
      rename_colnames = function(x) {x %>%
          rename(significant = SIGNIFICANT,
                 serious = SERIOUS,
                 report_type = REPORT_TYPE,
                 ID = OPERATOR_ID,
                 name = NAME,
                 year = IYEAR,
                 lat = LATITUDE,
                 long = LONGITUDE,
                 cost = TOTAL_COST,
                 commodity = CLASS_TEXT,
                 installation_year = PRTYR,
                 cause = CAUSE,
                 on_offshore = OFFSHORE,
                 narrative = NARRATIVE,
                 cost_1984 = TOTAL_COST_IN84)
      },
      # duplicate_consolidation = function(x) {},
      colume_creation = function(x) {x %>%
          mutate(volume = ifelse(SPUNIT_TEXT == "BARRELS",
                                 LOSS, LOSS / 31.5),
                 date = lubridate::date(IDATE)
          )
      },
      refactor = function(x) {x %>%
          mutate(commodity = oildata:::fix_commodities(commodity),
                 cause = recode(cause,
                                CORROSION = "corrosion",
                                EQUIPMENT = "equipment",
                                `EXCAVATION DAMAGE` = "damage",
                                `INCORRECT_OPERATION` = "operations",
                                `MATERIAL AND/OR WELD FAILURES` = "material",
                                `NATURAL FORCES` = "natural_forces",
                                OTHER = "other",
                                `OTHER OUTSIDE FORCE DAMAGE` = "other"),
                 on_offshore = recode(on_offshore,
                                      YES = "offshore",
                                      NO = "onshore")
                 )
      },
      string_cleaning = function(x) {x %>%
          mutate(name = str_to_title(name)) %>%
          mutate(name = DataAnalysisTools::remove_company_suffixes(name)) %>%
          mutate(narrative = str_to_sentence(narrative),
                 serious = serious == "YES",
                 significant = significant == "YES"
                 )
      }
    ),
    ##################################################################
    ###     Incidents 2010    ########################################
    ##################################################################
    incidents_2010 = list(
      rename_colnames = function(x) {x %>%
          rename(significant = SIGNIFICANT,
                 serious = SERIOUS,
                 ipe = IPE,
                 integrity_assessment_target = IA_IPE,
                 operations_maintenance_target = OM_IPE,
                 ID = OPERATOR_ID,
                 name = NAME,
                 year = IYEAR,
                 lat = LOCATION_LATITUDE,
                 long = LOCATION_LONGITUDE,
                 commodity = COMMODITY_RELEASED_TYPE,
                 volume = UNINTENTIONAL_RELEASE_BBLS,
                 on_offshore = ON_OFF_SHORE,
                 installation_year = INSTALLATION_YEAR,
                 cost = TOTAL_COST,
                 excavation_damage_type = PARTY_TYPE,
                 cause = CAUSE,
                 narrative = NARRATIVE,
                 cost_1984 = TOTAL_COST_IN84)
      },
      # duplicate_consolidation = function(x) {},
      column_creation = function(x) {x %>%
                           mutate(date = lubridate::date(LOCAL_DATETIME),
                                  lat = as.character(lat),
                                  long = as.character(long))
      },
      refactor = function(x) {x %>%
          mutate(commodity = oildata:::fix_commodities(commodity),
                 cause = recode(cause,
                                `CORROSION FAILURE` = "corrosion",
                                `EQUIPMENT FAILURE` = "equipment",
                                `EXCAVATION DAMAGE` = "damage",
                                `INCORRECT OPERATION` = "operation",
                                `MATERIAL FAILURE OF PIPE OR WELD` = "material",
                                `NATURAL FORCE DAMAGE` = "natural forces",
                                `OTHER INCIDENT CAUSE` = "other",
                                `OTHER OUTSIDE FORCE DAMAGE` = "other outside"),
                 on_offshore = recode(on_offshore,
                                      OFFSHORE = "offshore",
                                      ONSHORE = "onshore"))
      },
      string_cleaning = function(x) {x %>%
          mutate(name = str_to_title(name)) %>%
          mutate(name = DataAnalysisTools::remove_company_suffixes(name)) %>%
          mutate(narrative = str_to_sentence(narrative),
                 serious = serious == "YES",
                 significant = significant == "YES"
          )
      }
    )
  )

##################################################################
###     Functions    #############################################
##################################################################

download_datasets <- function(datasets) {
  dataset_arguments <- paste(datasets, collapse = " ")
  function_call <- paste("data-raw/util/load_data.py", dataset_arguments)
  system(function_call)
}

process_dataset <- function(dataset, input) {
  df <- feather::read_feather(paste0(temp_data_folder, "/", dataset, ".feather"))
  df[ , map_lgl(df, is.character)] <-
    sapply(df[ , map_lgl(df, is.character)], function(x) ifelse(x == "nan", NA, x))
  functions <- input[[dataset]]
  for (f in functions) {
    df <- f(df)
    df
  }
  df
}

##################################################################
###     Main        ##############################################
##################################################################

datasets <- if (length(dataset_input) == 0) {names(input)} else{dataset_input}
datasets <- datasets[datasets %in% names(input)]

if (redownload == TRUE) {
  download_datasets(datasets = datasets)
}

dfs <- map(datasets, process_dataset, input = input)
dfs <- set_names(dfs, datasets)

if ("pipelines_2004" %in% names(dfs)) {
  pipelines_2004 <- dfs[["pipelines_2004"]]
  use_data(pipelines_2004, overwrite = TRUE)
}

if ("pipelines_2010" %in% names(dfs)) {
  pipelines_2010 <- dfs[["pipelines_2010"]]
  use_data(pipelines_2010, overwrite = TRUE)
}

if ("incidents_2002" %in% names(dfs)) {
  incidents_2002 <- dfs[["incidents_2002"]]
  use_data(incidents_2002, overwrite = TRUE)
}

if ("incidents_2010" %in% names(dfs)) {
  incidents_2010 <- dfs[["incidents_2010"]]
  use_data(incidents_2010, overwrite = TRUE)
}
