# Consider the data in the accompanying 'crime.csv' file.  We only desire the
# data in those rows that contain state names in capital letters as the first
# elements on the lines.  Without editing the 'crime.csv' file and without
# creating any other files, get the desired data in a data frame called
# 'crime'.  Hint: you should have exactly 50 rows and 35 columns.
# [7 pts.]

crimea <- readLines('crime.csv')
crimeb <- crimea[grepl('[A-Z][A-Z]+.+', crimea)]
crimec <- crimeb[1:50]
crimed <- gsub('\\"',"\\'",crimec)
e <- gsub('\\"(\\d)+,(\\d)', "\\1\\2", crimec)
f <- gsub('(\\d),(\\d)(\\d)(\\d)\\\"', '\\1\\2\\3\\4', e)
g <- gsub('\\"','',f)

crimef <- read.csv(textConnection(g), header = FALSE) 
crimef

# Compute the mean of the third column in the crime data frame.
# [3 pts.]
mean(as.numeric(crimef$V3))

