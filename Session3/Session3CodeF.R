###############################################################################
# Date: 03/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session3CodeF.R
# Description: Survival Analysis with R
##############################################################################

# install the survival package
install.packages("survival")
library(survival)
# Get help
library(help=survival)

# load data
clinical.data <- read.csv(file = "inputData/colon.csv", header = TRUE, sep = ",")

# id:	id
# study:	1 for all patients
# rx:	Treatment - Obs(ervation), Lev(amisole), Lev(amisole)+5-FU
# sex:	1=male
# age:	in years
# obstruct:	obstruction of colon by tumour
# perfor:	perforation of colon
# adhere:	adherence to nearby organs
# nodes:	number of lymph nodes with detectable cancer
# time:	days until event or censoring
# status:	censoring status
# differ:	differentiation of tumour (1=well, 2=moderate, 3=poor)
# extent:	Extent of local spread (1=submucosa, 2=muscle, 3=serosa, 4=contiguous structures)
# surg:	time from surgery to registration (0=short, 1=long)
# node4:	more than 4 positive lymph nodes
# etype:	event type: 1=recurrence,2=death

# create the response variable:
# Create a survival object, usually used as a response variable in a model formula
response <- Surv(time = rep(0, nrow(clinical.data)), time2 = clinical.data$time, 
                 event = clinical.data$etype)
# Fits a Cox proportional hazards regression model
model <- coxph(response ~ sex + obstruct + age + perfor + nodes, data = clinical.data)
summary(model)
# Plot the baseline survival function
plot(survfit(model), 
     xscale = 365.25,
     xlab = "Time after diagnosis",
     ylab = "Proportion survived",
     main = "Baseline Hazard Curve")

# Test the proportional hazards assumption for a Cox regression model fit (coxph).
test.hazards <- cox.zph(model)
print(test.hazards)
plot(test.hazards)





