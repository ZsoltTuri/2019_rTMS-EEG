# ---------------------------------------------------------------------------------------------------
# Information:

# This script creates figures about the normal component of peak EF values.
# Data derived from the 5 resting motor threshold (RMT) intensities.

# ---------------------------------------------------------------------------------------------------

library(ProjectTemplate)
load.project()

pos<-ef_norm_rmt %>% filter(type=="pos_peak") %>% select(pid,intensity,peak) 
neg<-ef_norm_rmt %>% filter(type=="neg_peak") %>%select(pid,intensity,peak) 
  
fnorm2<-ggplot(data=NULL,aes(x=intensity,y=peak,fill=intensity))+
  geom_bar(data=pos,
           mapping=aes(x=intensity,y=peak,fill=intensity),
           color="black",
           stat="summary",
           fun.y=mean)+
  stat_summary(data=pos,
               mapping=aes(x=intensity,y=peak,fill=intensity),
               fun.y=median,
               fun.ymin=function(z) {quantile(z,0.025)},
               fun.ymax=function(z) {quantile(z,0.975)},
               size=0.2,
               alpha=1)+
  geom_bar(data=neg,
           mapping=aes(x=intensity,y=peak,fill=intensity),
           color="black",
           alpha=0.25,
           stat="summary",
           fun.y=mean)+
  stat_summary(data=neg,
               mapping=aes(x=intensity,y=peak,fill=intensity),
               fun.y=median,
               fun.ymin=function(z) {quantile(z,0.025)},
               fun.ymax=function(z) {quantile(z,0.975)},
               size=0.2,
               alpha=1)+
  geom_hline(yintercept=0,color="black")+
  scale_fill_viridis_d(option="viridis",direction=-1)+
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
  labs(x="RMT [%]",y="EF [mV/mm]")+
  ggtitle("Near threshold approach")+
  coord_cartesian(ylim=c(-60,60))
ggsave("graphs/peak_EF_magnitudes/norm2.svg",plot=fnorm2,width=110,height=80,units="mm",dpi=300)
rm(pos,neg)
