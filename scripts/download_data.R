# This file downloads and unzips the data required for the 
# Exploratory Data Analysis

download_data <- function() {
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    temp <- tempfile()
    download.file(fileURL, temp, method = "curl")
    unzip(temp, exdir = "./data") # Extracts the data
    unlink(temp) # Deletes the zipfile
}