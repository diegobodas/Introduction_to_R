###############################################################################
# Date: 28/09/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: CodeSession1.R
# Description: Intro to R
##############################################################################

# ----- PART1 ----- (check the "Top Level")

# This is a number
number <- 6
# print number
number
# or
print(number)
# this is a character or string
word <- "hello folks"
# print word
word

# this is a vector
numeric.vector <- c(1, -2, 5.1, 2, -1) # numeric vector
numeric.vector
character.vector <- c("one", "two", "three") # character vector
character.vector
logical.vector <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE) #logical vector
logical.vector

# Refer to elements of a vector using subscripts.
numeric.vector[c(1,4)] # 1st and 4th elements of vector
numeric.vector <- numeric.vector * 2
numeric.vector
numeric.vector[3] - 6
# start 
numeric.vector[0] # Opppssss!!!!!
numeric.vector[1] # Ahhhh, it starts at 1
length(numeric.vector) # length

####################################################################################

# Matrices
# All columns in a matrix must have the same mode(numeric, character, etc.) and the same length
# The general format is
my.matrix <- matrix(
  c(-2, 9, 30, 0.1, -8, -0.31),   # the data elements 
  nrow = 2,                       # number of rows 
  ncol = 3,                       # number of columns 
  byrow = TRUE)                   # fill matrix by rows 

# print
my.matrix

# generates 5 x 4 numeric matrix 
my.matrix2 <- matrix(1:20, nrow = 5, ncol = 4)
my.matrix2

# matrix and names
cells <- c(1, 2, 3, 4)
rnames <- c("row1", "row2")
cnames <- c("column1", "column2") 
my.matrix3 <- matrix(cells, nrow=2, ncol=2, byrow=TRUE, 
                     dimnames=list(rnames, cnames))
my.matrix3

#some useful functions
length(my.matrix3) # 4
ncol(my.matrix3) # 2
nrow(my.matrix3) # 2
dimnames(my.matrix3)
colnames(my.matrix3) # [1] "column1" "column2"
rownames(my.matrix3) # [1] "row1" "row2"

# Accessing matrices
my.matrix3[,2] # 2nd column of matrix
my.matrix3[1,] # 1st row of matrix 
my.matrix2[2:4,1:3] # rows 2,3,4 of columns 1,2,3
###############################################################################################
# Data Frames
# A data frame is more general than a matrix, 
# in that different columns can have different modes (numeric, character, factor, etc.)
vector1 <- c(1, 2, 3, 4)
vector2 <- c("red", "white", "red", NA) # NA is "Not Available" or "Not Applicable" or "Not Announced"
vector3 <- c(TRUE, TRUE, TRUE, FALSE)
my.data.frame <- data.frame(vector1, vector2, vector3)
my.data.frame

names(my.data.frame) <- c("ID", "Color", "Passed") # variable names
my.data.frame
colnames(my.data.frame)
rownames(my.data.frame) <- c("row1", "row2", "row3", "row4")
my.data.frame

# Accessing data frames
my.data.frame[2:3] # columns 2, 3 of data frame
my.data.frame[c("Color","Passed")] # columns Color and Passed from data frame
my.data.frame$ID # variable ID in the data frame
my.data.frame$ID[2] # variable ID, row 2, in the data frame
my.data.frame[3, 1] # row 3, column 1

###############################################################################################
# Lists
# An ordered collection of objects (components)
# A list allows you to gather a variety of (possibly unrelated) objects under one name
# example of a list with 4 components
# a string, a numeric vector, a matrix, and a scaler 
my.list <- list(name = "Yo", numbers = numeric.vector, mymatrix = my.matrix, other = 2.3)
my.list$name
my.list$numbers
# We can use lists if we want to return several values in a function

# example of a list containing two lists 
my.list2 <- c(my.list, my.list)
my.list2

# Accessing lists
my.list[[2]] # 2nd component of the list
my.list[["numbers"]] # component named numbers in list

###############################################################################################
# Factors
# Tell R that a variable is nominal by making it a factor
# The factor stores the nominal values as a vector of integers 
# in the range [ 1... k ] (where k is the number of unique values in the nominal variable), 
# and an internal vector of character strings (the original values) mapped to these integers

# variable gender with 5 "male" entries and 5 "female" entries 
gender <- c(rep("male", 5), rep("female", 5)) 
gender <- factor(gender) 
# stores gender as 5 1s and 5 2s and associates
# 1 = female, 2 = male internally (alphabetically)
# R now treats gender as a nominal variable 
summary(gender)
str(gender) # Display the internal structure of an R object
###############################################################################################
# NAs values
x <- c(1, 2, 3, NA)
mean(x) # NA
mean(x, na.rm = TRUE) # remove NAs # 2 = (1 + 2 + 3)/3 (remove NAs, not NA = 0)
# NAs to 0
x[is.na(x)] <- 0
x
mean(x, na.rm = TRUE) # 1.5
mean(x) # 1.5

