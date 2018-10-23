# Based on a permutation test with 10,000 replications, does Class 1 increase ACT scores on average?
# Answer the same question for Class 2? 

act <- read.table('act.txt', header = TRUE)
attach(act)

# Observed Stats for both classes
obs.class1 <- mean((post[class == 'class1'] - pre[class == 'class1']) > 0) 
obs.class2 <- mean((post[class == 'class2'] - pre[class == 'class2']) > 0) 


# Null Hypothesis: That neither class makes any difference in score. There is no difference. 

# Permute before and after

act.permute <- function(dataset = act, nReps = 10000) {
  result <- NULL
  for ( i in 1:as.numeric(nReps)) {
    dat <- dataset[,1:2]
    for ( j in 1:nrow(dataset) ) {
      dat[j,1:2] <- sample(act[j,1:2])
    }
    result[i] <- mean((dat[,2] - dat[,1]) > 0)
  }
  result
}

# Class 1 based on Class 1 distribution
den <- act.permute(act[class == 'class1',])
plot(density(den))
abline(v = obs.class1)
mean(abs(den)>=abs(obs.class1))

# Class 2 based on Class 2 distribution
den2 <- act.permute(act[class == 'class2',])
plot(density(den2))
abline(v = obs.class2)
mean(abs(den)>=abs(obs.class2))

# Class 1 & 2 based on overall distribution
den3 <- act.permute(act)
plot(density(den3))
abline(v = obs.class1, col = 'red')
abline(v = obs.class2, col = 'blue')

mean(abs(den3)>=abs(obs.class1))
mean(abs(den3)>=abs(obs.class2))

# Class 1 Has an insignficant result meaning it does not on average increase scores significant;y, but class 2 is significant
# meaning it does in fact raise scores more than would be expected from natural variation.

# Write a conclusion (as R comments) as to which class (or, neither class) you would recommend. Justify your answers.
#
# I recommend the second class for those searching for an ACT prep class. While half of the students reported higher scores in
# the first class this actually is not significantly different from what would be expected. On the other hand the second class
# has shown that 70% of students reported and increased score which is significantly more than what would be expected if there
# was no true improvement.