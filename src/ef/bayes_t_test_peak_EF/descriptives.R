# ---------------------------------------------------------------------------------------------------
# Information:

# This script provides descriptive statistics for the peak EF values in the rTMS and the
# resting motor threshold simulations.

# ---------------------------------------------------------------------------------------------------

library(ProjectTemplate)
load.project()

## Absolute EF
ef_abs_rtms %>% group_by(intensity) %>% summarise(mean(peak),
                                                  median(peak))
ef_abs_rmt %>% group_by(intensity) %>% summarise(mean(peak),
                                                 median(peak))
# Mean peak values: low rTMS vs. 80 and 120% RMT
48.3/13.4
72.3/13.4


## Normal EF
ef_norm_rtms %>% group_by(intensity,type) %>% summarise(mean(peak),
                                                        median(peak))
ef_norm_rmt %>% group_by(intensity,type) %>% summarise(mean(peak),
                                                       median(peak))
# Mean peak values: low rTMS vs. 80 and 120% RMT
# inward
31.8/8.77
47.6/8.77
# outward
-30.0/-8.29
-44.9/-8.29
