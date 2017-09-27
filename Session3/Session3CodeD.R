###############################################################################
# Date: 03/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session3CodeD.R
# Description: Regression with R
##############################################################################


# Se trabaja con datos generados en la clase

# 1. Training set and Test set (Pocos datos para validaci?n cruzada)
training.set <- sort.cpi.ibex[which(substring(sort.cpi.ibex$date, 1, 4) %in% 
                                      c("2007", "2009", "2012", "2014", "2016")), ]
test.set <- sort.cpi.ibex[which(substring(sort.cpi.ibex$date, 1, 4) %in% 
                                  c("2008", "2010", "2011", "2013", "2015")), ]


###############################################################################
my.formula <- as.formula("index ~ .")

# Modelo linel simple (quitar fechas)
my.linear.model <- lm(formula = my.formula, data = training.set[, -1])
# Información básica
summary(my.linear.model)
# Los coeficientes se obtienen así
coef(my.linear.model) # recordad que intercept es el término independiente
# y el error cuadrático medio así
my.ECM <- mean(my.linear.model$residuals^2)

# En R tenemos la función "predict". OJO, esta función puede depender
# del paquete concreto que se esté usando. En nuestro caso, "lm" es una función
# sencilla de la parte básica de R. Apliquemos el modelo al conjunto de test (quitando fecha)
# Poned se.fit a TRUE para que os devuelva los errores
my.prediction <- predict(my.linear.model, test.set[, -1], se.fit = TRUE)
# sale un warning, que podéis consultar aquí:
# http://stackoverflow.com/questions/26558631/predict-lm-in-a-loop-warning-prediction-from-a-rank-deficient-fit-may-be-mis

# Si queremos de forma sencilla el ECM de la predicción (fit son las predicciones)
# Recordad que la primera columa es la fecha y predecimos index que es la segunda columna
my.predict.ecm <- mean((test.set[, 2] - my.prediction$fit)^2)

