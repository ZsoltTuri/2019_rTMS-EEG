# Information:
# This script generates stack barplot about the mean, median, min and max values of the 
# normal EF component in region of interest. 

library('ProjectTemplate')
load.project()

neg<-roi_normal %>% select(-c("min","max","mean_glob","mean_pos","mean_neg","act_pos")) %>% mutate(val=act_neg) %>%
  mutate(hemisphere=plyr::mapvalues(.$hemisphere,as.character(c("L","R")),
                                    as.character(c("Left hemisphere","Right hemisphere")))) %>%
  filter(region %in% c("G_pariet_inf-Angular","G_occipital_sup","G_occipital_middle",
                  "S_oc_sup_and_transversal","S_oc_middle_and_Lunatus")) %>% droplevels() %>%
  mutate(region=plyr::mapvalues(.$region,
                                as.character(c("G_pariet_inf-Angular","G_occipital_sup","G_occipital_middle",
                                                "S_oc_sup_and_transversal","S_oc_middle_and_Lunatus")),
                                as.character(c("1","2","3","4","5"))))
pos<-roi_normal %>% select(-c("min","max","mean_glob","mean_neg","mean_pos","act_neg")) %>% mutate(val=act_pos) %>%
  mutate(hemisphere=plyr::mapvalues(.$hemisphere,as.character(c("L","R")),
                                    as.character(c("Left hemisphere","Right hemisphere")))) %>%
  filter(region %in% c("G_pariet_inf-Supramar","G_occipital_sup","G_occipital_middle",
                   "S_oc_sup_and_transversal","S_oc_middle_and_Lunatus")) %>% droplevels() %>%
  mutate(region=plyr::mapvalues(.$region,
                                as.character(c("G_pariet_inf-Supramar","G_occipital_sup","G_occipital_middle",
                                               "S_oc_sup_and_transversal","S_oc_middle_and_Lunatus")),
                                as.character(c("1","2","3","4","5"))))

# Figure (inward)
fact_b1<-ggplot(data=NULL,aes(x=region,y=val,fill=session))+
  facet_grid(cols=vars(hemisphere))+
  geom_bar(data=pos,
           mapping=aes(x=region,y=val,fill=session),
           stat="summary",fun.y=mean,position="dodge")+
  stat_summary(data=pos,
               fun.y=median,
               fun.ymin=function(z) {quantile(z,0.25)},
               fun.ymax=function(z) {quantile(z,0.75)},
               size=0.2,
               alpha=1,
               position=position_dodge(width=1))+
  scale_fill_manual(name="session",values=c(fparam[['c3']],   # pos HI
                                            fparam[['c1']],   # pos LI
                                            fparam[['c2']]))+ # pos MI
  scale_x_discrete(limits=levels(pos$region))+
  geom_hline(yintercept=50,linetype="solid",color="red",size=0.2,alpha=1)+
  theme_bw()+
  theme(legend.position="none",
        panel.grid.major=element_blank(),panel.grid.minor=element_blank(),
        text=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],color="black",face="bold"),
        axis.title.y=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.title.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.y=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        plot.title=element_text(hjust=0.5,size=12),
        strip.text.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        panel.border=element_rect(colour="black",fill=NA,size=0.75))+
  labs(x="Region of interest",y="Activation % (normal EF)")+
  coord_cartesian(ylim=c(0,100))
ggsave("graphs/f_r_EFn_activation_pos_bar_point.png",plot=fact_b1,width=240,height=120,units="mm")

# Figure (outward)
fact_b2<-ggplot(data=NULL,aes(x=region,y=val,fill=session))+
  facet_grid(cols=vars(hemisphere))+
  geom_bar(data=neg,
           mapping=aes(x=region,y=val,fill=session),
           stat="summary",fun.y=mean,position="dodge")+
  stat_summary(data=neg,
               fun.y=median,
               fun.ymin=function(z) {quantile(z,0.25)},
               fun.ymax=function(z) {quantile(z,0.75)},
               size=0.2,
               alpha=1,
               position=position_dodge(width=1))+
  scale_fill_manual(name="session",values=c(fparam[['c4']],   # pos HI
                                            fparam[['c6']],   # pos LI
                                            fparam[['c5']]))+ # pos MI
  scale_x_discrete(limits=levels(neg$region))+
  geom_hline(yintercept=50,linetype="solid",color="red",size=0.2,alpha=1)+
  theme_bw()+
  theme(legend.position="none",
        panel.grid.major=element_blank(),panel.grid.minor=element_blank(),
        text=element_text(family=fparam[["ftype"]],size=fparam[["fsize"]],color="black",face="bold"),
        axis.title.y=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.title.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        axis.text.y=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        plot.title=element_text(hjust=0.5,size=12),
        strip.text.x=element_text(size=fparam[["fsize"]],face="plain",color="black"),
        panel.border=element_rect(colour="black",fill=NA,size=0.75))+
  labs(x="Region of interest",y="Activation % (normal EF)")+
  coord_cartesian(ylim=c(0,100))
ggsave("graphs/f_r_EFn_activation_neg_bar_point.png",plot=fact_b2,width=240,height=120,units="mm")

rm(neg,pos)
