#Some brands of cold cereal run promotions in which one of four free toys is included in the cereal box. 
#The company encourages consumers to “collect all four.” The typical approach is to buy one box at a time
#and stop as soon as the set is complete. Consider two scenarios: 1. That each toy is equally likely, and 2. 
#That toys have selection probabilities 0.10, 0.25, 0.25, and 0.40. Write an R script named ‘all-four.R’ which 
#conducts a Monte Carlo simulation study to answer the following questions under the two scenarios:

#What is the mean number of boxes that a consumer must purchase to get a complete set?

#Equal Probability:

set <- function(possibilities = c(1:4), probability = c(1:4)) {
  c <- 0
  i <- 1
  while(length(unique(c)) < 4) {
    c[i] <- sample(possibilities, 1, probability, replace = TRUE)
    i <- i + 1
  }
  return(length(c))
}

#Mean Number of boxes at equal probability
meaneq <- mean(replicate(10000, set()))
meaneq

#Mean Number of boxes at inequal probability
meanineq <- mean(replicate(10000, set(possibilities = c(1:4), probability = c(.1,.25,.25,.40))))
meanineq

#What proportion of consumers will need to purchase 14 boxes or more to complete a set?
qnorm(14, meaneq, 2)

qnorm(14, meanineq, 2)
