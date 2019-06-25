# ---------------------------------------------------------------------------------------------------
# Information:

# This script combines figures about phase locking values (plv).

# ---------------------------------------------------------------------------------------------------

fplv3<-ggarrange(fplv1,fplv2,
                 labels=c("A","B"),
                 nrow=2,ncol=1,
                 common.legend=FALSE,
                 legend="bottom")

ggsave("graphs/plv/figure_plv.png",plot=fplv3,width=210,height=180,units="mm",dpi=300)
