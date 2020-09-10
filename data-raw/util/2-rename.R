#!/usr/bin/env Rscript
library(arrow)
library(dplyr)
library(readr)

pipelines_2004 <- read_feather("data-raw/.temp/data/pipelines_2004_raw.feather")
pipelines_2010 <- read_feather("data-raw/.temp/data/pipelines_2010_raw.feather")
incidents_1986 <- read_feather("data-raw/.temp/data/incidents_1986_raw.feather")
incidents_2002 <- read_feather("data-raw/.temp/data/incidents_2002_raw.feather")
incidents_2010 <- read_feather("data-raw/.temp/data/incidents_2010_raw.feather")

pipelines_2004 <- pipelines_2004 %>%
  rename(ID = OPERATOR_ID,
         name = NAME,
         year = YR,
         state = HQSTATE,
         commodity = SYSTEM_TYPE,
         hca_onshore = HCAONM,
         hca_offshore = HCAOFFM,
         hca_total = HCAMT,
         miles_total = DINSTMT,
         volume_crude_total = VTM_1,
         volume_hvl_total = VTM_2,
         volume_rpp_total = VTM_4,
         volume_other_total = VTM_5)

pipelines_2010 <- pipelines_2010 %>%
  rename(ID = OPERATOR_ID,
         name = PARTA2NAMEOFCOMP,
         year = REPORT_YEAR,
         state = PARTA4STATE,
         commodity = PARTA5COMMODITY,
         hca_onshore = PARTBHCAONSHORE,
         hca_offshore = PARTBHCAOFFSHORE,
         hca_total = PARTBHCATOTAL,
         miles_onshore = PARTDONTOTAL,
         miles_offshore = PARTDOFFTOTAL,
         miles_total = PARTDTOTALMILES,
         volume_co2_offshore = PARTCOFFCO2,
         volume_crude_offshore = PARTCOFFCRUDE,
         volume_fge_offshore = PARTCOFFETHANOL,
         volume_hvl_offshore = PARTCOFFHVL,
         volume_rpp_offshore = PARTCOFFRPP,
         volume_co2_onshore = PARTCONCO2,
         volume_crude_onshore = PARTCONCRUDE,
         volume_fge_onshore = PARTCONETHANOL,
         volume_hvl_onshore = PARTCONHVL,
         volume_rpp_onshore = PARTCONRPP)

incidents_1986 <- incidents_1986 %>%
  rename(incident_ID = RPTID,
         significant = SIGNIFICANT,
         serious = SERIOUS,
         ID = OPID,
         name = NAME,
         state = ACSTATE,
         on_offshore = OFFSHORE,
         system = CSYS,
         item = ORGLK,
         installation_year = ITMYR,
         cause = CAUSE, # Not using MAP_CAUSE, because that would lose the distinction between equipment and weld after 2002
         subcause = MAP_SUBCAUSE,
         cost = TOTAL_COST,
         fatalities = NFAT,
         injuries = NINJ,
         cost_1984 = TOTAL_COST_IN84,
         commodity = COMM,
         volume = LOSS,
         fire = FIRE,
         explosion = EXP,
         recovered = RECOV,
         narrative = NARRATIVE)

incidents_2002 <- incidents_2002 %>%
  rename(incident_ID = RPTID,
         significant = SIGNIFICANT,
         serious = SERIOUS,
         report_type = REPORT_TYPE,
         ID = OPERATOR_ID,
         name = NAME,
         year = IYEAR,
         lat = LATITUDE,
         long = LONGITUDE,
         cost = TOTAL_COST,
         commodity = CLASS_TEXT,
         installation_year = PRTYR,
         fatalities = FATAL,
         injuries = INJURE,
         fire = IGNITE,
         explosion = EXPLO,
         water_contamination = WATER,
         cause = CAUSE, # Not using MAP_CAUSE, because that would lose the distinction between equipment and weld after 2002
         subcause = MAP_SUBCAUSE,
         on_offshore = OFFSHORE,
         system = SYSPRT_TEXT,
         item = FAIL_OC_TEXT,
         manufacture_year = MANYR,
         installation_year = PRTYR,
         water_contamination = WATER,
         surface_water_remediation = RSURFACE,
         groundwater_remediation = RGROUND,
         soil_remediation = RSOIL,
         vegetation_remediation = RVEG,
         wildlife_remediation = RWILD,
         narrative = NARRATIVE,
         cost_1984 = TOTAL_COST_IN84)

incidents_2010 <- incidents_2010  %>%
  rename(incident_ID = REPORT_NUMBER,
         significant = SIGNIFICANT,
         serious = SERIOUS,
         ipe = IPE,
         integrity_assessment_target = IA_IPE,
         operations_maintenance_target = OM_IPE,
         ID = OPERATOR_ID,
         name = NAME,
         year = IYEAR,
         lat = LOCATION_LATITUDE,
         long = LOCATION_LONGITUDE,
         commodity = COMMODITY_RELEASED_TYPE,
         volume = UNINTENTIONAL_RELEASE_BBLS,
         recovered = RECOVERED_BBLS,
         net_loss = NET_LOSS_BBLS,
         fatalities = FATAL,
         injuries = INJURE,
         fire = IGNITE_IND,
         explosion = EXPLODE_IND,
         on_offshore = ON_OFF_SHORE,
         system = SYSTEM_PART_INVOLVED,
         item = ITEM_INVOLVED,
         installation_year = INSTALLATION_YEAR,
         surface_water_remediation = SURFACE_WATER_REMED_IND,
         groundwater_remediation = GROUNDWATER_REMED_IND,
         soil_remediation = SOIL_REMED_IND,
         vegetation_remediation = VEGETATION_REMED_IND,
         wildlife_remediation = WILDLIFE_REMED_IND,
         water_contamination = WATER_CONTAM_IND,
         cost = TOTAL_COST,
         excavation_damage_type = PARTY_TYPE,
         cause = CAUSE, # Not using MAP_CAUSE, because that would lose the distinction between equipment and weld after 2002
         subcause = MAP_SUBCAUSE,
         narrative = NARRATIVE,
         cost_1984 = TOTAL_COST_IN84)

write_rds(pipelines_2004, "data-raw/.temp/data/pipelines_2004_renamed.rds")
write_rds(pipelines_2010, "data-raw/.temp/data/pipelines_2010_renamed.rds")
write_rds(incidents_1986, "data-raw/.temp/data/incidents_1986_renamed.rds")
write_rds(incidents_2002, "data-raw/.temp/data/incidents_2002_renamed.rds")
write_rds(incidents_2010, "data-raw/.temp/data/incidents_2010_renamed.rds")
