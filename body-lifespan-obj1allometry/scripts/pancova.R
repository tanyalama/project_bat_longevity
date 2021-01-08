
#####################################################################################################################################################
#pGLS
#####################################################################################################################################################

    pGLS<-gls(Dependent~Independent,data,correlation=corPagel(1,phy=tree))
    lambda<-pGLS$modelStruct$corStruct[1]
    Sigma<-vcv(rescale(tree,"lambda",lambda))    #'Sigma' is now our new vcv(tree)
    plot(Dependent~Independent,data)
    

#####################################################################################################################################################
#pANCOVA for bayou
#####################################################################################################################################################


#####################################################################
grpS_01<-rep("XXX",length(rownames(data))) 
grpS_01[RodentsLagomorphs]<-"1" 
grpS_01[c(Vespertilionids,setdiff(YinBats,OWFruitbats))]<-"1" 
grpS_01[c(Ferungulates)]<-"1" 
grpS_01[Monotreme]<-"2" 
grpS_01[Marsupials]<-"2" 
grpS_01[c(setdiff(Placentals,c(RodentsLagomorphs,Primates,Bats,Ferungulates)))]<-"2" 
grpS_01[Primates]<-"2" 
grpS_01[OWFruitbats]<-"2" 
grpS_01[Emballonurids]<-"2" 
grpS_01<-as.factor(grpS_01) 
names(grpS_01)<-rownames(data)
    summary(grpS_01); length(grpS_01); length(names(summary(grpS_01)))
    tree$tip.label[which(grpS_01=="XXX")]

#For differences in intercept: 
grpI_01<-rep("XXX",length(rownames(data))) 
grpI_01[Muroids]<-"1_A" 
grpI_01[setdiff(RodentsLagomorphs,Muroids)]<-"1_B" 
grpI_01[c(Ferungulates)]<-"1_C" 
grpI_01[c(Vespertilionids,setdiff(YinBats,OWFruitbats))]<-"1_D" 
grpI_01[c(Marsupials)]<-"2_A" 
grpI_01[c(setdiff(Placentals,c(RodentsLagomorphs,Primates,Bats,Ferungulates)))]<-"2_A" 
grpI_01[c(Primates)]<-"2_B" 
grpI_01[c(OWFruitbats)]<-"2_B" 
grpI_01[c(Emballonurids)]<-"2_B" 
grpI_01[c(Monotreme)]<-"2_B" 
grpI_01<-as.factor(grpI_01) 
names(grpI_01)<-rownames(data)
    summary(grpI_01); length(grpI_01); length(names(summary(grpI_01)))
    tree$tip.label[which(grpI_01=="XXX")]


Model<-model.matrix(as.formula(Dependent~Independent),data)
Model_S_01<-model.matrix(as.formula(Dependent~grpS_01:Independent),data) 
Model_I_01<-model.matrix(as.formula(Dependent~grpI_01 + Independent),data) 
Model_SI_01<-model.matrix(as.formula(Dependent~grpI_01 + grpS_01:Independent),data)

#####################################################################


Model<-model.matrix(as.formula(Dependent~Independent),data)
Model_S_02<-model.matrix(as.formula(Dependent~grpS_02:Independent),data) 
Model_I_02<-model.matrix(as.formula(Dependent~grpI_02 + Independent),data) 
Model_SI_02<-model.matrix(as.formula(Dependent~grpI_02 + grpS_02:Independent),data)


####################################################################
#LS

gls.ancova(Dependent~Independent,Sigma,Model_SI_02,Model_SI_01)
gls.ancova(Dependent~Independent,Sigma,Model_SI_01,Model_SI_02)

gls.ancova(Dependent~Independent,Sigma,Model,Model_SI_02)
gls.ancova(Dependent~Independent,Sigma,Model,Model_SI_01)

####################################################################
#ML

Model_ML_01<-gls(as.formula(Dependent~grpI_01 + grpS_01:Independent),data,corPagel(1,phy=tree,fixed=FALSE),method="ML")
Model_ML_02<-gls(as.formula(Dependent~grpI_02 + grpS_02:Independent),data,corPagel(1,phy=tree,fixed=FALSE),method="ML")
anova(Model_ML_01,Model_ML_02)
                   



#####################################################################################################################################################
#pANCOVA for categories
#####################################################################################################################################################

###################################################
#VOLANT
###################################################

grpS<-rep("A",length(rownames(data))) 
grpS[which(dataCat$volancy=="volant")]<-"B" 
grpS<-as.factor(grpS) 
names(grpS)<-rownames(data)

grpI<-rep("A",length(rownames(data))) 
grpI[which(dataCat$volancy=="volant")]<-"B" 
grpI<-as.factor(grpI) 
names(grpI)<-rownames(data)

Model<-model.matrix(as.formula(Dependent~Independent),data)
Model_S<-model.matrix(as.formula(Dependent~grpS:Independent),data) 
Model_I<-model.matrix(as.formula(Dependent~grpI + Independent),data) 
Model_SI<-model.matrix(as.formula(Dependent~grpI + grpS:Independent),data)

