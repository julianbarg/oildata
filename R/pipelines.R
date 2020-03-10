#' Annual data on pipelines in the US from 2004 to 2019
#'
#' Annual Report Data from Gas Distribution, Gas Gathering, Gas Transmission,
#' Hazardous Liquids, Liquefied Natural Gas (LNG), and Underground Natural Gas
#' Storage (UNGS) Facility Operators. Operators are required to submit annual
#' reports to PHMSA. Reports include information such as total pipeline mileage,
#' facilities, commodities transported, mileage by material, and installation
#' dates. Organizations aggregated according to the M&A dataset in this package.
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
#'  \item{offshore_share}{Share of total pipeline miles that is offshore pipelines.}
#'  \item{on_offshore}{Observation describes offshore or onshroe pipelines.}
#'  \item{hca}{Miles of pipelines in High Consequences Areas.}
#'  \item{miles}{Total number of pipeline miles.}
#'  \item{volume_crude}{Volume of crude oil transported (in barrel-miles).}
#'  \item{volume_hvl}{Volume of highly volatile liquid transported (in barrel-miles).}
#'  \item{volume_rpp}{Volume of refined petroleum products transported (in barrel-miles).}
#'  \item{volume_other}{Volume of substance other than crude, rpp, and hvl transported (in barrel-miles).}
#'  \item{estimate_volume_crude}{Estimated volume of crude oil transported (in barrel-miles). Contains the actual value transported where available from volume_crude column. Missing values are approximated as total volume multiplied by the share of offshore pipelines/onshore in the pipeline network.}
#'  \item{estimate_volume_hvl}{Estimated volume of highly volatile liquid transported (in barrel-miles). Contains the actual value transported where available from volume_hvl column. Missing values are approximated as total volume multiplied by the share of offshore/onshore pipelines in the pipeline network.}
#'  \item{estimate_volume_rpp}{Estimated volume of refined petroleum products transported (in barrel-miles). Contains the actual value transported where available from volume_rpp column. Missing values are approximated as total volume multiplied by the share of offshore/onshore pipelines in the pipeline network.}
#'  \item{estimate_volume_other}{Estimated volume of substance other than crude, rpp, and hvl transported (in barrel-miles). Contains the actual value transported where available from volume_other column. Missing values are approximated as total volume multiplied by the share of offshore/onshore pipelines in the pipeline network.}
#'  \item{volume_all}{Combined volume of all substances transported (in barrel-miles).}
#'  \item{estimate_volume_all}{Estimated combined volume of all substances transported (in barrel-miles). Contains the actual value transported where available from the volume_all column. Missing values are approximated as total volume multiplied by the share of offshore/onshore pipelines in the pipeline network.}
#'  \item{volume_specific}{Volume transported of the substance that the pipeline is designated for (in barrel-miles).}
#'  \item{estimate_volume_specific}{Estimated volume transported of the substance that the pipeline is designated for (in barrel-miles).  Contains the actual value transported where available from the volume_specific column. Missing values are approximated as total volume multiplied by the share of offshore/onshore pipelines in the pipeline network.}
#'  \item{incidents}{Total number of incidents (both significant and non-significant).}
#'  \item{significant_incidents}{Count of significant incidents. Obtained from the incident datasets.}
#'  \item{serious_incidents}{Count of serious incidents. Obtained from the incident datasets.}
#'  \item{incidents_volume}{Total number of gallons spilled across all incidents.}
#'  \item{significant_incidents_volume}{Total number of gallons spilled across all significant incidents.}
#'  \item{incidents_cost}{Combined cost of all incidents (in 1984 dollars).}
#'  \item{significant_incidents_cost}{Combined cost of all significant incidents (in 1984 dollars).}
#' }
#' @examples
#' \dontrun{
#'  pipelines
#' }
"pipelines"
