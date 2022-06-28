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




#' The PLS function that runs the actually PLS-DA
#' 
#' @inheritParams None
#' @return
#' @param iteration: created by generatePLSDA function
#' @param spectra: a spectral object
#' @param className: the class (or variable) to run the PLSDA based on
#' @param ncomps: the number of components
#' @param resampling: which to resample by
#' @param include_age: if data includes age
#' @param modelDirectory: 
#' @param baseDirectory:
#' @param baseDirectory:
#' @param saveModelObject: 
#' @seealso None
#' @export 
#' @examples Not Yet Implemented

# spectra = spectra_all
# numCores = floor(detectCores()/2)
# cluster = makeCluster(numCores)
# numIterations = 3
# iterations = seq(1, numIterations)
# iteration = iterations
# className = "strain"
# ncomp = 2
# resampling = "down"
# include_age = FALSE
# saveModelObject = FALSE
# modelDirectory = NULL
# cmDirectory = NULL
# baseDirectory = "test"
# age = "no_age"
# accuracyDirectory = paste(baseDirectory, className, age, 'accuracies', sep = '/')

runPlsda <- function(iteration, spectra, className, ncomp, resampling, include_age,
         modelDirectory, accuracyDirectory, cmDirectory, saveModelObject) {

  #load spectra and convert to matrix and data frame
  spec_raw = spectra
  spec_mat = as.matrix(spectra)
  spec_df1 = as.data.frame(spec_raw)
  
  #combine relevant metadata
  spec_df2 = as.data.frame(spec_mat)
  spec_df2 = cbind(spec_df2, spec_df1[className])
  colnames(spec_df2)[colnames(spec_df2) == className] <- className
  uniqueNames = unique(spec_df1[[className]])
  
  if (include_age == TRUE) {
    spec_df2$age = spec_df1$age
    age = 'with-age'
  } else {
    age = 'no-age'
  }
  
  #create data partition: 70% of data for training, 30% for testing
  inTrain <- caret::createDataPartition(
    y = spec_df2[[className]],
    p = .7,
    list = FALSE
  )
  
  training <- spec_df2[inTrain,]
  testing <- spec_df2[-inTrain,]
  
  #tune model: 10-fold cross-validation repeated 3 times
  ctrl <- caret::trainControl(
    method = "repeatedcv",
    number = 10,
    sampling = resampling,
    repeats = 3)
  
  #Fit model. Note max iterations set to 100000 to allow model convergence
  plsFit <- caret::train(
    as.formula(paste(className, "~ .")),
    data = training,
    maxit = 10000,
    method = "pls",
    trControl = ctrl,
    tuneLength = ncomp)
  
  
  
  if (resampling == 'down') {
    accFileName = paste(paste('accuracy', className, age, toString(iteration), sep = "_"),
                        "rds", sep = ".")
    saveRDS(plsFit$results$Accuracy, paste(accuracyDirectory, accFileName,
                                           sep = '/'))
  }
  
  #file name - change if you'd prefer a different file name
  fileName = paste(paste('pls', className, age, resampling, toString(iteration), sep = "_"),
                   "rds", sep = ".")
  
  if (saveModelObject) {
    saveRDS(plsFit, paste(modelDirectory, fileName, sep = "/"))
  }
  
  if (resampling == 'up') {
    plsClasses = predict(plsFit, newdata = testing)
    cm = confusionMatrix(data = plsClasses, as.factor(testing[[className]]))
    cmFileName = paste(paste('cm', toString(iteration), sep="_"), "rds",
                       sep = ".")
    saveRDS(cm, paste(cmDirectory, cmFileName, sep = "/"))
  }
  
}





#' Function produces the optimal number of components
#' 
#' @inheritParams None
#' @return optimalComp
#' @param directory: directory of inputs
#' @param ncomp: number of components
#' @seealso None
#' @export 
#' @examples Not Yet Implemented


getNComps <- function(directory, ncomp) {
  require(matrixStats)
  models = list.files(path = directory)
  accuracies = matrix(nrow = ncomp)
  
  for(i in 1:length(models)) {
    model = readRDS(paste(directory, models[i], sep = "/"))
    accuracies = cbind(accuracies, as.matrix(model))
  }
  
  accuracies = accuracies[,-1]
  meanAcc = as.matrix(rowMeans(accuracies))
  sdAcc = as.matrix(rowSds(accuracies))
  lowerSd = meanAcc - (2 * sdAcc)
  meanAcc = meanAcc[1:which.max(meanAcc),]
  #get accuracies less than two standard deviations of the highest mean accuracy
  lowerMeans = meanAcc[meanAcc < lowerSd[which.max(meanAcc)]]
  optimalComp = length(lowerMeans) + 1 #first component with an average 
  # accuracy within 2 sd of the component with the highest mean accuracy
  
  return(optimalComp)
}




#' The PLS function that runs the actually PLS-DA
#' 
#' @inheritParams None
#' @return metrics
#' @param directory: directory of inputs
#' @param metricsDirectory: directory for metrics
#' @param className: the class (or variable) to run the PLSDA based on
#' @param includeAge: if data includes age
#' @seealso None
#' @export 
#' @examples Not Yet Implemented


