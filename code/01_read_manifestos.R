####################
## Read in PDF manifestos, add meta data and transform to corpus
####################

## Load required packages
library(quanteda)
library(readtext)
library(dplyr)

## Load custom ggplot2 scheme
source("code/theme_custom.R")

## Read PDF files with readtext
texts_man <- readtext("manifestos-pdf/*.pdf", 
                      docvarsfrom = "filenames",
                      dvsep = "_",
                      docvarnames = c("year", "party", "type"))

texts_man_data_frame <- as.data.frame(texts_man) %>% 
  select(-doc_id)

write.csv(texts_man_data_frame, "manifestos-corpus/ger_man_2017.csv",
          fileEncoding = "utf-8", row.names = FALSE)

## Transform to quantda corpus
corpus_ger_man_2017 <- corpus(texts_man,
                              metacorpus = list(notes = "Corpus created by Stefan Müller (muellerstefan.net)",
                                         source = "Party manifestos of 2017 German federal election"))

docnames(corpus_ger_man_2017) <- docvars(corpus_ger_man_2017, "party")

summary(corpus_ger_man_2017, 3)


# Corpus consisting of 24 documents, showing 3 documents.
# 
# Text Types Tokens Sentences year        party      type
# AfD  5972  21272       742 2017          AfD manifesto
# BUESO   718   1497        55 2017        BUESO programme
# Bayernpartei  4646  17605       846 2017 Bayernpartei programme
# 
# Source:  Party manifestos of 2017 German federal election
# Created: Mon Aug 28 23:03:20 2017
# Notes:   Corpus created by Stefan Müller (muellerstefan.net)

## Save corpus as Rdata file

save(corpus_ger_man_2017, file = "manifestos-corpus/corpus_ger_man_2017.Rdata")
