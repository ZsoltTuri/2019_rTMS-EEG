# ---------------------------------------------------------------------------------------------------
# Information:

# This script creates figure about the rTMS intensities (low, medium and high) and the
# corresponding maximum stimulator output values.

# ---------------------------------------------------------------------------------------------------

library(ProjectTemplate)
load.project()

mso_rTMS$intensity<-factor(mso_rTMS$intensity,levels=c("Low","Medium","High"))
mso_rTMS$pid<-as.factor(mso_rTMS$pid)
str(mso_rTMS)

fmso1<-ggplot(data=mso_rTMS,aes(x=intensity,y=perc))+
  geom_bar(mapping=aes(x=intensity,y=perc,fill=intensity),
           color="black",
           stat="summary",fun.y=mean,position="dodge")+
  stat_summary(fun.y=median,
               fun.ymin=function(z) {quantile(z,0.025)},
               fun.ymax=function(z) {quantile(z,0.975)},
               size=0.2,
               alpha=1,
               position=position_dodge(width=1))+
  scale_fill_manual(values=c(fparam[['c1']],   # pos HI
                             fparam[['c2']],   # pos LI
                             fparam[['c3']]))+ # pos MI
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
    labs(x="rTMS intenisity",y="MSO [%]")+
    ggtitle("EF estimation approach")+
    coord_cartesian(ylim=c(0,100))
  ggsave("graphs/mso/mso1.svg",plot=fmso1,width=70,height=80,units="mm",dpi=300)
