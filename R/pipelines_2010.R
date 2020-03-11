#' Annual data on pipelines in the US from 2010 onward
#'
#' Annual Report Data from Gas Distribution, Gas Gathering, Gas Transmission,
#' Hazardous Liquids, Liquefied Natural Gas (LNG), and Underground Natural Gas
#' Storage (UNGS) Facility Operators. Operators are required to submit annual
#' reports to PHMSA. Reports include information such as total pipeline mileage,
#' facilities, commodities transported, mileage by material, and installation
#' dates.
#'
#' @source United States Department of Transportation (DOT) Pipeline and
#'   Hazardous Materials Safety Administration (PHMSA).
#'   \url{https://www.phmsa.dot.gov/data-and-statistics/pipeline/gas-distribution-gas-gathering-gas-transmission-hazardous-liquids}
#'    (right side bar).
#' @format A data frame with columns:
#' \describe{
#'  \item{DATAFILE_AS_OF}{}
#'  \item{year}{Report year.}
#'  \item{REPORT_NUMBER}{}
#'  \item{SUPPLEMENTAL_NUMBER}{}
#'  \item{ID}{Unique operator ID.}
#'  \item{name}{Name of the pipelines operator at the time of the report year.}
#'  \item{PARTA4STREET}{}
#'  \item{PARTA4CITY}{}
#'  \item{PARTA4STATE}{}
#'  \item{PARTA4ZIP}{}
#'  \item{PARTA4COUNTRY}{}
#'  \item{commodity}{The type of commodity being transported (Crude, HVL, etc.).}
#'  \item{PARTA7INTER}{}
#'  \item{PARTA7INTRA}{}
#'  \item{hca_offshore}{Miles of pipelines offshore in High Consequences Areas.}
#'  \item{hca_onshore}{Miles of pipelines onshore in High Consequences Areas.}
#'  \item{hca_total}{Miles of pipelines in High Consequences Areas.}
#'  \item{volume_co2_offshore}{Volume of co2 transported offshore (in barrel-miles).}
#'  \item{volume_crude_offshore}{Volume of crude oil transported offshore (in barrel-miles).}
#'  \item{volume_fge_offshore}{Volume of biofuel transported offshore (in barrel-miles).}
#'  \item{volume_hvl_offshore}{Volume of highly volatile liquid transported offshore (in barrel-miles).}
#'  \item{volume_rpp_offshore}{Volume of refined petroleum products transported offshore (in barrel-miles).}
#'  \item{volume_co2_onshore}{Volume of co2 transported onshore (in barrel-miles).}
#'  \item{volume_crude_onshore}{Volume of crude oil transported onshore (in barrel-miles).}
#'  \item{volume_fge_onshore}{Volume of biofuel transported onshore (in barrel-miles).}
#'  \item{volume_hvl_onshore}{Volume of highly volatile liquid transported onshore (in barrel-miles).}
#'  \item{volume_rpp_onshore}{Volume of refined petroleum products transported onshore (in barrel-miles).}
#'  \item{PARTDONCPB}{}
#'  \item{PARTDONCPC}{}
#'  \item{PARTDONCUB}{}
#'  \item{PARTDONCUC}{}
#'  \item{PARTDONCUP}{}
#'  \item{PARTDONCUO}{}
#'  \item{miles_onshore}{Miles of pipelines onshore.}
#'  \item{PARTDOFFCPB}{}
#'  \item{PARTDOFFCPC}{}
#'  \item{PARTDOFFCUB}{}
#'  \item{PARTDOFFCUC}{}
#'  \item{PARTDOFFCUP}{}
#'  \item{PARTDOFFCUO}{}
#'  \item{miles_offshore}{Miles of pipelines offshore.}
#'  \item{PARTDCPBTOTAL}{}
#'  \item{PARTDCPCTOTAL}{}
#'  \item{PARTDCUBTOTAL}{}
#'  \item{PARTDCUCTOTAL}{}
#'  \item{PARTDCUPTOTAL}{}
#'  \item{PARTDCUOTOTAL}{}
#'  \item{miles_total}{Total miles of pipelines.}
#'  \item{PARTEUNKNHF}{}
#'  \item{PARTEUNKNLF}{}
#'  \item{PARTEUNKNTOTAL}{}
#'  \item{PARTEPRE40HF}{}
#'  \item{PARTEPRE40LF}{}
#'  \item{PARTEPRE40TOTAL}{}
#'  \item{PARTE1940HF}{}
#'  \item{PARTE1940LF}{}
#'  \item{PARTE1940TOTAL}{}
#'  \item{PARTE1950HF}{}
#'  \item{PARTE1950LF}{}
#'  \item{PARTE1950TOTAL}{}
#'  \item{PARTE1960HF}{}
#'  \item{PARTE1960LF}{}
#'  \item{PARTE1960TOTAL}{}
#'  \item{PARTE1970HF}{}
#'  \item{PARTE1970LF}{}
#'  \item{PARTE1970TOTAL}{}
#'  \item{PARTE1980HF}{}
#'  \item{PARTE1980LF}{}
#'  \item{PARTE1980TOTAL}{}
#'  \item{PARTE1990HF}{}
#'  \item{PARTE1990LF}{}
#'  \item{PARTE1990TOTAL}{}
#'  \item{PARTE2000HF}{}
#'  \item{PARTE2000LF}{}
#'  \item{PARTE2000TOTAL}{}
#'  \item{PARTE2010HF}{}
#'  \item{PARTE2010LF}{}
#'  \item{PARTE2010TOTAL}{}
#'  \item{PARTETOTAL}{}
#'  \item{PARTETOTALHF}{}
#'  \item{PARTETOTALLF}{}
#'  \item{REPORT_SUBMISSION_TYPE}{}
#'  \item{REPORT_DATE}{}
#'  \item{FILING_DATE}{}
#'  \item{FORM_REV}{}
#'  \item{volume_co2_total}{Total volume of co2 transported on- and offshore (in barrel-miles).}
#'  \item{volume_crude_total}{Total volume of crude oil transported on- and offshore (in barrel-miles).}
#'  \item{volume_fge_total}{Total volume of biofuel transported on- and offshore (in barrel-miles).}
#'  \item{volume_hvl_total}{Total volume of highly volatile liquid transported on- and offshore (in barrel-miles).}
#'  \item{volume_rpp_total}{Total volume of refined petroleum products transported on- and offshore (in barrel-miles).}
#'  \item{estimate_volume_crude_offshore}{Estimated volume of crude oil transported offshore. Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{estimate_volume_hvl_offshore}{Estimated volume of highly volatile liquid transported offshore. Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{estimate_volume_rpp_offshore}{Estimated volume of refined petroleum products transported offshore. Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{estimate_volume_crude_onshore}{Estimated volume of crude oil transported onshore. Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{estimate_volume_hvl_onshore}{Estimated volume of highly volatile liquid transported onshore. Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{estimate_volume_rpp_onshore}{Estimated volume of refined petroleum prloducts transported onshore. Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{offshore_share}{Share of total pipeline miles that is offshore pipelines.}
#'  \item{volume_other_total}{Total volume of substance other than crude, rpp, and hvl transported (in barrel-miles).}
#'  \item{volume_other_offshore}{Total volume of substance other than crude, rpp, and hvl transported offshore (in barrel-miles).}
#'  \item{volume_other_onshore}{Total volume of substance other than crude, rpp, and hvl transported onshore (in barrel-miles).}
#'  \item{estimate_volume_other_offshore}{Estimated volume of substance other than crude, rpp, and hvl transported offshore (in barrel-miles) Placeholder - for this dataset, the column holds the actual value (in barrel-miles)..}
#'  \item{estimate_volume_other_onshore}{Estimated volume of substance other than crude, rpp, and hvl transported onshore (in barrel-miles). Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{volume_all_total}{Combined volume of all substances transported (in barrel-miles). Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{volume_all_offshore}{Combined volume of all substances transported offshore (in barrel-miles). Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{volume_all_onshore}{combined volume of all substances transported onshore (in barrel-miles). Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{estimate_volume_all_offshore}{Estimated volume of all substances transported offshore (in barrel-miles). Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{estimate_volume_all_onshore}{Estimated volume of all substances transported onshore (in barrel-miles). Placeholder - for this dataset, the column holds the actual value (in barrel-miles).}
#'  \item{estimate_volume_all_total}{Estimated of volume of all substances transporte (in barrel-miles). Placeholder - contains the actual value as found in volume_all_total.}
#' }
#' @examples
#' \dontrun{
#'  pipelines_2010
#' }
"pipelines_2010"
