# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the phase locked value (PLV) data into a R dataframe.
# Extension of input data: .mat
# Source of data: Fieldtrip, Matlab toolbox for EEG and MEG analysis.

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
iparam=list() 
iparam[["dpath"]]<-file.path("data","ef","plv")
iparam[["file"]]<-"^plv"
iparam[["ls"]]<-list.files(iparam[["dpath"]],pattern="*.mat") %>% grep(iparam[["file"]],.,value=TRUE)
iparam[["var"]]<-c('AF3','AF4','AF7','AF8','AFz','C1','C2','C3','C4','C5',
                  'C6','CP1','CP2','CP3','CP4','CP5','CP6','CPz','Cz','F1',
                  'F2','F3','F4','F5','F6','F7','F8','FC1','FC2','FC3',
                  'FC4','FC5','FC6','FT10','FT7','FT8','FT9','Fp1','Fp2','Fz',
                  'O1','O2','Oz','P1','P2','P3','P4','P5','P6','P7',
                  'P8','PO3','PO4','PO7','PO8','POz','Pz','T7','T8','TP10','TP7',
                  'TP8','TP9','pid','time')
iparam[["pchs"]]<-c('O1','O2','Oz','P1','P2','P3','P4','P5','P6','P7','P8','PO3','PO4','PO7',
                   'PO8','POz','Pz')
iparam[["intensity"]]<-rep(c("High","Low","Medium"),each=6416)
iparam[["intensity"]]<-rep(iparam[["intensity"]],times=2)
iparam[["protocol"]]<-rep(c("ar","r"),each=6416*3)

# import matlab files
d<-NULL
for(fname in iparam[["ls"]]){
  temp<-readMat(file.path(iparam[["dpath"]],fname))
  temp<-data.frame(temp)
  colnames(temp)<-iparam[["var"]]
  d<-rbind(d,temp)}
rm(temp,fname)

# prepare dataframe
d$protocol<-iparam[["protocol"]]
d$intensity<-iparam[["intensity"]]
d$protocol<-factor(d$protocol,levels=c("r","ar"))
d$intensity<-factor(d$intensity,levels=c("Low","Medium","High"))
levels(d$intensity)<-c("Low rTMS","Medium rTMS","High rTMS")
d$pid<-factor(d$pid)
d<-d %>% arrange(pid,intensity,protocol,time)
d<-d %>% mutate(plv_par=rowMeans(.[,41:57]),
                plv_all=rowMeans(.[,1:63]))
plv<-d %>% select(pid,time,protocol,intensity,plv_par,plv_all)
rm(iparam,d)
