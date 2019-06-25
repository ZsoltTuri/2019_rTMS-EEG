# ---------------------------------------------------------------------------------------------------
# Information:

# This script combines figures about the peak absolute EF values.

# ---------------------------------------------------------------------------------------------------

fabs3<-ggarrange(fabs1,fabs2,
                 nrow=1,ncol=2)
ggsave("graphs/peak_EF_magnitudes/figure_abs.svg",plot=fabs3,width=130,height=80,units="mm",dpi=300)
