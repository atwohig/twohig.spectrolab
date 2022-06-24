#Formatting the spectra to be ready for analysis 
#Schoodic Institute at Acadia National Park - Univsersity of Maine Haploid Genomics Lab 
#Kyle Lima, Peter Nelson 
#June, 2022



#------------------------------------------------#
####           Packages Required              ####
#------------------------------------------------#

library(tidyverse)
library(spectrolab)

select <- dplyr::select




#------------------------------------------------#
####            Read in spectra               ####
#------------------------------------------------#

# #Read in first round data
# p5707a <- read_spectra(path = 'data/AF5707A')
# p5707b <- read_spectra(path = 'data/AF5707B')
# p5736a <- read_spectra(path = 'data/AF5736A')
# p5736b <- read_spectra(path = 'data/AF5736B')

# #Read in the spectra from the multiple scan per point datasets
# caribou_multi <- read_spectra(path = 'data/pvy_scan_20220429/caribou_multi')
# lamoka_multi <- read_spectra(path = 'data/pvy_scan_20220429/lamoka_multi')
# 
# #Read in the spectra from the single scan per point datasets
# caribou_single <- read_spectra(path = 'data/pvy_scan_20220429/caribou_single')
# lamoka_single <- read_spectra(path = 'data/pvy_scan_20220429/lamoka_single')




#------------------------------------------------#
####         Functions for Cleaning           ####
#------------------------------------------------#

#A prerequisite function to add the metadata to the spectra
add_meta <- function(spectra_path, metadata_file) {
  
  spectra_raw <- read_spectra(path = spectra_path, format = "sed")
  
  meta(spectra_raw) <- metadata_file
  
  return(spectra_raw)
  
}

spectra_path = "data/pvy_scan_20220429/caribou_multi"
data.name = "caribou_multi"
#Function that adds the metadata to the spectra, filters the wavelengths to 400:2400, 
# removes reflectance values greater than 1, and smooths the spectra.
format.spectra <- function(spectra_path, data.name) {

  meta <- read_spectra(path = spectra_path, format = "sed") %>%
    as_tibble %>% 
    select(scan.name = sample_name) %>% 
    mutate(scan.name = tolower(str_replace(scan.name, "\\.\\w*$", "")),
           scan.id = paste(data.name, "_", scan.name, sep = ""),
           scan.type = str_replace(scan.id, "^\\w*\\_(\\w*)\\_\\w*\\_\\d*$", "\\1"),
           leaf.type = str_replace(scan.name, "\\_\\d*$", ""),
           strain = str_replace(scan.id, "\\_\\w*\\_\\w*\\_\\d*$", "")) %>% 
    select(scan.id, scan.name, scan.type, strain, leaf.type)

  w.meta <- add_meta(spectra_path, meta)

  spectra_cut <- w.meta[, 400:2400]

  spectra_filt <- spectra_cut[!rowSums(spectra_cut > 1),]
  
  clean <- smooth(spectra_filt)

  return(clean)

}



# #List the spectra and data frame names
# spectras <- list(caribou_multi, caribou_single, lamoka_multi, lamoka_single)
# data.names <- list("caribou_multi", "caribou_single", "lamoka_multi", "lamoka_single")
# 
# 
# #Function that adds in the metadata, and filters spectra to wavelength 400:2400.
# create.metadata <- function(spectras, data.names) {
#   
#   meta <- spectras %>%
#     as_tibble %>% 
#     select(scan.name = sample_name) %>% 
#     #rename(scan.name = sample_name) %>% 
#     mutate(scan.name = tolower(str_replace(scan.name, "\\.\\w*$", "")),
#            scan.id = paste(data.names, "_", scan.name, sep = ""),
#            scan.type = str_replace(scan.id, "^\\w*\\_(\\w*)\\_\\w*\\_\\d*$", "\\1"),
#            leaf.type = str_replace(scan.name, "\\_\\d*$", ""),
#            strain = str_replace(scan.id, "\\_\\w*\\_\\w*\\_\\d*$", "")) %>% 
#     select(scan.id, scan.name, scan.type, strain, leaf.type, `400`:`2400`)
#   
#   w.meta <- add_meta(spectras, meta)
#   
#   return(w.meta)
#   
# }
# 
# 
# #Run the create.metadata function for all four spectra sets, and join the rows
# with_metadata <- map2_dfr(spectras, data.names, create.metadata)
# 

#full_metadata <- map2_dfr(spectras, data.names, create.metadata)

# deparse(substitute(caribou_multi))

# full_metadata <- bind_rows(create.metadata(caribou_multi), 
#                            create.metadata(caribou_single),
#                            create.metadata(lamoka_multi),
#                            create.metadata(lamoka_single))




#------------------------------------------------#
####        Formatting for Analyses           ####
#------------------------------------------------#

#Run the format.spectra function
caribou_multi <- format.spectra("data/pvy_scan_20220429/caribou_multi", "caribou_multi")
caribou_single <- format.spectra("data/pvy_scan_20220429/caribou_single", "caribou_single")
lamoka_multi <- format.spectra("data/pvy_scan_20220429/lamoka_multi", "lamoka_multi")
lamoka_single <- format.spectra("data/pvy_scan_20220429/lamoka_single", "lamoka_single")

#clean_all is the object used for most analyses
clean_all <- Reduce(combine, list(caribou_multi, caribou_single, lamoka_multi, lamoka_single))

#Save object as .rds
saveRDS(clean_all, "data/processed/clean_all.rds")




