#!/usr/bin/env Rscript
library(tidyverse)
library(devtools)
library(rlang)

# Input
dataset_input <- commandArgs(trailingOnly = TRUE)
redownload <- "--download" %in% dataset_input
dataset_input <- dataset_input[! startsWith(dataset_input, "--")]

temp_data_folder <- "data-raw/.temp-data"
all_datasets <- list(incidents_2002 = list(new_colnames = c("significant" = "SIGNIFICANT",
                                                            "serious" = "SERIOUS",
                                                            "report_type" = "REPORT_TYPE",
                                                            "ID" = "OPERATOR_ID",
                                                            "name" = "NAME",
                                                            "year" = "IYEAR",
                                                            "total_cost" = "TOTAL_COST",
                                                            "commodity" = "CLASS_TEXT",
                                                            "installation_year" = "PRTYR",
                                                            "cause" = "CAUSE",
                                                            "narrative" = "NARRATIVE"),
                                           recode = list(cause = c("CORROSION" = "corrosion",
                                                                   "EQUIPMENT" = "equipment",
                                                                   "EXCAVATION DAMAGE" = "damage",
                                                                   "INCORRECT OPERATION" = "operation",
                                                                   "MATERIAL AND/OR WELD FAILURES" = "material",
                                                                   "NATURAL FORCES" = "natural forces",
                                                                   "OTHER" = "other",
                                                                   "OTHER OUTSIDE FORCE DAMAGE" = "other outside"))),
                     incidents_2010 = list(new_colnames = c("significant" = "SIGNIFICANT",
                                                            "serious" = "SERIOUS",
                                                            "ipe" = "IPE",
                                                            "integrity_assessment_target" = "IA_IPE",
                                                            "operations_maintenance_target" = "OM_IPE",
                                                            "ID" = "OPERATOR_ID",
                                                            "name" = "NAME",
                                                            "year" = "IYEAR",
                                                            "commodity" = "COMMODITY_RELEASED_TYPE",
                                                            "installation_year" = "INSTALLATION_YEAR",
                                                            "total_cost" = "TOTAL_COST",
                                                            "excavation_damage_type" = "PARTY_TYPE",
                                                            "cause" = "CAUSE",
                                                            "narrative" = "NARRATIVE"),
                                           recode = list(cause = c("CORROSION FAILURE" = "corrosion",
                                                                   "EQUIPMENT FAILURE" = "equipment",
                                                                   "EXCAVATION DAMAGE" = "damage",
                                                                   "INCORRECT OPERATION" = "operation",
                                                                   "MATERIAL FAILURE OF PIPE OR WELD" = "material",
                                                                   "NATURAL FORCE DAMAGE" = "natural forces",
                                                                   "OTHER INCIDENT CAUSE" = "other",
                                                                   "OTHER OUTSIDE FORCE DAMAGE" = "other outside"
                                                                   )
                                                         )
                                           ),
                     pipelines_2004 = list(new_colnames = c("ID" = "OPERATOR_ID",
                                                            "name" = "NAME",
                                                            "year" = "YR",
                                                            "commodity" = "SYSTEM_TYPE",
                                                            "hca_onshore" = "HCAONM",
                                                            "hca_offshore" = "HCAOFFM",
                                                            "hca_total" = "HCAMT",
                                                            "total_miles" = "DINSTMT"),
                                           new_columns =
                                             list("total_onshore" = "CPBONM + CPCONM + CUBONM + CUCONM",
                                                  "total_offshore" = "CPBOFFM + CPCOFFM + CUBOFFM + CUCOFFM"),
                                           duplicate_consolidation =
                                             list("group_cols" = vars(ID, year, commodity),
                                                  "formula" = oildata::pipelines_consolidation
                                                  )
                                           ),
                     pipelines_2010 = list(new_colnames = c("ID" = "OPERATOR_ID",
                                                            "name" = "PARTA2NAMEOFCOMP",
                                                            "year" = "REPORT_YEAR",
                                                            "commodity" = "PARTA5COMMODITY",
                                                            "hca_onshore" = "PARTBHCAONSHORE",
                                                            "hca_offshore" = "PARTBHCAOFFSHORE",
                                                            "hca_total" = "PARTBHCATOTAL",
                                                            "total_onshore" = "PARTDONTOTAL",
                                                            "total_offshore" = "PARTDOFFTOTAL",
                                                            "total_miles" = "PARTDTOTALMILES"))
                     )
# factor_cols <- c("ID", "commodity")
sentence_case <- c("narrative")
yes_no <- c("serious", "significant")

# Functions
download_datasets <- function(datasets) {
  dataset_arguments <- paste(datasets, collapse = " ")
  function_call <- paste("data-raw/util/load_data.py", dataset_arguments)
  system(function_call)
}

