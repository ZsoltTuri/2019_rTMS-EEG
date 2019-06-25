# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the peak absolute EF values into a R dataframe.
# The EF simulations are based on resting motor threshold (RMT) data.

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
input=list() 
input[["dpath"]]<-file.path("data","ef","peak_EF")
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") 
input[["file"]]<-"^absE_RMT"
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") %>% grep(input[["file"]],.,value=TRUE)
input[["ses"]]<-c("100","110","120","80","90")
input[["ses_len"]]<-length(input[["ses"]])
input[["pid"]]<-c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,25,24)
input[["nsample"]]<-length(input[["pid"]])
input[["pid_long"]]<-rep(input[["pid"]],times=input[["ses_len"]])
input[["ses_long"]]<-rep(input[["ses"]],each=input[["nsample"]])
input[["var"]]<-"peak"

# Read matlab files
ef_abs_rmt<-NULL
for(fname in input[["ls"]]){
  temp<-readMat(file.path(input[["dpath"]],fname))
  temp<-data.frame(temp)
  colnames(temp)<-input[["var"]]
  ef_abs_rmt<-rbind(ef_abs_rmt,temp)}
rm(temp,fname)

# Prepare dataframe
ef_abs_rmt$pid<-input[["pid_long"]]
ef_abs_rmt$intensity<-input[["ses_long"]]

# Change factor orders
ef_abs_rmt$intensity<-factor(ef_abs_rmt$intensity,levels=c("80","90","100","110","120"))
ef_abs_rmt<-ef_abs_rmt %>% arrange(intensity,pid) %>% select(pid,intensity,peak)
rm(input)
