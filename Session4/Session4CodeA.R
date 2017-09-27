###############################################################################
# Date: 03/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session4CodeA.R
# Description: Lasso Regression with R
# References: 
# http://www4.stat.ncsu.edu/~post/josh/LASSO_Ridge_Elastic_Net_-_Examples.html
# http://web.stanford.edu/~hastie/glmnet/glmnet_alpha.html
##############################################################################


# --------------------------- LIBRARIES ---------------------------------------
library(ggplot2)
library (glmnet)
# ---------------------------- Code --------------------------------------
# training set
# as matrix
x.train <- as.matrix(training.set[3:length(training.set)])
# y should be a vector
y.train <- as.numeric(unlist(training.set[2]))

# Fit models 
fit.lasso <- glmnet(x.train, y.train, family = "gaussian", alpha = 1)
fit.ridge <- glmnet(x.train, y.train, family = "gaussian", alpha = 0)
fit.elnet <- glmnet(x.train, y.train, family = "gaussian", alpha =.5)

# Get MSE
lasso.fit <- cv.glmnet(x.train, y.train, type.measure="mse", alpha = 1, family = "gaussian")
ridge.fit <- cv.glmnet(x.train, y.train, type.measure="mse", alpha = 0, family = "gaussian")
elnet.fit <- cv.glmnet(x.train, y.train, type.measure="mse", alpha = .5, family = "gaussian")
# see lambda.min and lambda.1se

# Plot solution paths:
par(mfrow=c(3,2))
# For plotting options, type '?plot.glmnet' in R console
plot(fit.lasso, xvar="lambda")
plot(lasso.fit, main="LASSO")

plot(fit.ridge, xvar="lambda")
plot(ridge.fit, main="Ridge")

plot(fit.elnet, xvar="lambda")
plot(elnet.fit, main="Elastic Net")

# Test set
#training set
x.test <- as.matrix(test.set[3:length(test.set)])
# y should be a vector
y.test <- as.numeric(unlist(test.set[2]))
# MSE on test set
lasso.yhat <- predict(lasso.fit, s = lasso.fit$lambda.1se, newx = x.test)
lasso.mse <- mean((y.test - lasso.yhat)^2)

ridge.yhat <- predict(ridge.fit, s = ridge.fit$lambda.1se, newx = x.test)
ridge.mse <- mean((y.test - ridge.yhat)^2)

elnet.yhat <- predict(elnet.fit, s = elnet.fit$lambda.1se, newx = x.test)
elnet.mse <- mean((y.test - elnet.yhat)^2)

# Very similar! results
lasso.mse
ridge.mse
elnet.mse

# Plot (try)
plot.results <- data.frame(test.set$date, y.test, lasso.yhat, ridge.yhat, elnet.yhat)
colnames(plot.results) <- c("date", "real", "lasso", "ridge", "elastic net")

plot.df <- melt(plot.results, id.vars = 'date')
ggplot(plot.df, aes(x = date, y = value, colour = variable, group = variable)) + geom_line()

# Get coefficients
coef(lasso.fit, s = "lambda.1se")
