roommate <- c(6,6.25,5.75,6.5,6,15,35,20,4,5.25,5.75)
you <- c(3.5,5.5,4,4,4,6,11,12,3,4,4.25,7,3.25)
t.test(roommate,you,conf.level=0.9)

#Because neither data set is normal and the sample size is too small our t-test assumptions are violated
hist(you)
hist(roommate)

#Function to see the true difference in means

shower.time <- function(data1, data2, alpha = 0.10, BSsamples = 5000) {
  estimate <- NULL
  for (i in 1:BSsamples) {
    sample1 <- sample(data1, replace = TRUE)
    sample2 <- sample(data2, replace = TRUE)
    estimate[i] <- mean(sample1) - mean(sample2)
  }
  quantile(estimate, probs = c(alpha/2, 1-alpha/2))
}

shower.time(roommate,you)

#At the .10 level of significance I would conclude given the confidence interval that your roommate
#takes significantly longer showers than yourself.

