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
list.of.packages <- c("ggplot2","gridExtra")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
rm(list.of.packages,new.packages)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
#in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor 
#vehicle emissions?
nei_baltimore <-  NEI[NEI$fips == "24510",]
nei_la <-  NEI[NEI$fips == "06037",]

#get all vehicle indices and SCC codes
vehicles_indices <- grep("Vehicles",SCC$EI.Sector)
vehicles <- SCC[vehicles_indices,]
vehicles$SCC <- as.character(vehicles$SCC)
vehicles_scc <- vehicles$SCC

#subset all vehicle sources using their SCC code
baltimore_vehicles <- nei_baltimore[nei_baltimore$SCC %in% vehicles_scc, ]
la_vehicles <- nei_la[nei_la$SCC %in% vehicles_scc, ]

g3 <- ggplot(baltimore_vehicles, aes(year,Emissions))
balti_vehicles <- g3 + geom_point(color = "steelblue") + labs(title = "Motor Vehicle Emissions in Baltimore City") +
  labs(x = "Year", y = "PM2.5 Emissions (tons)") + geom_smooth(method = "lm")  

g4 <- ggplot(la_vehicles, aes(year,Emissions))
l_vehicles <- g4 + geom_point(color = "red") + labs(title = "Motor Vehicle Emissions in Los Angeles") +
  labs(x = "Year", y = "PM2.5 Emissions (tons)") + geom_smooth(method = "lm")  

require(gridExtra)
grid.arrange(balti_vehicles, l_vehicles, nrow=2)
png(file="plot6.png", width = 480, height = 480, units = "px")
grid.arrange(balti_vehicles, l_vehicles)
dev.off()