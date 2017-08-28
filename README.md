# Text corpus of the 2017 German federal election manifestos
This repository contains the 2017 German federal election manifestos of 24 parties participating in the 2017 general election. The anayses below are based on the six most popular parties ([CDU/CSU](manifestos-pdf/2017_CDU.pdf), [SPD](manifestos-pdf/2017_SPD.pdf), [Bündnis 90/Die Grünen](manifestos-pdf/2017_Gruene.pdf), [DIE LINKE](manifestos-pdf/2017_Linke.pdf), [AfD](manifestos-pdf/2017_AfD.pdf), [FDP](manifestos-pdf/2017_FDP.pdf)). This is because some of the smaller parties either have very short manifestos (which makes it difficult to scale these documents) or only published a fundamental program, not an election-specific manifesto.

The manifestos are loaded into R as a [quanteda](http://github.com/kbenoit/quanteda) corpus. You can clone the repository to use the text corpus. You can also download the file [corpus_ger_man_2017.Rdata](https://github.com/stefan-mueller/ger-man-2017/blob/master/manifestos-corpus/corpus_ger_man_2017.Rdata) to your machine and use the following command to import the texts as a quanteda corpus. The raw manifestos are available as PDF files in the folder [manifestos-pdf](manifestos-pdf).

```r
## Load packages
library(quanteda)
library(ggplot2)
library(dpylr)

## Load corpus file
load("path/to/file/corpus_ger_man_2017.Rdata")

## Only select the six major parties for the analysis
parties_select <- c("CDU-CSU", "SPD", "AfD", "Gruene", "Linke", "FDP")
corpus_ger_man_2017 <- corpus_subset(corpus_ger_man_2017, party %in% parties_select)

## Get summary of documents in corpus
summary(corpus_ger_man_2017)

# Corpus consisting of 6 documents.
# 
#     Text Types Tokens Sentences year   party      type
#      AfD  5972  21272       742 2017     AfD manifesto
#  CDU-CSU  4974  23034      1291 2017 CDU-CSU manifesto
#      FDP  9039  43383      2039 2017     FDP manifesto
#   Gruene 13185  81525      4011 2017  Gruene manifesto
#    Linke 12308  77004      2885 2017   Linke manifesto
#      SPD  8396  43827      2411 2017     SPD manifesto
# 
# Source:  Party manifestos of 2017 German federal election
# Created: Mon Aug 28 23:03:20 2017
# Notes:   Corpus created by Stefan Müller (muellerstefan.net)
```

You can use the script [load_and_explore_corpus.R](code/01_load_and_explore_corpus.R) to load the corpus into R, transform it to a document-feature matrix, get the most frequent words for each manfesto and to estimate Wordfish and Correspondence Analysis positions.

Plot the dispersion of the word "Gerechtigkeit" (justice, fairness) across the manifestos.
```r
textplot_xray(kwic(corpus_ger_man_2017, "Gerechtigkeit"))
```

![The dispersion of the word "Gerechtigkeit" (justice, fairness) across the manifestos.
](https://github.com/stefan-mueller/ger-man-2017/blob/master/output/plot_xray.png)

Interestingly, the CDU/CSU hardly mentions "Gerechtigkeit" only once while the word is missing entirely in the FDP manifesto.
The Greens devote a large section of their manifesto to justice, in the manifestos by the Left party (DIE LINNKE) and the SPD the word is spread throughout the entire manifesto. The token index for all manifestos (x-axis) is rescaled and standardised from 0 to 1.

Plot the 15 most frequent words per manifesto (after removing stopwords).

```r
## Define additonal German stopwords
stopwords_additional <- c("ab", "dass", "deshalb", "seit",
                          "statt", "n", "sowie")

## Transform to document feature matrix
dfm_man <- dfm(corpus_ger_man_2017, remove = c(stopwords("german"), stopwords_additional),
               tolower = TRUE, remove_punct = TRUE, remove_numbers = TRUE)

## Weight dfm by relative frequency
dfm_man_weight <- dfm_weight(dfm_man, type = "relfreq")

## Get most frequent words by party
freq <- textstat_frequency(dfm_man_weight, 
                           groups = docvars(corpus_ger_man_2017, "party"), 
                           n = 15)

freq_ordered <- freq[seq(dim(freq)[1],1),] # reorder rows for plotting

freq_ordered$order <- 1:nrow(freq_ordered)

## Plot most frequent words by party
ggplot(data = freq_ordered, aes(x = order, y = frequency)) +
  geom_point() +
  facet_wrap(~ group, scales = "free", nrow = 2) +
  coord_flip() +
  scale_x_continuous(breaks = freq_ordered$order, 
                     labels = freq_ordered$feature) +
  labs(x = NULL, y = "Relative frequency") + 
  theme_custom()
```

![The 15 most frequent words per manifesto (after removing stopwords).](https://github.com/stefan-mueller/ger-man-2017/blob/master/output/plot_topfeatures.png)

Estimate party positions with a [Wordfish](http://www.wordfish.org/uploads/1/2/9/8/12985397/slapin_proksch_ajps_2008.pdf) model and [Correspondence Analysis](http://www.jstatsoft.org/v20/i03/).

```r
## Select minimum frequency and occurence
dfm_man_trim <- dfm_trim(dfm_man, min_count = 2)

## Run Wordfish model
model_wordfish <- textmodel_wordfish(dfm_man_trim)

## Run correspondence analysis
model_ca <- textmodel_ca(dfm_man_trim)

## Plot models

## Create label
party_label <- paste(docvars(corpus_ger_man_2017, "party"), "2017", sep = " ")

textplot_scale1d(model_wordfish, margin = "documents", doclabels = party_label) +
  labs(title = "Wordfish estimates")

textplot_scale1d(model_ca, doclabels = party_label) +
  labs(title = "Correspondence analysis")
```
![Wordscores and Correspondence Analysis of Manifestos](https://github.com/stefan-mueller/ger-man-2017/blob/master/output/plot_textmodels.png)

```
To cite the corpus in publications, please use the following:

  Müller, Stefan. 2017. ger-man-2017: Text corpus of the 2017 German federal election 
  manifestos. Version 1.0: http://github.com/stefan-mueller/ger-man-2017.

  @Manual{,
    title = {ger-man-2017: Text corpus of the 2017 German federal election},
    author = {Stefan Müller},
    note = {Version 1.0},
    url = {http://github.com/stefan-mueller/ger-man-2017},
  }
```