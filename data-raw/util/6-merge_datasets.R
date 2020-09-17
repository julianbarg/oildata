#!/usr/bin/env Rscript
suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(here))
options(dplyr.summarise.inform = FALSE)

data_folder <- purrr::partial(here, "data-raw", ".temp", "data")

# Read data from disk
p_04 <- readRDS(data_folder("pipelines_2004_transformed.rds"))
p_10 <- readRDS(data_folder("pipelines_2010_transformed.rds"))

incidents <- readRDS(data_folder("incidents_transformed.rds"))
i_86 <- incidents[["i_86"]]
i_02 <- incidents[["i_02"]]
i_10 <- incidents[["i_10"]]

# Merge pipeline datasets
common_cols <- intersect(colnames(p_04), colnames(p_10))
pipelines <- bind_rows(p_04[ ,common_cols], p_10[ ,common_cols])  %>%
  pivot_longer(matches("offshore$|onshore$|total$"),
               names_to = c(".value", "on_offshore"),
               # Fortunately, goes to the last underscore bc. greedy first .* but could be more explicit, i.e., ""(.*)_([^_]*)"
               names_pattern = "(.*)_(.*)")

# Merge incident datasets
common_cols <- Reduce(intersect, map(incidents, colnames))
incidents <- incidents %>%
  map(~ select(.x, {{ common_cols }} )) %>%
  map_dfr(bind_rows)

# Create _specific cols to show when crude pipeline transports crude etc.
pipelines <- pipelines %>%
  mutate(estimate_volume_specific = case_when(commodity == "crude" ~ estimate_volume_crude,
                                              commodity == "hvl"   ~ estimate_volume_hvl,
                                              commodity == "rpp"   ~ estimate_volume_rpp),
         volume_specific =          case_when(commodity == "crude" ~ volume_crude,
                                              commodity == "hvl"   ~ volume_hvl,
                                              commodity == "rpp"   ~ volume_rpp))

# Merge in accidents
spills_grouped <- group_by(incidents, ID, year, commodity, on_offshore)
aggregate_inc <- function(columns, filter_col = NULL){
  filter <- if (!is.null(filter_col)) spills_grouped[[filter_col]] == TRUE else T
  column_values <- unname(columns)
  spills_grouped[filter,] %>%
    summarize(across({{ column_values }}, ~sum(.x, na.rm = T))) %>%
    rename(!!! columns)
}

# Define the spill columns we want to create
sum_cols <-         c(incidents_volume = "volume",
                      recovered = "recovered",
                      net_loss_volume = "net_loss",
                      incidents_cost = "cost_1984")
sum_cols_sign <-    c(significant_incidents = "significant",
                      significant_incidents_cost = "cost_1984",
                      significant_incidents_volume = "volume")
sum_cols_serious <- c(serious_incidents = "serious")
new_cols <- c(names(sum_cols), names(sum_cols_sign), names(sum_cols_serious))

# Prepare a spill df for merging
join_incidents <- partial(left_join,
                          by = c("ID", "year", "commodity", "on_offshore"))
incident_data <- spills_grouped %>%
  summarize(incidents = n()) %>%
  join_incidents(aggregate_inc(sum_cols)) %>%
  join_incidents(aggregate_inc(sum_cols_sign, "significant")) %>%
  join_incidents(aggregate_inc(sum_cols_serious, "serious"))

# Clean and merge and clean
pipelines <- incident_data %>%
  group_by(ID, year) %>%
  summarize(across({{ new_cols }},
                   ~sum(.x, na.rm = T),
                   .names = "{new_cols}_total")) %>%
  ungroup() %>%
  pivot_longer(matches("offshore$|onshore$|total$"),
               names_to = c(".value", "on_offshore"),
               # Fortunately, goes to the last underscore bc. greedy first .* but could be more explicit, i.e., ""(.*)_([^_]*)"
               names_pattern = "(.*)_(.*)") %>%
  bind_rows(incident_data) %>%
  right_join(pipelines, by = c("ID", "year", "commodity", "on_offshore")) %>%
  mutate(across({{ new_cols }}, ~ replace_na(.x, 0)))

readr::write_rds(pipelines, data_folder("pipelines_merged.rds"))
readr::write_rds(incidents, data_folder("incidents_merged.rds"))
