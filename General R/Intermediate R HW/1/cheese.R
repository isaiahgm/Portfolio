# Read into R the data in the files "cheese1.csv" and "cheese2.csv".  These
# datasets contain the per capita consumption of different cheeses from 1995 to
# 2014. The two data sets cover the same years, although the names for the
# variable holding the year differ.  Merge the data together into a single
# data.frame in which all the consumption data for a given year is one
# observation.  Name your merged data.frame "cheese".  The dimension of this
# data.frame should be 20 rows and 7 columns.

setwd('C:/Users/imoe9/OneDrive/Documents/STAT223/homework/1')
cheese1 <- read.csv('cheese1.csv')
cheese2 <- read.csv('cheese2.csv')

cheese <- (cbind(cheese1, cheese2[c(2:4)]))

# Which kind of cheese has the highest average consumption per capita over all
# years?

which.max(sapply(cheese[,-1], mean))

# Which year saw the largest total consumption per capita of all cheeses?

cheese[which.max(rowSums(cheese[,-1])),1]