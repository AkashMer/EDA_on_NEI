# This file provides the function which output a plot
# This plot answers the question,
# Which Of the four types of sources have seen decreases in emissions
# from 1999–2008 for Baltimore City?
# Which have seen increases in emissions from 1999–2008

plot3 <- function() {
    # Download if required and loading in the ggplot2 package
    if(system.file(package = "ggplot2") == "") install.packages("ggplot2")
    library(ggplot2)
    
    # Reading in the data
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    
    # Subsetting the data to only include Baltimore city data
    NEIBaltimore <- subset(NEI, NEI$fips == "24510")
    
    # Converting the type column into a factor with descriptive levels
    NEIBaltimore$type <- factor(NEIBaltimore$type, levels = unique(NEIBaltimore$type),
                                labels = c("Point", "Non Point",
                                           "On Road", "Non Road"))
    
    # Creating the ggplot object for the plot
    g <- ggplot(data = NEIBaltimore, aes(year, Emissions, color = type))
    
    # Opening a png device
    png("./plots/plot3.png", width = 1080, height = 720, res = 150)
    
    # Printing the plot of total emissions per year
    # for each source to check the trend
    print(g +
        # Plots the total emissions for each year as points
        stat_summary(fun = sum, geom = "point", size = 2.25) +
        # Combines all the points with a line
        stat_summary(fun = sum, geom = "path", linewidth = 1) +
        # Divides the plot into panels, each representing different type of source
        facet_grid(.~type) +
        # Changing the x-axis labels to represent when data was measured
        scale_x_continuous(breaks = unique(NEIBaltimore$year)) +
        # Providing descriptive titles to the axes and the plot
        labs(title = expression("Total PM"[2.5]*" Emissions for each type of Source by year"),
             x = "Years", y = expression("Total PM"[2.5]*" Emissions (tons)"),
             subtitle = "Baltimore City, Maryland") +
        # Changing the theme to black and white
        theme_bw(base_size = 12) +
        # Removes the legend and increases spacing between panels
        theme(legend.position = "none", panel.spacing = unit(0.8, "cm"))
    )
    
    # Closing the PNG Device
    dev.off()
}
