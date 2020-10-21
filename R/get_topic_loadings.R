#' Get topic loadings aggregated to the organization
#'
#' @param df Dataset with topic loadings.
#' @param variable Variable used for weighting the loadings.
#'
#' @return The dataset with identity columns and loadings only.
#' @import dplyr
#' @importFrom tidyr pivot_longer
#' @export
#'
#' @examples
#' get_topic_loadings()
get_topic_loadings <- function(df = oildata::incidents, variable = volume){
  id_vars <- c("incident_ID", "ID", "year", "commodity", "on_offshore")
  df %>%
    select({{ id_vars }}, {{ variable }}, starts_with("topic_")) %>%
    filter(!is.na({{ variable }}), {{ variable }} != 0, !is.na(topic_1)) %>%
    pivot_longer(starts_with("topic_"), names_to = "topic", values_to = "gamma",
                 names_prefix = "topic_") %>%
    # Include topic below, too, since the loss is duplicated for every topic
    # row. This saves us a pivot_wider or dividing by 23 to remove duplicates.
    # This way, the mathematical operations only include operations within the
    # same topic and there are no duplicate observations within the mathematical
    # operation.
    group_by(ID, year, commodity, on_offshore, topic) %>%
    mutate(variable_total = sum({{ variable }}),
           variable_share = {{ variable }} / variable_total,
           topic_share = gamma * variable_share) %>%
    group_by(ID, year, commodity, on_offshore, topic) %>%
    summarize(topic_share = sum(topic_share)) %>%
    ungroup()
}
