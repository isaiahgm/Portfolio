# What is the coverage of this confidence interval procedure 
#if the actual probability that the tack points up is 0.4? Remember to assess your 
#Monte Carlo error! Solve the problem by performing a simulation study in an R script called ‘tack.R’.

#CI Interval for a Proportion
cipro <- function(x, confidence.level = 0.95) {
  alpha <- 1 - confidence.level
  phat <- mean(x)
  n <- length(x)
  bounds <- phat + c(-1,1)*qnorm(alpha/2, lower.tail = FALSE)*sqrt(phat*(1-phat)/n)
  ci <- cbind("Lower Bound" = bounds[1], "Estimate" = phat, "Upper Bound" = bounds[2])
  ci
}

#Calculating Coverage Function
contains.p <- function(true.p, n = 50, nReps = 10000) {
  contains <- 0
  for(i in 1:as.numeric(nReps)) {
    x <- sample(c(0,1), n, c((1-true.p), true.p), replace = TRUE)
    interval <- cipro(x)
    contains[i] <- interval[1] < true.p && interval[3] > true.p
  }
  coverage <- mean(contains)
  covinterval <- coverage + c(-1,1)*qnorm(0.975)*sqrt(coverage*(1-coverage)/nReps)
  cbind('Lower' = covinterval[1], 'Coverage' = coverage, 'Upper' = covinterval[2] )
}

#Coverage at true probability at .40 and n = 50
contains.p(true.p = .4, n = 50)
