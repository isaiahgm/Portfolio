# Step 1: Read in Data Files
Domains <- read.csv('C:/Users/imoe9/Documents/School Work/STAT PROG/R Files/STAT 123/Project/Domains Form A1.csv')
  Domains$Domain <- as.character(Domains$Domain)
Form_A1 <- read.csv('C:/Users/imoe9/Documents/School Work/STAT PROG/R Files/STAT 123/Project/Form A1_only.csv', header = FALSE)

A_Ans <- read.table('C:/Users/imoe9/Documents/School Work/STAT PROG/R Files/STAT 123/Project/A1_Ans_only.txt', sep=",", stringsAsFactors =  FALSE)
A1_Ans <- A_Ans[,3:152]

str(Domains)
str(Form_A1)
str(A_Ans)


# Step 2: Student Score

Stsc <- function(x = Form_A1,y = A_Ans,z = c(1:152),a = 1, datas = Student_Scores){
  x[a,z] == y[1,z]
}

b <- 1
c <- 1
datas <- sum(Stsc(a = b), na.rm = TRUE) / 150
while(b <= 50){
  Student_Scores[c] <- sum(Stsc(a = b), na.rm = TRUE) / 150
  b <- b + 1
  c <- c + 1
}

# Question Score

Qsc <- function(x = Form_A1,y = A_Ans, a = c(1:50),d = 3){
  x[a,d] == y[1,d]
}

e <- 3
f <- 1
Q_Scores <- sum(Qsc(d = e), na.rm = TRUE) / 50
while(e <= 152){
  Q_Scores[f] <- sum(Qsc(d = e), na.rm = TRUE) / 50
  e <- e + 1
  f <- f + 1
}

# Sort Scores
  # Students
Student_Scores[order(Student_Scores)]
  # Questions
Q_Scores[order(Q_Scores)]

# Step 3: Domain Scores

DA_Ans <- data.frame(t(A1_Ans),Domains$Domain,Domains$Domain..)

Stsc(x = Form_A1[c(DA_Ans[,3] == 1),], y = DA_Ans[c(DA_Ans[,3] == 1),], datas = D_Scores)
