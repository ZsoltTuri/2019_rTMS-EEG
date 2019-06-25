# ---------------------------------------------------------------------------------------------------
# Information:

# This script creates figures about the normal component of peak EF values.
# Data derived from the 3 rTMS intensities.

# ---------------------------------------------------------------------------------------------------

library(ProjectTemplate)
load.project()

fnorm1<-ggplot(data=ef_norm_rtms,aes(intensity))+
  geom_bar(aes(x=intensity,y=peak,fill=interaction(intensity,type)),
           color="black",
           stat="summary",
           fun.y=mean)+
  stat_summary(data=ef_norm_rtms,
               aes(x=intensity,y=peak,fill=interaction(intensity,type)),
               fun.y=median,
               fun.ymin=function(z) {quantile(z,0.025)},
               fun.ymax=function(z) {quantile(z,0.975)},
               size=0.2,
               alpha=1)+
  geom_hline(yintercept=0,color="black")+
  scale_fill_manual(name="intensity",values=c(fparam[['c6']],   # pos HI
                                              fparam[['c5']],   # neg HI
                                              fparam[['c4']],   # pos LI
                                              fparam[['c1']],   # neg LI
                                              fparam[['c2']],   # pos MI
                                              fparam[['c3']]))+ # neg MI
  theme_bw()+
  theme(legend.position="none",
        panel.grid.major=element_blank(),panel.grid.minor=element_blank(),
        text=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],color="black",face="bold"),
        axis.title.y=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.title.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.y=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        plot.title=element_text(hjust=0.5,size=fparam[["fsize"]],face="plain",color="black"),
        strip.text.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        panel.border=element_rect(colour="black",fill=NA,size=0.75))+
  labs(x="rTMS intensity",y="EF [mV/mm]")+
  ggtitle("Prospective EF approach")+
  coord_cartesian(ylim=c(-60,60))
ggsave("graphs/peak_EF_magnitudes/norm1.svg",plot=fnorm1,width=70,height=80,units="mm",dpi=300)
