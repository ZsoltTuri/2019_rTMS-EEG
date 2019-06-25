# ---------------------------------------------------------------------------------------------------
# Information:

# This script reads the individual alpha frequency (IAF) information into a R dataframe.
# We chose to stimulate at IAF in the rhythmic rTMS session. We provide IAF for each participant
# and session. Further, we provide the timing of each rhythmic rTMS pulse (tms1-tms20). 

# ---------------------------------------------------------------------------------------------------
iaf<-data.frame("pid"=factor(rep(c(1,2,6,8,9,13,14,15,16,17,19,21,22,23,24,25),each=3)),
                "intensity"=rep(c("Low rTMS","Medium rTMS","High rTMS"),times=16),
                "freq"=c(11,11,11,
                         8,8,9,
                         11,11,11,
                         11,11,11,
                         12,12,12,
                         10,10,10,
                         10,9,9,
                         10,10,10,
                         11,11,10,
                         9,9,9,
                         10,10,10,
                         10,10,10,
                         11,12,12,
                         9,11,9,
                         11,10,10,
                         10,10,10))

iaf<-iaf %>% mutate(inr=1/freq,
                    strt=(1/freq)*-20,
                    tms1=(1/freq)*-19,
                    tms2=(1/freq)*-18,
                    tms3=(1/freq)*-17,
                    tms4=(1/freq)*-16,
                    tms5=(1/freq)*-15,
                    tms6=(1/freq)*-14,
                    tms7=(1/freq)*-13,
                    tms8=(1/freq)*-12,
                    tms9=(1/freq)*-11,
                    tms10=(1/freq)*-10,
                    tms11=(1/freq)*-9,
                    tms12=(1/freq)*-8,
                    tms13=(1/freq)*-7,
                    tms14=(1/freq)*-6,
                    tms15=(1/freq)*-5,
                    tms16=(1/freq)*-4,
                    tms17=(1/freq)*-3,
                    tms18=(1/freq)*-2,
                    tms19=(1/freq)*-1,
                    tms20=0)