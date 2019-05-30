#Setup and Libraries
setwd("C:/Users/imoe9/Documents/School Work/Big Data/Bible Assignment")
library(sparklyr)
library(dplyr)

#Starting a local connection for Spark
sc <- spark_connect(master='local', version = "2.1.0")

#Importing Text file into Spark
#This sets a path for Spark to find the working directory
bible_path <- paste0("file:///", getwd(), "/bible.txt")
#spark_read_text is like the readLines command
bible <-  spark_read_text(sc, "bible", bible_path)

#Remove all puncutation and numbers first with "regexp_replace" which is like gsub. Remember %>% is like a pipe line operator
words_nopunc <- bible %>%
  mutate(line = regexp_replace(line, "[_\"():;,.!?\\-]", " ")) %>%
  mutate(line = regexp_replace(line, "[0-9]", "")) %>%
  mutate(line = regexp_replace(line, "[\']", ""))

#Now separate all words in each line. "ft_tokenizer" does this automatically and gives the line, and the words in it in a list
words_all <- words_nopunc %>%
  ft_tokenizer(input.col = "line",
               output.col = "word_list")

#Now explode all words into individual lines
words_ind <- words_all %>%
  mutate(word = explode(word_list))
  
word_count <- words_ind %>%
  group_by(word) %>%
  tally() %>%
  arrange(desc(n)) %>%
  filter(n != 181438)

word_count

word_count <- word_count %>%
  compute("word_count")

spark_write_csv(word_count, "word_count")