getData <- function(directory, metricsDirectory, className, includesAge) {

  matrices = list.files(path = directory)
  
  cmList = list()
  accuracies = c()
  for (i in 1:length(matrices)) {
    cm = readRDS(paste(directory, matrices[i], sep = '/'))
    cmList = list.append(cmList, as.matrix(cm$table, rownames = TRUE))
    accuracies = append(accuracies, as.numeric(cm$overall[1]))
  }
  
  cmMean = t(Reduce("+", cmList)/length(matrices))
  cmMean = cmMean/rowSums(cmMean)
  
  # get standard deviations
  getSds = function(list){
    n = length(list); 	   
    rc = dim(list[[1]]); 	   
    ar1 = array(unlist(list), c(rc, n)); 	   
    round(apply(ar1, c(1, 2), sd), 2); 	         
  }
  
  cmSD = t(getSds(cmList))
  cmSD = cmSD/rowSums(cmSD)
  rownames(cmSD) = rownames(as.matrix(cmList[[1]]))
  colnames(cmSD) = colnames(as.matrix(cmList[[1]]))
  
  metrics = list(accuracies = accuracies, overallAccuracy = mean(accuracies),
                 cmMean = cmMean, cmSD = cmSD, ncomps = length(matrices))
  
  if (includesAge) {
    age = 'with-age'
  } else {
    age = 'no-age'
  }
  
  fileName = paste(paste(className, age, 'metrics', sep = '_'), '.rds', sep = '.')
  saveRDS(metrics, paste(metricsDirectory, fileName, sep = '/'))
  
  return(metrics)
}




#' Function that produces JPEG of the averages from all bootstraps as a confusion matrix
#' 
#' @inheritParams None
#' @return
#' @param matrix: input
#' @param directory: directory of output
#' @param fileName: name for output PNG
#' @seealso None
#' @export 
#' @examples Not Yet Implemented


plotConfusionMatrix <- function(matrix, directory, fileName) {
  
  cols = colorRampPalette(c('white', '#fe9929'))
  
  jpeg(filename = paste(directory, fileName, sep = "/"),
       width = 12, height = 12, units = 'in', res = 1200)
  par(mfrow = c(1,1))
  corrplot::corrplot(matrix,
                     cl.pos = 'n',
                     method = 'square',
                     tl.col = 'black',
                     na.label = 'square',
                     na.label.col = 'white',
                     addCoef.col = '#542788',
                     number.digits = 2,
                     number.cex = .7,
                     col = cols(10))
  dev.off()
}




#' Function that produces a JPEG of the most important explainatory variables
#' 
#' @inheritParams None
#' @return
#' @param matrix: input
#' @param directory: directory of output
#' @param fileName: name for output PNG
#' @seealso None
#' @export 
#' @examples Not Yet Implemented
 

plotVip <- function(modelDirectory, saveDirectory, baseFileName) {
  require(caret)
  require(rlist)
  models = list.files(path = modelDirectory)
  firstModel = readRDS(paste(modelDirectory, models[1], sep = "/"))
  importance = varImp(firstModel)$importance
  uniqueNames = colnames(importance)
  vipList = list()
  
  for (i in 1:length(uniqueNames)) {
    vipList = list.append(vipList, assign(uniqueNames[i],
                                          matrix(nrow = nrow(importance))))
  }
  
  for (i in 1:length(models)) {
    model = readRDS(paste(modelDirectory, models[i], sep = "/"))
    vip = varImp(model)$importance
    for (j in 1:length(uniqueNames)) {
      vipList[[j]] = cbind(vipList[[j]], vip[uniqueNames[j]])
    }
  }
  
  vip_to_bar = function(vip) {
    vip = vip[, -1]
    vip_mean = rowMeans(vip)
    sorted = sort(vip_mean)
    best = sorted[(length(sorted)-4):length(sorted)]
    bm = as.data.frame(as.matrix(rev(best)))
    bm$color = '#d8b365' 
    worst = sorted[1:5]
    wm = as.data.frame(as.matrix(rev(worst)))
    wm$color = '#5ab4ac'
    m = rbind(bm, wm)
    barplot(rev(m[,1]), horiz = T, main = names(vip)[1],
            names.arg = rev(rownames(m)), col = m$color, cex.names = 0.75)
  }
  
  fileNum = 1
  startIdx = 1
  endIdx = 12
  while (startIdx < length(vipList)) {
    fileName = paste(paste(baseFileName, fileNum, sep = "_"), "jpeg", sep = ".")
    jpeg(filename = paste(saveDirectory, fileName, sep = "/"),
         width = 10, height = 10, units = 'in', res = 1200)
    par(las = 2, mfrow = c(3,4))
    if (endIdx < length(vipList)) {
      end = endIdx
    } else {
      end = length(vipList)
    }
    for (i in startIdx:end) {
      vip_to_bar(vipList[[i]])
    }
    dev.off()
    startIdx = endIdx + 1
    endIdx = endIdx + 12
    fileNum = fileNum + 1
  }
}





