setwd("C:/Archive/Research/Projects/Life history/2018_07_Mammals longevity")

library(phytools); library(geiger); library(evomap);library(phangorn); library(nlme); library(geomorph); 
library(phylolm)
require(coda)
library(bayou)
library(bayesplot)
library(ggplot2)
#library(rstanarm)  

   source("Computations/functions.R") 

library(devtools)
install_github("JeroenSmaers/evomap")
library(evomap)

setwd("/Users/tanya/Box Sync/project_bat_aging/objective_1_allometry/rscripts/bayou-master")
install.packages("bayou",repos=NULL, type="source")
install_github("uyedaj/bayou")

require(bayou)

#####################################################################################################################################################
#Load data and tree
    tree<-read.nexus("Data/tree.nex")
		#Outliers
			#Marsupials
	    		Outliers<-c("Notoryctes_caurinus","Planigale_novaeguineae","Dendrolagus_lumholtzi","Macropus_irma")
	    		tree<-drop.tip(tree,Outliers)
			#Lagomorphs
	    		Outliers<-c("Lepus_nigricollis","Lepus_microtis","Lepus_flavigularis")
	    		tree<-drop.tip(tree,Outliers)
			#Rodents
	    		Outliers<-c("Geomys_pinetis")
	    		tree<-drop.tip(tree,Outliers)
			#Primates
	    		Outliers<-c("Presbytis_rubicunda")
			#Soricomorphs
	    		Outliers<-c("Crocidura_fuscomurina","Hylomys_suillus")
	    		tree<-drop.tip(tree,Outliers)
	    		tree<-drop.tip(tree,Outliers)
			#Bats
	    		Outliers<-c("Cheiromeles_torquatus")
	    		tree<-drop.tip(tree,Outliers)
			#Artiodactyls
	    		Outliers<-c("Cephalophus_leucogaster","Vicugna_vicugna")
	    		tree<-drop.tip(tree,Outliers)
			#Carnivorans
	    		Outliers<-c("Eupleres_goudotii","Lontra_felina")
	    		tree<-drop.tip(tree,Outliers)




    data<-read.table("Data/data_MammalsBirds.txt",header=T,sep="\t",row.names=1)
        data<-log(data)

    tree<-treedata(tree,data,sort=TRUE)$phy
    data<-as.data.frame(treedata(tree,data,sort=TRUE)$data)

    data<-data[,which(colnames(data)%in%c("Body","Max_Lifespan"))]

	  colnames(data)<-c("Independent","Dependent")

source("Computations/defineGroups.R") 



#####################################################################################################################################################
#Calculate prior regression parameters

    groups<-list(Marsupials,Lagomorphs,Rodents,Primates,Soricomorphs,
      Bats,Artiodactyls,Cetaceans,Carnivorans)
    names(groups)<-c("Marsupials","Lagomorphs","Rodents","Primates","Soricomorphs",
      "Bats","Artiodactyls","Cetaceans","Carnivorans")

        GroupParameters<-sapply(groups,function(x){getParameters(data=data,tree=tree,x)})
        rownames(GroupParameters)<-c("Slope","SlopeMIN","SlopeMAX","Intercept","InterceptMIN","InterceptMAX")
        Slope_Stdev<-(max(GroupParameters[3,])-mean(GroupParameters[1,]))/1.28
        Slope_Mean<-mean(GroupParameters[1,])
        Intercept_Stdev<-(max(GroupParameters[6,])-mean(GroupParameters[4,]))/1.28
        Intercept_Mean<-mean(GroupParameters[4,])
        NullRegressionParameters<-c(Slope_Mean,Slope_Stdev,Intercept_Mean,Intercept_Stdev)
        names(NullRegressionParameters)<-c("Slope_Mean","Slope_Stdev","Intercept_Mean","Intercept_Stdev"); NullRegressionParameters
        GroupParameters

colnames(data)<-c("Body","MaxLifespan")

data->data_all; tree->tree_all


#####################################################################################################################################################
#bayou

	# data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	#     Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	# DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 

 #    source("Computations/bayouAllometry_loadChains.R")
 #        pdf(sprintf("Results/bayouAllometry/%s_trace.pdf",paste(nameX,nameY,iterations,sep="_")))
 #        mcmc_trace(chains)
 #        dev.off()
 #    source("Computations/bayouAllometry_getResults.R")


#####################################################################################################################################################
#bayou chains

chainNumber<-"01"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.01; chainN->chain.NN.01
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"02"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.02; chainN->chain.NN.02
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"03"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.03; chainN->chain.NN.03
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"04"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.04; chainN->chain.NN.04
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"05"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.05; chainN->chain.NN.05
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"06"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.06; chainN->chain.NN.06
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"07"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.07; chainN->chain.NN.07
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"08"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.08; chainN->chain.NN.08
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"09"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.09; chainN->chain.NN.09
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))

chainNumber<-"10"
	data<-data_all; tree<-tree_all; Y<-"MaxLifespan"; X<-"Body"; iterations<-1000000
	    Slope<-NullRegressionParameters[1]; SlopeSD<-NullRegressionParameters[2]; Intercept<-NullRegressionParameters[3]; InterceptSD<-NullRegressionParameters[4]
	DNN = list(alpha=1.2, beta_X=0.3, sig2=0.7, k=c(1,1), theta=4, slide=1); 
	    source("Computations/bayouAllometry_makePrior.R")
	    source("Computations/bayouAllometry_runModel.R")
	    model.NN->model.10; chainN->chain.NN.10
	    save.image(sprintf("Workspace/bayouAllometry_withPrimer_%s.Rds",paste(nameY,nameX,chainNumber,iterations,sep="_")))




