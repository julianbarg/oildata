#' Merged dataset of all incidents.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{DATAFILE_AS_OF}{}
#'   \item{significant}{Identify if record meets the significant criteria or not: If there was fatality, injury, fire, explosion, total property damage $50K or more in 1984 dollars, non-HVL loss >= 50bbls, HVL loss >= 5bbls, then SIGNIFICANT=’YES’, else SIGNIFICANT=’NO’. See also: \url{https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/docs/pdmpublic_incident_page_allrpt.pdf}.}
#'   \item{serious}{Identify if record meets the SERIOUS criteria or not: If there was fatality or injury then SERIOUS = ‘YES’ else SERIOUS = ’NO’.}
#'   \item{incident_ID}{Unique incident ID. Also called report ID or report number.}
#'   \item{ID}{Unique operator ID.}
#'   \item{name}{Name of the pipelines operator at the time of the incident (year).}
#'   \item{state}{State of incidents (for offshore, the state of nearby coast).}
#'   \item{on_offshore}{Whether the oil spill occured onshore or offshore.}
#'   \item{system}{Part of system involved in accident.}
#'   \item{item}{Item involved in accident.}
#'   \item{installation_year}{Year item installed that involved in accident.}
#'   \item{MAP_CAUSE}{Cause, coded by PHMSA.}
#'   \item{cause}{Cause of the incident.}
#'   \item{subcause}{Subcause of the incident, coded by PHMSA.}
#'   \item{fatalities}{Total number of Fatalities.}
#'   \item{injuries}{Total number of Injuries.}
#'   \item{cost}{Total costs (in US$).}
#'   \item{cost_1984}{Converted Property Damage to Year 1984 dollars.}
#'   \item{TOTAL_COST_CURRENT}{}
#'   \item{commodity}{}
#'   \item{volume}{Volume of the spill (barrels).}
#'   \item{recovered}{Estimated volume of commodity recovered (barrels).}
#'   \item{fire}{Did a fire occur?}
#'   \item{explosion}{Did an explosion occur?}
#'   \item{narrative}{}
#'   \item{net_loss}{Volume of substance unintentionally released (in barrels) minus volume recovered.}
#'   \item{year}{Year accident occurred, derived from accident date.}
#'   \item{date}{Date of the spill.}
#'   \item{lat}{Accident location latitude.}
#'   \item{long}{Accident location longitude.}
#'   \item{water_contamination}{Water Contamination.}
#'   \item{manufacture_year}{Year that the failed item was manufactured (for 2010 onward: pipe or valve only).}
#'   \item{surface_water_remediation}{Anticipated remediation - Surface water.}
#'   \item{groundwater_remediation}{Anticipated remediation - Ground water.}
#'   \item{soil_remediation}{Anticipated remediation - Soil.}
#'   \item{vegetation_remediation}{Anticipated remediation - Vegetation.}
#'   \item{wildlife_remediation}{Anticipated remediation - Wildlife.}
#' }
"incidents"
