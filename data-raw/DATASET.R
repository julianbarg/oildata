library(devtools)

# PHMSA Datsets --------------------------

system("data-raw/util/process_phmsa_data.R")

# Company groups -------------------------

source("data-raw/util/groups.R")

# M & As ---------------------------------

source("data-raw/util/m_as.R")

# M&As and groups ------------------------

groups$type <- "group"
m_as$type <- "m_a"
groups$start_year <- NA
groups$end_year <- NA

m_as <- rbind(m_as, groups)
m_as$type <- as.factor(m_as$type)

use_data(m_as, overwrite = TRUE)
