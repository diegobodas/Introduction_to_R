###############################################################################
# Date: 03/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session3CodeC.R
# Description: Regression with R
##############################################################################


# 1. Training set and Test set (Pocos datos para validación cruzada)
training.set <- sort.cpi.ibex[which(substring(sort.cpi.ibex$date, 1, 4) %in% 
                                      c("2007", "2009", "2012", "2014", "2016")), ]
test.set <- sort.cpi.ibex[which(substring(sort.cpi.ibex$date, 1, 4) %in% 
                                  c("2008", "2010", "2011", "2013", "2015")), ]


###############################################################################
library(reshape2)
library(ggplot2)

# MSE - Error Cuadr?tico Medio - ECM
CalculeMSEvar <- function (dataset){
  mse <- sum((dataset[,3] - dataset[,2])^2)/nrow(dataset)
  # no necesario para training set, mucho más fino
  # mean(the.lm.model$residuals^2)
  # sobre test set --> predict
  # Lo hacemos de esta forma simplemente para practicar
}

PrintGraph <- function(testResults){
  # melt from reshape
  testResults_long <- melt(testResults, id = "DATE")  # convert to long format
  
  print(ggplot(data = testResults_long, 
               aes(x = DATE, y = value, colour = variable, group = variable)) + 
          geom_line())
}

TestModelCase1 <- function (coef, testData) {
  # Always predict the second one
  testResults <- data.frame(testData[[1]], testData[[2]])
  colnames(testResults) <- c("DATE", "REAL")
  
  testData <- testData[, -c(1:2)] # remove date and predictor (index)
  
  # change NA to 0 (safe check)
  coef[] <- lapply(coef, function(x) replace(x,is.na(x),0))
  
  testResults <- cbind(testResults, PREDICTED = 
                         (rowSums(t(t(testData[]) * as.double(coef[2:length(coef)])))) +
                         as.double(coef[1]))
  
  PrintGraph(testResults)
  
  return(CalculeMSEvar(testResults))
  
}

PerformLinearRegression <- function (data) {
  # remove dates
  data[, 1] <- NULL
  # predictor is the first one (without dates)
  print(paste(paste(colnames(data)[1], "~", sep = " "), ".", sep = ""))
  time <- system.time(model <- lm(as.formula(paste(paste(colnames(data)[1], "~", sep = " "), 
                                                   ".", sep = "")), data = data))
  print(time)
  
  return(model)
}

GetLinearModel <- function(trainData, test) {
  
  linearModel <- PerformLinearRegression(trainData)
  
  mse <- TestModelCase1(coef(linearModel), test)
  mse2 <- TestModelCase1(coef(linearModel), trainData)
  
  return (list(model = linearModel, MSE = mse, MSE_train = mse2, type = "linear"))
  
}

linearModel <- GetLinearModel(training.set, test.set)

# glm
the.glm.model <- glm(index ~., family = gaussian("log"), data = training.set[, -1])
summary(the.glm.model)

pred <- predict(the.glm.model, type = "response")
plot(training.set$index, pred, xlab = "Observed", ylab = "Prediction")
abline(a = 0, b = 1)

mse.glm <- mean(the.glm.model$residuals^2)
print(mse.glm)
