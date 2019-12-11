#!/usr/bin/env Rscript
library(devtools)
library(tidyverse)

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

load("data/incidents_2002.rda")
load("data/incidents_2010.rda")

incidents_count <- rbind(select(incidents_2002, year, ID, commodity, significant, serious),
                         select(incidents_2010, year, ID, commodity, significant, serious))

significant <- incidents_count %>%
  filter(significant == TRUE) %>%
  filter(commodity %in% c("crude", "hvl", "non_hvl")) %>%
  group_by(year, ID, commodity) %>%
  summarize(significant_incidents = n())

serious <- incidents_count %>%
  filter(serious == TRUE) %>%
  filter(commodity %in% c("crude", "hvl", "non_hvl")) %>%
  group_by(year, ID, commodity) %>%
  summarize(serious_incidents = n())

pipelines_ungrouped <- left_join(pipelines_ungrouped, significant, by = c("year", "ID", "commodity"))
pipelines_ungrouped <- left_join(pipelines_ungrouped, serious, by = c("year", "ID", "commodity"))
pipelines_ungrouped[is.na(pipelines_ungrouped$significant_incidents), ]$significant_incidents <- 0
pipelines_ungrouped[is.na(pipelines_ungrouped$serious_incidents), ]$serious_incidents <- 0

use_data(pipelines_ungrouped, overwrite = TRUE)

# Incidents merge ------------------------

incidents <- rbind(select(incidents_2002, year, ID, commodity, significant, serious, cause),
                   select(incidents_2010, year, ID, commodity, significant, serious, cause))
use_data(incidents, overwrite = TRUE)

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
