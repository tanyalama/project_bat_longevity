
Group<-Carnivorans
  
#Order data
dataTemp<-data[Group,]
exp(dataTemp[order(dataTemp$Dependent),])

#Explore residuals
data_Temp<-pruneSample(data,tree,Group)$data
tree_Temp<-pruneSample(data,tree,Group)$tree
plot(tree_Temp)
is.binary(tree_Temp)
dataTemp<-data_Temp
treeTemp<-tree_Temp
      pGLSTemp<-phylolm(Dependent~Independent,dataTemp,treeTemp,model="lambda")
      summary(pGLSTemp)
          library(phylobase); library(adephylo)
          data_phylo<-phylo4d(treeTemp,as.vector(pGLSTemp$residuals))
          table.phylo4d(data_phylo,box=F)

          pdf("Results/GradeCheck.pdf",height=50,width=20)
          table.phylo4d(data_phylo,box=F)
          dev.off()

#Order residuals
dataTemp<-as.matrix(pGLSTemp$residuals)
dataTemp[order(dataTemp),]


