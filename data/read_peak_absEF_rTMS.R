# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the peak absolute EF values into a R dataframe.
# The EF simulations are based on repetitive transcranial magnetic stimulation (rTMS) sessions.

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
input=list() 
input[["dpath"]]<-file.path("data","ef","peak_EF")
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") 
input[["file"]]<-"^absE_rTMS"
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") %>% grep(input[["file"]],.,value=TRUE)
input[["ses"]]<-c("High","Low","Medium")
input[["ses_len"]]<-length(input[["ses"]])
input[["pid"]]<-c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,25,24)
input[["nsample"]]<-length(input[["pid"]])
input[["pid_long"]]<-rep(input[["pid"]],times=input[["ses_len"]])
input[["ses_long"]]<-rep(input[["ses"]],each=input[["nsample"]])
input[["var"]]<-"peak"

# Read matlab files
ef_abs_rtms<-NULL
for(fname in input[["ls"]]){
  temp<-readMat(file.path(input[["dpath"]],fname))
  temp<-data.frame(temp)
  colnames(temp)<-input[["var"]]
  ef_abs_rtms<-rbind(ef_abs_rtms,temp)}
rm(temp,fname)

# Prepare dataframe
ef_abs_rtms$pid<-input[["pid_long"]]
ef_abs_rtms$intensity<-input[["ses_long"]]

# Change factor orders
ef_abs_rtms$intensity<-factor(ef_abs_rtms$intensity,levels=c("Low","Medium","High"))
ef_abs_rtms<-ef_abs_rtms %>% arrange(intensity,pid) %>% select(pid,intensity,peak)
rm(input)