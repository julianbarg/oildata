#!/usr/bin/env Rscript

library(usethis)
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

data_folder <- purrr::partial(here, "data-raw", ".temp", "data")
script_folder <- purrr::partial(here, "data-raw", "util")

# 0. Parameters
system(script_folder("0-define_parameters.R"))
parameters <- readRDS(here("data-raw", ".temp" ,"parameters.RDS"))

# 1. Download data
raw_files <- paste0(parameters[["all_datasets"]], "_raw.feather")
if (redownload) {
  system(here("data-raw", "util", "1-load_data.py"))
}
if (!all(raw_files %in% list.files(here("data-raw", ".temp","data")))){
  warning("Some file(s) not available. May need to use --redownload flag.")
}
# 2. Rename
system(script_folder("2-rename.R"))

# 3. Clean columns
# As a first step, all we do is clean up columns in all files without making any transformations.
system(script_folder("3a-clean_cols_pipelines.R"))
pipelines_2004 <- readRDS(data_folder("pipelines_2004_transformed.rds"))
use_data(pipelines_2004, overwrite = overwrite)
pipelines_2010 <- readRDS(data_folder("pipelines_2010_transformed.rds"))
use_data(pipelines_2010, overwrite = overwrite)

system(script_folder("3b-clean_cols_incidents.R"))
incidents <- readRDS(data_folder("incidents_transformed.rds"))
incidents_1986 <- incidents[["i_86"]]
use_data(incidents_1986, overwrite = overwrite)
incidents_2002 <- incidents[["i_02"]]
use_data(incidents_2002, overwrite = overwrite)
incidents_2010 <- incidents[["i_10"]]
use_data(incidents_2010, overwrite = overwrite)

# 4. Fix pipelines_2004
# There is a lot of stuff messed up with dataset in particular, such as duplicate observations, so we fix this first.
system(script_folder("4-fix_p_04.R"))

# 5. Create additional columns and transform as necessary
system(script_folder("5a-transform_cols_pipelines.R"))
system(script_folder("5b-transform_cols_incidents.R"))

# 6. Merge datasets
system(script_folder("6-merge_datasets.R"))
pipelines_ungrouped <- readRDS(data_folder("pipelines_merged.rds"))
use_data(pipelines_ungrouped, overwrite = overwrite)

# 7. Handle M&As
system(script_folder("7-handle_m_as.R"))
pipelines <- readRDS(data_folder("pipelines_grouped.rds"))
use_data(pipelines, overwrite = overwrite)

# 8. Create topic models
system("jupyter nbconvert --to notebook --execute --inplace data-raw/util/8-topic_model.ipynb")
system("jupyter nbconvert --to slides data-raw/util/8-topic_model.ipynb")
betas <- readRDS(data_folder("betas.rds"))
use_data(betas, overwrite = overwrite)

# 9. Interpret topic models
system("jupyter nbconvert --to notebook --execute --inplace data-raw/util/9-interpret_topics.ipynb")
system("jupyter nbconvert --to slides data-raw/util/9-interpret_topics.ipynb")
labels <- readRDS(data_folder("labels.rds"))
use_data(labels, overwrite = overwrite)
incidents <- readRDS(data_folder("incidents_topics.rds"))
use_data(incidents, overwrite = overwrite)
