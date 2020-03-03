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
#'  \item{commodity}{The type of commodity being transported (Crude, HVL, etc.).}
#'  \item{ID}{Unique operator ID.}
#'  \item{name}{Name of the pipelines operator at the time of the report year.}
#'  \item{on_offshore}{Observation describes offshore or onshroe pipelines.}
#'  \item{hca}{Miles of pipelines in High Consequences Areas.}
#'  \item{miles}{Total number of pipeline miles.}
#'  \item{incidents}{Total number of incidents (both significant and non-significant).}
#'  \item{significant_incidents}{Count of significant incidents. Obtained from the incident datasets.}
#'  \item{serious_incidents}{Count of serious incidents. Obtained from the incident datasets.}
#'  \item{incidents_volume}{Total number of gallons spilled across all incidents.}
#'  \item{significant_incidents_volume}{Total number of gallons spilled across all significant incidents.}
#'  \item{incidents_cost}{Combined cost of all incidents.}
#'  \item{significant_incidents_cost}{Combined cost of all significant incidents.}
#' }
#' @examples
#' \dontrun{
#'  pipelines_ungrouped
#' }
"pipelines_ungrouped"
