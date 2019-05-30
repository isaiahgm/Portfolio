### Inputs ###
startDate <- readline(prompt = "Enter the date for reconciliation (format as mmddyy): ")
endDate <- readline(prompt = "If the reconciliation is over multiple days enter the last date, otherwise hit Enter: ")

#Setup
setwd(dirname(parent.frame(2)$ofile)) #If sourcing the file
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) #If running the file within R-Studio
library(dplyr)
library(tidyverse)
library(readxl)

# Create the date range vector
if (endDate != "") {
    startDateFormatted <- as.Date(startDate, '%m%d%y')
  dateRange <- NULL
  i <- 1
  while(startDateFormatted != as.Date(endDate, '%m%d%y') + 1) {
    dateRange[i] <- as.character.Date(startDateFormatted, '%m%d%y')
    startDateFormatted <- startDateFormatted + 1
    i <- i + 1
  }
} else {
  dateRange <- startDate
}

### Read in Data and Refine to comparable table ###


## Create Individual Tables from each source ##
# CampusCall Report
# First grab all days specified in the dateRange argument
CC_Report_list <- list(NA)
for (i in 1:length(dateRange)) {
  if (file.exists(paste('CampusCall Data/(Reconcile) SCC Plg Report ', dateRange[i], '.csv', sep =""))) {
    CC_Report_list[[i]] <- read.csv(paste('CampusCall Data/(Reconcile) SCC Plg Report ',dateRange[i],'.csv',sep = ""), 
      stringsAsFactors = FALSE) %>%
      as.tbl() %>%
      filter(PLEDGE_DATE != "PLEDGE_DATE") %>% # Remove duplicate header rows
      #mutate_at(1, funs(as.Date)) %>% # Converts Dates to Date format
      mutate_at(c(2,3,6,7),funs(as.numeric)) %>%  # Change Data type from character to number where important
      mutate_at(6, funs(./NUMBER_PAYMENTS)) %>% # Pledge Amounts now match what LDSP will report (EFTS are now per payment)
      mutate_at(8, funs(as.character)) %>% # Stores Designation as a character string instead of a number
      mutate(PAYMENT_TYPE = replace(PAYMENT_TYPE, PAYMENT_TYPE == 'C', 'Pledge')) %>%  # This and following steps recode the payment type
      mutate(PAYMENT_TYPE = replace(PAYMENT_TYPE, PAYMENT_TYPE == 'D', 'OneTime')) %>% # to understandable factor levels 
      mutate(PAYMENT_TYPE = replace(PAYMENT_TYPE, PAYMENT_TYPE == 'E' & NUMBER_PAYMENTS != 1, 'Monthly')) %>%
      mutate(PAYMENT_TYPE = replace(PAYMENT_TYPE, PAYMENT_TYPE == 'E' & NUMBER_PAYMENTS == 1, 'Annually')) %>%
      select(-7) %>% # Remove the number of payments column as it is no longer needed
      mutate(Source = 'CC') %>%
      `colnames<-`(c('Date','ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Employee','Source'))
  } else {
    CC_Report_list[[i]] <- NULL
  }
}  

# Bind the rows of all these tables unless totally empty then produce a warning message
if (!is_empty(CC_Report_list)) {
  CC_Report <- bind_rows(CC_Report_list)
} else {
  CC_Report <- NULL
  warning("CampusCall Data Export not detected.")
}

# One Time Gifts reported by LDSP
# First grab all days specified in the dateRange argument
LDSP_OneTime_List <- list(NA)
for (i in 1:length(dateRange)) {
  if (file.exists(paste('LDSP OneTime Gifts/Telefund One-Time ', dateRange[i],'.xlsx', sep=""))) {
    LDSP_OneTime_List[[i]] <- read_xlsx(paste('LDSP OneTime Gifts/Telefund One-Time ', dateRange[i],'.xlsx', sep="")) %>%
      as.tbl() %>%
      select(4:5,7:10,19) %>% # selects only significant columns
      `colnames<-`(c('Date','FirstName','LastName','ID','Amount','DesignationDes','Employee')) %>%
      mutate(ID = as.numeric(ID)) %>%
      mutate(DonationType = 'OneTime') %>%
      mutate(Source = 'LDSP') %>%
      mutate(Designation = gsub('.+\\((\\d{8}).+','\\1',DesignationDes)) # Create Designation Number 
  } else {
    LDSP_OneTime_List[[i]] <- NULL
  }
}

