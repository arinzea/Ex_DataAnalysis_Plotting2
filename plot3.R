#setwd("~/")
if(!file.exists("EDA-Project-Data2")){
  dir.create("EDA-Project-Data2")
}
#Download the dataset
downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(downloadUrl,"./EDA-Project-Data2/project2-PM25.zip")

#unzip it
if (!file.exists("EDA-Project-Data2")) { 
  unzip("./EDA-Project-Data2/project2-PM25.zip")
}
#install needed packages
list.of.packages <- c("ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
rm(list.of.packages,new.packages)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
#3

#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a
#plot answer this question.

#get Baltimore data
nei_baltimore <-  NEI[NEI$fips == "24510",]
nei_baltimore$type <- factor(nei_baltimore$type)
png(file="plot3.png",width = 680, height = 480, units = "px")
balti <- ggplot(nei_baltimore, aes(year,Emissions))
p <- balti + geom_point() + facet_grid(.~ type) + labs(title = " Emission Sources in Baltimore City") +
  labs(x = "Year", y = "PM2.5 Emissions (tons)") + geom_smooth(method = "lm")  
print(p)
dev.off()