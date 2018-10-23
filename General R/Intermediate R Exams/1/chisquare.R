# The chi-squared goodness-of-fit test is used when we have counts for data
# falling into different categories.  Suppose there are 6 different restaurants
# that 52 individuals can choose on a given Friday evening and that each
# individual makes an independent decision.  

# The null hypothesis
# probability of choosing each restaurant is the same for all restaurants.
# Since we have 52 individuals, under the null hypothesis, the expected number
# of individuals choosing each restaurant is 52/6.  

# The alternative hypothesis
# probabilities are 0.1, 0.1, 0.15, 0.15, 0.2 and 0.3.

# The test
# statistic --- whether or not the null hypothesis is true --- is the sum of
# (O_i - 52/6)^2 / (52/6) for i=1,..,6, where O_i is the observed number of
# individuals who choose restaurant i.  Your job is to simulate under the null
# and alternative hypotheses to answer the following questions (28 pts.):
# 
# 1) What is the critical value for a 0.10 level of significance test?

n <- 52
test <- replicate(50000, chisq.test(tabulate(sample(1:6,n,prob=rep(1/6,6),replace=TRUE),nbins=6))$'statistic')
alt.test <- replicate(50000, chisq.test(tabulate(sample(1:6,n,prob=rep(1/6,6),replace=TRUE),nbins=6), c(0.1, 0.1, 0.15, 0.15, 0.2, 0.3) * n )$'statistic')
crit.v <- quantile(test,probs=.90,type=1) + 1
alt.crit.v <- quantile(alt.test,probs=.90,type=1) + 1

crit.v

# 2) If the observed test statistic was 12.1, what is the p-value?  Remember to
# assess the Monte Carlo error.
p.value <- 1 - pchisq(12.1, 5)
ci.p <- p.value + c(-1,1)*qnorm(.975)*sqrt(p.value*(1-p.value)/50000)

cbind('Lower' = ci.p[1], 'P-Value' = p.value, 'Upper' = ci.p[2])

# 3) What is the power for a 0.10 level of significance test?  Remember to
# assess the Monte Carlo error.
power <- mean(test >= crit.v)
ci.power <- power + c(-1,1)*qnorm(.975)*sqrt(power*(1-power)/50000)

cbind('Lower' = ci.power[1], 'Power' = power, 'Upper' = ci.power[2])

# Hint: The sample and tabulate functions will be helpful.  For example, the
# following code will sample 10 individuals' choices among 4 categories when
# the probability of each category is 1/4.