#!/usr/bin/env Rscript
suppressMessages(library(here))

##################################################################
###     About     ################################################
##################################################################

# Preprocesses 5 raw datasets
# i. Pipelines 2004-2009
# ii. Pipelines 2010-today
# iii. Pipeline incidents 1986-2001
# iv. Pipeline incidents 2002-2009
# v. Pipeline incidents 2010-today

arguments <- commandArgs(trailingOnly = TRUE)
redownload <- "--download" %in% arguments
overwrite <- "--overwrite" %in% arguments

# 0. Parameters
system(here("data-raw", "util","0-define_parameters.R"))
parameters <- readRDS(here("data-raw", ".temp" ,"parameters.RDS"))

# 1. Download data
raw_files <- paste0(parameters[["all_datasets"]], "_raw.feather")
if (redownload) {
  system(here("data-raw", "util", "1-load_data.py"))
} else if (!all(raw_files %in% list.files(here("data-raw", ".temp","data")))){
  warning("Some file(s) not available. May need to use --redownload flag.")
}
# 2. Rename
system(here("data-raw", "util", "2-rename.R"))

# 3. Clean columns
# As a first step, all we do is clean up columns in all files without making any transformations.
system(here("data-raw", "util", "3a-clean_cols_pipelines.R"))
system(here("data-raw", "util", "3b-clean_cols_incidents.R"))

# 4. Fix pipelines_2004
# There is a lot of stuff messed up with dataset in particular, such as duplicate observations, so we fix this first.
system(here("data-raw", "util", "4-fix_p_04.R"))

# 5. Create additional columns and transform as necessary
system(here("data-raw", "util", "5a-transform_cols_pipelines.R"))
system(here("data-raw", "util", "5b-transform_cols_incidents.R"))

# 6. Merge datasets
system(here("data-raw", "util", "6-merge_datasets.R"))

# TODO: this
# 7. Handle M&As

# 8. Use data
if (overwrite) {
  data_folder <- purrr::partial(here::here, "data-raw", ".temp", "data")

  pipelines_2004 <- readRDS(data_folder("pipelines_2004_transformed.rds"))
  usethis::use_data(pipelines_2004, overwrite = T)
  pipelines_2010 <- readRDS(data_folder("pipelines_2010_transformed.rds"))
  usethis::use_data(pipelines_2010, overwrite = T)

  incidents <- readRDS(data_folder("incidents_transformed.rds"))
  incidents_1986 <- incidents[["i_86"]]
  usethis::use_data(incidents_1986, overwrite = T)
  incidents_2002 <- incidents[["i_02"]]
  usethis::use_data(incidents_2002, overwrite = T)
  incidents_2010 <- incidents[["i_10"]]
  usethis::use_data(incidents_2010, overwrite = T)

  incidents <- readRDS(data_folder("incidents_merged.rds"))
  usethis::use_data(incidents, overwrite = T)
  pipelines_ungrouped <- readRDS(data_folder("pipelines_merged.rds"))
  usethis::use_data(pipelines_ungrouped, overwrite = T)
}



