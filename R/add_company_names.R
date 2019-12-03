#' Find the company behind the operator ID
#'
#' @param vector Vector with operator IDs to be replaced.
#' @param dataset Dataset with operator names.
#'
#' @return Vector, where the operator IDs with matches are replaced with the name of the company.
#' @import dplyr
#' @export
#'
#' @examples
#' add_company_names(c(300, 26049, 25146))
add_company_names <- function(vector, dataset = oildata::pipelines_2010) {
  col_type <- class(vector)

  # Prepare dataset to merge with
  all_names <- dataset %>%
    select(ID, Name, Year) %>%
    group_by(ID) %>%
    filter(Year == max(Year)) %>%
    slice(1) %>%
    select(-Year)
  all_names$ID <- as.character(all_names$ID)

  temp_names <- data.frame(organization = vector)
  temp_names$organization <- as.character(temp_names$organization)

  # Do the merging to obtain the (missing) names
  temp_names <- left_join(temp_names, all_names, by = c("organization" = "ID"))
  name_missing <- !is.na(temp_names$Name)  # The name of the company can only be missing if joining by OPERATOR_ID is successfuly (bc then there is an ID, not a Name there)
  names <- ifelse(name_missing, temp_names$Name, temp_names$organization)

  return(DataAnalysisTools::as.type(names, col_type))
}
