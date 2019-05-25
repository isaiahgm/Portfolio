#Sets Directory to grab Raw .txt files
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

date <- "102218"

#Grabbing Emails from the .txt file
FailedEmails <- readLines(paste('RawEmails ',date,'.txt', sep = ''))
FE2 <- FailedEmails[grepl('To:\t.', FailedEmails)]
FE3 <- gsub('To:\t', '', FE2)
FE4 <- unique(FE3)

#Creating a Reason Vector
Reason <- c()

#3 Types. Bad Address, Bad Domain, Automatically Blocked
#Grabbing Failure Reason from the .txt file
RE2 <- FailedEmails[!grepl('From:', FailedEmails)]
RE3 <- RE2[grepl('<.+@.+>',RE2)]

#User Unknown
UserUnknown <- RE3[grepl('User unknown', RE3)]
UU2 <- gsub('>.+', '', gsub('.+<', '', UserUnknown))
UU3 <- unique(sapply(UU2, function(x) match(x, table = FE4)))

Reason[UU3] <- "Unknown User"

UU4 <- RE2[grep('<.+@.+>',RE2) + 1]
UU5 <- RE3[grepl('55', UU4)]
UU6 <- gsub('>.*','', gsub('.*<','',UU5))
UU7 <- unique(sapply(UU6, function(x) match(x,table = FE4)))

Reason[UU7] <- "Unknown User"

#Bad Domain
ConnectTO <- RE3[grepl('Deferred', RE3)]
CTO2 <- gsub('>.+','',gsub('<','', ConnectTO))
CTO3 <- unique(sapply(CTO2, function(x) match(x,table = FE4)))

Reason[CTO3] <- "Incorrect Domain"

ConnectTO2 <- RE3[grepl('Host unknown', RE3)]
CTO4 <- gsub('>.+','',gsub('.+<','', ConnectTO2))
CTO5 <- unique(sapply(CTO4, function(x) match(x,table = FE4)))

Reason[CTO5] <- "Incorrect Domain"

#Blocked / Marked as Span
BL1 <- RE2[grep('<.+@.+>',RE2) + 1]
BL2 <- RE3[grepl('spam', BL1)]
BL3 <- gsub('>.*','', gsub('.*<','',BL2))
BL4 <- unique(sapply(BL3, function(x) match(x,table = FE4)))

Reason[BL4] <- "Marked Spam"

#Writting Final Table
FinalTable <- cbind("Email" = FE4,"Reason" = Reason)
write.table(FinalTable,file=paste('FailedEmails',date,'.csv', sep = ''), quote=FALSE, sep=",", row.names=FALSE)
