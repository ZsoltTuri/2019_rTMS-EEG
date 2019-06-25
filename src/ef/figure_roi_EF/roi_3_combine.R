# ---------------------------------------------------------------------------------------------------
# Information:

# This script combines figures about EF magnitudes in region of interests (ROIs).

# ---------------------------------------------------------------------------------------------------

froi3<-ggarrange(froi1,froi2,
                 labels=c("A","B"),
                 nrow=2,ncol=1)
ggsave("graphs/roi_EF/figure_roi_EF.svg",plot=froi3,width=210,height=200,units="mm",dpi=300)
