#!/usr/bin/env Rscript
library(devtools)

# Dataset consolidation rules ------------

source("data-raw/util/pipelines_consolidation.R")
use_data(pipelines_consolidation, overwrite = TRUE)

# PHMSA Datsets --------------------------

system("data-raw/util/process_phmsa_data.R")

# PHMSA Merge ----------------------------

load("data/pipelines_2004.rda")
load("data/pipelines_2010.rda")
common_cols <- colnames(pipelines_2010)[colnames(pipelines_2010) %in% colnames(pipelines_2004)]
pipelines_ungrouped <- rbind(pipelines_2004[ , common_cols], pipelines_2010[ , common_cols])
use_data(pipelines_ungrouped, overwrite = TRUE)

# Company groups -------------------------

source("data-raw/util/groups.R")

# M & As ---------------------------------

source("data-raw/util/m_as.R")

# M&As and groups ------------------------

# Groupings are applied before M&As. Therefore, it is very important that companies
# that are in a group show up in the M&A dataset under their group name.

groups$type <- "group"
m_as$type <- "m_a"
groups$start_year <- NA
groups$end_year <- NA

m_as <- rbind(m_as, groups)
m_as$type <- as.factor(m_as$type)

use_data(m_as, overwrite = TRUE)

# Pipelines grouped ----------------------

pipelines <- oildata::consolidate_groups(pipelines_ungrouped, pipelines_consolidation,
                                         groups = m_as, by_cols = dplyr::vars(ID, year, commodity))
use_data(pipelines, overwrite = TRUE)
