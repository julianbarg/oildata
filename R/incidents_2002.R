#' Annual data on oil spills in the US from 2004 to 2010
#'
#' Distribution, Transmission & Gathering, LNG, and Liquid Accident and Incident Data.
#'
#' Title 49 of the Code of Federal Regulations (49 CFR Parts 191, 195) requires
#' pipeline operators to submit incident reports within 30 days of a pipeline
#' incident or accident. The CFR defines accidents and incidents, as well as
#' criteria for submitting reports to the Office of Pipeline Safety. The
#' following kinds of information are collected:
#' * Key report information
#' * In-depth location information
#' * Facility information
#' * Operating information
#' * Drug and Alcohol information
#' * Cause of the accident/incident
#' Specific information includes the time and location of the incident(s),
#' number of any injuries and/ or fatalities, commodity spilled/gas released,
#' causes of failure and evacuation procedures. The reports are used for
#' identifying long- and short-term trends at the national, state and
#' operator-specific levels. The frequency, causes, and consequences of the
#' incidents provide insight into the safety metrics currently used by PHMSA,
#' state partners, and other pipeline safety stakeholders, including the
#' pipeline industry and general public. PHMSA also uses the data for inspection
#' planning and risk assessment.
#'
#' @source United States Department of Transportation (DOT) Pipeline and
#'   Hazardous Materials Safety Administration (PHMSA).
#'   \url{https://www.phmsa.dot.gov/data-and-statistics/pipeline/distribution-transmission-gathering-lng-and-liquid-accident-and-incident-data}
#'    (right side bar).
#' @format A data frame with columns:
#' \describe{
#'  \item{year}{Year of the incident report.}
#'  \item{ID}{Unique operator ID.}
#'  \item{RPTID}{}
#'  \item{OWNER_OPERATOR_ID}{}
#'  \item{name}{Name of the pipelines operator at the time of the incident report.}
#'  \item{OPSTREET}{}
#'  \item{OPCITY}{}
#'  \item{OPCOUNTY}{}
#'  \item{OPSTATE}{}
#'  \item{OPZIP}{}
#'  \item{IHOUR}{}
#'  \item{IDATE}{}
#'  \item{LATITUDE}{}
#'  \item{LONGITUDE}{}
#'  \item{ACCITY}{}
#'  \item{ACCOUNTY}{}
#'  \item{ACSTATE}{}
#'  \item{ACZIP}{}
#'  \item{MPVST}{}
#'  \item{SURNO}{}
#'  \item{TELRN}{}
#'  \item{TELDT}{}
#'  \item{PPPRP}{}
#'  \item{EMRPRP}{}
#'  \item{ENVPRP}{}
#'  \item{OPCPRP}{}
#'  \item{OPCPRPO}{}
#'  \item{PRODPRP}{}
#'  \item{OPPRP}{}
#'  \item{OOPPRP}{}
#'  \item{OOPPRPO}{}
#'  \item{PRPTY}{}
#'  \item{SPILLED}{}
#'  \item{COMM}{}
#'  \item{CLASS}{}
#'  \item{commodity}{The type of commodity being spilled (Crude, HVL, etc.).}
#'  \item{SPUNIT}{}
#'  \item{SPUNIT_TXT}{}
#'  \item{LOSS}{}
#'  \item{RECOV}{}
#'  \item{GEN_CAUSE}{}
#'  \item{GEN_CAUSE_TXT}{}
#'  \item{LINE_SEG}{}
#'  \item{IFED}{}
#'  \item{INTER}{}
#'  \item{OFFSHORE}{}
#'  \item{OFFAREA}{}
#'  \item{BNUMB}{}
#'  \item{OFFST}{}
#'  \item{OCS}{}
#'  \item{OPPROP}{}
#'  \item{PIPEROW}{}
#'  \item{HCA}{}
#'  \item{HCADESC}{}
#'  \item{SYSPRT}{}
#'  \item{SYSPRT_TXT}{}
#'  \item{SYSPRTO}{}
#'  \item{FAIL_OC}{}
#'  \item{FAIL_OC_TXT}{}
#'  \item{FAIL_OCO}{}
#'  \item{PRTYR}{}
#'  \item{INC_PRS}{}
#'  \item{MOP}{}
#'  \item{OPRS}{}
#'  \item{LRTYPE}{}
#'  \item{LRTYPE_TXT}{}
#'  \item{LRTYPEO}{}
#'  \item{LEAK}{}
#'  \item{LEAK_TXT}{}
#'  \item{PUNC_DIAM}{}
#'  \item{RUPTURE}{}
#'  \item{RUPTURE_TXT}{}
#'  \item{RUPLN}{}
#'  \item{PROPLN}{}
#'  \item{UBLKVM}{}
#'  \item{UBLKVA}{}
#'  \item{UBLKVR}{}
#'  \item{UBLKVC}{}
#'  \item{DBLKVM}{}
#'  \item{DBLKVA}{}
#'  \item{DBLKVR}{}
#'  \item{DBLKVC}{}
#'  \item{SEGISO}{}
#'  \item{VLVDIST}{}
#'  \item{SEGCONF}{}
#'  \item{INLINE}{}
#'  \item{INLINE_TXT}{}
#'  \item{DRHRMF}{}
#'  \item{DRHRMFY}{}
#'  \item{DRLRMF}{}
#'  \item{DRLRMFY}{}
#'  \item{DRUT}{}
#'  \item{DRUTY}{}
#'  \item{DRGEO}{}
#'  \item{DRGEOY}{}
#'  \item{DRCAL}{}
#'  \item{DRCALY}{}
#'  \item{DRCRK}{}
#'  \item{DRCRKY}{}
#'  \item{DRHARD}{}
#'  \item{DRHARDY}{}
#'  \item{DROTH}{}
#'  \item{DROTHY}{}
#'  \item{NPS}{}
#'  \item{WALLTHK}{}
#'  \item{SPEC}{}
#'  \item{SMYS}{}
#'  \item{SEAM}{}
#'  \item{VALVE}{}
#'  \item{MANU}{}
#'  \item{MANYR}{}
#'  \item{LOCLK }{}
#'  \item{LOCLK_TXT}{}
#'  \item{LOCLKO}{}
#'  \item{DEPTH_COV}{}
#'  \item{FATAL}{}
#'  \item{EFAT}{}
#'  \item{NFAT}{}
#'  \item{GPFAT }{}
#'  \item{INJURE}{}
#'  \item{EINJ}{}
#'  \item{NINJ}{}
#'  \item{GPINJ}{}
#'  \item{SHUTDOWN}{}
#'  \item{SHUTDAY}{}
#'  \item{SHUTHR }{}
#'  \item{SHUTMIN}{}
#'  \item{IGNITE}{}
#'  \item{EXPLO}{}
#'  \item{EVAC}{}
#'  \item{EVACNO}{}
#'  \item{EVAC_REASON}{}
#'  \item{EVAC_REASON_TEXT }{}
#'  \item{STHH}{}
#'  \item{STMN}{}
#'  \item{FISH}{}
#'  \item{BIRDS}{}
#'  \item{TERRESTRIAL}{}
#'  \item{SOIL}{}
#'  \item{SOIL_YRD }{}
#'  \item{IMPACT}{}
#'  \item{REMEDIAL}{}
#'  \item{RSURFACE}{}
#'  \item{RGROUND}{}
#'  \item{RSOIL}{}
#'  \item{RVEG}{}
#'  \item{RWILD }{}
#'  \item{WATER}{}
#'  \item{AMT_IN_WATER}{}
#'  \item{OCEAN}{}
#'  \item{SURFACE}{}
#'  \item{GROUNDW}{}
#'  \item{DRINK}{}
#'  \item{DRINKSRC }{}
#'  \item{DRINKSRC_TXT}{}
#'  \item{COMP_BASED}{}
#'  \item{DETECTED}{}
#'  \item{DETECTED_TXT}{}
#'  \item{DETECTEDO}{}
#'  \item{DURLEAK_DAY}{}
#'  \item{DURLEAK_HR }{}
#'  \item{CAUSE}{}
#'  \item{CAUSE_TXT}{}
#'  \item{PIPE_COAT}{}
#'  \item{PIPE_COAT_TXT}{}
#'  \item{VIS_EXAM}{}
#'  \item{VIS_EXAM_TXT}{}
#'  \item{VIS_EXAMO }{}
#'  \item{COR_CAUSE}{}
#'  \item{COR_CAUSE_TXT}{}
#'  \item{COR_CAUSEO}{}
#'  \item{PROT}{}
#'  \item{CPYR}{}
#'  \item{PREV_DAM}{}
#'  \item{PREV_DAM_YR }{}
#'  \item{PREV_DAM_MO}{}
#'  \item{PREV_DAM_UK}{}
#'  \item{EARTH_MOVE}{}
#'  \item{EARTH_MOVE_TXT}{}
#'  \item{EARTH_MOVEO}{}
#'  \item{FLOODS}{}
#'  \item{FLOODS_TXT }{}
#'  \item{FLOODSO}{}
#'  \item{TEMPER}{}
#'  \item{TEMPER_TXT}{}
#'  \item{TEMPERO}{}
#'  \item{THIRD_PARTY_GRP}{}
#'  \item{THIRD_PARTY_GRP_TXT}{}
#'  \item{THIRD_PARTY_TYPE }{}
#'  \item{THIRD_PARTY_TYPE_TXT}{}
#'  \item{THIRD_PARTY_TYPEO}{}
#'  \item{EXCAV_TYPE}{}
#'  \item{EXCAV_TYPE_TXT}{}
#'  \item{EXCAV_ON}{}
#'  \item{EXCAV_LAST_CONTACT}{}
#'  \item{NOTIF }{}
#'  \item{NOTIF_DATE}{}
#'  \item{NOTIF_RCVD_TXT}{}
#'  \item{MARKED}{}
#'  \item{TEMP_MARK}{}
#'  \item{TEMP_MARK_TXT}{}
#'  \item{PERM_MARK}{}
#'  \item{ACC_MARK }{}
#'  \item{ACC_MARK_TXT}{}
#'  \item{MKD_IN_TIME}{}
#'  \item{FIRE_EXPLO}{}
#'  \item{FIRE_EXPLO_TXT}{}
#'  \item{PIPE_BODY}{}
#'  \item{PIPE_BODY_TXT}{}
#'  \item{PIPE_BODYO }{}
#'  \item{COMPONENT}{}
#'  \item{COMPONENT_TXT}{}
#'  \item{COMPONENTO}{}
#'  \item{JOINT}{}
#'  \item{JOINT_TXT}{}
#'  \item{JOINTO}{}
#'  \item{BUTT }{}
#'  \item{BUTT_TXT}{}
#'  \item{BUTTO}{}
#'  \item{FILLET}{}
#'  \item{FILLET_TXT}{}
#'  \item{FILLETO}{}
#'  \item{PIPE_SEAM}{}
#'  \item{PIPE_SEAM_TXT }{}
#'  \item{PIPE_SEAMO}{}
#'  \item{FAIL_TYPE}{}
#'  \item{FAIL_TYPE_TXT}{}
#'  \item{CONS_DEF}{}
#'  \item{CONS_DEF_TXT}{}
#'  \item{PIPE_DAMAGE}{}
#'  \item{PRS_TEST }{}
#'  \item{TEST_DATE}{}
#'  \item{TEST_MED}{}
#'  \item{TEST_MED_TXT}{}
#'  \item{TEST_MEDO}{}
#'  \item{TEST_TP}{}
#'  \item{TEST_PRS}{}
#'  \item{MALFUNC }{}
#'  \item{MALFUNC_TXT}{}
#'  \item{MALFUNCO}{}
#'  \item{THREADS}{}
#'  \item{THREADS_TXT}{}
#'  \item{THREADSO}{}
#'  \item{SEAL}{}
#'  \item{SEAL_TXT }{}
#'  \item{SEALO}{}
#'  \item{IO_TYPE}{}
#'  \item{IO_TYPE_TXT}{}
#'  \item{IO_TYPEO}{}
#'  \item{IO_DRUG}{}
#'  \item{IO_ALCO}{}
#'  \item{MISC }{}
#'  \item{UNKNOWN}{}
#'  \item{UNKNOWN_TXT}{}
#'  \item{PNAME}{}
#'  \item{PTEL}{}
#'  \item{PEMAIL}{}
#'  \item{PFAX}{}
#'  \item{narrative}{Written description of the incident.}
#' }
#' @examples
#' \dontrun{
#'  incidents_2002
#' }
"incidents_2002"
