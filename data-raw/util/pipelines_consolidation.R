pipelines_consolidation <- list(hca_offshore = dplyr::quo(sum(hca_offshore, na.rm = T)),
                                hca_onshore = dplyr::quo(sum(hca_onshore, na.rm = T)),
                                hca_total = dplyr::quo(sum(hca_total, na.rm = T)),
                                total_onshore = dplyr::quo(sum(total_onshore, na.rm = T)),
                                total_offshore = dplyr::quo(sum(total_offshore, na.rm = T)),
                                total_miles = dplyr::quo(sum(total_miles, na.rm = T)),
                                serious_incidents = dplyr::quo(sum(serious_incidents, na.rm = T)),
                                significant_incidents = dplyr::quo(sum(significant_incidents, na.rm = T))
                                )
