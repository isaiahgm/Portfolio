#Implement both strategies (i.e., “do not switch” versus “switch”). Give the probability 
#of winning under each of the strategies. Quantify your uncertainity about the emperically 
#estimated probabilities by forming a confidence intervals on the proportions of wins. 
#(Hint, the normal approximation to the binomial provides excellent results when the number 
#of trials is large, as it is here.)


#Function to simulate the Monty Hall Problem
pick <- function(doors = c("A", "B", "C"), switch = TRUE) {
  picked <- sample(doors,1)
  correct <- sample(doors,1)
  open <- sample(doors[doors != correct & doors != picked], 1)
  if(switch == TRUE) {
    picked <- doors[doors != open & doors != picked]
    ans <- rbind(picked, correct)
    ans
  }
  else {
    ans <- rbind(picked, correct)
    ans
  }
}

#Function to conduct a Monte Carlo Study
simulation <- function(nReps = 50000, switch = TRUE, confidence.level = 0.95) {
  reps <- replicate(nReps, pick(switch = switch), simplify = TRUE)
  match <- reps[1,] == reps[2,]
  est <- mean(match)
  alpha <- 1 - confidence.level
  ci <- est + c(-1,1)*qnorm(alpha/2, lower.tail = FALSE)*sqrt(est*(1-est)/nReps)
  cbind('Lower' = ci[1], 'Estimate' = est, 'Upper' = ci[2])
}

#Estimated Likelihood of switching vs not switching
answer <- rbind(simulation(), simulation(switch = FALSE))
row.names(answer) <- c('Switch','Stay')
answer
``
#You should switch doors every time. You are twice as likely to win if you switch doors

