#!/usr/bin/env Rscript
library(tidyverse)
library(devtools)

# Input
dataset_input <- commandArgs(trailingOnly = TRUE)
redownload <- "--download" %in% dataset_input
dataset_input <- dataset_input[! startsWith(dataset_input, "--")]

temp_data_folder <- "data-raw/.temp-data"
all_datasets <- list(incidents_2004 = list(new_colnames = c("ID" = "OPERATOR_ID",
                                                            "Name" = "NAME",
                                                            "Year" = "IYEAR")),
                     incidents_2010 = list(new_colnames = c("ID" = "OPERATOR_ID",
                                                            "Name" = "NAME",
                                                            "Year" = "IYEAR")),
                     pipelines_2004 = list(new_colnames = c("ID" = "OPERATOR_ID",
                                                            "Name" = "NAME",
                                                            "Year" = "YR")),
                     pipelines_2010 = list(new_colnames = c("ID" = "OPERATOR_ID",
                                                            "Name" = "PARTA2NAMEOFCOMP",
                                                            "Year" = "REPORT_YEAR"))
                     )

# Functions
download_datasets <- function(datasets) {
  dataset_arguments <- paste(datasets, collapse = " ")
  function_call <- paste("data-raw/load_data.py", dataset_arguments)
  system(function_call)
}

process_dataset <- function(dataset, all_datasets, temp_data_folder) {
  df <- feather::read_feather(paste0(temp_data_folder, "/", dataset, ".feather"))
  if ("new_colnames" %in% names(all_datasets[[dataset]])) {
    df <- rename(df, !!! all_datasets[[dataset]][["new_colnames"]])
  }
  if ("Name" %in% colnames(df)) {
    df$Name <- str_to_title(df$Name)
    df$Name <- DataAnalysisTools::remove_company_suffixes(df$Name)
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

  if ("incidents_2004" %in% names(dfs)) {
    incidents_2004 <- dfs[["incidents_2004"]]
    use_data(incidents_2004, overwrite = TRUE)
  }
}

prepare_datasets <- function(dataset_input, datasets_all, temp_data_folder, redownload = FALSE) {
  datasets <- if (length(dataset_input) == 0) names(all_datasets) else dataset_input
  datasets <- datasets[datasets %in% names(all_datasets)]
  if (redownload == TRUE) {
    download_datasets(datasets = datasets)
  }
  dfs <- map(datasets, process_dataset, all_datasets = all_datasets, temp_data_folder = temp_data_folder)
  dfs <- dfs %>%
    set_names(datasets)
  save_datasets(dfs)
}

# Main
prepare_datasets(dataset_input = dataset_input,
                 datasets_all = datasets_all,
                 temp_data_folder = temp_data_folder,
                 redownload = redownload)
