# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the normal component of peak EF values into a R dataframe.
# The EF simulations are based on repetitive transcranial magnetic stimulation (rTMS) sessions.

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
input=list() 
input[["dpath"]]<-file.path("data","ef","peak_EF")
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") 
input[["file"]]<-"^normE_rTMS"
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") %>% grep(input[["file"]],.,value=TRUE)
input[["ses"]]<-c("High","Low","Medium")
input[["ses_len"]]<-length(input[["ses"]])
input[["pid"]]<-c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,25,24)
input[["nsample"]]<-length(input[["pid"]])
input[["pid_long"]]<-rep(input[["pid"]],times=input[["ses_len"]])
input[["ses_long"]]<-rep(input[["ses"]],each=input[["nsample"]])
input[["var"]]<-c("neg_peak","pos_peak")

# Read matlab files
ef_norm_rtms<-NULL
for(fname in input[["ls"]]){
  temp<-readMat(file.path(input[["dpath"]],fname))
  temp<-data.frame(temp)
  colnames(temp)<-input[["var"]]
  ef_norm_rtms<-rbind(ef_norm_rtms,temp)}
rm(temp,fname)

# Prepare dataframe
ef_norm_rtms$pid<-input[["pid_long"]]
ef_norm_rtms$intensity<-input[["ses_long"]]

# Change factor order
ef_norm_rtms$intensity<-factor(ef_norm_rtms$intensity,levels=c("Low","Medium","High"))

# Prepare dataframe
ef_norm_rtms<-ef_norm_rtms %>% arrange(intensity,pid) %>% select(pid,intensity,neg_peak,pos_peak)
ef_norm_rtms<-ef_norm_rtms %>% gather(.,key="type",value="peak",-c(pid,intensity))
rm(input)