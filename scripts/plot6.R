# This file provides the function which output a plot
# This plot answers the question,
# Compare emissions from motor vehicle sources in Baltimore City
# with emissions from motor vehicle sources in Los Angeles County, California

plot6 <- function() {
    # Download if required and loading in the ggplot2 package
    if(system.file(package = "ggplot2") == "") install.packages("ggplot2")
    if(system.file(package = "cowplot") == "") install.packages("cowplot")
    if(system.file(package = "dplyr") == "") install.packages("dplyr")
    library(ggplot2)
    library(cowplot)
    library(dplyr)
    
    # Reading in the data
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    SCC <- readRDS("./data/Source_Classification_Code.rds")
    
    # Finding out which Source Code corresponds to motor vehicle sources
    vehicleSCC <- SCC$SCC[grep("[Vv]ehicle", SCC$SCC.Level.Two)]
    
    # Subsetting the data to only include data from motor vehicle sources in
    # Baltimore City & Los Angeles County
    vehicleNEI <- subset(NEI, NEI$SCC %in% vehicleSCC & (NEI$fips == "24510" |
                                                             NEI$fips == "06037"))
    
    # Adding a variable city which converts the fips variable
    # into a factor with descriptive labels
    vehicleNEI$city <- factor(vehicleNEI$fips, levels = c("24510", "06037"),
                              labels = c("Baltimore City","Los Angeles"))
    
    
    # Summarizing the data as total Emissions for each city for each year
    res <- summarise(vehicleNEI,
                     total = sum(Emissions),
                     .by = c("city", "year"))
    
    # Dividing the summary into 2 cities for easier comparison
    # Adding the change in total emissions as compared to previous year
    # Adding the percent change in total emissions as compared to previous year
    Baltimoreres <- res %>%
        filter(city == "Baltimore City") %>%
        mutate(change = total - lag(total)) %>%
        mutate(percentchange = ((total/lag(total)) - 1)*100)
    LAres <- res %>%
        filter(city == "Los Angeles") %>%
        mutate(change = total - lag(total)) %>%
        mutate(percentchange = ((total/lag(total)) - 1)*100)
    
    # Plot for the combined data from both cities
    # x axis represents years
    # y axis the total Emissions in tons
    # Different colors represent different cities
    combined <- ggplot(res, aes(year, total, color = city)) +
        # Plotting the totals and a line through the points
        geom_point(size = 3) + geom_path(linewidth = 1) +
        # Dividing the plot into 2 panels by city
        facet_grid(.~city) +
        # Changing the x-axis labels to represent when data was measured
        scale_x_continuous(breaks = unique(vehicleNEI$year)) +
        # Providing descriptive titles to the axes and the plot
        labs(title = expression("Total PM"[2.5]*" emissions from motor vehicles")) +
        labs(x = "Years", y = expression("Total PM"[2.5]*" Emissions (tons)")) +
        # Changing the theme to black and white
        theme_bw(base_size = 14) +
        # Prevents the printing of legend
        theme(legend.position = "none")
    
    # Plot for Baltimore city total emissions from motor vehicles
    baltimore <- ggplot(data = Baltimoreres) +
        # Plots the total against year with points
        geom_point(aes(year, total), color = "#F8766D", size = 3) +
        # Joins the above points with a line
        geom_path(aes(year, total), color = "#F8766D", linewidth = 1) +
        # Plots the difference between the current total and previous total
        # with color representing a decrease or increase in total emissions
        geom_col(aes(year, change, fill = change < 0),
                 na.rm = TRUE, alpha = 0.5) +
        # Changes the default colors, labels and title for the legend
        scale_fill_manual("Change from previous measurement",
                          values = c("green", "orange"),
                          labels = c("Decrease", "Increase")) +
        # Plots the percentage change in total emissions from previous year
        # as a text positioned at the middle of the change bar
        geom_text(aes(year, change),
                  label = paste0(round(Baltimoreres$percentchange), "%"),
                  na.rm = TRUE,
                  nudge_y = -Baltimoreres$change/2, size = 5) +
        # Changing the x-axis labels to represent when data was measured
        scale_x_continuous(breaks = unique(Baltimoreres$year)) +
        # Providing descriptive titles to the axes and the plot
        labs(subtitle = "Baltimore City, Maryland") +
        labs(x = "Years", y = expression("Total PM"[2.5]*" Emissions (tons)")) +
        # Changes the theme to black and white
        theme_bw(base_size = 14) +
        # Prevents from printing the legend
        theme(legend.position = "none")
    
    # Plot for Los Angeles total emissions from motor vehicles
    losangeles <- ggplot(data = LAres) +
        # Plots the total against year with points
        geom_point(aes(year, total), color = "#00BFC4", size = 3) +
        # Joins the above points with a line
        geom_path(aes(year, total), color = "#00BFC4", linewidth = 1) +
        # Plots the difference between the current total and previous total
        # with color representing a decrease or increase in total emissions
        geom_col(aes(year, change, fill = change < 0),
                 na.rm = TRUE, alpha = 0.5) +
        # Changes the default colors, labels and title for the legend
        scale_fill_manual("Change from previous measurement",
                          values = c("orange", "green"),
                          labels = c("Increase", "Decrease")) +
        # Plots the percentage change in total emissions from previous year
        # as a text positioned at the middle of the change bar
        geom_text(aes(year, change),
                  label = paste0(round(LAres$percentchange), "%"),
                  na.rm = TRUE,
                  nudge_y = -LAres$change/2, size = 5) +
        # Changing the x-axis labels to represent when data was measured
        scale_x_continuous(breaks = unique(LAres$year)) +
        # Providing descriptive titles to the axes and the plot
        labs(subtitle = "Los Angeles County, California") +
        labs(x = "Years", y = expression("Total PM"[2.5]*" Emissions (tons)")) +
        # Changes the theme to black and white
        theme_bw(base_size = 14) +
        # Prevents from printing the legend
        theme(legend.position = "none")
    
    # Extracting the legend that is layed out horizontally 
    # from either of the city plots to plot later
    legend_change <- get_legend(
        losangeles +
            theme(legend.position = "bottom")
    )
    
    # Putting the bottom row together for the final plot
    bottomplots <- plot_grid(baltimore, losangeles,
                             nrow = 1, rel_widths = c(1,1))
    
    # Opening a png device
    png("./plots/plot6.png", width = 1080, height = 1440, res = 150)
    
    # Plotting both plots to the PNG device
    print(plot_grid(combined, bottomplots, legend_change,
              ncol = 1, rel_heights = c(1,1,0.1)))
    
    # Closing the PNG Device
    dev.off()
}
