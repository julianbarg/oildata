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
#'   \item{on_offshore}{Whether the oil spill occured onshore or offshore.}
#'   \item{installation_year}{Year item installed that involved in accident.}
#'   \item{CAUSE}{Cause, self-selected from available options.}
#'   \item{cause}{Coded, by PHMSA to be consistent between different versions of form accross time.}
#'   \item{MAP_SUBCAUSE}{}
#'   \item{fatalities}{Total number of Fatalities.}
#'   \item{injuries}{Total number of Injuries.}
#'   \item{cost}{Total costs (in US$).}
#'   \item{cost_1984}{Converted Property Damage to Year 1984 dollars.}
#'   \item{TOTAL_COST_CURRENT}{}
#'   \item{commodity}{}
#'   \item{volume}{}
#'   \item{recovered}{Estimated volume of commodity recovered (barrels).}
#'   \item{narrative}{}
#'   \item{net_loss}{Volume of substance unintentionally released (in barrels) minus volume recovered.}
#'   \item{year}{Year accident occurred, derived from accident date.}
#'   \item{date}{Date of the spill.}
#'   \item{lat}{Accident location latitude.}
#'   \item{long}{Accident location longitude.}
#' }
"incidents"
