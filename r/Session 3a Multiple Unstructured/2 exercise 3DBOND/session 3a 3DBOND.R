
print("-------------------Memory Clear---------------------------")
ls()
rm(list=ls(all=TRUE))
gc()
dev.off() #clears charts

print("---------------- Load Libraries --------------------------")

suppressMessages(library(plyr))
suppressMessages(library(reshape2))

"--------run manual-------------------"
folderName <- setwd(choose.dir())
folderName
setwd(folderName)
getwd()


#  ---------- Start File Processing ----------
print("------ TLA load files & make output folder ---------------")
EqName <- ("ET101")
EqName

CustName <- ("TEL")
CustName



print("loading files.....")
print("Making output folder....")
dir.create("Combo")
print("Finding files....")

"wafer flow...."
vctFiles <- c(list.files(path = folderName,pattern = "WaferFlow",recursive = FALSE))
vctFiles

total.logs <- length(vctFiles)
total.logs

datalist10 = list()
for ( j in 1:length(vctFiles) ) {
  lp.file <- vctFiles[j]
  lp.file
  total <- paste(total.logs)
  lp.cnt <- paste(j)
  print(paste("Loading file",lp.cnt,"of",total))
  {
    f01 <- read.csv(lp.file,header = FALSE,sep = ",",nrows = 4)
    #View(f01)
    f01a <- t(f01)
    colnames(f01a) <- as.character(f01a[1,]) 
    f01a <- as.data.table(f01a)
    f01a <- f01a[-c(1), ]
    #View(f01a)
    
    FileName <- basename(lp.file)
    f01_set <- read.csv(lp.file,header = TRUE,sep = ",",skip = 5)
    #View(f01_set)
    f01_seta <- f01_set[-c(1), ]
    #View(f01_seta)
    
    strRef <- c("sec")
    suppressWarnings(f01_setb <- melt(f01_seta, id=strRef))
    #View(f01_setb)
    suppressWarnings(f01_setb$asnumeric <- as.numeric(f01_setb$value))
    f01_setb$numeric <- is.numeric(f01_setb$asnumeric)
    f01_setb$isna <- is.na(f01_setb$asnumeric)
    
    f01_setc <- subset(f01_setb,f01_setb$isna==FALSE)
    #View(f01_setc)
    
    colnames(f01_setc)
    f01_setc <- subset(f01_setc,select = -c(value,numeric,isna))
    
    
    colnames(f01_setc) <- c(strRef, "Label", "Value")
    
    f02 <- cbind(FileName,f01a,f01_setc)
    
    datalist10[[j]] <- f02
  }
}

logcomb01=rbind.fill(datalist10,f02) # combine looped LP data
nrow(logcomb01)
View(logcomb01)

print("Files combined....")

setwd("Combo")
getwd()
#setwd('..')
write.csv(logcomb01,"Synapse vacuum logs combined.csv",row.names = FALSE)
print("File saved....")