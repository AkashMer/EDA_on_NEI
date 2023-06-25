# This file provides the function which outputs a plot
# This plot answers the question,
# Have total emissions from PM2.5 decreased
# in the United States from 1999 to 2008?

plot1 <- function() {
    # Reading in the data
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    
    # Converting the year column as a factor
    NEI$year <- as.factor(NEI$year)
    
    # Calculating the total PM2.5 emissions in each year
    TotalEmissionsperYear <- tapply(NEI$Emissions, NEI$year, sum)
    
    # Converting Total emissions in megatons for easier visualization
    TotalEmissionsperYear <- TotalEmissionsperYear / 10^6
    
    # Opening a png device
    png("./plots/plot1.png", width = 480, height = 480)
    
    # Adjusting the margins and increasing the size of axis ticks,
    # axis labels and main title
    par(mar = c(5,5,4,2), cex.main = 1.5, cex.lab = 1.3, cex.axis = 1.2)
    
    # Using the base plotting system,
    # comparing the total emissions for each year
    plot(1:4, TotalEmissionsperYear, type = "b",
         xlab = "Years", ylab = expression("Total PM"[2.5]*" Emissions (megatons)"),
         col = "red3", pch = 4, xaxt = "n", lwd = 2)
    # Adding a custom axis which only mentions the years for which data was
    # measured
    axis(1, at = 1:4, labels = levels(NEI$year))
    # Adding the title to the plot
    title(main = expression("Fall of total PM"[2.5]*
                                " Emissions from 1999 to 2008"))
    
    # Closing the PNG device
    dev.off()
}