# Bind the rows of all these tables unless totally empty then produce a warning message
if (!is_empty(LDSP_OneTime_List)) {
  LDSP_OneTime <- bind_rows(LDSP_OneTime_List)
  LDSP_OneTime$Date <- as.Date(format(as.POSIXct(LDSP_OneTime$Date,format='%m/%d/%Y %H:%M:%S'),format='%m/%d/%Y'), '%m/%d/%Y')
} else {
  LDSP_OneTime <- NULL
  warning("No LDSP One-Time Gifts file detected.")
}


# Recurring Gifts reported by LDSP
LDSP_Recurring_List <- list(NA)
for (i in 1:length(dateRange)) {
  if (file.exists(paste('LDSP Recurring Gifts/Telefund Recurring ', dateRange[i],'.xlsx', sep = ""))) {
    LDSP_Recurring_List[[i]] <- read_xlsx(paste('LDSP Recurring Gifts/Telefund Recurring ', dateRange[i],'.xlsx', sep = "")) %>%
      as.tbl() %>%
      select(4,8,5,7,9,10,18,19) %>%
      `colnames<-`(c('Date','ID','FirstName','LastName','Amount','DesignationDes','DonationType','Employee')) %>%
      mutate(ID = as.numeric(ID)) %>%
      mutate(Source = 'LDSP') %>%
      mutate(Designation = gsub('.+\\((\\d{8}).+','\\1',DesignationDes))
  } else {
    LDSP_Recurring_List[[i]] <- NULL
  }
}

# Bind the rows of all these tables unless totally empty then produce a warning message
if (!is_empty(LDSP_Recurring_List)) {
  LDSP_Recurring <- bind_rows(LDSP_Recurring_List)
  LDSP_Recurring$Date <- as.Date(format(as.POSIXct(LDSP_Recurring$Date,format='%m/%d/%Y %H:%M:%S'),format='%m/%d/%Y'), '%m/%d/%Y')
} else {
  LDSP_Recurring <- NULL
  warning("No LDSP Recurring Gifts files were detected.")
}

## Create a table combine previous tables ##
if (exists(c("LDSP_Recurring","LDSP_OneTime","CC_Report"))) {
  Combined <- bind_rows(CC_Report[,c(2:8,10,9)], LDSP_OneTime[,c(4,2,3,5,10,8,9,7)], LDSP_Recurring[,c(2:5,10,7,9,8)]) %>%
    arrange(LastName)
} else if (exists(c("LDSP_OneTime","CC_Report"))) {
  Combined <- bind_rows(CC_Report[,c(2:8,10,9)], LDSP_OneTime[,c(4,2,3,5,10,8,9,7)]) %>%
    arrange(LastName)
} else if (exists(c("LDSP_Recurring","CC_Report"))) {
  Combined <- bind_rows(CC_Report[,c(2:8,10,9)], LDSP_Recurring[,c(2:5,10,7,9,8)]) %>%
    arrange(LastName)
}

### Reconciliation ###


# Split the Combined records into records groups that share a common ID number. i.e. each group is its own dataframe
# and represents a single donation.
Combined <- Combined[is.na(Combined$SpouseID),] %>%
  mutate(SpouseID = ID) %>%
  bind_rows(Combined[!is.na(Combined$SpouseID),]) # This will fill the Spouse ID slot if it is not already filled
grouped_id <- split(Combined, Combined$ID)
grouped_records <- lapply(c(1:length(grouped_id)), function(x) 
  {unique(merge.data.frame(grouped_id[[x]], bind_rows(grouped_id),by = "SpouseID")[,c(1,10:17)])})
grouped_records <- grouped_records %>%
  unique()
# Add a donation ID to each donation
grouped_records <- mapply(cbind, grouped_records, "DonationID"=c(1:length(grouped_records)), SIMPLIFY=F)

