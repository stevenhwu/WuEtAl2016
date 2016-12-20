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

allComponentTh<- vector(length=8, mode="list")
allComponentPh<- vector(length=8, mode="list")

columnIndex <- split( matrix(paste( c("f","p1","phi"), rep(1:6,each=3), sep="."),
    ncol=6), rep(1:6, each = 3))
#list(c("f.1","p1.1","phi.1"), c("f.2","p1.2","phi.2") )

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

    maxIndex<- which.max(maxModel[[BICIndexList[p]-1]]$f)
    allModelTh[p,]<- maxModel[[BICIndexList[p]-1]]$vecParams[columnIndex[[maxIndex]]]

    fOrder<- rev(order(maxModel[[BICIndexList[p]-1]]$f))
    allComponentTh[[p]]<-  cbind(maxModel[[BICIndexList[p]-1]]$f[fOrder], maxModel[[BICIndexList[p]-1]]$params[fOrder,1:2] )
    colnames(allComponentTh[[p]])<- c("ProportionInComponent", "ProportionRefInComponent", "phiInComponent")


    maxIndex<- which.max(maxModel[[BicPhIndex[p]*2]]$f)
    allModelPh[p,]<- maxModel[[BicPhIndex[p]*2]]$vecParams[columnIndex[[maxIndex]]]

    fOrder<- rev(order(maxModel[[BicPhIndex[p]*2]]$f))
    allComponentPh[[p]]<-  cbind(maxModel[[BicPhIndex[p]*2]]$f[fOrder], maxModel[[BicPhIndex[p]*2]]$params[fOrder,1:2] )
    colnames(allComponentPh[[p]])<- c("ProportionInComponent", "ProportionRefInComponent", "phiInComponent")

}
names(allComponentPh) <- subNameList
names(allComponentTh) <- subNameList
allModelTh<- cbind(allModelTh, BicThIndex)
allModelPh<- cbind(allModelPh, BicPhIndex)

newOrder<- c( rev(grep("C21", subNameList)), rev(grep("C10", subNameList))  )
plotDataPh <- allModelPh[newOrder,1]
plotDataTh <- allModelTh[newOrder,1]

# something like this?
boxplot(cbind(allModelTh[,1],allModelPh[,2]))


#save(allModelTh, file="allModelTh.RData")
#save(allModelPh, file="allModelPh.RData")

#save(allComponentPh, file="allComponentPh.RData")
#save(allComponentTh, file="allComponentTh.RData")
