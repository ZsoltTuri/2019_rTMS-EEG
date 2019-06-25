# ---------------------------------------------------------------------------------------------------
# Information:

# This script creates figure about the relation of the resting motor threshold (80-120%) and the
# corresponding maximum stimulator output.

# ---------------------------------------------------------------------------------------------------

library(ProjectTemplate)
load.project()

mso_RMT$pid<-as.factor(mso_RMT$pid)
mso_RMT$intensity<-factor(mso_RMT$intensity,levels=c("80","90","100","110","120"))
str(mso_RMT)

fmso2<-ggplot(data=mso_RMT,aes(x=intensity,y=perc))+
  geom_bar(mapping=aes(x=intensity,y=perc,fill=intensity),
           color="black", 
           stat="summary",fun.y=mean,position="dodge")+
  stat_summary(fun.y=median,
               fun.ymin=function(z) {quantile(z,0.025)},
               fun.ymax=function(z) {quantile(z,0.975)},
               size=0.2,
               alpha=1,
               position=position_dodge(width=1))+
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
  labs(x="Resting motor threshold [%]",y="MSO [%]")+
  ggtitle("Near threshold approach")+
  coord_cartesian(ylim=c(0,100))
ggsave("graphs/mso/mso2.svg",plot=fmso2,width=110,height=80,units="mm",dpi=300)
