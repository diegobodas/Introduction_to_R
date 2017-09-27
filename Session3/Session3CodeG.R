###############################################################################
# Date: 06/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session3CodeG.R
# Description: foreach example
##############################################################################


# install the survival package
install.packages("foreach")
install.packages("doParallel")
library(foreach)
library(doParallel)

# For 10 iterations, we are creating a normally-distributed random variable (1000000 samples)
# we can see how computation time increases if we increase the number of iterations

# number of iterations in the loop
#iterations to time
iters <- seq(10, 100, by = 10)
 
#output time vector for  iteration sets
times <- numeric(length(iters))
 
#loop over iteration sets
for(val in 1:length(iters)){
    cat(val,' of ', length(iters),'\n')
    to.iter <- iters[val]
    #vector for appending output
    ls <- vector('list', length = to.iter)
    #start time
    strt <- Sys.time()
    #same for loop as before
    for(i in 1:to.iter){
        cat(i,'\n')
        to.ls <- rnorm(1e6)
        to.ls <- summary(to.ls)
        #export
        ls[[i]] <- to.ls
	}
    #end time
    times[val] <- Sys.time() - strt
}
 
#plot the times
library(ggplot2)
 
to.plo <- data.frame(iters,times)
ggplot(to.plo,aes(x = iters, y = times)) + 
    geom_point() +
    geom_smooth() + 
    theme_bw() + 
    scale_x_continuous('No. of loop iterations') + 
    scale_y_continuous ('Time in seconds')

# Predict more executions
mod <- lm(times ~ iters)
predict(mod, newdata = data.frame(iters = 1e4))/60

# Parallel execution
#number of iterations
iters<-1e4
#setup parallel backend to use 8 processors
cl <- makeCluster(8)
registerDoParallel(cl)
#start time
strt <- Sys.time()
#loop
ls <- foreach(icount(iters)) %dopar% {
    to.ls <- rnorm(1e6)
    to.ls <- summary(to.ls)
    to.ls
}
print(Sys.time() - strt)
stopCluster(cl)

