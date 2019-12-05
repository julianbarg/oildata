#!/usr/bin/env Rscript
library(devtools)

# PHMSA Datsets --------------------------

system("data-raw/util/process_phmsa_data.R")

# PHMSA Merge ----------------------------

load("data/pipelines_2004.rda")
load("data/pipelines_2010.rda")
common_cols <- colnames(pipelines_2010)[colnames(pipelines_2010) %in% colnames(pipelines_2004)]
pipelines <- rbind(pipelines_2004[ , common_cols], pipelines_2010[ , common_cols])
use_data(pipelines, overwrite = TRUE)

# Company groups -------------------------

source("data-raw/util/groups.R")

# M & As ---------------------------------

source("data-raw/util/m_as.R")

# M&As and groups ------------------------

groups$type <- "group"
m_as$type <- "m_a"
groups$start_year <- NA
groups$end_year <- NA

m_as <- rbind(m_as, groups)
m_as$type <- as.factor(m_as$type)

use_data(m_as, overwrite = TRUE)
