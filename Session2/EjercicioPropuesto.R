###############################################################################
# Date: 12/05/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: EjercicioPropuesto.R
# Description: analyze arrival and departure delays (R course)
##############################################################################

# ----- Libraries section -----
library(data.table)

# ----- Get Data -----
# data from: http://stat-computing.org/dataexpo/2009/the-data.html (2006 data)

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
  
  return(fread(the.path, header = TRUE, 
               colClasses = c("integer", "integer", "integer", 
                              "integer", "integer", "integer", 
                              "integer", "integer", "character", 
                              "character", "character", "character", 
                              "character", "character", "character", 
                              "character", "character", "character", 
                              "character", "character", "character", 
                              "character", "character", "character", 
                              "character", "character","character",
                              "character", "character")))
}

# 1: fast load data
flight.data <- LoadFlightData("inputData/2006.csv")
##################################################################################

# ----- Analyze data -----

# how many different origins are there?
length(unique(flight.data$Origin))
# and Dest?
length(unique(flight.data$Dest))
# Obtain airports in origin but not in destinations
# set operations
origin.not.dest <- setdiff(flight.data$Origin, flight.data$Dest)
# check, look for CKB in Dest
find.dest <- flight.data[Dest == "CKB"] # 0 values, well done
# the same (on the contrary...)
dest.not.origin <- setdiff(flight.data$Dest, flight.data$Origin)
# check one value
find.origin <- flight.data[Origin == "LBF"] # 0 values, well done
find.origin <- flight.data[Origin %in% dest.not.origin]

##################################################################################
str(flight.data) #### uhmmmmm there are characters!!!!!
flight.data[, c("ArrDelay", "DepDelay") := list(as.numeric(ArrDelay), as.numeric(DepDelay))]
str(flight.data) #### Check, ok. Now, they are integers
# Analyze Months variation
monthly.delay.flight.data <- flight.data[, j = list(meanArrDelay = mean(ArrDelay, na.rm = TRUE), 
                                                    meanDepDelay = mean(DepDelay, na.rm = TRUE)), 
                                         by = list(Month)]

# By Month and origin airport
monthly.origin.delay.flight.data <- flight.data[, j = list(meanArrDelay = mean(ArrDelay, na.rm = TRUE), 
                                                    meanDepDelay = mean(DepDelay, na.rm = TRUE)), 
                                         by = list(Month, Origin)] # by clause (= group by)


correlation.value <- cor(monthly.delay.flight.data[, .(meanArrDelay, meanDepDelay)])

# ----- Visual information (graphs) -----

# histogram and distribution
plotHistogramDensity <- function(column, title, ytitle, xtitle){
  hist(column, prob = TRUE, main = title, 
       col = "grey", ylim = c(0, 0.4), ylab = ytitle, xlab = xtitle)
  density <- density(column)
  lines(density, col = "blue", lwd = 2) 
}

plotHistogramDensity(monthly.delay.flight.data$meanArrDelay, "Histogram for mean Arrival Delay",
                     'Probability', "Arrival Delay")

plotHistogramDensity(monthly.delay.flight.data$meanDepDelay, "Histogram for mean Departure Delay",
                     'Probability', "Departure Delay")

# QQPlots
qqnorm(monthly.delay.flight.data$meanDepDelay)
qqline(monthly.delay.flight.data$meanDepDelay)

qqnorm(monthly.delay.flight.data$meanArrDelay)
qqline(monthly.delay.flight.data$meanArrDelay)

# Normal???? check using a "normal" plot
# seed for random numbers
set.seed(1234)
normal <- rnorm(1000)
qqnorm(normal) 
qqline(normal)
