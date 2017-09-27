###############################################################################
# Date: 03/10/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: Session3CodeB.R
# Description: Exploratory analysis with R
##############################################################################
# Great function from: 
# http://stackoverflow.com/questions/3369959/moving-columns-within-a-data-frame-without-retyping/18540144#18540144
# test <- test[moveme2(names(test), "Colummx after ColumnY")]
moveme2 <- function(invec, movecommand) {
  movecommand <- lapply(strsplit(strsplit(movecommand, ";")[[1]], ",|\\s+"),
                        function(x) x[x != ""])
  movelist <- lapply(movecommand, function(x) {
    Where <- x[which(x %in% c("before", "after", "first", "last")):length(x)]
    ToMove <- setdiff(x, Where)
    list(ToMove, Where)
  })
  myVec <- invec
  for (i in seq_along(movelist)) {
    temp <- setdiff(myVec, movelist[[i]][[1]])
    A <- movelist[[i]][[2]][1]
    if (A %in% c("before", "after")) {
      ba <- movelist[[i]][[2]][2]
      if (A == "before") {
        after <- match(ba, temp)-1
      } else if (A == "after") {
        after <- match(ba, temp)
      }
    } else if (A == "first") {
      after <- 0
    } else if (A == "last") {
      after <- length(myVec)
    }
    myVec <- append(temp, values = movelist[[i]][[1]], after = after)
  }
  myVec
}
################################################################
# install.packages("quantmod")
library(quantmod)
library(data.table)

getSymbols("^IBEX", src = "yahoo")

# outliers
ibex_dt <- as.data.table(IBEX)
ibex_dt$date <- substring(ibex_dt$index, 1, 7)

# By Month 
monthly.ibex.dt <- ibex_dt[, j = list(meanIbexValue = mean(IBEX.Adjusted, na.rm = TRUE)), 
                           by = list(date)] # by clause (= group by)

# and now... Join!!!
cpi.ibex <- merge(cpi.data.year, monthly.ibex.dt, by = "date", all.x = FALSE, all.y = FALSE)
cpi.ibex <- cpi.ibex[moveme2(names(cpi.ibex), "meanIbexValue after miscellaneus")]
# sort columns
corr.matrix <- cor(cpi.ibex[, 2:15]) # We don't consider dummy or months

# to excel
library(xlsx)
write.xlsx(corr.matrix, file = "outputFiles/corr_data.xlsx")

sort.cpi.ibex <- cbind(cpi.ibex$date, cbind(log(cpi.ibex[ , c("index", "food", 
                                                              "clothing", "health", 
                                                              "communications", 
                          "recreation", "meanIbexValue")]), cpi.ibex[, 18:29]))
names(sort.cpi.ibex)[1] <- "date"

summary(sort.cpi.ibex[, 2:8])
#####################################################################################
# histogram and distribution
plotHistogramDensity <- function(column, title, ytitle, xtitle, min_y, max_y){
  hist(column, prob = TRUE, main = title, 
       col = "grey", ylim = c(min_y, max_y), ylab = ytitle, xlab = xtitle)
  density <- density(column)
  lines(density, col = "blue", lwd = 2) 
}

plotHistogramDensity(sort.cpi.ibex$index, "Histogram for CPI index",
                     'Probability', "CPI Index", 0, 15)

# QQPlots
qqnorm(sort.cpi.ibex$index)
qqline(sort.cpi.ibex$index)

# Normal???? check using a "normal" plot
# seed for random numbers
set.seed(1234)
normal <- rnorm(1000)
qqnorm(normal) 
qqline(normal)

