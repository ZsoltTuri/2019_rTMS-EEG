library(ProjectTemplate)
load.project()

a<-ggplot(data=plv)+
  facet_grid(cols=vars(intensity))+
  geom_rect(xmin=-2.5,xmax=0,ymin=fparam[["ymin"]],ymax=fparam[["ymax"]],fill="grey90",colour=NA)+
  geom_segment(aes(x=0,y=fparam[["ymin"]],xend=0,yend=fparam[["ymax"]]))+
  geom_segment(aes(x=-2.5,y=fparam[["ymin"]],xend=-2.5,yend=fparam[["ymax"]]),linetype='dashed')+
  geom_segment(aes(x=-2.22,y=fparam[["ymin"]],xend=-2.22,yend=fparam[["ymax"]]),linetype='dashed')+
  geom_segment(aes(x=-2.0,y=fparam[["ymin"]],xend=-2.0,yend=fparam[["ymax"]]),linetype='dashed')+
  geom_segment(aes(x=-1.82,y=fparam[["ymin"]],xend=-1.82,yend=fparam[["ymax"]]),linetype='dashed')+
  geom_segment(aes(x=-1.67,y=fparam[["ymin"]],xend=-1.67,yend=fparam[["ymax"]]),linetype='dashed')+
  stat_summary(mapping=aes(x=time,y=plv_all,colour=protocol),
               fun.y=mean,
               geom="line",
               size=1.5)+
  stat_summary(mapping=aes(x=time,y=plv_all,fill=protocol,colour=NA),
               fun.data=mean_cl_boot,fun.args=(c(conf.int=0.95,B=5000)),geom="ribbon",alpha=0.5)+ 
  scale_colour_manual(values=c("grey25","#bf0a30"))+
  scale_fill_manual(name="Protocols:",values=c("#bf0a30","grey25"),labels=c("Rhythmic","Arrhythmic"))+
  geom_text(x=-2.0,y=fparam[["ymax"]]+fparam[["adj"]],label="rTMS onset (8-12 Hz)",family="Arial",fontface="plain",size=fparam[["asize"]],color="black")+
  geom_text(x=0,y=fparam[["ymax"]]+fparam[["adj"]],label="rTMS offset",fontface="plain",size=fparam[["asize"]],color="black")+
  coord_cartesian(ylim=c(fparam[["ymin"]],fparam[["ymax"]]+fparam[["adj"]]))+
  labs(x="Time (s)",y="Phase locking value")+
  theme_bw()+
  theme(axis.text.x=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.y=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"),
        axis.title=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"),
        strip.text.x=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"),
        strip.text.y=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"),
        legend.position="bottom",legend.justification='center',legend.direction="horizontal",
        legend.background=element_rect(fill="white",size=0.4,linetype="solid",colour="black"),
        legend.title=element_text(color="black",size=fparam[["fsize"]]),
        legend.text=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"))+
  guides(color=FALSE)
ggsave("graphs/plv/plv_all_offset_locked.png",plot=a,width=240,height=100,units="mm",dpi=300)
