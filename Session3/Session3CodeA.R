###############################################################################
# Date: 03/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session3CodeA.R
# Description: Regression with R
##############################################################################

# ------- Start ---------------------
# http://www.ine.es/dyngs/INEbase/en/operacion.htm?c=Estadistica_C&cid=1254736176802&menu=ultiDatos&idp=1254735976607
# http://www.ine.es/jaxiT3/Datos.htm?t=10013


# ------- Libraries -----------------
# Maybe you have problems loading rJava
dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_102.jdk/Contents/Home/jre/lib/server/libjvm.dylib')
library(rJava)
.jinit()
.jcall("java/lang/System", "S", "getProperty", "java.runtime.version")
# write and load xlsx files
library(xlsx)

# ---------- Functions and code -----------------
LoadCPI <- function(path.file){
  # set ColClasses
  col.formats = c("character", rep("numeric", 172)) # 4 en 2016, + 12 x 14 a?os
  
  system.time(return(read.csv(path.file, header = TRUE, 
                                   colClasses = col.formats, sep = ";",
                                   dec = ",")))
}

cpi.data <- LoadCPI("inputData/CPI_Spain.csv")

# Quality
cpi.data[1:5, 160]
cpi.data[1:5, 161]
cpi.data[1:5, 162]

names(cpi.data) #173, next wrong columns (" " or other symbols)
names(cpi.data)[174]
names(cpi.data)[173]

#cut
cpi.data <- cpi.data[, 1:173]
# check
names(cpi.data)[ncol(cpi.data)] #"OK!!!!"
names.df <- cpi.data$Group
# transpose
cpi.data.year <- as.data.frame(t(cpi.data[, 2:ncol(cpi.data)]))
cpi.data.year <- cpi.data.year[order(rownames(cpi.data.year)),]
colnames(cpi.data.year) <- names.df


# final function
LoadFormattedCPI <- function(path.file){
  # set ColClasses
  col.formats = c("character", rep("numeric", 172)) # 4 en 2016, + 12 x 14 a?os
  
  system.time(cpi.data <- read.csv(path.file, header = TRUE, 
                              colClasses = col.formats, sep = ";",
                              dec = ","))
  
  # Limpiar los nombres de columnas, est?n muy muy muy feos!!!
  
  the.names <- c("index", "food", "alcoholic", "clothing", "housing", "furnishings", "health",
                 "transport", "communications", "recreation", "education", "restaurants",
                 "miscellaneus")
  cpi.data <- cpi.data[, 1:173]
  
  # transpose
  cpi.data <- as.data.frame(t(cpi.data[, 2:ncol(cpi.data)]))
  cpi.data <- cpi.data[order(rownames(cpi.data)),]
  colnames(cpi.data) <- the.names
  
  return(cpi.data)
}

cpi.data.year <- LoadFormattedCPI("inputData/CPI_Spain.csv")

# hay nulos o infinitos??????
the.nulls <- length(cpi.data.year[which(is.na(cpi.data.year))])
# there are no nulls
# save to excel
dir.create("outputFiles")
write.xlsx(cpi.data.year, file = "outputFiles/the_file.xlsx")
# summary
summary(cpi.data.year)
plot(cpi.data.year)

#########################################################
# date column for join
cpi.data.year$date <- paste(substring(row.names(cpi.data.year), 2, 5), 
                            substring(row.names(cpi.data.year), 7, 8), sep = "-")


#########################################################
# dummy variables
# no es necesario aquí, se trata de interactuar con R
cpi.data.year$month <- substring(cpi.data.year$date, 6, 7)
cpi.data.year$year <- substring(cpi.data.year$date, 1, 4)
# add months columns
month.abb # try
cpi.data.year[, month.abb] <- 0

AddDummyMonth <- function(the.dataframe){
  for (index in 1:nrow(the.dataframe)){
    # the problem here is to find the right column to change
    the.dataframe[index, paste(month.abb[as.numeric(the.dataframe[index, "month"])])] <- 1
  }
  
  return(the.dataframe)
}

cpi.data.year <-AddDummyMonth(cpi.data.year)

##################################################
# Add binomial variable
cor(cpi.data.year$index, cpi.data.year$food)

# dummyBinomial = 1 if food > 80 and index > 100 else dummyBinomial = 0
cpi.data.year$dummyBinomial <- ifelse((cpi.data.year$index > 100 & cpi.data.year$food > 80), 
                                      1, 0)



