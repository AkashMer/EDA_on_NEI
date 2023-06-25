## Exploratory Data Analysis for NEI data

This exploratory data analysis was done as part of a course project

Descriptions of files and directories in this repository,

-   **data** : Directory containing the data used for the Exploratory Data Analysis. The data was obtained from [EPA National Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

    Specifically the data provided from the following link,

    [Data for Peer Assessment](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)

    It contains 2 files,

    1.  **PM2.5 Emissions Data** (`summarySCC_PM25.rds`) : This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of **tons** of PM2.5 emitted from a specific type of source for the entire year.
        -   **fips**: A five-digit number (represented as a string) indicating the U.S. county

        -   **SCC:** The name of the source as indicated by a digit string (see source code classification table)

        -   **Pollutant**: A string indicating the pollutant

        -   **Emissions**: Amount of PM2.5 emitted, in tons

        -   **type**: The type of source (point, non-point, on-road, or non-road)

        -   **year**: The year of emissions recorded\
    2.  **Source Classification Code Table** `(Source_Classification_Code.rds)` : This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source "10100101" is known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".

-   **scripts :** Directory containing the scripts which perform the following tasks,

    1.  **download_data.R** : Provides a function - `download_data()` which downloads and unzips the data required for the Exploratory Data Analysis

    2.  **plot1.R** : Provides the `plot1()` function which outputs a plot, which answers the question,

        *Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?*

    3.  **plot2.R** : Provides the `plot2()` function which outputs a plot for the question,

        *Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?*

    4.  **plot3.R** : Provides the `plot3()` function which outputs a plot which answers the question,

        *Which Of the four types of sources have seen decreases in emissions from 1999--2008 for Baltimore City? Which have seen increases in emissions from 1999--2008?*

    5.  **plot4.R** : Provides the `plot4()` function which outputs a plot which answers the question,

        *How have emissions from coal combustion-related sources changed from 1999--2008?*

    6.  **plot5.R** : Provides the `plot5()` function which outputs a plot which answers the question,

        *How have emissions from motor vehicle sources changed from 1999--2008 in Baltimore City?*

    7.  **plot6.R** : Provides the `plot6()` function which outputs a plot which answers the question,

        *Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. Which city has seen greater changes over time in motor vehicle emissions?*

-   **plot**s : Directory containing all the plots corresponding to the questions mentioned above
