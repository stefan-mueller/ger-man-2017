# 2017 German federal election manifestos
This repository contains the 2017 German federal election manifestos of the six most popular parties (CDU/CSU, SPD, Bündnis 90/Die Grünen, DIE LINKE, AfD, FDP).

You can load the manifestos into R with the [quanteda](github.com/kbenoit/quanteda) package. You can download or clone the repository to use the text corpus. You can also download [this .Rdata file](https://github.com/stefan-mueller/ger-man-2017/blob/master/manifestos-corpus/corpus_ger_man_2017.Rdata) to your computer and use the following command to import the texts as a quanteda corpus.

```r
# Load quanteda package
library(quanteda)

# Load corpus file
load("path/to/file/corpus_ger_man_2017.Rdata")

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
```

You can use the script [load_and_explore_corpus.R]("https://github.com/stefan-mueller/ger-man-2017/blob/master/code/01_load_and_explore_corpus.R") to load the corpus into R, transform it to a document-feature matrix, get the most frequent words for each manfesto and to estimate Wordfish and Correspondence Analysis positions.
