#!/usr/bin/env Rscript
library(tidyverse)

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

# 0. Parameters
system("data-raw/util/0-define_parameters.R")
parameters <- readRDS("data-raw/.temp/parameters.RDS")

# 1. Download data
raw_files <- paste0(parameters[["all_datasets"]], "_raw.feather")
if (redownload) {
  system("data-raw/util/1-load_data.py")
} else if (!all(raw_files %in% list.files("data-raw/.temp/data"))){
  warning("Some file(s) not available. May need to use --redownload flag.")
}
# 2. Rename
system("data-raw/util/2-rename.R")

# 3. Clean columns
# As a first step, all we do is clean up columns in all files without making any transformations.
system("data-raw/util/3a-clean_cols_p'04.R")
system("data-raw/util/3b-clean_cols_incidents.R")

# 4. Fix pipelines_2004
system("data-raw/util/4-fix_p_04.R")
