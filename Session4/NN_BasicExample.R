###############################################################################
# Date: 17/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: NN_BasicExample.R
# Description: NNs XOR with R
##############################################################################

# --------------------------- LIBRARIES ---------------------------------------
library(neuralnet)
library(h2o)
# --------------------------- DATA ---------------------------------------
# xor dataframe
xor.df <- data.frame(X = c(0, 0, 1, 1), Y = c(0, 1, 0, 1), Z = c(0, 1, 1, 0))

# ------------------------- Neural Net ------------------------------------
column.names <- names(xor.df)
my.formula <- as.formula("Z ~ X+Y")
rep_ <- 1000
# if hidden = c(3,5) we'll have two hidden layers of 3 and 5 neurons
time <- system.time(nn.mod <- neuralnet(my.formula, data = xor.df, hidden = c(2,2), rep = rep_, 
                                     act.fct = "logistic", linear.output = TRUE))
print(time)
print(nn.mod)
plot(nn.mod, rep = "best")

results <- nn.mod$net.result[[rep_]] # good???

# try again with 5000 and 10000 rep_

# ------------------------- H2O ------------------------------------
## Start a local cluster 
localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE)

xor_h2o <- as.h2o(xor.df, destination_frame = "xorData")

# predict (y) the first one, erasing date
# try different "epochs"
xor.dl <- h2o.deeplearning(x = 1:2, y = 3, training_frame = xor_h2o, epochs = 100000, 
                           hidden = c(2, 2), export_weights_and_biases = TRUE,
                           distribution = "gaussian")

## Using the DNN model for predictions
# to data frame to H2O Frame
xor.h2o <- as.h2o(xor.df[, 1:2], destination_frame = "xor.h2o")
# Predict
h2o_test <- h2o.predict(xor.dl, xor.h2o)

## Converting H2O format into data frame
df_test <- as.data.frame(h2o_test)
# the trick: to bivariate result
df_test$predict <- ifelse(df_test$predict < 0.5, 0, 1) # works??? Try other values for epochs

# the Neural Network
h2o.weights(xor.dl)
summary(xor.dl)
h2o.download_pojo(xor.dl) # print the model to screen