create_column <- function(df, col_name, formula){
  df <- df %>%
    mutate(!! col_name := !! parse_expr(formula))
  return(df)
}

process_dataset <- function(dataset, all_datasets, temp_data_folder, factor_cols) {
  df <- feather::read_feather(paste0(temp_data_folder, "/", dataset, ".feather"))
  df[ , map_lgl(df, is.character)] <- sapply(df[ , map_lgl(df, is.character)], function(x) ifelse(x == "nan", NA, x))


  if ("new_colnames" %in% names(all_datasets[[dataset]])) {
    df <- rename(df, !!! all_datasets[[dataset]][["new_colnames"]])
  }

  if ("new_columns" %in% names(all_datasets[[dataset]])) {
    for (new_column in names(all_datasets[[dataset]][["new_columns"]])) {
      df <- create_column(df, new_column, all_datasets[[dataset]][["new_columns"]][[new_column]])
    }
  }

  if ("recode" %in% names(all_datasets[[dataset]])) {
    recode_passthrough <- function(x, codes) {
      return(recode(x, !!! codes))
    }
    for (column in names(all_datasets[[dataset]][["recode"]]))
    {
      recode_info <- all_datasets[[dataset]][["recode"]][[column]]
      df[[column]] <- recode_passthrough(df[[column]], recode_info)
    }
  }

  if ("duplicate_consolidation" %in% names(all_datasets[[dataset]])) {
    formula <- all_datasets[[dataset]][["duplicate_consolidation"]][["formula"]]
    formula <- formula[names(formula) %in% colnames(all_datasets[[dataset]])]
    df <- DataAnalysisTools::consolidate_duplicates(
      df,
      summary_parsing = formula,
      by_cols = all_datasets[[dataset]][["duplicate_consolidation"]][["group_cols"]])
  }

  if ("name" %in% colnames(df)) {
    df$name <- str_to_title(df$name)
    df$name <- DataAnalysisTools::remove_company_suffixes(df$name)
  }

  if ("commodity" %in% colnames(df)) {
    df$commodity <- oildata:::fix_commodities(df$commodity)
  }

  # if (any(colnames(df) %in% factor_cols)) {
  #   df[ , colnames(df) %in% factor_cols] <- map(df[ , colnames(df) %in% factor_cols], as.factor)
  # }

  if (any(colnames(df) %in% sentence_case)) {
    df[ , colnames(df) %in% sentence_case] <- map(df[ , colnames(df) %in% sentence_case], stringr::str_to_sentence)
  }

  # short_cols <- map_lgl(df, function(x) length(unique(x)) <= 3)
  # df[ , short_cols] <- map(df[ , short_cols], as.factor)

  if (any(colnames(df) %in% yes_no)) {
    df[ , colnames(df) %in% yes_no] <- map(df[ , colnames(df) %in% yes_no], tolower)
    df[ , colnames(df) %in% yes_no] <- map(df[ , colnames(df) %in% yes_no], function(x) x == "yes")
  }

  assign(dataset, df)
}

save_datasets <- function(dfs){
  if ("pipelines_2010" %in% names(dfs)) {
    pipelines_2010 <- dfs[["pipelines_2010"]]
    use_data(pipelines_2010, overwrite = TRUE)
  }

  if ("incidents_2010" %in% names(dfs)) {
    incidents_2010 <- dfs[["incidents_2010"]]
    use_data(incidents_2010, overwrite = TRUE)
  }

  if ("pipelines_2004" %in% names(dfs)) {
    pipelines_2004 <- dfs[["pipelines_2004"]]
    use_data(pipelines_2004, overwrite = TRUE)
  }

  if ("incidents_2002" %in% names(dfs)) {
    incidents_2002 <- dfs[["incidents_2002"]]
    use_data(incidents_2002, overwrite = TRUE)
  }
}

prepare_datasets <- function(dataset_input, datasets_all, temp_data_folder, redownload = FALSE) {
  datasets <- if (length(dataset_input) == 0) names(all_datasets) else dataset_input
  datasets <- datasets[datasets %in% names(all_datasets)]
  if (redownload == TRUE) {
    download_datasets(datasets = datasets)
  }
  dfs <- map(datasets, process_dataset, all_datasets = all_datasets,
             temp_data_folder = temp_data_folder, factor_cols = factor_cols)
  dfs <- dfs %>%
    set_names(datasets)
  save_datasets(dfs)
}

# Main
prepare_datasets(dataset_input = dataset_input,
                 datasets_all = datasets_all,
                 temp_data_folder = temp_data_folder,
                 redownload = redownload)
