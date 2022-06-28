#Running PCA on spectra groups to examine visually 
#Schoodic Institute at Acadia National Park - University of Maine Haploid Genomics Lab 
#Kyle Lima, Peter Nelson 
#June, 2022



#------------------------------------------------#
####           Packages Required              ####
#------------------------------------------------#

require(ggplot2)
require(ggfortify)




#------------------------------------------------#
####               PCA Strain                 ####
#------------------------------------------------#

#Load data
spectra <- readRDS("data/processed/clean_all.rds")
spectra <- resample(spectra, seq(400, 2400, by = 10))
names(spectra) <- meta(spectra)$strain
spectra.df <- as.data.frame(spectra)
spectra.m <- as.matrix(spectra)

#PCA
strain.pca <- prcomp(spectra.m, scale = TRUE)

summary(strain.pca)

autoplot(strain.pca, data = spectra.df, colour = "sample_name", loadings = FALSE, 
         frame = TRUE, frame.type = 'norm',
         x = 1, y = 2)

ggsave("outputs/pca_strain.png", height = 4.5, width = 6)




#------------------------------------------------#
####             PCA Scan Type                ####
#------------------------------------------------#

#Load data
spectra <- readRDS("data/processed/clean_all.rds")
spectra <- resample(spectra, seq(400, 2400, by = 10))
names(spectra) <- meta(spectra)$scan.type
spectra.df <- as.data.frame(spectra)
spectra.m <- as.matrix(spectra)

#PCA
scantype.pca <- prcomp(spectra.m, scale = TRUE)

summary(scantype.pca)

autoplot(scantype.pca, data = spectra.df, colour = "sample_name", loadings = FALSE, 
         frame = TRUE, frame.type = 'norm',
         x = 1, y = 2)

ggsave("outputs/pca_scan_type.png", height = 4.5, width = 6)




#------------------------------------------------#
####             PCA Leaf Type                ####
#------------------------------------------------#

#Load data
spectra <- readRDS("data/processed/clean_all.rds")
spectra <- resample(spectra, seq(400, 2400, by = 10))
names(spectra) <- meta(spectra)$leaf.type
spectra.df <- as.data.frame(spectra)
spectra.m <- as.matrix(spectra)

#PCA
leaftype.pca <- prcomp(spectra.m, scale = TRUE)

summary(leaftype.pca)

loading <- leaftype.pca$rotation[,1]
score <- sort(abs(loading), decreasing = T)


autoplot(leaftype.pca, data = spectra.df, colour = "sample_name", loadings = FALSE, 
         frame = TRUE, frame.type = 'norm',
         x = 1, y = 2) #+
  #theme_bw()

ggsave("outputs/pca_leaf_type.png", height = 4.5, width = 6)







