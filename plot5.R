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

#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

#get baltimore data
nei_baltimore <-  NEI[NEI$fips == "24510",]

#get all vehicle indices and SCC codes
vehicles_indices <- grep("Vehicles",SCC$EI.Sector)
vehicles <- SCC[vehicles_indices,]
vehicles$SCC <- as.character(vehicles$SCC)
vehicles_scc <- vehicles$SCC

#subset all vehicle sources using their SCC code
baltimore_vehicles <- nei_baltimore[nei_baltimore$SCC %in% vehicles_scc, ]
baltimore_vehicles$type <- as.factor(baltimore_vehicles$type)
#plotting
png(file="plot5.png",width = 480, height = 480, units = "px")
g2 <- ggplot(baltimore_vehicles, aes(year,Emissions))
baltimore_vehicles <- g2 + geom_point(color = "steelblue") + labs(title = "Motor Vehicle Emissions in Baltimore City") +
  labs(x = "Year", y = "PM2.5 Emissions (tons)") + geom_smooth(method = "lm")  
print(baltimore_vehicles)
dev.off()
