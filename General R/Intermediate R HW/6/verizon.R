ILEC <- c(1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1,2,3,1,1,1,1,2,3,1,1,1,1,2,3,1,1,1,1,2,3,1,1,1,1,2,3,1,1,1,1,2,3,1,1,1,1,2,4,1,1,1,1,2,5,1,1,1,1,2,5,1,1,1,1,2,6,1,1,1,1,2,8,1,1,1,1,2,15,1,1,1,2,2) 

CLEC <- c(1,1,5,5,5,1,5,5,5,5) 

# Test statistic of ratio of variances with p-value (given by the hw question)
varCLEC <- var(CLEC)
varILEC <- var(ILEC)

N1 <- length(CLEC)
N2 <- length(ILEC)

observed.test.statistic <- varCLEC/varILEC
pf(observed.test.statistic,N1-1,N2-1,lower.tail=FALSE) 

#Perform a one-sided permutation test on the ratio of variances. What is the p-value and what does it tell you?

#First create a permutation sampling distribution
permute.dist <- function(data1 = CLEC, data2 = ILEC) {
  combo <- c(data1,data2)
  N1 <- length(data1)
  N2 <- length(data2)
  permute <- sample(combo)
  splitC <- permute[1:N1]
  splitI <- permute[(N1+1):(N1+N2)]
  varP.C <- var(splitC)
  varP.I <- var(splitI)
  varP.C / varP.I
}

#Plot the density function
density <- replicate(50000, permute.dist())
plot(density(density))
abline(v=observed.test.statistic)

#Find a p value
p.value <- mean(observed.test.statistic <= density)
p.value

# The P-value is definitely not significant given an alpha of .05 meaning that there is not a significant difference in the variance of
# wait time for ILEC and CLEC customers

#What does a comparison of the two p-values say about the validity of the F test for these data?

# The P-value for the F test was very different from the p-value of the permutation test demonstrating how the F-test is invalid for this
# skewed data.