gls.ancova(Dependent~Independent,Sigma,Model,Model_S)
gls.ancova(Dependent~Independent,Sigma,Model,Model_I)
gls.ancova(Dependent~Independent,Sigma,Model,Model_SI)
gls.ancova(Dependent~Independent,Sigma,Model_I,Model_SI)

###################################################
#FOSSORIAL
###################################################

grpS<-rep("A",length(rownames(data))) 
grpS[which(dataCat$fossoriallity=="fossorial")]<-"B" 
grpS[which(dataCat$fossoriallity=="semifossorial")]<-"C" 
grpS<-as.factor(grpS) 
names(grpS)<-rownames(data)

grpI<-rep("A",length(rownames(data))) 
grpI[which(dataCat$fossoriallity=="fossorial")]<-"B" 
grpI[which(dataCat$fossoriallity=="semifossorial")]<-"C" 
grpI<-as.factor(grpI) 
names(grpI)<-rownames(data)

Model<-model.matrix(as.formula(Dependent~Independent),data)
Model_S<-model.matrix(as.formula(Dependent~grpS:Independent),data) 
Model_I<-model.matrix(as.formula(Dependent~grpI + Independent),data) 
Model_SI<-model.matrix(as.formula(Dependent~grpI + grpS:Independent),data)

gls.ancova(Dependent~Independent,Sigma,Model,Model_S)
gls.ancova(Dependent~Independent,Sigma,Model,Model_I)
gls.ancova(Dependent~Independent,Sigma,Model,Model_SI)
gls.ancova(Dependent~Independent,Sigma,Model_I,Model_SI)



###################################################
#FORAGING
###################################################

grpS<-rep("A",length(rownames(data))) 
grpS[which(dataCat$foraging_environment=="aquatic")]<-"B" 
grpS[which(dataCat$foraging_environment=="arboreal")]<-"C" 
grpS[which(dataCat$foraging_environment=="semiarboreal")]<-"C" 
grpS[which(dataCat$foraging_environment=="terrestrial")]<-"D" 
grpS[which(dataCat$foraging_environment=="volant")]<-"E" 
grpS<-as.factor(grpS) 
names(grpS)<-rownames(data)

grpI<-rep("A",length(rownames(data))) 
grpI[which(dataCat$foraging_environment=="aquatic")]<-"B" 
grpI[which(dataCat$foraging_environment=="arboreal")]<-"C" 
grpI[which(dataCat$foraging_environment=="semiarboreal")]<-"C" 
grpI[which(dataCat$foraging_environment=="terrestrial")]<-"D" 
grpI[which(dataCat$foraging_environment=="volant")]<-"E" 
grpI<-as.factor(grpI) 
names(grpI)<-rownames(data)

Model<-model.matrix(as.formula(Dependent~Independent),data)
Model_S<-model.matrix(as.formula(Dependent~grpS:Independent),data) 
Model_I<-model.matrix(as.formula(Dependent~grpI + Independent),data) 
Model_SI<-model.matrix(as.formula(Dependent~grpI + grpS:Independent),data)

gls.ancova(Dependent~Independent,Sigma,Model,Model_S)
gls.ancova(Dependent~Independent,Sigma,Model,Model_I)
gls.ancova(Dependent~Independent,Sigma,Model,Model_SI)
gls.ancova(Dependent~Independent,Sigma,Model_I,Model_SI)


      pglsModel<-gls(Dependent~Independent+grpI,data,correlation=corPagel(1,phy=tree)); summary(pglsModel)



###################################################
#DAILY ACTIVITY
###################################################

grpS<-rep("A",length(rownames(data))) 
grpS[which(dataCat$daily_activity=="cathemeral")]<-"B" 
grpS[which(dataCat$daily_activity=="crepuscular")]<-"A" 
grpS[which(dataCat$daily_activity=="diurnal")]<-"A" 
grpS[which(dataCat$daily_activity=="nocturnal")]<-"A" 
grpS<-as.factor(grpS) 
names(grpS)<-rownames(data)

grpI<-rep("A",length(rownames(data))) 
grpI[which(dataCat$daily_activity=="cathemeral")]<-"B" 
grpI[which(dataCat$daily_activity=="crepuscular")]<-"A" 
grpI[which(dataCat$daily_activity=="diurnal")]<-"A" 
grpI[which(dataCat$daily_activity=="nocturnal")]<-"A" 
grpI<-as.factor(grpI) 
names(grpI)<-rownames(data)

Model<-model.matrix(as.formula(Dependent~Independent),data)
Model_S<-model.matrix(as.formula(Dependent~grpS:Independent),data) 
Model_I<-model.matrix(as.formula(Dependent~grpI + Independent),data) 
Model_SI<-model.matrix(as.formula(Dependent~grpI + grpS:Independent),data)

gls.ancova(Dependent~Independent,Sigma,Model,Model_S)
gls.ancova(Dependent~Independent,Sigma,Model,Model_I)
gls.ancova(Dependent~Independent,Sigma,Model,Model_SI)
gls.ancova(Dependent~Independent,Sigma,Model_I,Model_SI)

