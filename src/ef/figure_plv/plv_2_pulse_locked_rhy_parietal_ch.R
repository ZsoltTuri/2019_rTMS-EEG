# ---------------------------------------------------------------------------------------------------
# Information:

# This script creates figures about phase locking values (plv) locked to each rTMS pulse.

# ---------------------------------------------------------------------------------------------------

library(ProjectTemplate)
load.project()

sub<-unique(iaf$pid)
intensity<-c("Low rTMS","Medium rTMS","High rTMS")
plv_locked<-list()

for (i in intensity){
  df<-NULL
  df<-as.data.frame(matrix(data=NA,nrow=length(unique(iaf$pid)),ncol=24))
  df[,1]<-unique(iaf$pid)
  colnames(df)<-c("pid","1","2","3","4","5","6","7","8","9","10","11","12","13",
                  "14","15","16","17","18","19","20","pre","post","intensity")
  for (p in 1:length(unique(iaf$pid))){
    t1<-NULL
    t2<-NULL
    t1<-plv %>% filter(intensity==i,pid==sub[p],protocol=="r")
    t2<-iaf %>% filter(pid==sub[p],intensity==i)
    df[p,2]<-t1 %>% filter(time>=t2$tms1,time<t2$tms2) %>% summarise(mean(plv_par)) %>% unname()
    df[p,3]<-t1 %>% filter(time>=t2$tms2,time<t2$tms3) %>% summarise(mean(plv_par)) %>% unname()
    df[p,4]<-t1 %>% filter(time>=t2$tms3,time<t2$tms4) %>% summarise(mean(plv_par)) %>% unname()
    df[p,5]<-t1 %>% filter(time>=t2$tms4,time<t2$tms5) %>% summarise(mean(plv_par)) %>% unname()
    df[p,6]<-t1 %>% filter(time>=t2$tms5,time<t2$tms6) %>% summarise(mean(plv_par)) %>% unname()
    df[p,7]<-t1 %>% filter(time>=t2$tms6,time<t2$tms7) %>% summarise(mean(plv_par)) %>% unname()
    df[p,8]<-t1 %>% filter(time>=t2$tms7,time<t2$tms8) %>% summarise(mean(plv_par)) %>% unname()
    df[p,9]<-t1 %>% filter(time>=t2$tms8,time<t2$tms9) %>% summarise(mean(plv_par)) %>% unname()
    df[p,10]<-t1 %>% filter(time>=t2$tms9,time<t2$tms10) %>% summarise(mean(plv_par)) %>% unname()
    df[p,11]<-t1 %>% filter(time>=t2$tms10,time<t2$tms11) %>% summarise(mean(plv_par)) %>% unname()
    df[p,12]<-t1 %>% filter(time>=t2$tms11,time<t2$tms12) %>% summarise(mean(plv_par)) %>% unname()
    df[p,13]<-t1 %>% filter(time>=t2$tms12,time<t2$tms13) %>% summarise(mean(plv_par)) %>% unname()
    df[p,14]<-t1 %>% filter(time>=t2$tms13,time<t2$tms14) %>% summarise(mean(plv_par)) %>% unname()
    df[p,15]<-t1 %>% filter(time>=t2$tms14,time<t2$tms15) %>% summarise(mean(plv_par)) %>% unname()
    df[p,16]<-t1 %>% filter(time>=t2$tms15,time<t2$tms16) %>% summarise(mean(plv_par)) %>% unname()
    df[p,17]<-t1 %>% filter(time>=t2$tms16,time<t2$tms17) %>% summarise(mean(plv_par)) %>% unname()
    df[p,18]<-t1 %>% filter(time>=t2$tms17,time<t2$tms18) %>% summarise(mean(plv_par)) %>% unname()
    df[p,19]<-t1 %>% filter(time>=t2$tms18,time<t2$tms19) %>% summarise(mean(plv_par)) %>% unname()
    df[p,20]<-t1 %>% filter(time>=t2$tms19,time<0) %>% summarise(mean(plv_par)) %>% unname()
    df[p,21]<-t1 %>% filter(time>=0,time<t2$tms20+t2$inr) %>% summarise(mean(plv_par)) %>% unname()
    df[p,22]<-t1 %>% filter(time>=t2$strt-t2$inr,time<t2$strt) %>% summarise(mean(plv_par)) %>% unname()
    df[p,23]<-t1 %>% filter(time>=t2$tms20+t2$inr,time<t2$tms20+t2$inr*2) %>% summarise(mean(plv_par)) %>% unname()
    df[p,24]<-i
  }
  plv_locked[[i]]<-df %>% gather(.,key="tms",value="plv",c(-pid,-intensity))
}

plv_TMS_lock<-rbind(plv_locked[["Low rTMS"]],plv_locked[["Medium rTMS"]],plv_locked[["High rTMS"]])
plv_TMS_lock$intensity<-factor(plv_TMS_lock$intensity,levels=c("Low rTMS","Medium rTMS","High rTMS"))
plv_TMS_lock$tms<-factor(plv_TMS_lock$tms,levels=c("pre","1","2","3","4","5","6","7","8","9","10","11",
                                                   "12","13","14","15","16","17","18","19","20","post"))
rm(df,t1,t2,plv_locked)


fplv2<-ggplot(plv_TMS_lock,aes(x=tms,y=plv))+
  facet_grid(cols=vars(intensity))+
  geom_rect(xmin=2,xmax=21,ymin=fparam[["ymin"]],ymax=fparam[["ymax"]],fill="grey90",color=NA)+
  geom_segment(aes(x=which(levels(tms) %in% 'pre'),y=fparam[["ymin"]],xend=which(levels(tms) %in% 'pre'),yend=fparam[["ymax"]]),linetype='dotted')+
  geom_segment(aes(x=which(levels(tms) %in% 'post'),y=fparam[["ymin"]],xend=which(levels(tms) %in% 'post'),yend=fparam[["ymax"]]),linetype='dotted')+
  stat_summary(fun.y=mean,geom="point",color="#bf0a30",size=2)+
  stat_summary(fun.data=mean_cl_boot,fun.args=(c(conf.int=0.95,B=5000)),
               geom="errorbar",alpha=0.5,color="#bf0a30",size=1.25)+
  geom_text(x=which(levels(plv_TMS_lock$tms) %in% '1'),y=fparam[["ymax"]]+fparam[["adj"]],label="pre",family="Arial",fontface="plain",size=fparam[["asize"]],color="black")+
  geom_text(x=which(levels(plv_TMS_lock$tms) %in% '20'),y=fparam[["ymax"]]+fparam[["adj"]],label="post",family="Arial",fontface="plain",size=fparam[["asize"]],color="black")+
  scale_x_discrete(breaks=c("1","5","10","15","20"))+
  coord_cartesian(ylim=c(fparam[["ymin"]],fparam[["ymax"]]+fparam[["adj"]]))+
  labs(x="Rhythmic rTMS pulses",y="Phase locking value")+
  theme_bw()+
  theme(axis.text.x=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]]-2,face="plain",color="black",angle=0),
        axis.text.y=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"),
        axis.title=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"),
        strip.text.x=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"),
        strip.text.y=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],face="plain",color="black"))
ggsave("graphs/plv/plv2.png",plot=fplv2,width=210,height=85,units="mm",dpi=300)
