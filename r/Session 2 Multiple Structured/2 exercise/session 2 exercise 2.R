folderLocation <- choose.dir()
folderLocation
setwd(folderLocation)

vctFiles <- c(list.files(path = folderLocation,pattern = "TRD.CSV",recursive = FALSE))
vctFiles

total.logs <- length(vctFiles) #log count
total.logs

#create variables
EqName <- ("ET101")
TestName <- ("MyTest")


#create loop
datalist10 = list()
for ( j in 1:length(vctFiles) ) {
  lp.file <- vctFiles[j]
  
  {
    #print("Load file")
    f1 <- read.csv(lp.file,header = TRUE,sep = ",")
    
    datalist10[[j]] <- f1
  }
}

library(plyr)
f2=rbind.fill(datalist10,f1) #combine 
nrow(f2)

system.time(write.csv(f2,"write_TRD_combined_files.csv"))

system.time(write.csv(f2,"write_noRowNames_TRD_combined_files.csv",row.names = FALSE))


library(data.table)
system.time(fwrite(f2,"fread_TRD_combined_files.csv"))