# ----- PART2 -----

# install packages from repo
install.packages('Rcpp', repos = 'http://cran.us.r-project.org')
# Check installation path or library

# examples with dev tools
# Why to explain? It needs compilation
# devtools is designed for package developers and provide R functions 
# that simplify many common tasks
# PRE
# Windows: Install Rtools
# Mac: Install Xcode from the Mac App Store
# Linux: Install a compiler and various development libraries

# install
install.packages("devtools", type = "source") 
# Do not worry if it requires restart the R session

# test
library(devtools) # it works!!!
# other way
require(devtools) # it also works!!! ???????

# unload a package
detach("package:devtools", unload = TRUE)

# Advance package management, and some data structures and functions ;-)
# install several packages (note: "<-")
packages.to.install <- c("plyr", "psych", "tm") # c is a vector
install.packages(packages.to.install, dependencies = TRUE)

# apply function to all elements in vector (load all)
lapply(packages.to.install, library, character.only = TRUE)

# list all packages in memory 
packages.in.memory <- names(sessionInfo()$otherPkgs)
# see results in Global Environment

# concat = paste
packages.in.memory <- paste('package:', packages.in.memory, sep = "")
# print in console
packages.in.memory
# or print in console
print(packages.in.memory)

# unload all (detach)
lapply(packages.in.memory, detach, character.only = TRUE, unload = TRUE)
# test (if you want)
packages.in.memory <- names(sessionInfo()$otherPkgs)

# Clean memory
rm(list = ls(all = TRUE))

# ----- PART3 -----

# list objects in memory
ls()

x2 <- 9
y2 <- 10
# objects including x
ls(pattern = "x")
# objects starting with x
ls(pattern = "^x")

# Conditionals
number = 3
if (number%%2 == 0){ # even number
  print("even number")
} else {
  print("odd number")
}

# The same but... brackets are important
if (number%%2 == 0) print("even number")
else #fail, R reads line by line
  print("odd number")

if (number%%2 == 0) print("even number") #not fail, one line

# Several if-else
if (number%%2 == 0){ # even number
  print("even number")
} else if (number%%2 != 0) {
  print("odd number")
} else {
  print("I do not know what it is!!!")
}

####################################################################

# Loops
for (i in 1:10){
  print(paste("valor ", i, sep = ""))
}

i <- 1
repeat {
  print(paste("valor ", i, sep = ""))
  i <- i + 1
  if (i > 10) break # break the loop (I do not like "break"!!!)
}


i <- 1
while (i <= 10) {
  print(paste("valor ", i, sep = ""))
  i <- i + 1
}
#####################################################################

# Functions
MyFunction <- function(the.text){
  
  for (i in 1:10){
    print(paste(the.text, i, sep = ""))
  }
  
  # we can return a value 
  return (i) # silly example
}

# how to use
MyFunction("helloooo ") # check last line in output
# or
value <- MyFunction("byeeeeeee")

#######################################################################

# Apply: 
# Applies a function to sections of an array and returns the results in an array

my.matrix <- matrix(rep(seq(3), 3), ncol = 3)
my.matrix

#row sums of mat1
apply(my.matrix, 1, sum) # 1 = rows

#column sums of mat1
apply(my.matrix, 2, sum) # 2 = columns

#using a user defined function
my.function <- function(x){
  sum(x) * 2
}

apply(my.matrix, 1, my.function)
apply(my.matrix, 2, my.function)

# the function can be defined inside the apply function
# note the lack of curly brackets 
apply(my.matrix, 1, function(x) sum(x) * 2)

# lapply: useful with data frames, returns results in a list
my.dataframe <- as.data.frame(my.matrix)
lapply(my.dataframe, sum)
# sapply is a user-friendly version of lapply by default returning 
# a vector or matrix if appropriate
sapply(my.dataframe, sum)
# check
apply(my.dataframe, 2, sum) # columns

# ----- PART4 -----

# I want to find my files!!!
setwd("/Users/diego.bodas.sagi/OneDrive/Work/dBodasTeachingBBVA/R/MisApuntes/Introduction2R/Session2")

# Timing code
system.time(print("hello"))
# The ‘user time’ is the CPU time charged for the execution of user instructions of the calling process.
# The ‘system time’ is the CPU time charged for execution by the system on behalf of the calling process.

# read.table
system.time (
  flight.data <- read.table("inputData/2006.csv", dec = ".", sep = ",", stringsAsFactors = FALSE)
)

# stringAsFactors -> do not convert to factors

# read.csv
system.time (
  flight.data <- read.csv("inputData/2006.csv", dec = ".", sep = ",", stringsAsFactors = FALSE)
)

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

