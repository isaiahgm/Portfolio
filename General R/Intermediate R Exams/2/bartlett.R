# Read the Wikipedia entry on Bartlett's test:
#
# https://en.wikipedia.org/wiki/Bartlett's_test
#
# Complete the function below that takes a list of k numeric vectors
# (representing k random samples from the k populations) and returns Bartlett's
# test statistic (given on the Wikipedia page) as a numeric vector of length
# one.
#
# A few notes:  1. 'ln' in the equation is the natural logarithm, which is
# implemented in R as the 'log' function.  2. Your implementation may *not*
# call R's builtin function 'bartlett.test', but you may find it helpful in
# checking your code. 3. If you correctly implement the function, the following
# code will return something close to '25.96':
#
# bartlett(lapply(split(InsectSprays,InsectSprays$spray),function(x) x$count))
#
# [10 pts.]

bartlett <- function(samples) {
  k <- length(samples)
  ni <- lengths(samples)
  N <- sum(ni)
  S2i <- sapply(samples, function(x) var(x))
  S2p <- sum((ni - 1) * S2i) / (N - k)
  X2 <- ((N - k)*log(S2p) - sum((ni - 1)*log(S2i))) / (1 + (sum(1/(ni - 1) - 1/(N - k)) / (3*(k-1))))
  X2
}


# Complete the function below where 'n', 'mean', and 'var' are all numeric
# vectors that can be assumed to be of length k, for k >= 2.  The function
# should return a list of k numeric vectors, where the i^th vector (for
# i=1,..,k) is drawn from a normal distribution with mean 'mean[i]' and
# standard deviation 'sqrt(var[i])'.  Although your numbers will be slightly
# different because of sampling variability, your function should behave as
# follows:
#
# > simulate.data(c(2,5,3),c(0,10,30),c(1,1,10))
# [[1]]
# [1] -0.5879083 -0.5065722
# 
# [[2]]
# [1]  9.138581 10.211088 10.266380 12.587052  8.068297
# 
# [[3]]
# [1] 29.56058 32.59358 29.92688
#   
# [10 pts.]

simulate.data <- function(n, mean, var) {
  N <- length(n)
  vectorlist <- list(NULL)
  for (i in 1:N) {
    vectorlist[[i]] <- rnorm(n[i], mean[i], sqrt(var[i]))
  }
  vectorlist
}


# Using the two functions that you wrote above, perform a simulation study to
# calculate the power of Bartlett's test when sampling from k=3 normally
# distributed populations with: 1. sample sizes 20, 25, and 15 respectively, 2.
# means 0, 1, and 3 respectively, and 3. variances 1, 2, and 3 respectively.
# Assume a Type I error rate of 0.05 (i.e., alpha = 0.05).  Make sure you
# assess your Monte Carlo error.
#
# A few notes: 1. Recall that Bartlett's test rejects the null hypothesis when
# the test statistic exceeds the critical value, i.e., the 95% percentile of a
# chi-square distribution with k-1 degrees of freedom.  You can use the
# 'qchisq' function to compute the critical value. 2. The approximate power is
# '0.485'.
# [10 pts.]

critical.value <- qchisq(.95, 2)
nReps <- 50000
montesample <- replicate(nReps, bartlett(simulate.data(c(20,25,15),c(0,1,3),c(1,2,3))))
power.est <- mean(montesample > critical.value)
ci <- power.est + c(-1,1)*qt(.975, nReps - 1)*sd(montesample)/sqrt(nReps)

cbind('Lower' = ci[1], 'Power Estimate' = power.est, 'Upper' = ci[2])
