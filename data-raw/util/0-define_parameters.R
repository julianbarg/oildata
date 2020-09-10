#!/usr/bin/env Rscript

all_datasets <- c("pipelines_2004", "pipelines_2010", "incidents_1986",
                  "incidents_2002", "incidents_2010")

# How many miles of pipelines should an operator have at least to be considered.
miles_cutoff <- 0

parameters <- list(all_datasets = all_datasets,
                   miles_cutoff = miles_cutoff)

saveRDS(parameters, "data-raw/.temp/parameters.RDS")
