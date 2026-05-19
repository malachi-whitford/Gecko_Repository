packages=c("tidyverse","palmerpenguins","dplyr","ggplot2")
for (p in packages) if (!require(p, character.only = TRUE)) { install.packages(p); library(p, character.only = TRUE) }

penguins %>%
  ggplot(aes(x=bill_depth_mm))+
  geom_histogram()
