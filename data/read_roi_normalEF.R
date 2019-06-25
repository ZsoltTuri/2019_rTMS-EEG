# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the normal component of the EF from each region of interest (ROI) 
# into a R dataframe.

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
input=list() 
input[["dpath"]]<-file.path("data","ef","roi_EF")
input[["file"]]<-"^normalE"
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") %>% grep(input[["file"]],.,value=TRUE)
input[["hem"]]<-c("L","R") 
input[["hem_len"]]<-length(input[["hem"]]) 
input[["var"]]<-c("min","max","mean_glob","mean_pos","mean_neg","act_pos","act_neg")
input[["ses"]]<-c("HI","LI","MI")
input[["ses_len"]]<-length(input[["ses"]])
input[["pid"]]<-c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,25,24)
input[["nsample"]]<-length(input[["pid"]])
input[["gyri"]]<-c("G_postcentral","G_parietal_sup","G_precuneus","G_pariet_inf-Supramar",
                   "G_pariet_inf-Angular","G_occipital_sup","G_occipital_middle","G_cuneus",
                   "G_oc-temp_med-Lingual","G_oc-temp_lat-fusifor","G_and_S_occipital_inf","Pole_occipital")
input[["sulci"]]<-c("S_postcentral","S_intrapariet_and_P_trans","S_interm_prim-Jensen","S_subparietal",
                    "S_parieto_occipital","S_oc_sup_and_transversal","S_oc_middle_and_Lunatus","S_occipital_ant",
                    "S_calcarine","S_oc-temp_med_and_Lingual","S_collat_transv_post","S_oc-temp_lat")
input[["gyr_len"]]<-length(input[["gyri"]]) 
input[["sul_len"]]<-length(input[["sulci"]])
temp<-input[["hem_len"]]*(input[["gyr_len"]]+input[["sul_len"]])
input[["ses_len_long"]]<-input[["nsample"]]*temp
rm(temp)
input[["hem_gyr"]]<-rep(input[["hem"]],each=input[["gyr_len"]]*input[["nsample"]])
input[["hem_sul"]]<-rep(input[["hem"]],each=input[["sul_len"]]*input[["nsample"]])
input[["pid_gyr"]]<-rep(input[["pid"]],times=input[["gyr_len"]]*input[["hem_len"]])
input[["pid_sul"]]<-rep(input[["pid"]],times=input[["sul_len"]]*input[["hem_len"]])
input[["reg_gyr"]]<-rep(rep(input[["gyri"]],each=input[["nsample"]]),times=input[["hem_len"]])
input[["reg_sul"]]<-rep(rep(input[["sulci"]],each=input[["nsample"]]),times=input[["hem_len"]])

# Read matlab files
roi_normal<-NULL
for(fname in input[["ls"]]){
  temp<-readMat(file.path(input[["dpath"]],fname))
  temp<-data.frame(temp)
  colnames(temp)<-input[["var"]]
  roi_normal<-rbind(roi_normal,temp)}
rm(temp,fname)

# Prepare dataframe
roi_normal$pid<-rep(c(input[["pid_gyr"]],input[["pid_sul"]]),times=input[["ses_len"]])
roi_normal$hemisphere<-rep(c(input[["hem_gyr"]],input[["hem_sul"]]),times=input[["ses_len"]])
roi_normal$region<-rep(c(input[["reg_gyr"]],input[["reg_sul"]]),times=input[["ses_len"]])
roi_normal$session<-rep(input[["ses"]],each=input[["ses_len_long"]])

# Change factor orders
roi_normal$session<-factor(roi_normal$session,levels=c("LI","MI","HI"))
roi_normal$hemisphere<-factor(roi_normal$hemisphere,levels=c("L","R"))
roi_normal$region<-factor(roi_normal$region,levels=c("G_postcentral","G_parietal_sup","G_precuneus","G_pariet_inf-Supramar",
                                                     "G_pariet_inf-Angular","G_occipital_sup","G_occipital_middle","G_cuneus",
                                                     "G_oc-temp_med-Lingual","G_oc-temp_lat-fusifor","G_and_S_occipital_inf","Pole_occipital",
                                                     "S_postcentral","S_intrapariet_and_P_trans","S_interm_prim-Jensen","S_subparietal",
                                                     "S_parieto_occipital","S_oc_sup_and_transversal","S_oc_middle_and_Lunatus","S_occipital_ant",
                                                     "S_calcarine","S_oc-temp_med_and_Lingual","S_collat_transv_post","S_oc-temp_lat"))
rm(input)