# The following code is a series of algorithms that categorize each donation in a tree pattern. In the end, all of the donations
# will be reorganized into a dataframe similar to the Combined data frame but will have a labeling added.First pledge form donations 
# are Identified and removed so they do not interfere with identifying records that should have a CC or LDSP counterpart but don't. 
# Those records are then removed so they do not interfere with identifying matched records.
# The data in _grp are consolidations of the data into a single dataframe. These _grp will be used at the end of the process to
# bind everything back together.
# Identify Records that are pledges done correctly
correct_pledges <- grouped_records[sapply(c(1:length(grouped_records)), function(x) {any(grouped_records[[x]]$DonationType.y == 'Pledge')})]
correct_pledges_grp <- bind_rows(correct_pledges) %>%
  `colnames<-`(c('ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Source','Employee', 'DonationID'))

# Grouped Records 2 has correct pledge donations removed from it
grouped_records_2 <- grouped_records[!sapply(c(1:length(grouped_records)), function(x) {any(grouped_records[[x]]$DonationType.y == 'Pledge')})]

# Identify Records that have no match
lonely_records <- grouped_records_2[sapply(c(1:length(grouped_records_2)), function(x) {nrow(grouped_records_2[[x]]) == 1})]
if (length(lonely_records) > 0) {
  lonely_records_grp <- bind_rows(lonely_records) %>%
  `colnames<-`(c('ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Source','Employee', 'DonationID'))
} else {
  lonely_records_grp <- NULL
}

# Grouped Records 3 has lonely records removed from it
grouped_records_3 <- grouped_records_2[!sapply(c(1:length(grouped_records_2)), function(x) {nrow(grouped_records_2[[x]]) == 1})]

# Identify any records that contain an extra transaction than the one reported by CC and the one reported by LDSP
des1_records <- grouped_records_3[sapply(c(1:length(grouped_records_3)), function(x) 
  {(nrow(grouped_records_3[[x]]) == 2) && any(grouped_records_3[[x]]$Source.y == 'LDSP') && any(grouped_records_3[[x]]$Source.y == 'CC')})]

extra_records <- grouped_records_3[!sapply(c(1:length(grouped_records_3)), function(x) 
  {(nrow(grouped_records_3[[x]]) == 2) && any(grouped_records_3[[x]]$Source.y == 'LDSP') && any(grouped_records_3[[x]]$Source.y == 'CC')})]
if (length(extra_records) > 0) {
  extra_records_grp <-  bind_rows(extra_records) %>%
    `colnames<-`(c('ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Source','Employee', 'DonationID'))
} else {
  extra_records_grp <- NULL
}

## Sort records in the 1 Designation rows ##
# This section does not break up the data further, but seeks to identify what each donation sorted into single designation
# records is whether it is correct or has one of three errors. To be correct a donation must be consistent in three components
# Amount, Designation, and Donation Type. The three error types are based on whether a donation is inconsistent in any one
# of those components.
correct_des1_records <- des1_records[sapply(c(1:length(des1_records)), function(x) {any(duplicated(des1_records[[x]][,5:7]))})]
if (length(correct_des1_records) > 0) {
  correct_des1_records_grp <-  bind_rows(correct_des1_records) %>%
    `colnames<-`(c('ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Source','Employee', 'DonationID'))
} else {
  correct_des1_records_grp <- NULL
}

# Incorrect Amount in single designation records
incorrect_amount_des1_records <- des1_records[!sapply(c(1:length(des1_records)), function(x) {any(duplicated(des1_records[[x]][,5]))})]
if (length(incorrect_amount_des1_records) > 0) {
  incorrect_amount_des1_records_grp <-  bind_rows(incorrect_amount_des1_records) %>%
    `colnames<-`(c('ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Source','Employee','DonationID'))
} else {
  incorrect_amount_des1_records_grp <- NULL
}

