#!/usr/bin/env Rscript
library(tidyverse)
library(devtools)

# Input
datasets_all <- "pipelines_2010"
dataset_input <- commandArgs(trailingOnly = TRUE)

temp_data_folder <- "data-raw/.temp-data"
new_colnames <- list(colnames_pipelines_2010 = c("Name" = "PARTA2NAMEOFCOMP",
                                                 "ID" = "OPERATOR_ID"))

# Functions
get_datasets <- function(dataset_input, datasets_all){
  datasets <- ifelse(length(dataset_input) > 0, dataset_input, datasets_all)
  return(datasets)
}

load_datasets <- function(datasets){
  dataset_arguments <- paste(datasets, sep = " ")
  function_call <- paste("data-raw/load_data.py", dataset_arguments)
  system(function_call)
}

process_dataset <- function(dataset, new_colnames, temp_data_folder) {
  df <- feather::read_feather(paste0(temp_data_folder, "/", dataset, ".feather"))
  df <- rename(df, !!!new_colnames)
  assign(dataset, df)
}

# Main
datasets <- get_datasets(dataset_input = dataset_input, datasets_all = datasets_all)
load_datasets(datasets = datasets)
dfs <- map2(datasets, new_colnames, process_dataset, temp_data_folder = temp_data_folder)
dfs <- dfs %>%
  set_names(datasets)

if ("pipelines_2010" %in% datasets){
  pipelines_2010 <- dfs[["pipelines_2010"]]
  use_data(pipelines_2010, overwrite = TRUE)
}
