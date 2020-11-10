#!/usr/bin/env Rscript
suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(here))
options(dplyr.summarise.inform = FALSE)

parameters <- readRDS(here("data-raw", ".temp", "parameters.RDS"))
data_folder <- purrr::partial(here, "data-raw", ".temp", "data")

# Take care of company groups
pipelines_ungrouped <- readRDS(data_folder("pipelines_merged.rds"))
pipelines_ungrouped$ID <- as.character(pipelines_ungrouped$ID)
groups <- parameters[["groups"]]
groups$members <- as.character(groups$members)
sum_na_rm_cols <- parameters[["aggregate_operators"]][["sum_na_rm_cols"]]
take_first_cols <- parameters[["aggregate_operators"]][["take_first_cols"]]

# group_pipelines <- subset(pipelines_ungrouped, ID %in% groups$members)
# lonely_pipelines <- subset(pipelines_ungrouped, !(ID %in% groups$members))
# group_pipelines <- select(group_pipelines, -state)
#
# pipelines <- group_pipelines %>%
#   left_join(groups, by = c("ID" = "members")) %>%
#   group_by(group_name, year, commodity, on_offshore) %>%
#   summarize(across({{ sum_na_rm_cols }}, ~sum(.x, na.rm = T)),
#             across({{ take_first_cols }}, first)) %>%
#   rename("ID" = "group_name") %>%
#   mutate(name = str_remove(ID, " \\(Group\\)")) %>%
#   bind_rows(lonely_pipelines)

# Take care of m_as
m_as <- parameters[["m_as"]] %>%
  mutate(start_year = replace_na(start_year, 1950),
         end_year = replace_na(end_year, 2050)) %>%
  merge(data.frame(year = 1900:2100)) %>%
  filter(year < end_year, year >= start_year) %>%
  mutate(ma_year = (year == start_year) | year == end_year) %>%
  select(-end_year, -start_year)

no_ma <- anti_join(pipelines_ungrouped, m_as,
                   by = c("year" = "year", "ID" = "members")) %>%
  mutate(ma_year = F)
pipelines_grouped <- pipelines_ungrouped %>%
  inner_join(m_as, by=c("year" = "year", "ID" = "members")) %>%
  mutate(state = state.y) %>%
  select(-state.x, state.y) %>%
  group_by(group_name, year, commodity, on_offshore) %>%
  summarize(across({{ sum_na_rm_cols }}, ~sum(.x, na.rm = T)),
            across({{ take_first_cols }}, first)) %>%
  ungroup() %>%
  rename("ID" = "group_name") %>%
  mutate(name = str_remove(ID, " \\(Group\\)")) %>%
  bind_rows(no_ma) %>%
  mutate(ma_year = replace_na(ma_year, F))

readr::write_rds(pipelines_grouped, data_folder("pipelines_grouped.rds"))
print("7 - Aggregated companies to group level.")