# Incorrect Designation in single designation records
inconsistent_designation_des1_records <- des1_records[!sapply(c(1:length(des1_records)), function(x) {any(duplicated(des1_records[[x]][,6]))})]
# With Incorrect Designation find those that were correctly placed as other account in CampusCall
if (length(inconsistent_designation_des1_records) > 0) {
  incorrect_designation_des1_records <- inconsistent_designation_des1_records[!sapply(1:length(inconsistent_designation_des1_records), function (x) 
    {any(grepl('0{5}',inconsistent_designation_des1_records[[x]]$Designation.y))})]
  nonissue_designation_des1_records <- inconsistent_designation_des1_records[sapply(1:length(inconsistent_designation_des1_records), function (x) 
    {any(grepl('0{5}',inconsistent_designation_des1_records[[x]]$Designation.y))})]
} else {
  incorrect_designation_des1_records <- NULL
  nonissue_designation_des1_records <- NULL
}

# Create Group Tables
if (length(incorrect_designation_des1_records) > 0) {
  incorrect_designation_des1_records_grp <-  bind_rows(incorrect_designation_des1_records) %>%
    `colnames<-`(c('ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Source','Employee', 'DonationID'))
} else {
  incorrect_designation_des1_records_grp <- NULL
}
if (length(nonissue_designation_des1_records) > 0) {
  nonissue_designation_des1_records_grp <-  bind_rows(nonissue_designation_des1_records) %>%
    `colnames<-`(c('ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Source','Employee', 'DonationID'))
} else {
  nonissue_designation_des1_records_grp <- NULL
}

# Incorrect Donation Type in single designation records
incorrect_donationtype_des1_records <- des1_records[!sapply(c(1:length(des1_records)), function(x) {any(duplicated(des1_records[[x]][,7]))})]
if (length(incorrect_donationtype_des1_records) > 0) {
  incorrect_dontype_des1_records_grp <-  bind_rows(incorrect_donationtype_des1_records) %>%
    `colnames<-`(c('ID','SpouseID','FirstName','LastName','Amount','Designation','DonationType','Source','Employee', 'DonationID'))
} else {
  incorrect_dontype_des1_records_grp <- NULL
}




### Generate Report ###


# Correct Donation Report
Correct_Donations <- bind_rows(correct_des1_records_grp,correct_pledges_grp,nonissue_designation_des1_records_grp, 
                               .id = 'ResultType') %>%
  mutate(ResultType = recode(ResultType, '1' = 'Correct', '2' = 'Corr Plg', '3' = 'NonIssue Designation'))

# Incorrect Donation Report
Incorrect_Donations <- list(lonely_records_grp,
                            incorrect_amount_des1_records_grp,
                            incorrect_designation_des1_records_grp,
                            incorrect_dontype_des1_records_grp,
                            extra_records_grp
                            )
Error_Types <- c('No Match','Incorrect Amount', 'Inconsistent Designation','Mislabeled Donation','Potential Reused ID')

Donation_Report <- lapply(c(1:5), function (x) {cbind('ResultType' = Error_Types[x], Incorrect_Donations[[x]])})
Donation_Report <- suppressWarnings(bind_rows(Donation_Report[sapply(c(1:5), function (x) {!is_empty(Incorrect_Donations[[x]])})]))
Complete_Report <- bind_rows(Donation_Report, Correct_Donations[,c(2:11,1)])


## Write Reports to file ##
if(length(dateRange) > 1) {
  write.table(Complete_Report,file=paste('Daily Donation Reports/', startDate,' - ', endDate,' Donation Report.csv', sep = ''), 
              quote=FALSE, sep=",", row.names=FALSE)
  write.table(Donation_Report,file=paste('Daily Error Reports/', startDate,' - ', endDate,' Donation Error Report.csv', sep = ''), 
              quote=FALSE, sep=",", row.names=FALSE)
} else if (length(dateRange) > 0) {
  write.table(Complete_Report,file=paste('Daily Donation Reports/', startDate,' Donation Report.csv', sep = ''), 
              quote=FALSE, sep=",", row.names=FALSE)
  write.table(Donation_Report,file=paste('Daily Error Reports/', startDate,' Donation Error Report.csv', sep = ''), 
              quote=FALSE, sep=",", row.names=FALSE)
}

print("Report Generation Complete")