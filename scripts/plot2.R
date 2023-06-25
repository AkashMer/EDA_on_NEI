# This file provides the function which output a plot
# This plot answers the question,
# Have total emissions from PM2.5 decreased
# in the Baltimore City, Maryland from 1999 to 2008?

plot2 <- function() {
    # Reading in the data
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    
    # Subsetting the data to only include Baltimore city data
    NEIBaltimore <- subset(NEI, NEI$fips == "24510")
    
    # Converting the year column as a factor
    NEIBaltimore$year <- as.factor(NEIBaltimore$year)
    
    # Calculating the total PM2.5 emissions in each year for Baltimore City
    TotalEmissionsperYear <- tapply(NEIBaltimore$Emissions, NEIBaltimore$year, sum)
    
    # Opening a png device
    png("./plots/plot2.png", width = 480, height = 480)
    
    # Adjusting the margins and increasing the size of axis ticks,
    # axis labels and main title
    par(mar = c(5,5,4,2), cex.main = 1.3, cex.lab = 1.3, cex.axis = 1.2)
    
    # Using the base plotting system,
    # comparing the total emissions for each year in Baltimore City
    plot(1:4, TotalEmissionsperYear, type = "b",
         xlab = "Years", ylab = expression("Total PM"[2.5]*" Emissions (tons)"),
         col = "red3", pch = 4, xaxt = "n", lwd = 2)
    # Adding the X axis
    axis(1, at = 1:4, labels = levels(NEIBaltimore$year))
    # Adding the main title of the plot
    title(main = expression("Total PM"[2.5]*
                                " Emissions from 1999 to 2008 in Baltimore City"))
    
    # Closing the PNG Device
    dev.off()
}