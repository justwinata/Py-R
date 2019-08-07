"---------------------CREATE BASE CODE WITH SINGLE FILE-----------------------"
#load 1 file
#f0 <- file.choose()
#f0


#dev0 <-  read.csv(f0,header = FALSE,sep = ",",nrows = 6)
dev0 <-  read.csv(f0,header = FALSE,sep = ",",nrows = 6)

nrow() #add df name
str(dev0)
View(dev0)

#transpose data
f2 <- as.data.frame(t(dev0))
View(f2)



#set column name and remove row 1
colnames(f2) <- as.character(unlist(f2[1,])) #use row1 as the column name
colnames(f2)
View(f2)

f3 <- f2[-1, ] #remove row 1
nrow(f3)
View(f3)
str(f3)

#convert factors to numbers
#f3$Amount_num <- as.numeric(as.character(f3$Amount))


#f3$Phase_num <- as.numeric(as.character(f3$Phase))



#View(f3)
str(f3)

#calculations for wafer centering
#f3$RealAngle <- (360-f3$Phase_num)
f3$RealAngle <- (360-f3$Phase_num)
f3$x_offset <- f3$Amount_num*cos(f3$RealAngle*(pi/180))
f3$y_offset <- f3$Amount_num*sin(f3$RealAngle*(pi/180))
View(f3)

plot(f3$x_offset,f3$y_offset,xlim = c(-2,2),ylim = c(-2,2))


"---------------------CREATE LOOP TO PROCESS MULTIPLE FILES-----------------------"
#load library
suppressMessages(library(plyr))

#select folder with files
folderLocation <- choose.dir()
folderLocation

#set working directory & create output folder
print("loading files.....")
setwd(folderLocation)
print("Making output folder....")
dir.create("Combo")
print("Finding ORT log files....")

#create variables
EqName <- ("ET101")
TestName <- ("Baseline")

#find files
vctFiles <- c(list.files(path = folderLocation,pattern = "ALGN.CSV",recursive = FALSE))
vctFiles

total.logs <- length(vctFiles) #log count
total.logs

#create loop
datalist10 = list()
for ( j in 1:length(vctFiles) ) {
  lp.file <- vctFiles[j]
  total <- paste(total.logs)
  lp.cnt <- paste(j)
  print(paste("Loading file",lp.cnt,"of",total))
  {
    #print("Load file")
    f1 <- read.csv(lp.file,header = FALSE,sep = ",",nrows = 6)
    file.name <- basename(lp.file)
    f2 <- as.data.frame(t(f1))
  
    
    colnames(f2) <- as.character(unlist(f2[1,]))
    f3 <- f2[-1, ]
    
    #print("Make numbers")
    f3$Amount_num <- as.numeric(as.character(f3$Amount))
    f3$Phase_num <- as.numeric(as.character(f3$Phase))
    
    
    #print("calculate xy")
    f3$RealAngle <- (360-f3$Phase_num)
    f3$x_offset <- f3$Amount_num*cos(f3$RealAngle*(pi/180))
    f3$y_offset <- f3$Amount_num*sin(f3$RealAngle*(pi/180))
    
    
    f4 <- cbind(EqName,TestName,file.name,f3)
    
        datalist10[[j]] <- f4
  }
}

library(plyr)
f5a=rbind.fill(datalist10,f4) # combine looped LP data
View(f5a)

f5a <- as.data.frame(f5a)
f5a$TestID <- row.names(f5a)
f5a <- subset(f5a,select=-c(Amount_num,Phase_num))
f5 <- f5a[,c(13,1:12)]
#nrow(f5)
#View(f5)


print("Files combined....")

setwd("Combo")
print("Making chart....")
jpeg_name <- paste(EqName,TestName,"LM Wafer Center Test Results.jpg")

#jpeg('LM wafer center results.jpg')
jpeg(jpeg_name,width = 800, height = 600, units = "px")
p <- plot(f5$x_offset,f5$y_offset,xlim = c(-2,2),ylim = c(-2,2),pch = 21,cex=2,
          main = paste(EqName,TestName,"LM Cycle Test Offset Results"),
          xlab = "X-axis",ylab = "Y-axis" ,abline(h=0,col="blue"))
p+ abline(v=0,col="blue")

with(f5, text(f5$y_offset~f5$x_offset, labels = row.names(f5), pos = 1)) #adds labels to data points


suppressMessages(dev.off())
print("Chart saved....")

print("Saving file....")
file_name <- paste(EqName,TestName,"LM Wafer Center Test Results.CSV")
write.csv(f5,file_name,row.names = FALSE)
print("File saved....")
