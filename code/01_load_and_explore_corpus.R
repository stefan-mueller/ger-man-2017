####################
## Load and explore corpus with 2017 manifestos
####################

# Load required packages
library(quanteda)
library(ggplot2)
library(dplyr)

# Note: Specify working directory (or use RStudio project)

## Load corpus (corpus_ger_man_2017)
load("manifestos-corpus/corpus_ger_man_2017.RData")

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
ggsave("output/plot_topfeatures.png", width = 12, height = 6)


## Select minimum frequency and occurence
dfm_man_trim <- dfm_trim(dfm_man, min_count = 2)

## Run Wordfish model
model_wordfish <- textmodel_wordfish(dfm_man_trim, dir = c(1, 2))

## Run correspondence analysis
model_ca <- textmodel_ca(dfm_man_trim)

## Plot models

## Create label
party_label <- paste(docvars(corpus_ger_man_2017, "party"), "2017", sep = " ")

plot_wordfish <- textplot_scale1d(model_wordfish, margin = "documents",
                 doclabels = party_label) +
  labs(title = "Wordfish estimates")
ggsave(plot_wordfish, file = "output/plot_wordfish.png", height = 4, width = 4)

plot_ca <- textplot_scale1d(model_ca, doclabels = party_label) +
  labs(title = "Correspondence analysis")
ggsave(plot_ca, file = "output/plot_ca.png", height = 4, width = 4)

library(gridExtra)
pdf("output/plot_textmodels.pdf", height = 4, width = 8)
grid.arrange(plot_wordfish, plot_ca, nrow = 1)
dev.off()