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
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 emission from all 
#sources for each of the years 1999, 2002, 2005, and 2008.

nei_plot <- transform(NEI, year = factor(year))
png(file="plot1.png",width = 480, height = 480, units = "px")
boxplot(Emissions ~ year, nei_plot, xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "PM2.5 Emissions in the US")

dev.off()
