#' Annual data on pipelines in the US from 2004 to 2018
#'
#' Annual Report Data from Gas Distribution, Gas Gathering, Gas Transmission,
#' Hazardous Liquids, Liquefied Natural Gas (LNG), and Underground Natural Gas
#' Storage (UNGS) Facility Operators. Operators are required to submit annual
#' reports to PHMSA. Reports include information such as total pipeline mileage,
#' facilities, commodities transported, mileage by material, and installation
#' dates. Organizations not aggregated: some organizations fall within the same
#' parent company.
#'
#' @source United States Department of Transportation (DOT) Pipeline and
#'   Hazardous Materials Safety Administration (PHMSA).
#'   \url{https://www.phmsa.dot.gov/data-and-statistics/pipeline/gas-distribution-gas-gathering-gas-transmission-hazardous-liquids}
#'    (right side bar).
#' @format A data frame with columns:
#' \describe{
#'  \item{year}{Report year.}
#'  \item{ID}{Unique operator ID.}
#'  \item{name}{Name of the pipelines operator at the time of the report year.}
#'  \item{commodity}{The type of commodity being transported (Crude, HVL, etc.).}
#'  \item{hca_offshore}{Miles of pipelines offshore in High Consequences Areas.}
#'  \item{hca_onshore}{Miles of pipelines onshore in High Consequences Areas.}
#'  \item{hca_total}{Miles of pipelines in High Consequences Areas.}
#'  \item{total_onshore}{Miles of pipelines onshore.}
#'  \item{total_offshore}{Miles of pipelines offshore.}
#'  \item{total_miles}{Miles of pipelines onshore.}
#' }
#' @examples
#' \dontrun{
#'  pipelines_ungrouped
#' }
"pipelines_ungrouped"