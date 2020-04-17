#' Recode a commodity vector to be standardized between the different datasets.
#'
#' @param x Vector with commodities to be standardized.
#'
#' @return Cleaned up vector as factor.
#'
#' @examples
#' oildata:::fix_commodities(incidents_2002$commodity)
fix_commodities <- function(x) {
  commodities <- c("Crude Oil" = "crude",
                   "Fuel Grade Ethanol (dedicated system)" = "fge",
                   "Refined and/or Petroleum Product (non-HVL)" = "rpp",
                   "CRUDE OIL" = "crude",
                   "HVLS" = "hvl",
                   "PETROLEUM & REFINED PRODUCTS" = "rpp",
                   "HVLS/OTHER FLAMMABLE OR TOXIC FLUID WHICH IS A GAS AT AMBIENT CONDITIONS" = "hvl",
                   "GASOLINE, DIESEL, FUEL OIL OR OTHER PETROLEUM PRODUCT WHICH IS A LIQUID AT AMBIENT CONDITIONS"
                      = "rpp",
                   # "CO2 OR OTHER NON-FLAMMABLE, NON-TOXIC FLUID WHICH IS A GAS AT AMBIENT CONDITIONS" = "CO2",
                   "CO2 (CARBON DIOXIDE)" = "co2",
                   "HVL OR OTHER FLAMMABLE OR TOXIC FLUID WHICH IS A GAS AT AMBIENT CONDITIONS" = "hvl",
                   "REFINED AND/OR PETROLEUM PRODUCT (NON-HVL) WHICH IS A LIQUID AT AMBIENT CONDITIONS" = "rpp",
                   "HVL" = "hvl",
                   "CRUDE OIL" = "crude",
                   "GASOLINE" = "rpp",
                   "NATURAL GAS LIQUID" = "lng",
                   "FUEL OIL" = "rpp",
                   "DIESEL FUEL" = "rpp",
                   "L. P. G." = "hvl",
                   "JET FUEL" = "rpp",
                   "ANHYDROUS AMMONIA" = "hvl",
                   "OIL AND GASOLINE" = "rpp",
                   "BUTANE" = "hvl",
                   "TURBINE FUEL" = "rpp",
                   "TRANSMIX (PART. REFINED PETRO)" = "rpp",
                   "PROPANE" = "hvl",
                   "KEROSENE" = "rpp",
                   "GASOLINE AND FUEL OIL" = "rpp",
                   "CO2/N2 OR OTHER NON-FLAMMABLE, NON-TOXIC FLUID WHICH IS A GAS AT AMBIENT CONDITIONS" = "co2")

  return(recode(x, !!! commodities))
}

#' Rules for consolidating the different columns in the pipelines datasets when companies merge
#'
#' @source Wirtten for the purpose of handling operations in this package. Source of the processed data:
#'   \url{https://www.phmsa.dot.gov/data-and-statistics/pipeline/gas-distribution-gas-gathering-gas-transmission-hazardous-liquids}
#' @format A list with the rowname, and the summary operation.
#' \describe{
#'   \item{pipelines_consolidation}{List that holds entry for each column as separate object.}
#' }
#' @examples
#' \dontrun{
#'  pipelines_consolidation
#' }
"pipelines_consolidation"

#' Rules for adding together different incidents when aggregating by organization and/or year etc.
#'
#' @source Wirtten for the purpose of handling operations in this package. Source of the processed data:
#'   \url{https://www.phmsa.dot.gov/data-and-statistics/pipeline/distribution-transmission-gathering-lng-and-liquid-accident-and-incident-data}
#' @format A list with the rowname, and the summary operation.
#' \describe{
#'   \item{incident_consolidation}{List that holds entry for each column as separate object.}
#' }
#' @examples
#' \dontrun{
#'  incident_consolidation
#' }
"incident_consolidation"
