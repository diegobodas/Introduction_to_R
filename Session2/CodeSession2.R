###############################################################################
# Date: 29/09/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: CodeSession2.R
# Description: Basic Statistic (R course)
##############################################################################

# ----- Get Data -----

# I want to find my files!!!
setwd("/your_path/")

# Load data from the.path
LoadFlightData <- function(the.path){
  # set ColClasses
  colVuelo = c("Year" = "integer",
               "Month" = "integer",
               "DayofMonth" = "integer",
               "DayOfWeek" = "integer",
               "DepTime" = "integer",
               "CRSDepTime" = "integer",
               "ArrTime" = "integer",
               "CRSArrTime" = "integer",
               "UniqueCarrier" = "character",
               "FlightNum" = "integer",
               "TailNum" = "character",
               "ActualElapsedTime" = "integer",
               "CRSElapsedTime" = "integer",
               "AirTime" = "integer",
               "ArrDelay" = "integer",
               "DepDelay" = "integer",
               "Origin" = "character",
               "Dest" = "character",
               "Distance" = "integer",
               "TaxiIn" = "integer",
               "TaxiOut" = "integer",
               "Cancelled" = "integer",
               "CancellationCode" = "character",
               "Diverted" = "integer",
               "CarrierDelay" = "integer",
               "WeatherDelay" = "integer",
               "NASDelay" = "integer",
               "SecurityDelay" = "integer",
               "LateAircraftDelay" = "integer")
  
  return(read.csv(the.path, header = TRUE, colClasses = colVuelo))
}

flight.data <- LoadFlightData("inputData/2006.csv")

# ----- Get basic information -----

# start rows
head(flight.data, 10)
# last rows
tail(flight.data, 10)

# mean and sd departure delay
mean.departure.delay = mean(flight.data$DepDelay)
mean.departure.delay #Opppssss!!!!! NA!!!!!!!!!!!
# 2 options
mean.departure.delay = mean(flight.data$DepDelay, na.rm = TRUE) # forget NAs
# or
flight.data[is.na(flight.data)] <- 0 # NAs = 0
# different values because n is greater
mean.departure.delay = mean(flight.data$DepDelay)
# sd
sd.departure.delay = sd(flight.data$DepDelay)
# summary information
summary(flight.data)

# quantiles
quantile(flight.data$DepDelay)
# median
median(flight.data$DepDelay, na.rm = TRUE)

# mode... Ahhhh, sorry, not standard function
GetMode <- function(the.data) {
  # extract unique elements
  uniqv <- unique(the.data)
  # tabulate takes the integer-valued vector bin and counts 
  # the number of times each integer occurs in it
  # which.max: Determines the location, i.e., index of 
  # the (first) minimum or maximum of a numeric (or logical) vector
  uniqv[which.max(tabulate(match(the.data, uniqv)))]
}

mode.depdelay <- GetMode(flight.data$DepDelay)

# ----- Time to plot -----

# Very basic plot
plot(flight.data$DepDelay[1:1000])
# histogram
hist(flight.data$DepDelay[1:1000], main = "Histogram for Departure Delay")
# Add Density plot
density.depdelay <- density(flight.data$DepDelay[1:1000])
plot(density.depdelay)
# NO NO NOOOOOOO
# I want to plot in the histogram
# try again
# prob = TRUE for probalities, not counts
hist(flight.data$DepDelay[1:1000], prob = TRUE, main = "Histogram for Departure Delay", col = "grey")
lines(density.depdelay, col = "blue", lwd = 2)
# ummmmmm, what is happening at top of the curce
hist(flight.data$DepDelay[1:1000], prob = TRUE, main = "Histogram for Departure Delay", 
     col = "grey", ylim = c(0, 0.08), ylab = 'Probability')
lines(density.depdelay, col = "blue", lwd = 2) # Well done!!!

# Simple Pie Chart
# Combine as table
pie(table(flight.data$Origin[1:100]), main = "Origins pie chart")

# Boxplot of Arrive Delay by Departure Delay  
boxplot(ArrDelay ~ DepDelay, data = flight.data[1:100,], main = "ArrDelay vs DepDelay", 
xlab = "DeepDelay", ylab = "ArrDelay")

# Boxplot of Arrive Delay by Departure Delay  
boxplot(ArrDelay ~ Origin, data = flight.data[1:100,], main = "ArrDelay vs Origin", 
        xlab = "Origin", ylab = "ArrDelay")

