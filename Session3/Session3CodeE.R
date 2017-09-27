###############################################################################
# Date: 03/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session3CodeE.R
# Description: Analyze residuals with R
##############################################################################


#Get residuals
# The residual data of the simple linear regression model is the difference between 
# the observed data of the dependent variable y and the fitted values ŷ.
res1 <- linearModel$model$residuals
# The same
res2 <- resid(linearModel$model)
# Test, it is the same
check <- which(res1 != res2)
print(check)
# ok, it is the same
# but... we have a problem
# we want residuals using test sets no train sets
rm(list = c("res1", "res2", "check"))
###################################################################
GetLinearResiduals <- function (coef, testData) {
  # Always predict the last one
  testResults <- data.frame(testData[[1]], testData[[2]])
  colnames(testResults) <- c("DATE", "REAL")
  
  testData[, 1] <- NULL
  testData[, 2] <- NULL
  
  # change NA to 0
  coef[] <- lapply(coef, function(x) replace(x,is.na(x),0))
  
  testResults <- cbind(testResults, PREDICTED = 
                         (rowSums(t(t(testData[]) * as.double(coef[2:length(coef)])))) +
                         as.double(coef[1]))
  
  return(testResults)
  
}

linearResiduals <- GetLinearResiduals(coef(linearModel$model), test.set)

# Silly exercise #####

# En R es imprescindible definir el vector especie como un factor, ya que en caso contrario se puede
# confundir con un vector numérico 
typeResiduals <- gl(2, 60, labels = c("real", "predicted"))
# Análisis de la varianza, contraste de medias
# ¿Hay diferencias significativas entre los grupos?
the.residuals <- c(linearResiduals$REAL, linearResiduals$PREDICTED)
# Asumiendo que la variable longitud sigue una distribución normal con varianza común para las tres
# poblaciones, la tabla del análisis de la varianza es
models.aov <- aov(the.residuals ~ typeResiduals)
summary(models.aov)
# Si no es menor que 0.05 evidencia que serían similares las muestras
# en otro caso, son cosas distintas y nos quedamos "la mejor"

# Other silly game to understand this
the.residuals1 <- c(linearResiduals$REAL, linearResiduals$REAL)
# Asumiendo que la variable longitud sigue una distribución normal con varianza común para las tres
# poblaciones, la tabla del análisis de la varianza es
models.aov1 <- aov(the.residuals1 ~ typeResiduals)
summary(models.aov1)
# Of course, It's the same
######################################################################################

# Graph Analysis
plot(typeResiduals, the.residuals, ylab = "residuals")
abline(h = 0)
qqnorm(the.residuals)
qqline(the.residuals)

# Levene's Test for Homogeneity of Variance (center = median)
med <- tapply(the.residuals, typeResiduals, median)
med

aresid <- abs(the.residuals - med[typeResiduals])
anova(lm(aresid ~ typeResiduals))

# p-valor < 0,01 -> Heteroscedasticity (if there are sub-populations that have different variabilities from others)
# p-valor >= 0,01 -> Homoscedasticity

# Get Coefficient of Determination
# R-squared is a statistical measure of how close the data are to the fitted regression line
# Linear R2
R2linear <- summary(linearModel$model)$r.squared 
# Be careful with R2: https://onlinecourses.science.psu.edu/stat501/node/258


