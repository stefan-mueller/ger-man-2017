####################
## Load and explore corpus with 2017 manifestos
####################

# Load required packages
library(quanteda)
library(ggplot2)
library(dplyr)

# Note: Specify working directory (or use RStudio project)

## Load corpus (corpus_ger_man_2017) from computer
load("manifestos-corpus/corpus_ger_man_2017.RData")

## Load corpus from GitHub repository

github.download = function(url) { 
  fname <- tempfile() 
  system(sprintf("curl -3 %s > %s", url, fname)) 
  return(fname) 
} 

custdata <- load(github.download("https://github.com/stefan-mueller/ger-man-2017/blob/master/manifestos-corpus/corpus_ger_man_2017.Rdata")) 

githubURL <- "https://github.com/stefan-mueller/ger-man-2017/blob/master/manifestos-corpus/ger_man_2017.csv"

corpus_texts <- read.csv(url(githubURL))

load(url(githubURL))
head(df)

library(rio)
library(readr)

y <- read_csv("https://github.com/stefan-mueller/ger-man-2017/blob/master/manifestos-corpus/ger_man_2017.csv")

x <- getURL("https://github.com/stefan-mueller/ger-man-2017/blob/master/manifestos-corpus/ger_man_2017.csv")
y <- read.csv(x)


source_data("https://github.com/opetchey/RREEBES/raw/Beninca_development/Beninca_etal_2008_Nature/data/GLE_estimate.Rdata?raw=True")
load("https://github.com/stefan-mueller/ger-man-2017/blob/master/manifestos-corpus/corpus_ger_man_2017.Rdata")
# Check occurence of words within manifestos
textplot_xray(kwic(corpus_ger_man_2017, "Flüchtling*"),
              kwic(corpus_ger_man_2017, "Einwanderung*"),
              kwic(corpus_ger_man_2017, "Migration*"))


## Define additonal German stopwords
stopwords_additional <- c("ab", "dass", "deshalb", "seit",
                          "statt", "n", "sowie")

## Transform to documement feature matrix
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
ggsave("output/plot_topfeatures.pdf", width = 12, height = 6)


## Select minimum frequency and occurence
dfm_man_trim <- dfm_trim(dfm_man, min_count = 2)

## Run Wordfish model
model_wordfish <- textmodel_wordfish(dfm_man_trim, dir = c(1, 2))

## Run correspondence analysis
model_ca <- textmodel_ca(dfm_man_trim)

## Plot models

## Create label
party_label <- paste(docvars(corpus_ger_man_2017, "party"), "2017", sep = " ")

# textplot_scale1d(model_wordfish, margin = "features")

plot_wordfish <- textplot_scale1d(model_wordfish, margin = "documents",
                 doclabels = party_label) +
  labs(title = "Wordfish estimates")

plot_ca <- textplot_scale1d(model_ca, doclabels = party_label) +
  labs(title = "Correspondence analysis")

library(gridExtra)
pdf("output/plot_textmodels.pdf", height = 4, width = 8)
grid.arrange(plot_wordfish, plot_ca, nrow = 1)
dev.off()
