#Birthday.R

#CI function from in class lecture. I hope that this is okay, I didn't want to rewrite a formula to do the same thing
ci <- function(x,sd=NA,confidence.level=0.95) {
  alpha <- 1 - confidence.level
  if ( !is.na(sd) ) {
    tableValue <- qnorm(alpha/2,lower.tail=FALSE)
  } else {
    tableValue <- qt(alpha/2,df=length(x)-1,lower.tail=FALSE)
    sd <- sd(x)
  }
  r <- mean(x) + c(-1,1)*tableValue*sd/sqrt(length(x))
  names(r) <- c("Lower bound","Upper bound")
  r
}

#Birthday Function
birthday <- function(n = 25, nReps = 1000) {
  match <- 0
  for(i in 1:nReps) {
    sample <- sample(1:365, n, replace = TRUE)
    match[i] <- length(sample) > length(unique(sample))
  }
  monteest <- mean(match)
  interval <- ci(match, sd=NA, confidence.level=0.95)
  return(c(interval[1],"Monte Carlo Estimate" = monteest, interval[2]))
}
birthday()

#Part 2

monten <- t(sapply(c(1:100), birthday))
plot(NULL, NULL, xlim=c(0,100), ylim=c(0,1), ylab = 'Probability')
xspline(seq(1:100),monten[,2])
xspline(seq(1:100),monten[,1], lty = 2)
xspline(seq(1:100),monten[,3], lty = 2)
xspline(seq(1:100), 1-(364/365)^(choose((1:100), 2)), border = 'red', lwd = 3)
