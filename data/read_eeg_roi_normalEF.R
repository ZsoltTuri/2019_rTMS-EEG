# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the normal component of the EF from each EEG region of interest (ROI) into a R dataframe.

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
input=list() 
input[["dpath"]]<-file.path("data","ef","eeg_roi_ef")
input[["file"]]<-"^normal_Efield_individual_EEG_ROI"
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") %>% grep(input[["file"]],.,value=TRUE)
input[["var"]]<-c("min","max","mean_glob","mean_pos","mean_neg","act_pos","act_neg")
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
eeg_roi_normal<-NULL
for(fname in input[["ls"]]){
  temp<-readMat(file.path(input[["dpath"]],fname))
  temp<-data.frame(temp)
  colnames(temp)<-input[["var"]]
  eeg_roi_normal <- rbind(eeg_roi_normal,temp)}
rm(temp,fname)

# Prepare dataframe
eeg_roi_normal$pid<-rep(input[["pid_long"]],times=input[["ses_len"]])
eeg_roi_normal$elec<-input[["elec_long"]]
eeg_roi_normal$session<-input[["ses_long"]]

# Change factor orders
eeg_roi_normal$session<-factor(eeg_roi_normal$session,levels=c("LI","MI","HI"))
# anterior>posterior; medial>lateral
eeg_roi_normal$elec<-factor(eeg_roi_normal$elec,levels=c("Pz","P1","P3","P5","P7",
                                                         "POz","PO3","PO7","Oz","O1")) 

# Reorder columns
eeg_roi_normal<-select(eeg_roi_normal,c("pid","session","elec",
                                        "min","max","mean_glob","mean_pos","mean_neg","act_pos","act_neg"))
eeg_roi_normal$session<-factor(eeg_roi_normal$session,levels=c("LI","MI","HI"))
eeg_roi_normal<-eeg_roi_normal %>% arrange(pid,session,elec)

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
eeg_roi_normal$plv_r<-eeg_temp$plv_r
eeg_roi_normal$pow_r<-eeg_temp$pow_r

# Clean global environment
rm(eeg,eeg_temp,input,fname)

