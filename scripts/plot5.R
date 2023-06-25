# This file provides the function which output a plot
# This plot answers the question,
# How have emissions from motor vehicle sources changed from 1999–2008
# in Baltimore City?

plot5 <- function() {
    # Download if required and loading in the ggplot2 package
    if(system.file(package = "ggplot2") == "") install.packages("ggplot2")
    if(system.file(package = "cowplot") == "") install.packages("cowplot")
    library(ggplot2)
    library(cowplot)
    
    # Reading in the data
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    SCC <- readRDS("./data/Source_Classification_Code.rds")
    
    # Finding out which Source Code corresponds to motor vehicle sources
    vehicleSCC <- SCC$SCC[grep("[Vv]ehicle", SCC$SCC.Level.Two)]
    
    # Subsetting the data to only include data from motor vehicle sources in
    # Baltimore City
    vehicleNEI <- subset(NEI, NEI$SCC %in% vehicleSCC & NEI$fips == "24510")
    
    # Converting the type column into a factor with descriptive levels
    vehicleNEI$type <- factor(vehicleNEI$type, levels = unique(vehicleNEI$type),
                           labels = c("On Road", "Non Road"))
    
    # Creating the ggplot object for the plot with year on x axis
    # and Emissions in tons on y axis
    g <- ggplot(data = vehicleNEI, aes(year, Emissions))
    
    # Plots the trend of total emissions from motor vehicles
    # each year in Baltimore city
    total <- g +
        # # Plots the total emissions for each year as points
        stat_summary(fun = sum, size = 1) +
        # Connects the points as a line
        stat_summary(fun = sum, geom = "path", linewidth = 1, color = "blue") +
        # Changing the x-axis labels to represent when data was measured
        scale_x_continuous(breaks = unique(vehicleNEI$year)) +
        # Providing descriptive titles to the axes and the plot
        labs(title = "Changes in motor vehicle emissions in Baltimore City, Maryland",
             subtitle = expression("Total PM"[2.5]*" emissions from "*
                                       "for each year")) +
        labs(x = "Years", y = expression("Total PM"[2.5]*" Emissions (tons)")) +
        # Changing the theme to black and white
        theme_bw(base_size = 14)
    
    # Plots the total emissions from motor vehicles for each type of
    # source for each year
    totalbytype <- g +
        # Adding the color aesthetic for type of source
        aes(group = type, color = type) +
        # Plots the total emissions for each year as points
        stat_summary(fun = sum, size = 1) +
        # Connects the points as a line
        stat_summary(fun = sum, geom = "path", linewidth = 1) +
        # Divides the plot into panels for each type of source
        facet_grid(.~type, scales = "free") +
        # Changing the x-axis labels to represent when data was measured
        scale_x_continuous(breaks = unique(vehicleNEI$year)) +
        # Providing descriptive titles to the axes and the plot
        labs(subtitle = expression("Total PM"[2.5]*" Emissions"*
                                       " for each type of source per year"),
             x = "Years", y = expression("Total PM"[2.5]*" Emissions"*
                                             " (tons)")) +
        # Changing the theme to black and white
        theme_bw(base_size = 14) +
        # Removes the legend and increases spacing between panels
        theme(legend.position = "none", panel.spacing = unit(0.8, "cm"))
    
    # Opening a png device
    png("./plots/plot5.png", width = 1080, height = 1440, res = 150)
    
    # Plotting both plots to the PNG device
    print(plot_grid(total, totalbytype, nrow = 2))
    
    # Closing the PNG Device
    dev.off()
}