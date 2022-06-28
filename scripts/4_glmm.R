#Running GLMM on leaf position with random effects
#Schoodic Institute at Acadia National Park - University of Maine Haploid Genomics Lab 
#Kyle Lima, Peter Nelson 
#June, 2022



#------------------------------------------------#
####           Packages Required              ####
#------------------------------------------------#

library(tidyverse)
library(lme4)
library(glmm)




#------------------------------------------------#
####            Formatting data               ####
#------------------------------------------------#


spectra <- readRDS("data/processed/clean_all.rds")

spectra <- resample(spectra, seq(400, 2400, by = 10))

spectra_wide <- spectra %>% 
  as_tibble() %>% 
  select(-c(sample_name, scan.id, scan.name))

spectra_long <- spectra_wide %>% 
  pivot_longer(cols = `400`:`2400`) %>% 
  rename(wavelength = name, reflectance = value) %>% 
  mutate(#reflectance = as.integer(round(reflectance * 1000, digits = 0)),
         wavelength = as.integer(wavelength))




#------------------------------------------------#
####        Tests for setting up GLMM         ####
#------------------------------------------------#

spectra_long %>% 
  filter(leaf.type == "lower") %>% 
  ggplot(aes(x = reflectance)) +
  geom_histogram(aes(y = ..density..), color = "black", fill = "gray", bins = 40) +
  geom_density(alpha = .2, fill = "skyblue") +
  theme_classic()

spectra_long %>% 
  filter(leaf.type == "middle") %>% 
  ggplot(aes(x = reflectance)) +
  geom_histogram(aes(y = ..density..), color = "black", fill = "gray", bins = 40) +
  geom_density(alpha = .2, fill = "skyblue") +
  theme_classic()

spectra_long %>% 
  filter(leaf.type == "upper") %>% 
  ggplot(aes(x = reflectance)) +
  geom_histogram(aes(y = ..density..), color = "black", fill = "gray", bins = 40) +
  geom_density(alpha = .2, fill = "skyblue") +
  theme_classic()



# spectra_long %>%
#   select(leaf.type, reflectance) %>% 
#   group_by(leaf.type) %>%
#   summarise(test_result = chisq.test(reflectance)$p.value)



#------------------------------------------------#
####              Running GLMM                ####
#------------------------------------------------#


maybe <- lmer(reflectance ~ 0 + leaf.type/strain + (1 | wavelength),
      data = spectra_long)

summary(maybe)







# glmer(reflectance ~ leaf.type + (1 | strain) + (1 | wavelength),
#       data = spectra_long, family = poisson)
# 
# glmer(reflectance ~ leaf.type + (1 | wavelength),
#       data = spectra_long, family = poisson)
# 
# glmer(reflectance ~ leaf.type + (1 | ),
#       data = spectra_long, family = poisson)





data(salamander)
head(salamander)

test <- glmm(Mate ~ 0 + Cross,
     random = list( ~ 0 + Female, ~ 0 + Male),
     varcomps.names = c("F", "M"),
     data = salamander,
     m = 100,
     family.glmm = binomial.glmm)

summary(test)

mcse(test)



library(flexplot)



