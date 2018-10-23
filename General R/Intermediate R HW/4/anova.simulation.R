#Part A

anova.simulation <- function(K = a) {
  treatlist <- NULL
  pvalue <- NULL
  res <- NULL
  p <- replicate(5000, (function(K = a) {
    for (i in 1:length(K)) {
      res[[i]] <- K[[i]] ()
      treatlist[[i]] <- seq(i, by= 0, length = length(res[[i]]))
    }
    treat <- sapply(treatlist, '[', seq(max(sapply(treatlist, length))))
    treatment <- as.numeric(na.exclude(as.vector(treat)))
    resp <- sapply(res, '[', seq(max(sapply(res, length))))
    response <- as.numeric(na.exclude(as.vector(resp)))
    myData <- as.data.frame(cbind(treatment, response))
    anova <- anova(lm(response ~ treatment, data = myData))
    pvalue <- anova$"Pr(>F)"[1]
    pvalue
  })() )
  est <- mean(p >= 0.05)
  ci <- est + c(-1,1)*qnorm(.975)*sqrt(est*(1-est)/5000)
  return(list(cbind('Lower' = ci[1], 'Estimate' = est, 'Upper' = ci[2]),p))
}

#Part B

# This list of samples meets all of the requirements of an ANOVA test: they are independently collected (randomly selected), they are sample from a
# normal population (rnorm), and the samples have homoscedasticity because they all come from a rnorm with sd = 1. 
#
# The null hypothesis is true in this case as none of the sample means should be different as they are drawn from a normal population with mean = 0.

a <- list(function() rnorm(10), function() rnorm(10), function() rnorm(10))
rnormstudy <- anova.simulation(K = a)
hist(rnormstudy[[2]], main = 'Distribution of P-Values', xlab = 'P-Values') # This shows that the pvalues are uniformly distributed

1 - rnormstudy[[1]][2] #This is the estimate of the proportion of pvalues less than or equal to 0.05

#Part C

shape1 <- 0.05
shape2 <- 0.2
mean <- shape1/(shape1+shape2)
sd <- sqrt((shape1*shape2)/((shape1+shape2)^2*(shape1+shape2+1)))
n <- 10
pop3 <- function() ( rbeta(n,shape1=shape1,shape2=shape2) - mean ) / sd
hist(pop3())

# In this case the normal population assumption is violated as the third population samples from a non-normal population, but the other two are met.

n <- 2
b <- list(function() rnorm(n), function() rnorm(n), pop3())
PartCn2 <- anova.simulation(K = b)

n <- 4
c <- list(function() rnorm(n), function() rnorm(n), pop3())
PartCn4 <- anova.simulation(K = c)

n <- 10
d <- list(function() rnorm(n), function() rnorm(n), pop3())
PartCn10 <- anova.simulation(K = d)

rbind( 1 - PartCn2[[1]], 1 - PartCn4[[1]], 1 - PartCn10[[1]])

# The size of the test decreases with greater sample sizes

# Part D

# The ANOVA conditions are met in all cases except for where the standard deviation becomes 3.0 which violates the equal variance assumption.

n <- 5
e <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 0, 1))
f <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 0.5, 1))
g <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 1, 1))
h <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 0, 3))
k <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 0.5, 3))
l <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 1, 3))

estmatrix <- rbind(anova.simulation(e)[[1]],anova.simulation(f)[[1]],anova.simulation(g)[[1]],anova.simulation(h)[[1]],anova.simulation(i)[[1]],
               anova.simulation(j)[[1]])
row.names(estmatrix) <- c('Mean 0, SD 1','Mean .5, SD 1','Mean 1, SD 1','Mean 0, SD 3','Mean .5, SD 3','Mean 1, SD 3')
estmatrix

n <- 20
e <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 0, 1))
f <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 0.5, 1))
g <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 1, 1))
h <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 0, 3))
k <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 0.5, 3))
l <- list(function() rnorm(n), function() rnorm(n), function() rnorm(n, 1, 3))

estmatrixn20 <- rbind(anova.simulation(e)[[1]],anova.simulation(f)[[1]],anova.simulation(g)[[1]],anova.simulation(h)[[1]],anova.simulation(i)[[1]],
                   anova.simulation(j)[[1]])
row.names(estmatrixn20) <- c('Mean 0, SD 1','Mean .5, SD 1','Mean 1, SD 1','Mean 0, SD 3','Mean .5, SD 3','Mean 1, SD 3')
estmatrixn20

estmatrixn20 > estmatrix

#In general having a larger sample size helped improve the size of the test
