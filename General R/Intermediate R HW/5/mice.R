# 1) The mean is 94
mice <- c(82,107,93)
mean(mice)

#2) 24 possible bootstrap samples

#3) 
# 111, 112, 113, 121, 122, 123, 131, 132, 133
# 211, 212, 213, 221, 222, 223, 231, 232, 233
# 311, 312, 313, 321, 322, 323, 331, 332, 333

# 111 = 82
a <- mean(c(82, 82, 82))
# 222 = 107
b <- mean(c(107, 107, 107))
# 333 = 93
c <- mean(c(93, 93, 93))
# 112, 121, 211 = 90.3
d <- mean(c(82, 82, 107))
# 113, 131, 311 = 85.7
e <- mean(c(82, 82, 93))
# 122, 212, 221 = 98.7
f <- mean(c(82, 107, 107))
# 133, 313, 331 = 89.3
g <- mean(c(82, 93, 93))
# 233, 323, 332 = 97.7
h <- mean(c(107, 93, 93))
# 322, 232, 223 = 102.3
i <- mean(c(93, 107, 107))

# 4) The mean of all the possible sample means equals the true sample mean
mean(c(a,b,c,d,d,d,e,e,e,f,f,f,g,g,g,h,h,h,i,i,i))

# 5)

bootstrap.confidence.interval <- function(x,func,alpha=0.05,nBootstrapSamples=1000) {
  bs <- numeric(nBootstrapSamples)
  for ( i in 1:nBootstrapSamples ) {
    y <- sample(x,replace=TRUE)
    bs[i] <- func(y)
  }
  quantile(bs,probs=c(alpha/2,1-alpha/2))
}

bootstrap.confidence.interval(mice, mean, nBootstrapSamples = 10000)

# This confidence interval provides very little information regarding the true mean.
# While I feel confident in its coverage, the range of the interval is far too large
# to make any meaningful conclusion. This likely results from the small sample size
