#Heat maps for same spot scans
#UMO Genome Elimination Lab - Schoodic Institute at Acadia National Park
#Kyle Lima 2021

#------------------------------------------------#
####           Packages Required              ####
#------------------------------------------------#

library(spectrolab)
library(gplots)
library(vegan)

select <- dplyr::select



#------------------------------------------------#
####            Read in spectra               ####
#------------------------------------------------#

#Read in the spectra from the multi scan per point datasets
caribou_spectra = read_spectra(path = 'data/pvy_scan_20220429/caribou_multi')
lamoka_spectra = read_spectra(path = 'data/pvy_scan_20220429/lamoka_multi')



#------------------------------------------------#
####              Heat map viz                ####
#------------------------------------------------#

#Create heat map
heatmap.2(as.matrix(decostand(caribou_spectra, "standardize", MARGIN = 2), 
  breaks = c(seq(-2, 2, by = 0.1)), 
  dendrogram = "row", 
  trace = "none", 
  Colv = TRUE,
  col = "heat.colors"))











