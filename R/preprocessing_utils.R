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
                   "Refined and/or Petroleum Product (non-HVL)" = "non_hvl",
                   "CRUDE OIL" = "crude",
                   "HVLS" = "hvl",
                   "PETROLEUM & REFINED PRODUCTS" = "non_hvl",
                   "HVLS/OTHER FLAMMABLE OR TOXIC FLUID WHICH IS A GAS AT AMBIENT CONDITIONS" = "hvl",
                   "GASOLINE, DIESEL, FUEL OIL OR OTHER PETROLEUM PRODUCT WHICH IS A LIQUID AT AMBIENT CONDITIONS"
                      = "non_hvl",
                   # "CO2 OR OTHER NON-FLAMMABLE, NON-TOXIC FLUID WHICH IS A GAS AT AMBIENT CONDITIONS" = "CO2",
                   "CO2 (CARBON DIOXIDE)" = "co2",
                   "HVL OR OTHER FLAMMABLE OR TOXIC FLUID WHICH IS A GAS AT AMBIENT CONDITIONS" = "hvl",
                   "REFINED AND/OR PETROLEUM PRODUCT (NON-HVL) WHICH IS A LIQUID AT AMBIENT CONDITIONS" = "non_hvl",
                   "HVL" = "hvl")

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
