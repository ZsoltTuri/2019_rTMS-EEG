# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the absolute EF values from each EEG region of interest (ROI) into a R dataframe.

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
input=list() 
input[["dpath"]]<-file.path("data","ef","eeg_roi_EF")
input[["file"]]<-"^abs_Efield_individual_EEG_ROI"
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") %>% grep(input[["file"]],.,value=TRUE)
input[["var"]]<-c("min","max","mean_glob")
input[["ses"]]<-c("HI","LI","MI")
input[["ses_len"]]<-length(input[["ses"]])
input[["nsample"]]<-16
input[["pid"]]<-c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,25,24)
input[["elec"]]<-c("P7","P5","P3","P1","Pz","PO7","PO3","POz","O1","Oz")
input[["elec_len"]]<-length(input[["elec"]])
input[["elec_long"]]<-rep(input[["elec"]],times=input[["nsample"]]*input[["ses_len"]])
input[["pid_long"]]<-rep(input[["pid"]],each=input[["elec_len"]])
input[["ses_long"]]<-rep(input[["ses"]],each=length(input[["pid_long"]]))

# Read matlab files
eeg_roi_abs<-NULL
for(fname in input[["ls"]]){
  temp<-readMat(file.path(input[["dpath"]],fname))
  temp<-data.frame(temp)
  colnames(temp)<-input[["var"]]
  eeg_roi_abs <- rbind(eeg_roi_abs,temp)}
rm(temp,fname)

# Prepare dataframe
eeg_roi_abs$pid<-rep(input[["pid_long"]],times=input[["ses_len"]])
eeg_roi_abs$elec<-input[["elec_long"]]
eeg_roi_abs$session<-input[["ses_long"]]

# Change factor orders
eeg_roi_abs$session<-factor(eeg_roi_abs$session,levels=c("LI","MI","HI"))
# anterior>posterior; medial>lateral
eeg_roi_abs$elec<-factor(eeg_roi_abs$elec,levels=c("Pz","P1","P3","P5","P7",
                                                   "POz","PO3","PO7","Oz","O1")) 

# Reorder columns
eeg_roi_abs<-select(eeg_roi_abs,c("pid","session","elec","min","max","mean_glob"))
eeg_roi_abs$session<-factor(eeg_roi_abs$session,levels=c("LI","MI","HI"))
eeg_roi_abs<-eeg_roi_abs %>% arrange(pid,session,elec)

#-----------------------------------------------------------------------------------------------------
# Import EEG data (note the different electrode order!)
input[["elec"]]<-c("Pz","POz","Oz","P1","P3","P5","P7","PO7","PO3","O1")
input[["elec_long"]]<-rep(input[["elec"]],times=input[["nsample"]]*input[["ses_len"]])
eeg_temp<-data.frame("pid"=rep(input[["pid_long"]],times=input[["ses_len"]]),
                     "elec"=input[["elec_long"]],
                     "session"=input[["ses_long"]])
# Import mat file
fname="DATA_R.mat"
eeg<-readMat(file.path(input[["dpath"]],fname))
names(eeg)<-"data"
eeg_temp$plv_r<-eeg[["data"]][,1]
eeg_temp$pow_r<-eeg[["data"]][,2]

# Change factor order
eeg_temp$session<-factor(eeg_temp$session,levels=c("LI","MI","HI"))
# anterior>posterior; medial>lateral
eeg_temp$elec<-factor(eeg_temp$elec,levels=c("Pz","P1","P3","P5","P7",
                                             "POz","PO3","PO7","Oz","O1")) 
eeg_temp<-eeg_temp %>% arrange(pid,session,elec)

#-----------------------------------------------------------------------------------------------------
# Add eeg data to the EF roi dataframe
eeg_roi_abs$plv_r<-eeg_temp$plv_r
eeg_roi_abs$pow_r<-eeg_temp$pow_r

# Clean global envoronment
rm(eeg,eeg_temp,input,fname)
