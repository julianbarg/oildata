#' Merged dataset of all incidents.
#'
#' @format A data frame with 53940 rows and 60 variables:
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
# TODO: add the first 5 most frequent terms.
#'   \item{topic_1}{Gammas (topic weights) for topic 1 in the narrative which describes the management of incident reports.}
#'   \item{topic_2}{Gammas (topic weights) for topic 2 which describes the management of spills.}
#'   \item{topic_3}{Gammas (topic weights) for topic 3 which contains terms related to  contractors and excavation.}
#'   \item{topic_4}{Gammas (topic weights) for topic 4 which is related to storms, water and related damages.}
#'   \item{topic_5}{Gammas (topic weights) for topic 5 which is related to the remote operation of pipelines from control centers.}
#'   \item{topic_6}{Gammas (topic weights) for topic 6 which is related to service and repair of pipelines.}
#'   \item{topic_7}{Gammas (topic weights) for topic 7 which is related to pumps and their components.}
#'   \item{topic_8}{Gammas (topic weights) for topic 8 which describes procedures.}
#'   \item{topic_9}{Gammas (topic weights) for topic 9 which contains terms relating to the different commodities being transported.}
#'   \item{topic_10}{Gammas (topic weights) for topic 10 which contains terms related to the remote monitoring of pipelines.}
#'   \item{topic_11}{Gammas (topic weights) for topic 11 which contains terms such as flow, pressure, and relief.}
#'   \item{topic_12}{Gammas (topic weights) for topic 12 which describes corrosion-related damages.}
#'   \item{topic_13}{Gammas (topic weights) for topic 13 which includes gaskets and related terms.}
#'   \item{topic_14}{Gammas (topic weights) for topic 14 which is related to the reporting of spills.}
#'   \item{topic_15}{Gammas (topic weights) for topic 15 which describes the personnels onsite response.}
#'   \item{topic_16}{Gammas (topic weights) for topic 16 which includes terms related to valves.}
#'   \item{topic_17}{Gammas (topic weights) for topic 17 which contains terms related to a leak and cleanup.}
#'   \item{topic_18}{Gammas (topic weights) for topic 18 which describes the contamination of the environment that resulted from a spill.}
#'   \item{topic_19}{Gammas (topic weights) for topic 19 which is related to the release of oil.}
#'   \item{topic_20}{Gammas (topic weights) for topic 20 which contains words related to a release of crude oil.}
#'   \item{topic_21}{Gammas (topic weights) for topic 21 which is related to fire and emergencies.}
#'   \item{topic_22}{Gammas (topic weights) for topic 22 which is related to storage tanks.}
#'   \item{topic_23}{Gammas (topic weights) for topic 23 which describes cracks and other kinds of failure.}
#' }
"incidents"
