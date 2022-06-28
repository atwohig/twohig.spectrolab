#PLS-DA for our different hypotheses
#Schoodic Institute at Acadia National Park - University of Maine Haploid Genomics Lab 
#Kyle Lima, Peter Nelson 
#June, 2022

#------------------------------------------------#
####            PLS-DA Strain All             ####
#------------------------------------------------#

#Read in the data
spectra_all <- readRDS("data/processed/clean_all.rds")

#Call the package/function
#generatePLSData <- readRDS('functions/generatePLSData.rds')
source("functions/generatePLSDA.R")


spectra_all <- as.data.frame(spectra_all)

#------------------------------------------------#
####            PLS-DA Strain All             ####
#------------------------------------------------#

#Run PLS-DA for Strain with data from all leaf types
generatePLSData(spectra = spectra_all, className = 'strain', includeAge = FALSE,
                ncomps = 2, numIterations = 3, baseDirectory = 'test')
'outputs/plsda'



#------------------------------------------------#
####       PLS-DA Strain by Leaf Type         ####
#------------------------------------------------#

#Filter to data from lower leaves
lower <- spectra_all[!meta(spectra_all)$leaf.type == "lower",]

#Run PLS-DA for Strain with data from all leaf types
generatePLSData(spectra = lower, className = 'strain', includeAge = F,
                ncomps = 2, numIterations = 100, baseDirectory = 'outputs/plsda/strain_lower')


#------------------------------------------------#


#Filter to data from middle leaves
middle <- spectra_all[!meta(spectra_all)$leaf.type == "middle",]

#Run PLS-DA for Strain with data from all leaf types
generatePLSData(spectra = middle, className = 'strain', includeAge = F,
                ncomps = 2, numIterations = 100, baseDirectory = 'outputs/plsda/strain_middle')


#------------------------------------------------#


#Filter to data from upper leaves
upper <- spectra_all[!meta(spectra_all)$leaf.type == "upper",]

#Run PLS-DA for Strain with data from all leaf types
generatePLSData(spectra = upper, className = 'strain', includeAge = F,
                ncomps = 2, numIterations = 100, baseDirectory = 'outputs/plsda/strain_upper')




#------------------------------------------------#
####            PLS-DA Leaf Type              ####
#------------------------------------------------#

#Run PLS-DA for Strain with data from all leaf types
generatePLSData(spectra = spectra_all, className = 'leaf.type', includeAge = F,
                ncomps = 3, numIterations = 100, baseDirectory = 'outputs/plsda')




#------------------------------------------------#
####            PLS-DA Scan Type              ####
#------------------------------------------------#

#Run PLS-DA for Strain with data from all leaf types
generatePLSData(spectra = spectra_all, className = 'scan.type', includeAge = F,
                ncomps = 2, numIterations = 100, baseDirectory = 'outputs/plsda')




