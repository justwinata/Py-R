library(plyr)
library(data.table)

f0 <- choose.dir()
f0

setwd(f0)

pFiles <- c(list.files(path = getwd(),pattern = "p01.csv",recursive = FALSE,full.names = TRUE))
length(pFiles)
pFiles

p_list <- unlist(unique(pFiles))


datalist10 = list() #for pin torque summary data
datalist20 = list() #for pin torque raw data
for ( j in 1:length(p_list) ) {
  p_lp1 <- p_list[j]
  p_lp1
  p_total <- paste(length(p_list))
  p_cnt <- paste(j)
  print(paste("Loading file",p_cnt,"of",p_total))
  {
    #f01 <- read.csv(paste(pl.lp1),header = FALSE,sep = ",", skip = 0,fill = TRUE,col.names = paste0("V",seq_len(13)))
    f01 <- read.csv(paste(p_lp1),header = FALSE,sep = ",",fill = TRUE,col.names = paste0("V",seq_len(200)))
    f01$row <- row.names(f01)
    #View(f01)
    nrow(f01)
    
    #get date
    start01 <- unique(subset(f01,f01$V1=="Trace Start Time"))
    #View(start01)
    start02 <- (start01$V2)
    #View(start02)
    
    start03 <- (start01$V3)
    #View(start03)
    
    start04 <- paste(start02,start03)
    start05 <- min(start04)
    start05
    
    #get PM
    module01 <- subset(f01,f01$V1=="Module Name")
    module02 <- (module01$V2)
    #View(module02)
    
    #get recipe name
    recipe01 <- subset(f01,f01$V1=="Recipe Name")
    recipe02 <- (recipe01$V2)
    #View(recipe02)
    
    #get wafer number
    wfr01 <- subset(f01,f01$V1=="Wafer No")
    wfr02 <- (wfr01$V2)
    #View(wfr02)
    
    #get PJID
    pjid01 <- subset(f01,f01$V1=="PJID")
    pjid02 <- (pjid01$V2)
    #View(pjid02)
    
    
    #get pin torque data locations
    f02 <- which(grepl("Section No.", f01$V1))
    f02na <- as.numeric(f02)
    f02na <- f02na + 1
    f02na
    
    f02nb <- (f02+4)
    f02nb
    
    f02nc <- length(f02na)
    f02nc
    
    #get pin torque raw data
    f22 <- which(grepl("Pin Torque", f01$V3))
    f22na <- as.numeric(f22)+2
    f22na
    
    f22nb <- max(nrow(f01))
    f22nb
    
    #RUN BELOW IF PIN TORQUE DATA EXISTS
    if (f02nc > 0) {
    
      
    f03 <- f01[f02na:f02nb,] 
    
    #View(f03)
    
    f04 <- subset(f03, select = c(V1:V4))
    #View(f04)
    f04$V5 <- c("Pin Torque MAX", "Pin Torque MIN", "Pin Speed MAX","Pin Speed MIN")
    f05 <- subset(f04, select = c(V5,V2:V4))
    #View(f05)
    
    fName <- basename(p_lp1)
    fName
    
    f07 <- cbind(fName,module02,start05,pjid02,recipe02,wfr02,f05)
    #View(f07)
    
    "-------------RAW PIN TORQUE DATA--------------"
    
    f33 <- f01[f22na:f22nb,] 
    f33 <- as.data.table(f33)
    f22na
    f22nb
    #View(f33)
    f33a <- subset(f33,select = c(1:4))
    colnames(f33a) <- c("Interval",	"Section No.",	"Pin Torque",	"Pin Speed")
    
    
    #combine metadata & data frames
    f33b <- cbind(fName,module02,start05,pjid02,recipe02,wfr02,f33a)
    colnames(f33b)
    
    #create counter for each section group 
    setDT(f33b)[, counter := seq_len(.N), by = list(`Section No.`)]
    
   
    
    datalist10[[j]] <- f07 #summary data
    datalist20[[j]] <- f33b #raw data
    }
  }   
  
  
}

"-----------PIN TORQUE SUMMARY COMBINE & CSV SAVE-------------------"
pin_sum_02=rbind.fill(datalist10,f07) # combine pin torque summary data
nrow(pin_sum_02)
pin_sum_03 <- unique(pin_sum_02)
nrow(pin_sum_03)


#View(tns.03)

colnames(pin_sum_03) <- c("FileName","Module","StartDateTime","PJID","Recipe","WaferID","PinTorque Sensor","Sec1","Sec2","Sec3"  )

pin_sum_03$WaferID <- gsub("\\[", "", pin_sum_03$WaferID)
pin_sum_03$WaferID <- gsub("\\]", "", pin_sum_03$WaferID)
pin_sum_03$WaferID <- gsub("-", "", pin_sum_03$WaferID)

setwd(f0)
getwd()

write.csv(pin_sum_03,"PinTorque_combined.csv",row.names = FALSE)


"-----------PIN TORQUE SUMMARY COMBINE & CSV SAVE-------------------"
pin_raw_22=rbind.fill(datalist20,f33b) # combine pin raw data
nrow(pin_raw_22)
pin_raw_23 <- unique(pin_raw_22)
nrow(pin_raw_23)
#View(tns.23)

colnames(pin_raw_23) <- c("FileName","Module","StartDateTime","PJID","Recipe","WaferID","Interval","Section","PinTorque","PinSpeed","SecInterval")
pin_raw_23$WaferID <- gsub("\\[", "", pin_raw_23$WaferID)
pin_raw_23$WaferID <- gsub("\\]", "", pin_raw_23$WaferID)
pin_raw_23$WaferID <- gsub("-", "", pin_raw_23$WaferID)



fwrite(pin_raw_23,"PinTorque_raw_combined.csv")
