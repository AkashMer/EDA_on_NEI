# This file provides the function which output a plot
# This plot answers the question,
# How have emissions from coal combustion-related sources changed from 1999–2008?

plot4 <- function() {
    # Download if required and loading in the ggplot2 package
    if(system.file(package = "ggplot2") == "") install.packages("ggplot2")
    if(system.file(package = "cowplot") == "") install.packages("cowplot")
    library(ggplot2)
    library(cowplot)
    
    # Reading in the data
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    SCC <- readRDS("./data/Source_Classification_Code.rds")
    
    # Finding out which Source Code corresponds to coal combustion sources
    coalSCC <- SCC$SCC[grep("Coal", SCC$EI.Sector)]
    
    # Subsetting to only include data from coal combustion sources
    coalNEI <- subset(NEI, NEI$SCC %in% coalSCC)
    
    # Converting the type column into a factor with descriptive levels
    coalNEI$type <- factor(coalNEI$type, levels = unique(coalNEI$type),
                                labels = c("Point", "Non Point"))
    
    # Creating the ggplot object for the plot with year on x axis
    # and Emissions in kilo Tons on y axis
    g <- ggplot(data = coalNEI, aes(year, Emissions/10^3))
    
    # Plots the total emissions per year from coal combustion sources
    # to check the trend
    total <- g +
        # Plots the total emissions for each year as points
        stat_summary(fun = sum, size = 1) +
        # Connects the points as a line
        stat_summary(fun = sum, geom = "path", linewidth = 1, color = "blue") +
        # Changing the x-axis labels to represent when data was measured
        scale_x_continuous(breaks = unique(coalNEI$year)) +
        # Providing descriptive titles to the axes and the plot
        labs(title = "Changes in coal combustion emissions",
             subtitle = expression("Total PM"[2.5]*" Emissions"*
                                    " from coal combustion sources"*
                                    " for each year"),
             x = "Years", y = expression("Total PM"[2.5]*" Emissions"*
                                            " (kilotons)")) +
        # Changing the theme to black and white
        theme_bw(base_size = 14)
    
    # Plots the total emissions from coal combustion sources for each type of
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
        scale_x_continuous(breaks = unique(coalNEI$year)) +
        # Providing descriptive titles to the axes and the plot
        labs(subtitle = expression("Total PM"[2.5]*" Emissions"*
                                    " from coal combustion sources"*
                                    " for each type of source"),
             x = "Years", y = expression("Total PM"[2.5]*" Emissions"*
                                            " (kilotons)")) +
        # Changing the theme to black and white
        theme_bw(base_size = 12) +
        # Removes the legend and increases spacing between panels
        theme(legend.position = "none", panel.spacing = unit(0.8, "cm"))
    
    # Opening a png device
    png("./plots/plot4.png", width = 1080, height = 1440, res = 150)
    
    # Plotting both plots to the PNG device
    print(plot_grid(total, totalbytype, nrow = 2))
    
    # Closing the PNG Device
    dev.off()
}