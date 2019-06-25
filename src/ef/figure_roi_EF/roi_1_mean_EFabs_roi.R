# ---------------------------------------------------------------------------------------------------
# Information:

# This script generates stack barplot about the mean and median values of the 
# absolute EF in region of interest. 

# ---------------------------------------------------------------------------------------------------

library('ProjectTemplate')
load.project()

abs<-roi_abs %>% select(-c("min","max","act")) %>% mutate(val=avg) %>%
  mutate(hemisphere=plyr::mapvalues(.$hemisphere,as.character(c("L","R")),
                                    as.character(c("Left hemisphere","Right hemisphere")))) %>%
  filter(region %in% c("G_pariet_inf-Angular","G_occipital_sup","G_occipital_middle",
                  "S_oc_sup_and_transversal","S_oc_middle_and_Lunatus")) %>% droplevels() %>%
  mutate(region=plyr::mapvalues(.$region,
                                as.character(c("G_pariet_inf-Angular","G_occipital_sup","G_occipital_middle",
                                                "S_oc_sup_and_transversal","S_oc_middle_and_Lunatus")),
                                as.character(c("1","2","3","4","5"))),
         session=factor(.$session,levels=c("LI","MI","HI")))
str(abs)

# Figure 
froi1<-ggplot(data=NULL,aes(x=region,y=val,fill=session))+
  facet_grid(cols=vars(hemisphere))+
  geom_bar(data=abs,
           mapping=aes(x=region,y=val,fill=session),
           color="black",
           stat="summary",
           fun.y=mean,
           position="dodge")+
  stat_summary(data=abs,
               fun.y=median,
               fun.ymin=function(z) {quantile(z,0.025)},
               fun.ymax=function(z) {quantile(z,0.975)},
               size=0.2,
               alpha=1,
               position=position_dodge(width=1))+
  scale_fill_manual(name="session",values=c(fparam[['c1']],   # pos HI
                                            fparam[['c2']],   # pos LI
                                            fparam[['c3']]))+ # pos MI
  scale_x_discrete(limits=levels(abs$region))+
  geom_hline(yintercept=1,linetype="solid",color="red",size=0.2,alpha=1)+
  theme_bw()+
  theme(legend.position="none",
        panel.grid.major=element_blank(),panel.grid.minor=element_blank(),
        text=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],color="black",face="bold"),
        axis.title.y=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.title.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.y=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        plot.title=element_text(hjust=0.5,size=12),
        #strip.background=element_rect(fill=NA,color=NA),
        strip.text.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        panel.border=element_rect(colour="black",fill=NA,size=0.75))+
  labs(x="Region of interest",y="Absolute EF [mV/mm]")+
  coord_cartesian(ylim=c(0,30))

ggsave("graphs/roi_EF/roi1.png",plot=froi1,width=240,height=120,units="mm")

abs %>% group_by(hemisphere,session) %>% summarise(mean(val))
rm(abs)
