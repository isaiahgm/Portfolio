# True Value
data(trees)
fit <- lm(Volume ~ Height + Girth, data=trees)
as.numeric(coef(fit)[2] / coef(fit)[3])

#Function to create Bootstrap confidence interval
tree.strap <- function(data, alpha = 0.05, BSsamples = 5000) {
  estimate <- NULL
  for (i in 1:BSsamples) {
    index <-sample(1:nrow(data), nrow(data), replace = TRUE)
    sample <- data[index, ]
    model <- lm(sample$Volume ~ sample$Height + sample$Girth)
    estimate[i] <- as.numeric(coef(model)[2] / coef(model)[3])
  }
  quantile(estimate,probs=c(alpha/2,1-alpha/2))
}


#Confidence interval
tree.strap(trees)
