## 1. Set working directory & ensure required packages are installed & loaded -----------

setwd("enter path of working directory path here")

require.packages("gsubfn")
require.packages("tidyr")

library(gsubfn)
library(tidyr)

## 2. Download and unzip the data files ----------------------------------------

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "Datafile.zip")
dateDownloaded <- date()
unzip("Datafile.zip")
file.remove("Datafile.zip")
rm(fileUrl)

## 3. Read relevant part of dataset into R & create appropriate dataframe ---------

# define date range of rows to read
regexp <- "(^1/2/2007.+$|^2/2/2007.+$)"
electric <- read.pattern("household_power_consumption.txt", pattern = regexp) # 2880 obs.

# read in variable names
varNames <- read.table("household_power_consumption.txt", nrow =1, sep = ";")
varNames <- as.vector(unlist(varNames))

# divide 'electric' dataframe into 9 variables
elec <- separate(electric, V1, into = varNames, sep = ";", convert = TRUE)

# create one date/time variable of POSIX class
elec$Time2 <- paste(elec$Date, elec$Time)
elec$Time2 <- strptime(elec$Time2, "%d/%m/%Y %H:%M:%S")

## 4. Generate plot in png file device ------------------------------------

png(file = "plot3.png")

plot(elec$Time2, elec$Sub_metering_1, type = "l", xlab="", 
     ylab="Energy sub metering")
par(new=T)
plot(elec$Time2, elec$Sub_metering_2, type = "l", ylim = c(0,40), 
     axes=F, xlab="", ylab="", col = "red")
par(new=T)
plot(elec$Time2, elec$Sub_metering_3, type = "l", ylim = c(0,40), 
     axes=F, xlab="", ylab="", col = "blue")
legend("topright", lty = c(1,1), col = c("black", "red", "blue"), legend = names(elec[7:9]))

dev.off()