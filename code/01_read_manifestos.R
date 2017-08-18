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
corpus_ger_man_2017 <- corpus(texts_man)

docnames(corpus_ger_man_2017) <- docvars(corpus_ger_man_2017, "party")

summary(corpus_ger_man_2017)

## Save corpus as Rdata file

save(corpus_ger_man_2017, file = "manifestos-corpus/corpus_ger_man_2017.Rdata")
