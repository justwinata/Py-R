#This session will use iris data
View(iris)
colnames(iris)
nrow(iris)


#We will use below site to copy sample code and discuss syntax
browseURL("https://www.mailman.columbia.edu/sites/default/files/media/fdawg_ggplot2.html")

#Create XY plot
plot(x=iris$Sepal.Length, y=iris$Sepal.Width, 
     xlab="Sepal Length", ylab="Sepal Width",  main="My Sepal Length-Width")

#Create simple line plot
plot(iris$Sepal.Length)


#Plot 2 charts side by side & plot 2 stacked
browseURL("https://www.statmethods.net/advgraphs/layout.html")
dev.off()
par(mfrow=c(1,2))
plot(iris$Sepal.Width)
plot(iris$Sepal.Length)
dev.off()



####Section 1 | Scatter Plot

# 1 R basic plot
plot(x=iris$Sepal.Length, y=iris$Sepal.Width, 
     xlab="Sepal Length", ylab="Sepal Width",  main="My Sepal Length-Width")

# 2 ggplot2 plot 1
library(ggplot2)
scatter <- ggplot(data=iris, aes(x = Sepal.Length, y = Sepal.Width)) 
scatter

scatter + geom_point(aes(color=Species, shape=Species)) +
  xlab("Sepal Length") +  ylab("Sepal Width") +
  ggtitle("Sepal Length-Width")

# 3 ggplot2 plot 2
scatter + geom_point(aes(color = Petal.Width, shape = Species), size = 4, alpha = I(1/2)) +
  geom_vline(aes(xintercept = mean(Sepal.Length)), color = "red", linetype = "dashed") +
  geom_hline(aes(yintercept = mean(Sepal.Width)), color = "red", linetype = "dashed") +
  scale_color_gradient(low = "yellow", high = "red") +
  xlab("Sepal Length") +  ylab("Sepal Width") +
  ggtitle("Sepal Length-Width")

####Section 2 | Box Plot

# 1 R basic plot
boxplot(Sepal.Length~Species,data=iris, 
        xlab="Species", ylab="Sepal Length", main="Iris Boxplot")

# 2 ggplot2 plot
library(ggplot2)
box <- ggplot(data=iris, aes(x=Species, y=Sepal.Length))
box
box + geom_boxplot(aes(fill=Species)) + 
  ylab("Sepal Length") + ggtitle("Iris Boxplot") +
  stat_summary(fun.y=mean, geom="point", shape=5, size=4) 


####Section 3 | Histogram
# 1 R basic plot
hist(iris$Sepal.Width, freq=NULL, density=NULL, breaks=12,
     xlab="Sepal Width", ylab="Frequency", main="Histogram of Sepal Width")

# 2 ggplot2 plot
library(ggplot2)
histogram <- ggplot(data=iris, aes(x=Sepal.Width))
histogram + geom_histogram(binwidth=0.2, color="black", aes(fill=Species)) + 
  xlab("Sepal Width") +  ylab("Frequency") + ggtitle("Histogram of Sepal Width")


####Saving histogram plot
browseURL("https://ggplot2.tidyverse.org/reference/ggsave.html")
getwd()
setwd(choose.dir())
ggsave("histogram.jpg", width = 80, height = 40, units = "cm")


#Additional resources to support chart creation
browseURL("https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf")
browseURL("https://ggplot2.tidyverse.org/")
browseURL("http://www.sthda.com/english/wiki/ggplot2-error-bars-quick-start-guide-r-software-and-data-visualization")
