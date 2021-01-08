

#####################################################################################################################################################
#Taxoomic groups
#####################################################################################################################################################

plot(data$Dependent~data$Independent,col="white",pch=19,xlab="", ylab="",asp=1,cex=2) 
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Marsupials,col="lightblue",lwd=5,cex=1,pch=19)
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Lagomorphs,col="deepskyblue3",lwd=5,cex=1,pch=19)
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Rodents,col="royalblue3",lwd=5,cex=1,pch=19)
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Primates,col="darkblue",lwd=5,cex=1,pch=19)
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Soricomorphs,col="darkolivegreen1",lwd=5,cex=1,pch=19)
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Bats,col="darkolivegreen3",lwd=5,cex=1,pch=19)
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Artiodactyls,col="darkgreen",lwd=5,cex=1,pch=19)
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Cetaceans,col="orange",lwd=5,cex=1,pch=19)
pGLS.plotGrade("Dependent","Independent",data,tree,model="lambda",group=Carnivorans,col="red",lwd=5,cex=1,pch=19)



