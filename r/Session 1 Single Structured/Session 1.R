f0 <- file.choose() #select csv file
f0 #view file name

f1 <- read.csv(f0, header = TRUE,sep = ",") # load csv file


colnames(f1) # view column names
ncol(f1) # column count

nrow(f1) # row number
 
View(f1) # view data in table format

str(f1) # view column attributes

head(f1) # first 6 rows

tail(f1) # last 6 rows

getwd() # this is the location where files are being saved or loaded from
 
setwd(choose.dir()) # change working folder

fName <- basename(f0) # get file name
fName

tool <- ("ET101") # create tool name object
tool

time <- Sys.time() # get current time
time

f2  <- cbind(tool,time, fName,f1) #combine objects and data
colnames(f2)

#rename columns
colnames(f2) <- c("EqName","FileProcessTime","FileName","ProcessDateTime","Recipe","Step","Interval",
                 "Pressure","GasFlow","ElectricalPower","Temperature" )


f2$MyName <- ("John Solis") # add new additional column


colnames(f2)
View(f2)

# reorder by column name
f3 <- f2[c("MyName","EqName","FileProcessTime","FileName","ProcessDateTime","Recipe","Step","Interval",
           "Pressure","GasFlow","ElectricalPower","Temperature")]


colnames(f3)
ncol(f3)
#reorder by column index
f4 <- f3[c(2,1,3:12)]
colnames(f4)

#remove column
f5 <- subset(f4,select = -c(MyName))
colnames(f5)

#simple plot
plot(f4$Pressure)

getwd()
setwd(choose.dir())

#save file with static name
write.csv(f5,"session1 file.csv",row.names = FALSE)

#save file with dynamic name
my_file_name <- paste(tool,"session1 file.csv")
my_file_name

write.csv(f5,my_file_name,row.names = FALSE)
