###############################################################################
# Date: 03/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session4CodeB.R
# Description: Neural Net "Regression" with R
##############################################################################


# --------------------------- LIBRARIES ---------------------------------------
library(ggplot2)
library(reshape2)
library(h2o)
## Start a local cluster with 2GB RAM
localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE)
# ----- FUNCTIONS -------

# MSE
CalculeMSEandR2 <- function (dataset){
  # We suppose Date in column 1, Real data in column 2 and Predicted data in column 3
  mse <- sum((dataset[, 3] - dataset[, 2])^2)/nrow(dataset)
  # R2
  mean_y <- mean(dataset[, 2])
  totalSumSquares <- sum((dataset[, 2] - mean_y)^2)
  residualSumSquares <- sum((dataset[, 2] - dataset[, 3])^2)
  r2 <- 1 - (residualSumSquares/totalSumSquares)
  return(list(mse = mse, r2 = r2, residuals = (dataset[, 3] - dataset[, 2])))
}

TestDeepModel <- function(model, testData, testH2O){
  # now make a prediction
  predictions <- h2o.predict(model, testH2O)
  ## Converting H2O format into data frame
  prediction.df <- as.data.frame(predictions)
  prediction.df <- cbind(testData$date, testData$index, prediction.df)
  colnames(prediction.df) <- c("DATE", "REAL", "PREDICTED")
  
  PrintGraph(prediction.df)
  return(CalculeMSEandR2(prediction.df))
  
}

GetDeepLearningModel <- function(trainData, testData, name){
  #No dates to Model
  train_h2o <- as.h2o(trainData[,-1], destination_frame = "trainData")
  test_h2o <- as.h2o(testData[,-1], destination_frame = "testData")
  # predict (y) the first one, erasing date
  deepLearningModel.dl <- h2o.deeplearning(x = 2:length(trainData[,-1]), y = 1, 
                                           training_frame = train_h2o, epochs = 50000, 
                                           hidden = c(50, 50),
                                           export_weights_and_biases = TRUE)
  
  test.error <- TestDeepModel(deepLearningModel.dl, testData, test_h2o)
  train.error <- TestDeepModel(deepLearningModel.dl, trainData, train_h2o)
  # create the path
  h2o.saveModel(object = deepLearningModel.dl, path = name, force = TRUE)
  
  # h2o.shutdown(prompt = TRUE)
  
  return (list(model = deepLearningModel.dl, test = test.error, 
               train = train.error, type = "deepLearning"))
}

deepLearningModel <- GetDeepLearningModel(training.set, test.set, "Welcome to NNs")
#### Be careful with overfitting

