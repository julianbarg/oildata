#!/usr/bin/env Rscript
suppressMessages(library(here))

all_datasets <- c("pipelines_2004", "pipelines_2010", "incidents_1986",
                  "incidents_2002", "incidents_2010")

# How many miles of pipelines should an operator have at least to be considered.
miles_cutoff <- 0

# How are datasets aggregated?
# p_04 pre-aggregation
aggregate_p_04 <-
  list(take_first_cols = c("name", "state"),
       sum_na_rm_cols =
         c("hca_offshore", "hca_onshore", "hca_total", "miles_onshore",
           "miles_offshore", "miles_total", "volume_crude_total",
           "volume_hvl_total", "volume_rpp_total", "volume_other_total"))

aggregate_incidents <-
  # For this first group of variables, we just take a sum (with na.rm = T)
  # and insert 0 if no applicable incidents found.
  list(sum_cols = c(incidents_volume = "volume",
                    recovered = "recovered",
                    net_loss_volume = "net_loss",
                    incidents_cost = "cost_1984"),
  # For this second group of variables, we filter on significant incidents first.
       sum_cols_sign = c(significant_incidents = "significant",
                         significant_incidents_cost = "cost_1984",
                         significant_incidents_volume = "volume"),
  # For this third group of variables, we filter on serious incidents first.
       sum_cols_serious = c(serious_incidents = "serious"))

df_ma <- function(group_name, members, start_year = NA, end_year = NA,
                  state = NA){
  data.frame(group_name = group_name,
             members = members,
             start_year = start_year,
             end_year = end_year,
             state = state)
}

groups <-
  rbind(df_ma("Teppco (Group)", c("30829", "32209", "3445")),
        df_ma("ONEOK (Group)", c("32109", "30629")),
        df_ma("Phillips 66 (Group)", c("15485", "31684")),
        df_ma("Magellan (Group)", c("22610", "12105", "31579", "39504")),
        df_ma("Buckeye (Group)", c("1845",  "31371")),
        df_ma("Sunoco (Group)",
                 c("18718", "12470", "39205", "39596", "7063")),
        # Other members of Energy Transfer Partners are found in M_As data file.
        df_ma("Energy Transfer Partners (Group)", c("32099")),
        df_ma("Kinder Morgan (Group)",
                 c("19237", "2190",  "4472",  "15674", "18092", "19585",
                   "26125", "31555", "31957", "32114", "32258", "32541",
                   "32619", "32678", "39023", "39440", "39518")),
        df_ma("NuStar (Group)", c("26094", "31454", "39348")),
        df_ma("Enbridge (Group)",
                 c("11169", "31448", "31720", "31947", "32080", "32502")),
        df_ma("Marathon (Group)",
                 c("32147", "22830", "26026", "31574", "31871", "39347", "12127")),
        df_ma("Tesoro (Group)",
                 c("31570", "31583", "38933", "39013", "39029")),
        df_ma("ExxonMobil (Group)",
                 c("4906",  "12624", "12628", "12634", "30005")),
        df_ma("Chevron (Group)", c("2731",  "2339")),
        df_ma("Plains Pipeline (Group)", c("300",   "31666", "26085")),
        df_ma("BP (Group)", c("31189", "18386", "31610", "1466",  "31549")),
        df_ma("Amoco (Group)", c("395",   "3466")),
        df_ma("Citgo (Group)", c("30755", "2387",  "31023")),
        df_ma("HollyFrontier (Group)",
                 c("32011", "32493", "5656",  "13161")),
        df_ma("Gensis (Group)", c("31045", "32407")),
        df_ma("Williams Field Services (Group)",
                 c("30826", "994",   "32614")),
        df_ma("Pacific (Group)", c("31325", "31695", "31885")),
        df_ma("Valero (Group)",
                 c("4430",  "39105", "32679", "31415", "32032")),
        df_ma("CHS (Group)",
                 c("2170",  "9175",  "14391", "26065", "26086", "32283")),
        df_ma("Rose Rock (Group)", c("31476", "32288")),
        df_ma("BKEP (Group)", c("32551", "32481")),
        df_ma("Targa (Group)", c("32296", "39823", "31977")),
        df_ma("Dow (Group)", c("3527",  "2162",  "3535",  "30959")),
        df_ma("Boardwalk (Group)", c("39138")),
        df_ma("Enlink (Group)", c("32005", "32107")),
        df_ma("Hunt (Group)", c("26048", "7660" )),
        df_ma("Eastman Chemical (Group)", c("31166", "26103")),
        df_ma("Delek (Group)", c("11551", "15851", "26061", "26136")),
        df_ma("Suncor (Group)", c("15786", "31822")),
        df_ma("Crestwood (Group)", c("39083", "39368")),
        df_ma("Torrance (Group)", c("39534", "26120", "31167", "39535")),
        df_ma("LDH Energy (Group)", c("32035", "31673", "32246")),
        df_ma("Glass Mountain (Group)", c("39080", "39774"))
  )

m_as <-
  rbind(df_ma("Enterprise Products (Group)", "Teppco (Group)", 2010, NA),
        df_ma("Sunoco (Group)", c("32683", "22442"), 2011, NA),
        df_ma("Energy Transfer Partners (Group)", "Sunoco (Group)", 2013, NA),
        df_ma("NuStar (Group)", "10012", 2007, NA),
        df_ma("NuStar (Group)", "31454", 2006, NA),
        df_ma("Enbridge (Group)", "15774", NA, 2013),
        df_ma("Enbridge (Group)", "31720", 2012, NA),
        df_ma("Enbridge (Group)", "30781", 2006, NA),
        df_ma("BP (Group)", "30781", 2001, 2006),
        df_ma("Marathon (Group)", "15774", 2013, NA),
        df_ma("Chevron (Group)", "31556", 2002, NA),
        df_ma("Chevron (Group)", "31554", 2002, 2014),
        df_ma("Valero (Group)", "31742", 2005, NA),
        df_ma("Dynegy (Group)", c("30626", "22175"), NA, 2005),
        df_ma("Targa (Group)", c("30626", "22175"), 2005, NA),
        df_ma("Boardwalk (Group)", "31554", 2014, NA),
        df_ma("Energy Transfer Partners (Group)", "LDH Energy (Group)", 2011, NA)
)

aggregate_operators <- list(
  sum_na_rm_cols =
    c("incidents_volume", "recovered", "net_loss_volume", "incidents_cost",
      "significant_incidents", "significant_incidents_cost",
      "significant_incidents_volume", "serious_incidents", "incidents",
      "hca", "miles", "volume_crude", "volume_hvl", "volume_rpp",
      "volume_other", "estimate_volume_crude", "estimate_volume_hvl",
      "estimate_volume_rpp", "estimate_volume_other", "volume_all",
      "estimate_volume_all", "estimate_volume_specific", "volume_specific"),
  take_first_cols  = c("state", "ma_year")
  )

parameters <- list(all_datasets = all_datasets,
                   miles_cutoff = miles_cutoff,
                   aggregate_p_04 = aggregate_p_04,
                   aggregate_incidents = aggregate_incidents,
                   m_as = rbind(groups, m_as),
                   aggregate_operators = aggregate_operators)

saveRDS(parameters, here("data-raw", ".temp", "parameters.RDS"))
print("Made parameters available for all steps.")
