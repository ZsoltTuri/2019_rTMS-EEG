# ---------------------------------------------------------------------------------------------------
# Information:

# This script performs Bayesian t-test between peak EF values derived from the prospective EF estimation
# approach and the current, resting motor threshold-based approach.

# ---------------------------------------------------------------------------------------------------

library(ProjectTemplate)
load.project()

# Absolute EF -----------------------------------------------------------------------------------------
# Low rTMS vs. 80% RMT
bayes<-list()
bayes[["a_low_80%"]]=ttestBF(x=ef_abs_rtms$peak[ef_abs_rtms$intensity=="Low"],
                             y=ef_abs_rmt$peak[ef_abs_rmt$intensity=="80"], 
                             paired=TRUE,posterior=TRUE,iterations=1000)
plot(bayes[["a_low_80%"]][,"mu"])
summary(bayes[["a_low_80%"]])
# Low rTMS vs. 120% RMT
bayes[["a_low_120%"]]=ttestBF(x=ef_abs_rtms$peak[ef_abs_rtms$intensity=="Low"],
                              y=ef_abs_rmt$peak[ef_abs_rmt$intensity=="120"], 
                              paired=TRUE,posterior=TRUE,iterations=1000)
plot(bayes[["a_low_120%"]][,"mu"])
summary(bayes[["a_low_120%"]])


## Normal component of the EF -------------------------------------------------------------------------

# Inward component
# Low rTMS vs. 80% RMT
bayes[["n_inv_low_80%"]]=ttestBF(x=ef_norm_rtms$peak[ef_norm_rtms$intensity=="Low" & ef_norm_rtms$type=="pos_peak"],
                                 y=ef_norm_rmt$peak[ef_norm_rmt$intensity=="80" & ef_norm_rmt$type=="pos_peak"], 
                                 paired=TRUE,posterior=TRUE,iterations=1000)
plot(bayes[["n_inv_low_80%"]][,"mu"])
summary(bayes[["n_inv_low_80%"]])
# Low rTMS vs. 120% RMT
bayes[["n_inv_low_120%"]]=ttestBF(x=ef_norm_rtms$peak[ef_norm_rtms$intensity=="Low" & ef_norm_rtms$type=="pos_peak"],
                                  y=ef_norm_rmt$peak[ef_norm_rmt$intensity=="120" & ef_norm_rmt$type=="pos_peak"], 
                                  paired=TRUE,posterior=TRUE,iterations=1000)
plot(bayes[["n_inv_low_120%"]][,"mu"])
summary(bayes[["n_inv_low_120%"]])

# Outward component
# Low rTMS vs. 80% RMT
bayes[["n_out_low_80%"]]=ttestBF(x=ef_norm_rtms$peak[ef_norm_rtms$intensity=="Low" & ef_norm_rtms$type=="neg_peak"],
                                 y=ef_norm_rmt$peak[ef_norm_rmt$intensity=="80" & ef_norm_rmt$type=="neg_peak"], 
                                 paired=TRUE,posterior=TRUE,iterations=1000)
plot(bayes[["n_out_low_80%"]][,"mu"])
summary(bayes[["n_out_low_80%"]])

bayes[["n_out_low_120%"]]=ttestBF(x=ef_norm_rtms$peak[ef_norm_rtms$intensity=="Low" & ef_norm_rtms$type=="neg_peak"],
                                  y=ef_norm_rmt$peak[ef_norm_rmt$intensity=="120" & ef_norm_rmt$type=="neg_peak"], 
                                  paired=TRUE,posterior=TRUE,iterations=1000)
plot(bayes[["n_out_low_120%"]][,"mu"])
summary(bayes[["n_out_low_120%"]])

