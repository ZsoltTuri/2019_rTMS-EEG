# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the EEG distance information into a R dataframe.
# Since we extracted the EF values from the gray matter compartment by using 10 mm spherical ROI, 
# we had to offset the EEG electrode coordinates. Without the offset, sherical 10mm ROIs would not reach the gray matter compartment, if the 
# the skin-gray-matter distance exceeds 10 mm. The distance variable reflect the amount of offset 
# we used to offset the EEG electrodes. 

# ---------------------------------------------------------------------------------------------------
# Define parameters for importing data
input=list() 
input[["dpath"]]<-file.path("data","ef","distance")
input[["file"]]<-"^EEG_distance"
input[["ls"]]<-list.files(input[["dpath"]],pattern="*.txt") %>% grep(input[["file"]],.,value=TRUE)
input[["nsample"]]<-16
input[["pid"]]<-c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,24,25)
input[["elec"]]<-c("P7","P5","P3","P1","Pz","PO7","PO3","POz","O1","Oz")
input[["elec_len"]]<-length(input[["elec"]])
input[["pid_long"]]<-rep(input[["pid"]],each=input[["elec_len"]])

# Read matlab files
d<-read.table((file.path(input[["dpath"]],input[["ls"]])),
              sep=",",header=TRUE) %>% 
  mutate("pid_long"=input[["pid_long"]]) %>% 
  select(pid_long,electrode,distance)

# Change factor order
d$electrode<-factor(d$electrode,levels=c("Pz","P1","P3","P5","P7",
                                         "POz","PO3","PO7","Oz","O1")) 

# Prepare dataframe
distance<-d %>% arrange(pid_long,electrode) %>% slice(rep(row_number(),each=3)) %>%
  mutate(session=rep(c("LI","MI","HI"),times=dim(d)[1]),
         pid=pid_long) %>% 
  arrange(pid,session,electrode) %>%
  select(pid,electrode,distance,-c(session,pid_long))
rm(input,d)


