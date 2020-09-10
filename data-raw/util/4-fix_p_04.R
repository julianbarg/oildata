#!/usr/bin/env Rscript
library(magrittr)
library(tidyverse)

p_04 <- readRDS("data-raw/.temp/data/pipelines_2004_cleaned.rds")
parameters <- readRDS("data-raw/.temp/parameters.RDS")

# Currently, miles cutoff is at 0. Only retaining observations with any pipeline miles.
p_04 <- subset(p_04, miles_total > parameters[["miles_cutoff"]])

