#Heat maps for test scanning potato plants
#UMO Genome Elimination Lab - Schoodic Institute at Acadia National Park
#Kyle Lima 2022



#------------------------------------------------#
####           Packages Required              ####
#------------------------------------------------#

library(spectrolab)
library(gplots)
library(vegan)



#------------------------------------------------#
####            Read in spectra               ####
#------------------------------------------------#

#Read in first round data
p5707a = read_spectra(path = 'data/AF5707A')
p5707b = read_spectra(path = 'data/AF5707B')
p5736a = read_spectra(path = 'data/AF5736A')
p5736b = read_spectra(path = 'data/AF5736B')

#Read in the spectra from the multiple scan per point datasets
caribou_multi = read_spectra(path = 'data/pvy_scan_20220429/caribou_multi')
lamoka_multi = read_spectra(path = 'data/pvy_scan_20220429/lamoka_multi')

#Read in the spectra from the single scan per point datasets
caribou_single = read_spectra(path = 'data/pvy_scan_20220429/caribou_single')
lamoka_single = read_spectra(path = 'data/pvy_scan_20220429/lamoka_single')



#------------------------------------------------#
####              Heat map viz                ####
#------------------------------------------------#

##Uncomment and run this pdf function and the connected dev.off function at the 
##bottom of this script to produce a pdf output of the following heat maps
#pdf(file = "outputs/heatmaps_20220501.pdf", height = 7.6, width = 10.9)

##Heat maps for the first round data
#AF5707A
#Remove low spectra
p5707a <- p5707a[,400:2500]

#Convert to matrix and plot heat map
heatmap.2(as.matrix(decostand(p5707a, "standardize", MARGIN = 2)), 
          dendrogram = "both", 
          trace = "none", 
          Colv = TRUE,
          Rowv = TRUE,
          col = heat.colors(50),
          main = 'AF5707A',
          xlab = 'wavelength',
          ylab = 'scan',
          margins = c(5,10))


#AF5707B
#Remove low spectra
p5707a <- p5707a[,400:2500]

#Convert to matrix and plot heat map
heatmap.2(as.matrix(decostand(p5707b, "standardize", MARGIN = 2)), 
          dendrogram = "both", 
          trace = "none", 
          Colv = TRUE,
          Rowv = TRUE,
          col = heat.colors(50),
          main = 'AF5707B',
          xlab = 'wavelength',
          ylab = 'scan',
          margins = c(5,10))


#AF5736A
#Remove low spectra
p5707a <- p5736a[,400:2500]

#Convert to matrix and plot heat map
heatmap.2(as.matrix(decostand(p5736a, "standardize", MARGIN = 2)), 
          dendrogram = "both", 
          trace = "none", 
          Colv = TRUE,
          Rowv = TRUE,
          col = heat.colors(50),
          main = 'AF5736A',
          xlab = 'wavelength',
          ylab = 'scan',
          margins = c(5,10))


#AF5736B
#Remove low spectra
p5707a <- p5736a[,400:2500]

#Convert to matrix and plot heat map
heatmap.2(as.matrix(decostand(p5736b, "standardize", MARGIN = 2)), 
          dendrogram = "both", 
          trace = "none", 
          Colv = TRUE,
          Rowv = TRUE,
          col = heat.colors(50),
          main = 'AF5736B',
          xlab = 'wavelength',
          ylab = 'scan',
          margins = c(5,10))




##Heat maps for second round multiple scans per point data
#Caribou
#Remove low spectra
caribou_multi <- caribou_multi[,400:2500]

#Create heat map
heatmap.2(as.matrix(decostand(caribou_multi, "standardize", MARGIN = 2)), 
          dendrogram = "both", 
          trace = "none", 
          Colv = TRUE,
          Rowv = TRUE,
          col = heat.colors(50),
          main = 'caribou_multi',
          xlab = 'wavelength',
          ylab = 'scan',
          margins = c(5,10))


#Lamoka
#Remove low spectra
lamoka_multi <- lamoka_multi[,400:2500]

#Create heat map
heatmap.2(as.matrix(decostand(lamoka_multi, "standardize", MARGIN = 2)), 
          dendrogram = "both", 
          trace = "none", 
          Colv = TRUE,
          Rowv = TRUE,
          col = heat.colors(50),
          main = 'lamoka_multi',
          xlab = 'wavelength',
          ylab = 'scan',
          margins = c(5,10))

                



##Heat maps for single scans per point data
#Caribou
#Remove low spectra
caribou_single <- caribou_single[,400:2500]

#Create heat map
heatmap.2(as.matrix(decostand(caribou_single, "standardize", MARGIN = 2)), 
          dendrogram = "both", 
          trace = "none", 
          Colv = TRUE,
          Rowv = TRUE,
          col = heat.colors(50), 
          main = 'caribou_single',
          xlab = 'wavelength',
          ylab = 'scan',
          margins = c(5,10))


#Lamoka
#Remove low spectra
lamoka_single <- lamoka_single[,400:2500]

#Create heat map
heatmap.2(as.matrix(decostand(lamoka_single, "standardize", MARGIN = 2)), 
          dendrogram = "both", 
          trace = "none", 
          Colv = TRUE,
          Rowv = TRUE,
          col = heat.colors(50),
          main = 'lamoka_single',
          xlab = 'wavelength',
          ylab = 'scan',
          margins = c(5,10))


##Uncomment to make pdf output
#dev.off()

