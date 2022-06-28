require(tidyverse)
require(parallel)
require(spectrolab)
require(caret)
require(rlist)
require(matrixStats)
require(mlbench)
require(MASS)
require(corrplot)
require(naniar)


#' Main PLS function that returns all outputs from a PLS discriminant analysis
#' 
#' @inheritParams None
#' @return
#' @param spectra: a spectral object
#' @param className: the class (or variable) to run the PLSDA based on
#' @param includeAge: TRUE or FALSE, if your data includes age
#' @param ncomps: the number of components
#' @param numIterations: how many interactions to run
#' @param baseDirectory: the start directory for where all outputs will be written
#' @seealso runPlsda, getData, getNComps, plotConfusionMatrix, plotVip
#' @export 
#' @examples Not Yet Implemented

# spectra = spectra_all
# className = 'strain'
# includeAge = FALSE
# ncomps = 2
# numIterations = 3
# baseDirectory = 'test'

generatePLSData <- function(spectra, className, includeAge, ncomps,
                            numIterations, baseDirectory) {
  
  
  #############
  # Setup
  #############
  
  #functions
  # runPlsda = readRDS("functions/runPlsda.rds")
  # getNComps = readRDS("functions/getNComps.rds")
  # getData = readRDS("functions/getData.rds")
  # plotConfusionMatrix = readRDS("functions/plotConfusionMatrix.rds")
  # plotVip = readRDS("functions/plotVip.rds")
  source("functions/plsda_functions.R")
  
  
  #variables 
  if (includeAge) {
    age = 'with_age'
  } else {
    age = 'no_age'
  }
  
  #list directory locations
  upSamplingDirectory = paste(baseDirectory, className, age, 'upsampled_models', sep = '/' )
  accuracyDirectory = paste(baseDirectory, className, age, 'accuracies', sep = '/')
  cmDirectory = paste(baseDirectory, className, age, 'confusion_matrices', sep = '/')
  metricsDirectory = paste(baseDirectory, className, age, 'metrics', sep = '/')
  cmFinalDirectory = paste(baseDirectory, className, age, 'cm_final', sep = '/')
  vipDirectory = paste(baseDirectory, className, age, 'variable_importance', sep = '/')
  
  
  #################################
  # Classification - parallelized
  #################################
  
  #choose number of cores - this code chooses half the cores available on your machine
  numCores = floor(detectCores()/2)
  cluster = makeCluster(numCores)
  iterations = seq(1, numIterations)

  #this function will run PLSDA and save model objects into the specified directory
  #the console will log a list of NULL values, don't worry about this
  parLapply(cl = cluster, iterations, runPlsda, spectra = spectra,
            className = className, ncomp = ncomps, resampling = "down",
            include_age = includeAge, modelDirectory = NULL, saveModelObject = FALSE,
            cmDirectory = NULL, accuracyDirectory = accuracyDirectory)
  
  #get optimal number of components from down sampled model objects
  optimalNumComps = getNComps(accuracyDirectory, ncomps)
  
  #run PLSDA with up sampling and optimal number of components
  parLapply(cl = cluster, iterations, runPlsda, spectra = spectra,
            className = className, ncomp = optimalNumComps, resampling = "up",
            include_age = includeAge, modelDirectory = upSamplingDirectory, 
            cmDirectory = cmDirectory, saveModelObject = TRUE)
  
  
  ##############################################################################
  # Get data and plot confusion matrices and variable importance values
  ##############################################################################
  
  #get overall accuracy, mean confusion matrix, and standard deviation (2) 
  #confusion matrix
  data = getData(directory = cmDirectory, metricsDirectory = metricsDirectory,
                 className = className, includesAge = includeAge)
  
  matrixName = paste(paste(className, age, data$ncomps, 'comps', sep = '_'),
                     'jpeg', sep = '.')
  
  #plot confusion matrix as high resolution jpeg
  plotConfusionMatrix(data$cmMean, directory = cmFinalDirectory,
                      fileName = matrixName)
  
  #plot top 5 and bottom 5 variable importance values
  plotVip(modelDirectory = upSamplingDirectory, saveDirectory = vipDirectory,
          baseFileName = paste(className, 'vip', sep = '_'))
  
}
