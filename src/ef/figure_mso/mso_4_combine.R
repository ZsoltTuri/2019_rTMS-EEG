# ---------------------------------------------------------------------------------------------------
# Information:

# This script combines figures about RMT and rTMS intensities expressed in MSO and RMT.

# ---------------------------------------------------------------------------------------------------

fmso4<-ggarrange(fmso1,fmso2,fmso3,
                  labels=c("A","B","C"),
                  nrow=1,ncol=3)
ggsave("graphs/mso/figure_mso.svg",plot=fmso4,width=240,height=80,units="mm",dpi=300)
