#!/usr/bin/Rscript
## Usage: Rscript --vallina filename.R
isCEU <- TRUE
suppressPackageStartupMessages( source("./summaryFunctions.R") )
source("./summarySetup.R")

msTable<- vector(mode="list", length=length(subNameList)*2)
AicThIndex <- c(4,3,3,4,4,4,3,4)
BicThIndex <- BICIndexList/2

AicPhIndex <- c(5,6,6,6,6,6,3,6)
BicPhIndex <- c(3,4,4,5,4,5,3,6)

dimnames=list(subNameList, c("propMajor","propRefInMajorComp","phiMajor"))
allModelTh<- matrix(nrow=length(subNameList), ncol=3, dimnames=dimnames)
allModelPh<- matrix(nrow=length(subNameList), ncol=3, dimnames=dimnames)

columnIndex <- list(c("f.1","p1.1","phi.1"), c("f.2","p1.2","phi.2") )

dataDir<- "/home/steven/Postdoc2/Project_MDM/CEU/"

for(p in length(subNameList):1 ){

    subName<- subNameList[p]
    fullTitle<- fullTitleList[p]
    fullPath <- file.path(dataDir, subName)

    # temp<- loadRawData(fullPath, isCEU, lowerLimit, upperLimit, dirtyData)
    # dataFull <- temp$dataFull
    # dataRef <- temp$dataRef
    # dataRefDirty <- temp$dataRefDirty

    maxModel<- loadMaxModel(fullPath, subName, loadData, isCEU, isRscriptMode)
    ## Need to change 'pwd' in loadMaxModel to "github:CartwrightLab/labpubs/papers/DiriMulti/data/CEU/"

    maxIndex<- which.max(maxModel[[3]]$f)
    allModelTh[p,]<- maxModel[[3]]$vecParams[columnIndex[[maxIndex]]]

    maxIndex<- which.max(maxModel[[4]]$f)
    allModelPh[p,]<- maxModel[[4]]$vecParams[columnIndex[[maxIndex]]]

}


newOrder<- c( rev(grep("C21", subNameList)), rev(grep("C10", subNameList))  )
plotDataPh <- allModelPh[newOrder,1]
plotDataTh <- allModelTh[newOrder,1]

# something like this?
boxplot(cbind(allModelTh[,1],allModelPh[,2]))
