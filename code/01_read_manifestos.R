####################
## Read in PDF manifestos, add meta data and transform to corpus
####################

## Load required packages
library(quanteda)
library(readtext)

## Load custom ggplot2 scheme
source("code/theme_custom.R")

## Read PDF files with readtext
texts_man <- readtext("manifestos-pdf/*.pdf", 
                      docvarsfrom = "filenames",
                      dvsep = "_",
                      docvarnames = c("year", "party"))

texts_man_data_frame <- as.data.frame(texts_man) %>% 
  select(-doc_id)

write.csv(texts_man_data_frame, "manifestos-corpus/ger_man_2017.csv",
          fileEncoding = "utf-8", row.names = FALSE)

## Transform to quantda corpus
corpus_ger_man_2017 <- corpus(texts_man,
                              metacorpus = list(notes = "Corpus created by Stefan Müller (muellerstefan.net)",
                                         source = "Party manifestos of 2017 German federal election (https://bundestagswahl-2017.com/wahlprogramm/)"))

docnames(corpus_ger_man_2017) <- docvars(corpus_ger_man_2017, "party")

summary(corpus_ger_man_2017)


# Corpus consisting of 6 documents.
# 
# Text Types Tokens Sentences year  party
# AfD  5972  21272       742 2017    AfD
# CDU  4974  23034      1291 2017    CDU
# FDP  9039  43383      2039 2017    FDP
# Gruene 13185  81525      4011 2017 Gruene
# Linke 12308  77004      2885 2017  Linke
# SPD  8396  43827      2411 2017    SPD
# 
# Source:  Party manifestos of 2017 German federal election (https://bundestagswahl-2017.com/wahlprogramm/)
# Created: Fri Aug 18 16:50:40 2017
# Notes:   Corpus created by Stefan Müller (muellerstefan.net)

## Save corpus as Rdata file

save(corpus_ger_man_2017, file = "manifestos-corpus/corpus_ger_man_2017.Rdata")
