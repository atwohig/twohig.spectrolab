library(tidyverse)
select <- dplyr::select

#Read in the data
spectra_all <- readRDS("data/processed/clean_all.rds")

spectra <- as.data.frame(spectra_all)


spectra_long <- spectra %>%
  as_tibble() %>% 
  pivot_longer(cols = `400`:`2400`) %>% 
  rename(band = name, reflectance = value) %>% 
  mutate(band = as.numeric(band)) %>% 
  select(scan.id, strain, leaf.type, band, reflectance)


spectra_long %>% 
  filter(strain == "caribou") %>% 
  ggplot(aes(x = band, y = reflectance, group = scan.id, color = leaf.type)) +
  geom_line() +
  scale_color_manual(values = c("skyblue", "forestgreen", "orange")) +
  scale_x_continuous(expand = c(0,0)) +
  labs(x = "Band", y = "Reflectance (nm)", title = "Caribou spectra plot by leaf position",
       col = "Leaf position") +
  theme_classic() +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold"),
    legend.position = c(0.8, 0.8))




spectra_long %>% 
  filter(strain == "lamoka") %>% 
  ggplot(aes(x = band, y = reflectance, group = scan.id, color = leaf.type)) +
  geom_line() +
  scale_color_manual(values = c("skyblue", "darkgray", "orange")) +
  scale_x_continuous(expand = c(0,0)) +
  labs(x = "Band", y = "Reflectance (nm)", title = "Lamoka spectra plot by leaf position",
       col = "Leaf position") +
  theme_classic() +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold"),
    legend.position = c(0.8, 0.8))
  )
  