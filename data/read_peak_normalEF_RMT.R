# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the normal component of peak EF values into a R dataframe.
# The EF simulations are based on resting motor threshold (RMT) data.

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
input=list() 
input[["dpath"]]<-file.path("data","ef","peak_EF")
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") 
input[["file"]]<-"^normE_RMT"
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.mat") %>% grep(input[["file"]],.,value=TRUE)
input[["ses"]]<-c("100","110","120","80","90")
input[["ses_len"]]<-length(input[["ses"]])
input[["pid"]]<-c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,25,24)
input[["nsample"]]<-length(input[["pid"]])
input[["pid_long"]]<-rep(input[["pid"]],times=input[["ses_len"]])
input[["ses_long"]]<-rep(input[["ses"]],each=input[["nsample"]])
input[["var"]]<-c("neg_peak","pos_peak")

# Read matlab files
ef_norm_rmt<-NULL
for(fname in input[["ls"]]){
  temp<-readMat(file.path(input[["dpath"]],fname))
  temp<-data.frame(temp)
  colnames(temp)<-input[["var"]]
  ef_norm_rmt<-rbind(ef_norm_rmt,temp)}
rm(temp,fname)

# Prepare dataframe
ef_norm_rmt$pid<-input[["pid_long"]]
ef_norm_rmt$intensity<-input[["ses_long"]]

# Change factor order
ef_norm_rmt$intensity<-factor(ef_norm_rmt$intensity,levels=c("80","90","100","110","120"))

# Prepare dataframe
ef_norm_rmt<-ef_norm_rmt %>% arrange(intensity,pid) %>% select(pid,intensity,neg_peak,pos_peak)
ef_norm_rmt<-ef_norm_rmt %>% gather(.,key="type",value="peak",-c(pid,intensity))
rm(input)