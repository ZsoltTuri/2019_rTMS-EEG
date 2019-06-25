# ---------------------------------------------------------------------------------------------------
# Information:

# This script combines figures about the normal component of peak EF values.

# ---------------------------------------------------------------------------------------------------

fnorm3<-ggarrange(fnorm1,fnorm2,
                  nrow=1,ncol=2)
ggsave("graphs/peak_EF_magnitudes/figure_normal.svg",plot=fnorm3,width=130,height=80,units="mm",dpi=300)
