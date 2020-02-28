#!/usr/bin/env Rscript
library(devtools)
library(tidyverse)

##################################################################
###     Setup     ################################################
##################################################################

arguments <- commandArgs(trailingOnly = TRUE)
redownload <- "--download" %in% arguments

# Downloads and saves the original datasets
if (isTRUE(redownload)) {system("data-raw/util/process_phmsa_data.R --download")
} else system("data-raw/util/process_phmsa_data.R")

# Set up arguments
observation_period <- c(2004:2019)

mutate_cols <- list(incidents = list(filter_col=NULL, aggregate_col=NULL),
                    significant_incidents = list(filter_col=quo(significant), aggregate_col=NULL),
                    serious_incidents = list(filter_col=quo(serious), aggregate_col=NULL),
                    incidents_volume = list(filter_col=NULL, aggregate_col=quo(volume)),
                    significant_incidents_volume = list(filter_col=quo(significant), aggregate_col=quo(volume)),
                    incidents_cost = list(filter_col=NULL, aggregate_col=quo(cost)),
                    significant_incidents_cost = list(filter_col=quo(significant), aggregate_col = quo(cost))
                    )

pipelines_consolidation <- list(hca_offshore = quo(sum(hca_offshore, na.rm = T)),
                                hca_onshore = quo(sum(hca_onshore, na.rm = T)),
                                hca_total = quo(sum(hca_total, na.rm = T)),
                                total_onshore = quo(sum(total_onshore, na.rm = T)),
                                total_offshore = quo(sum(total_offshore, na.rm = T)),
                                total_miles = quo(sum(total_miles, na.rm = T)),
                                incidents = quo(sum(incidents, na.rm = T)),
                                significant_incidents = quo(sum(significant_incidents, na.rm = T)),
                                serious_incidents = quo(sum(serious_incidents, na.rm = T)),
                                incident_volume = quo(sum(incident_volume, na.rm = T)),
                                significant_incident_volume = quo(sum(significant_incident_volume, na.rm = T)),
                                incidents_cost = quo(sum(incidents_cost, na.rm = T)),
                                significant_incidents_cost = quo(sum(significant_incidents_cost, na.rm = T))
)

##################################################################
###   Functions   ################################################
##################################################################

col_union <- function(dfs) {
  # Rowbinds a list of dataframes, but only retains the columns that they have in common
  common_cols <- Reduce(intersect, (map(dfs, ~ colnames(.x))))
  map_dfr(dfs, ~select(.x, !! quo(common_cols)))
}

extract_count <- function(df, colname, filter_col=NULL, aggregate_col=NULL) {
  # Extract the count of the number of accidents per organization and commodity based on filters and returns them
  # with a sensible column name.
  filter_if <- function(df, filter_col){
    if (is.null(filter_col)) {
      df
    } else {
      df %>%
        filter(!! filter_col == TRUE)
    }
  }

  aggregate_if <- function(df, aggregate_col, colname) {
    if (is.null(aggregate_col)) {
      df %>%
        summarize(!! colname := n())
    } else {
      df %>%
        summarize(!! colname := sum(!! aggregate_col))
    }
  }

  df %>%
    filter_if(filter_col) %>%
    filter(commodity %in% c("crude", "hvl", "non_hvl")) %>%
    group_by(year, ID, commodity) %>%
    aggregate_if(aggregate_col, colname)
}

make_dataset <- function(pipelines, incidents, mutate_cols) {
  for (colname in names(mutate_cols)) {
    filter_col = mutate_cols[[colname]][["filter_col"]]
    aggregate_col = mutate_cols[[colname]][["aggregate_col"]]
    column <- extract_count(incidents,
                            colname,
                            filter_col = filter_col,
                            aggregate_col = aggregate_col)

      pipelines <- left_join(pipelines, column, by = c("year", "ID", "commodity"))
      pipelines[is.na(pipelines[[colname]]), ][[colname]] <- 0
  }
  pipelines
}

##################################################################
###     Main      ################################################
##################################################################

# Ingest datasets to mutate. Datasets are created by process_phmsa_data.R,
# which does not greatly alter the original dataset.
source("data-raw/util/pipelines_consolidation.R")
load("data/pipelines_2004.rda")
load("data/pipelines_2010.rda")
load("data/incidents_2002.rda")
load("data/incidents_2010.rda")
source("data-raw/util/groups.R")
source("data-raw/util/m_as.R")
pipeline_datasets <- list(pipelines_2004, pipelines_2010)
incidents_datasets <- list(incidents_2002, incidents_2010)

# Some basic housekeeping
m_as <- rbind(m_as, groups)
m_as$type <- as.factor(m_as$type)
incidents <- col_union(incidents_datasets)

# Provide datasets in package
use_data(pipelines_consolidation, overwrite = TRUE)
use_data(m_as, overwrite = TRUE)
use_data(incidents, overwrite = TRUE)

# Create important datasets
pipelines_ungrouped <- col_union(pipeline_datasets)
pipelines_ungrouped <- make_dataset(pipelines = pipelines_ungrouped,
                                    incidents = incidents,
                                    mutate_cols = mutate_cols)
pipelines_ungrouped <- subset(pipelines_ungrouped, year %in% observation_period)
pipelines <- oildata::consolidate_groups(pipelines_ungrouped,
                                         pipelines_consolidation,
                                         groups = m_as,
                                         by_cols = vars(ID, year, commodity))

# Provide important datasets in package
use_data(pipelines_ungrouped, overwrite = T)
use_data(pipelines, overwrite = T)