system.time(flight.data <- read.csv("inputData/2006.csv",
                                    header = TRUE,
                                    colClasses = colVuelo))

# subset example
subset.example <- subset(flight.data, Month > 11 & DayofMonth > 15 & Dest == "MIA")

# ----- PART5 -----

# fread: speed!!!!
library(data.table)
# Maybe some problems reading files due to column format
system.time(flight.data <- fread("inputData/2006.csv"))
# the right choice
system.time(
  flight.data <- fread("inputData/2006.csv", header = TRUE, 
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

# ff
# Objective: Manage HUGE files (not faster than fread, but if we have a huge file...)
library(ff)

system.time(flight.data <- read.csv.ffdf(file = "inputData/2006.csv", header=TRUE))

# bigmemory: same objective as ff package, 
# it creates a descriptor file to manipulate the source
library(bigmemory)
system.time(flight.data <- read.big.matrix("inputData/2006.csv", header = T,
                                           type = "integer", backingfile ="data.bin", 
                                           descriptor = "data.desc") 
)

# ----- Create Paths -----

ConfigurePaths <- function(){
  dir.create(file.path(getwd(), "primaryData"), showWarnings = FALSE)
  dir.create(file.path(getwd(), "SummaryResults"), showWarnings = FALSE)
  dir.create(file.path(getwd(), "data"), showWarnings = FALSE)
}

# ----------- CONEXION REDSHIFT ------------------------------------
#---------- LIBRARIES ----------
# if("RPostgreSQL" %in% rownames(installed.packages()) == FALSE) {install.packages("RPostgreSQL", dependencies = TRUE)}
# library('RPostgreSQL')
# parameters with default values
GetTxDataFromRedshiftByQuery <- function(myUser, myPassword,
                                         myHost = "bbvadata.c9itpkszvsr4.eu-west-1.redshift.amazonaws.com",
                                         myPort = 5439, myDBname = "transactions", query){
  # Connect with Redshift with user and password values
  # Search in data base transaction
  # Example: tx_date, day_of_week, SUM(tx_amount), merchant_fuc and total transaction per day
  #
  # Args:
  #   myUser: Redshift user
  #   myPassword: Redshift user password
  #   myHost: Redshift host
  #   myPort: Host Port
  #   myDBname: DB Name
  #   query: The query
  #   NOTES: problems wiht Redshift driver and last version of Java VM.
  #   Solution: use postgresql driver
  #
  # Returns:
  #   Query results. Example: Total amount per day, total transaction number per day. Group by merchant id
  #
  # Version:
  #   0.1
  #
  # Author:
  # Your name here
  #
  # Date:
  #   Today
  #
  # How to call:
  #   txDataSummarizedByCategoryId <- GetTxDataFromRedshiftByQuery(
  #     query = "SELECT tx_date, merchant_ccaa_code, merchant_category_id, day_of_week, 
  #              SUM(tx_amount) AS day_tx_amount, COUNT(tx_cod) AS total_tx
  #              FROM transactions_raw
  #              GROUP BY tx_date, merchant_ccaa_code, merchant_category_id, day_of_week"
  #     )
  #
  # loads the PostgreSQL driver
  drv <- dbDriver("PostgreSQL")
  connect <- dbConnect(drv, host = myHost, port = myPort, dbname = myDBname, 
                       user = myUser, password = myPassword)
  # ----------- QUERY ------------------------------------
  results_df <- dbGetQuery(connect, query)
  dbDisconnect(connect)
  return(results_df)
}


# ------------- USEFUL FUNCTIONS -----------------------
a <- c(1,2,3,4)
b <- a
c <- a
d <- c(1,2)
e <- c(1,2,3,4)

library(utils)

all.mix <- expand.grid(a, d, e)

# ------------- MORE ABOUT FACTORS -------------------------

setwd("/Users/diego.bodas.sagi/OneDrive/Work/dBodasTeachingBBVA/FDM2DS_IV/R_Intro/Session1/")

# Read csv (characters with quotes (It's more efficient))
factor.example <- read.csv("input/clinicalData.csv", header = TRUE, sep = " ")
names(factor.example) <- c("Answer", "Treatment")

# Difference between class and type
class(factor.example$Treatment)
typeof(factor.example$Treatment)

levels(factor.example$Treatment)
# Analyze
summary(factor.example)
boxplot(factor.example) #Ohhh my God. Treatment is a QUALITATIVE variable

# Do it right
boxplot(Answer ~ Treatment, data = factor.example) 

# cut function (?cut)
years <- scan(file = "input/years.csv")
years.cut <- c(0, 20, 40, 60, 100)
# which interval?
cut.example <- cut(years, breaks = years.cut, include.lowest = TRUE)

