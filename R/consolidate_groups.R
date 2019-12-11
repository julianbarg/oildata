#' Handle M&As in a dataframe
#'
#' Aggregates observations where an M&A has taken place. Is called by oildata::consolidate_groups,
#' after company groups are handled.
#'
#' @param df Dataframe for which to aggregate companies to organizational level.
#' @param summary_parsing A list of new column names and quoted functions (with quo) to be passed into summarize.
#' @param m_as The M&As section of the m_as dataset in this package.
#' @param by_cols Columns by which to aggregate.
handle_ma <- function(df, summary_parsing, m_as, by_cols = vars(ID, year, commodity)) {
  # Todo: Check for m_as not being in dataset.
  summary_parsing <- summary_parsing[names(summary_parsing) %in% colnames(df)]
  m_as$group_name <- as.character(m_as$group_name)

  batch <- m_as[!duplicated(m_as$ID), ]
  next_batch <- m_as[duplicated(m_as$ID), ]

  df <- left_join(df, batch, by = "ID")
  df$within <- (!is.na(df$group_name) & df$year >= df$start_year & df$year < df$end_year)
  # Todo: Check for m_as not being within observation period.
  df$ID <- ifelse(df$within, df$group_name, df$ID)
  df <- select(df, -c(start_year, end_year, within, group_name))

  df <- DataAnalysisTools::consolidate_duplicates(df, summary_parsing = summary_parsing, by_cols = by_cols)

  if (nrow(next_batch) >= 1) {
    df <- (handle_ma(df, summary_parsing = summary_parsing,
                     m_as = next_batch, by_cols = by_cols))
  }
  return(df)
}

#' Consolidate company groups in a dataframe
#'
#' Functions first can be used in ... to retain the latest value (e.g., for name),
#' and sum_na_rm can be used to sum values with NAs being removed by default.
#'
#' @param df Dataframe for which to aggregate companies to organizational level.
#' @param summary_parsing A list of new column names and quoted functions (with quo) to be passed into summarize.
#' @param ... Column and parsing function, in the format c("col_1" = "func_1", "col_2" = "func_2" ...).
#' @param groups The m_as dataset from this packge, or equivalent.
#' @param by_cols Columns by which to aggregate.
#'
#' @export
#'
#' @examples
#' consolidate_groups(oildata::pipelines,
#'                    list(total_miles = dplyr::quo(sum(total_miles, na.rm = TRUE))))
consolidate_groups <- function(df, summary_parsing, ...,
                               groups = oildata::m_as, by_cols = vars(ID, year, commodity)) {
  # Todo: check for groups not being in dataset.
  if (length(c(...) >= 1)) {by_cols <- enquos(...)}

  summary_parsing <- summary_parsing[names(summary_parsing) %in% colnames(df)]

  groups$group_name <- as.character(groups$group_name)

  df$ID <- as.character(df$ID)
  groups$ID <- as.character(groups$members)

  groups_ <- subset(groups, type == "group") %>%
    select(-c(members, start_year, end_year, type))
  m_as <- subset(groups, type == "m_a", -members) %>%
    select(-c(type))

  df <- left_join(df, groups_, by = "ID") # %>% # Stop here and remane column?
  if (max(duplicated(select(df, ID, year, commodity))) == 1) warning("Some duplicates detected. Is a company erroneously in multiple groups?")

  df$ID <- ifelse(is.na(df$group_name), df$ID, df$group_name)
  df <- select(df, -group_name)

  df <- DataAnalysisTools::consolidate_duplicates(df, summary_parsing = summary_parsing, by_cols = by_cols)

  # Now do the same for M&As, you amazing guy.
  m_as[is.na(m_as$start_year), ]$start_year <- -9999
  m_as[is.na(m_as$end_year), ]$end_year <- 9999

  df <- handle_ma(df, summary_parsing = summary_parsing, m_as = m_as, by_cols = by_cols)

  return(df)
}
