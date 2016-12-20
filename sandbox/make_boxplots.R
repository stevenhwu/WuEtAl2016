library(reshape2)
library(ggplot2)

setwd("~/Desktop/ASU/WuEtAl2016/sandbox")
load("allComponentPh.RData")
load("allComponentTh.RData")

#NB: ProportionRefInComponent phiInComponent are switched

#fix labels
for (i in 1:length(allComponentTh)){
  print(i)
  rownames(allComponentTh[[i]])<-seq.int(nrow(allComponentTh[i]))
}

for (i in 1:length(allComponentPh)){
  print(i)
  rownames(allComponentPh[[i]])<-seq.int(nrow(allComponentPh[i]))
}

#reshape data to long format
TH_long<-melt(allComponentTh)
PH_long<-melt(allComponentPh)

#combine data, fix headers and labels
TH_long<-cbind(TH_long,c('TH'))
PH_long<-cbind(PH_long,c('PH'))
names(TH_long)<-c('component','measure','value','year_chr','dataset')
names(PH_long)<-c('component','measure','value','year_chr','dataset')
all_long<-rbind(TH_long,PH_long)
all_long$component<-as.numeric(gsub('m','',as.character(all_long$component)))

#plot proportion ref for component
all_long %>% filter(measure=='phiInComponent') %>%
  ggplot(aes(component,value,group=component))+geom_boxplot()+
  labs(y='Proportion of Reference Allele In Component') +
  facet_grid(. ~ dataset)

#plot phi for component
all_long %>% filter(measure=='ProportionRefInComponent') %>%
  ggplot(aes(component,value,group=component))+geom_boxplot()+
  labs(y='Overdispersion (phi)') +
  facet_grid(. ~ dataset)

#plot prop data in the component
all_long %>% filter(measure=='ProportionInComponent') %>%
  ggplot(aes(component,value,group=component))+geom_boxplot()+
  labs(y='Proportion of data') +
  facet_grid(. ~ dataset)
