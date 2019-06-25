loadfonts()
fparam<-list()
fparam[["TMSpuls"]]<-c(-2.5,-2.22,-2,-1.82,-1.67)
fparam[["TMSfreq"]]<-c("8","9","10","11","12 Hz rTMS")
fparam[["fsize"]]<-13  # font size
fparam[["asize"]]<-3.5 # annotation font size
fparam[["ymin"]]<-0.05
fparam[["ymax"]]<-0.25
fparam[["adj"]]<-0.01
fparam[["ang"]]<-45
fparam[["ftype"]]<-"Arial"

# Warm colors for inward current 
# https://www.color-hex.com/color/ff6666
fparam[["c1"]]<-"#ffc1c1" # HI session
fparam[["c2"]]<-"#ff6666" # MI session
fparam[["c3"]]<-"#b24747" # LI session

# Cold colors for outward current
# https://www.color-hex.com/color-palette/1294
fparam[["c4"]]<-"#005b96" # HI session
fparam[["c5"]]<-"#6497b1" # MI session
fparam[["c6"]]<-"#b3cde0" # LI session