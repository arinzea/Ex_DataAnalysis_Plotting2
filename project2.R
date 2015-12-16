
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


dir()
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 emission from all 
#sources for each of the years 1999, 2002, 2005, and 2008.

plot(NEI$Emissions,NEI$year ,type = "l", ylab = "PM2.5 Emission",xlab = "Year")

nei_plot <- transform(NEI, year = factor(year))
boxplot(Emissions ~ year, nei_plot, xlab = "Year", ylab = "Emissions (PM2.5)")
dev.copy(png,file="plot1.png",width = 480, height = 480)
dev.off()

#2
#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
#from 1999 to 2008? Use the base plotting system to make a plot answering this question.
nei_baltimore <-  NEI[NEI$fips == "24510",]
boxplot(Emissions ~ year, nei_baltimore, xlab = "Year", ylab = "Emissions (PM2.5)",main = "Baltimore Emissions")
dev.copy(png,file="plot2.png",width = 480, height = 480)
dev.off()

library(ggplot2)
#3

#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a
#plot answer this question.
str(nei_baltimore)
nei_baltimore$type <- factor(nei_baltimore$type)

balti <- ggplot(nei_baltimore, aes(year,Emissions))
p <- balti + geom_point() + facet_grid(.~ type) + geom_smooth(method = "lm")
print(p)
dev.copy(png,file="plot3.png",width = 480, height = 480)
dev.off()


#4
#Across the United States, how have emissions from coal combustion-related sources changed from 
#1999–2008?

#get all coal indices and SCC codes
coal_indices <- grep("Coal",SCC$EI.Sector)
coal <- SCC[coal_indices,]
coal$SCC <- as.character(coal$SCC)
coal_scc <- coal$SCC

#subset all coal combustions using their SCC code
nei_coal <- NEI[NEI$SCC %in% coal_scc, ]
str(nei_coal)
nei_coal$type <- as.factor(nei_coal$type)
g1 <- ggplot(nei_coal, aes(year,Emissions))
us_coal <- g1 + geom_point(aes(color = type)) + labs(title = "Coal Emissions in the US") + 
  labs(x = "Year", y = "PM2.5 Emissions (tons)")  
print(us_coal)
dev.copy(png,file="plot4.png",width = 480, height = 480)
dev.off()

#5
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
g2 <- ggplot(baltimore_vehicles, aes(year,Emissions))
baltimore_vehicles <- g2 + geom_point(color = "steelblue") + labs(title = "Motor Vehicle Emissions in Baltimore City") +
  labs(x = "Year", y = "PM2.5 Emissions (tons)") + geom_smooth(method = "lm")  
print(baltimore_vehicles)
dev.copy(png,file="plot5.png",width = 480, height = 480)
dev.off()


#6
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
par(mfrow = c(1,2))
g3 <- ggplot(baltimore_vehicles, aes(year,Emissions))
balti_vehicles <- g3 + geom_point(color = "steelblue") + labs(title = "Motor Vehicle Emissions in Baltimore City") +
  labs(x = "Year", y = "PM2.5 Emissions (tons)") + geom_smooth(method = "lm")  
print(balti_vehicles)

g4 <- ggplot(la_vehicles, aes(year,Emissions))
l_vehicles <- g4 + geom_point(color = "red") + labs(title = "Motor Vehicle Emissions in Los Angeles") +
  labs(x = "Year", y = "PM2.5 Emissions (tons)") + geom_smooth(method = "lm")  
print(l_vehicles, balti_vehicles)

require(gridExtra)

grid.arrange(balti_vehicles, l_vehicles, ncol=2)
png(file="plot6.png", width = 480, height = 480, units = "px")
grid.arrange(balti_vehicles, l_vehicles)

dev.copy(png,file="plot6.png",width = 480, height = 480)
dev.off()

# (g_balt_la <- ggplot(baltimore_vehicles, aes(year, Emissions)) + 
#   geom_point() +
#   geom_step(data = la_vehicles)
# )

lines(hh$Date_Time,hh$Sub_metering_2,type = "l",col = "red")
lines(hh$Date_Time,hh$Sub_metering_3,type = "l",col = "blue")
legend("topright",cex = 0.8, lty = c(1,1,1),col = c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty = "n")

png(file="plot1.png", width = 480, height = 480, units = "px")

