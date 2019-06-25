# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the maximum stimulator output (MSO) information into two R dataframes.
# In one dataframe, we provide the MSO values corresponding to the rTMS session. 
# In the other dataframe, we provide the MSO values corresponding to the resting motor threshold (RMT)
# measurement. 

# ---------------------------------------------------------------------------------------------------
mso_rTMS<-data.frame("pid"=factor(rep(c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,24,25),each=3)),
                     "intensity"=rep(c("Low","Medium","High"),times=16),
                     "perc"=c(9,17,24,
                              9,17,24,
                              9,17,23,
                              10,17,25,
                              10,18,26,
                              12,21,29,
                              9,16,23,
                              9,15,22,
                              8,13,20,
                              12,21,29,
                              9,16,23,
                              9,15,22,
                              9,16,23,
                              10,17,24,
                              8,14,20,
                              11,19,24))

mso_RMT<-data.frame("pid"=factor(rep(c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,24,25),each=5)),
                    "intensity"=rep(c("80","90","100","110","120"),times=16),
                    "perc"=c(60,68,75,83,90,
                             54,61,68,75,82,
                             60,68,75,83,90,
                             51,58,64,70,77,
                             37,41,46,51,55,
                             60,68,75,83,90,
                             38,42,47,52,56,
                             55,62,69,76,83,
                             42,47,52,57,62,
                             58,65,72,79,86,
                             34,39,43,47,52,
                             33,37,41,45,49,
                             45,50,56,62,67,
                             36,41,45,50,54,
                             38,42,47,52,56,
                             60,68,75,83,90))

# Prepare dataframe
temp<-mso_RMT %>% filter(intensity=="100") %>% select(perc) %>% pull(.) %>% rep(.,each=3)
mso_rTMS<-mso_rTMS %>% mutate(rmt_perc=(mso_rTMS$perc/temp)*100)
rm(temp)


