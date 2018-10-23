# You notice that there is a drip under the sink in your bathroom and that the
# number of drips every minute is random.  Specifically, suppose that the
# number of drips in a minute is initially a Poisson random variable with rate
# parameter 'rate'.  (You don't need to know anything about the Poisson
# distribution except that you can sample a random value from the Poisson
# distribution with parameter 'rate' in R with the code: 'rpois(1,rate)'.)
# Unfortunately, the severity of the leak is increasing.  Specifically, with
# each passing minute, the rate parameter increases by x%, where x is a random
# value from the uniform distribution on the interval 0 to 5.  (Note that the
# value of x changes every minute!)  You can sample a random value from this
# uniform distribution using 'runif(1,0,5)'.
#
# Assuming that the initial rate is 1, what is the probability that the total
# number of drips exceeds 700 drips after 2 hours?  Here, and throughout this
# problem, make sure you assess the Monte Carlo error for any Monte Carlo
# estimates you make.  (14 pts.)

#Function to measure rate and total water loss
rate.inc <- function(time, initial = 1) {
  rate <- initial
  sum <- NULL
  for (i in 1:(as.numeric(time)-1)) {
    rate[i + 1] <- rate[i] + rate[i] * (runif(1,0,5) / 100)
    sum[i] <- sum(rate[1:(i+1)])
  }
  return(list(rate, sum(rate),sum))
}

rate.monte <- function(nReps, time, initial = 1, drips = 700, confidence.level = .975) {
  est <- sum((replicate(nReps, rate.inc(time = time, initial = initial)[[2]])) > drips) / nReps
  ci <- est + c(-1,1)*qnorm(confidence.level)*sqrt((est*(1-est))/nReps)
  cbind('Lower'=ci[1], 'Estimate'=est, 'Upper'=ci[2])
}

# After two hours we expect the following percent have had more that 700 drips
rate.monte(50000, 120, 1, 700)

# Suppose you are interested in testing the null hypothesis that the initial
# rate parameter is 1 versus the alternative hypothesis that the initial rate
# is larger than 1.  You observe 876 drips in 2 hours.  What is the associated
# p-value?  (4 pts.)
p.value <- rate.monte(50000, 120, 1, 876, confidence.level=.95)
p.value[2]

# Using a 0.05 level of significance, what conclusion do you make regarding the
# null hypothesis?  (2 pts.)
# We fail to reject the null hypothesis because the p-value is greater than >.05


# What is the power for this test when the initial rate is 1.2?  (8 pts.)
alt.p.value <- rate.monte(50000, 120, 1.2, 876, confidence.level = .95)
power <- 1 - alt.p.value[2]
powerest <- power + c(-1,1)*qnorm(.95)*sqrt((power*(1-power))/50000)
cbind('Lower'=powerest[1], 'Power'=power, 'Upper'=powerest[2])
