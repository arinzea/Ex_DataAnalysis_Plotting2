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
#Across the United States, how have emissions from coal combustion-related sources changed from 
#1999–2008?

#get all coal indices and SCC codes
coal_indices <- grep("Coal",SCC$EI.Sector)
coal <- SCC[coal_indices,]
coal$SCC <- as.character(coal$SCC)
coal_scc <- coal$SCC

#subset all coal combustions using their SCC code
nei_coal <- NEI[NEI$SCC %in% coal_scc, ]
nei_coal$type <- as.factor(nei_coal$type)

png(file="plot4.png",width = 480, height = 480, units = "px")
g1 <- ggplot(nei_coal, aes(year,Emissions))
us_coal <- g1 + geom_point(aes(color = type)) + labs(title = "Coal Emissions in the US") + 
  labs(x = "Year", y = "PM2.5 Emissions (tons)")  
print(us_coal)
dev.off()