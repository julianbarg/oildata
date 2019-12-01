#!/usr/bin/env Rscript
library(tidyverse)
library(devtools)

# Input
datasets_all <- c("pipelines_2010", "incidents_2010", "pipelines_2004", "incidents_2004")
dataset_input <- commandArgs(trailingOnly = TRUE)

temp_data_folder <- "data-raw/.temp-data"
new_colnames_list <- list("incidents_2004" = c("ID" = "OPERATOR_ID",
                                               "Name" = "NAME",
                                               "Year" = "IYEAR"),
                          "incidents_2010" = c("ID" = "OPERATOR_ID",
                                               "Name" = "NAME",
                                               "Year" = "IYEAR"),
                          "pipelines_2004" = c("ID" = "OPERATOR_ID",
                                               "Name" = "NAME",
                                               "Year" = "YR"),
                          "pipelines_2010" = c("ID" = "OPERATOR_ID",
                                               "Name" = "PARTA2NAMEOFCOMP",
                                               "Year" = "REPORT_YEAR"))

# Functions
get_datasets <- function(dataset_input, datasets_all) {
  datasets <- if (length(dataset_input) > 0) {dataset_input} else {datasets_all}
  return(datasets)
}

load_datasets <- function(datasets) {
  dataset_arguments <- paste(datasets, collapse = " ")
  function_call <- paste("data-raw/load_data.py", dataset_arguments)
  system(function_call)
}

get_new_names <- function(datasets, new_colnames_list){
  new_names <- list()
  for (dataset in datasets){
    new_names[[dataset]] <- new_colnames_list[[dataset]]
  }
  return(new_names)
}

process_dataset <- function(dataset, new_colnames, temp_data_folder) {
  df <- feather::read_feather(paste0(temp_data_folder, "/", dataset, ".feather"))
  df <- rename(df, !!! new_colnames)
  assign(dataset, df)
}

prepare_datasets <- function(dataset_input, datasets_all, new_colnames_list, temp_data_folder) {
  datasets <- get_datasets(dataset_input = dataset_input, datasets_all = datasets_all)
  load_datasets(datasets = datasets)
  new_colnames <- get_new_names(datasets, new_colnames_list)
  dfs <- map2(datasets, new_colnames, process_dataset, temp_data_folder = temp_data_folder)
  dfs <- dfs %>%
    set_names(datasets)
}

# Main
dfs <- prepare_datasets(dataset_input = dataset_input,
                        datasets_all = datasets_all,
                        new_colnames_list = new_colnames_list,
                        temp_data_folder = temp_data_folder)

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
