# Read in the data from "clothes.csv" file into a data.frame called "clothes".
# Remove all rows from the data.frame where the variable "Price" is empty,
# i.e., equal to "". 

library(dplyr)

setwd('C:/Users/imoe9/OneDrive/Documents/STAT223/homework/1')
clothes <- read.csv('clothes.csv')
clothes <- clothes[clothes$Price != "",]

# Write a function called "num" that takes a character vector of prices as
# input, removes the dollar sign, and returns a numeric vector of prices.

num <- function(string) { 
  nstring <- gsub("\\$","",string)
  as.numeric(nstring)
} 


# Using the "num" function you just wrote, convert the variable "Price" in the
# clothes data.frame from a character vector to a numeric vector.

clothes$Price <- num(clothes$Price)

# Determine the standard deviation of the price of clothes for each part of the
# body, as indicated by the variable "Body.Location".

clothest <- tbl_df(clothes)
clothest %>% group_by(Body.Location) %>% summarise(sd(Price))
