library(readxl)
library(ggplot2)
library(reshape2) # melt() et dcast()

setwd("D:/Kuzulia/Docs_stat/2020_covid")

aujourdhui=format(Sys.Date(),"%d/%m%/%Y")
hier=format(Sys.Date()-1,"%d/%m%/%Y")
dateconfinement = as.Date("2020-03-17")

#############################
# cumul sur la r�gion Bretagne

bzh = read_excel("ARS_BZH.xlsx", sheet = "covid19_ARS_Bretagne")

bzh$date=as.Date(bzh$date, format="%d/%m/%Y")
bzh$categorie=as.factor(bzh$categorie)
summary(bzh)

ggplot(data=bzh) + aes(y=nombre, x=date, col=categorie) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas d�clar�s par l'ARS en r�gion Bretagne", col="", 
		caption=paste("donn�es mises � jour le",aujourdhui,"@MaelaKloareg"))

# �chelle log
ggplot(data=bzh) + aes(y=nombre, x=date, col=categorie) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas d�clar�s par l'ARS en r�gion Bretagne (�chelle logarithmique)", col="") +
	scale_y_continuous(trans = 'log10') +
	annotation_logticks(sides="l")

#############################
# augmentation quotidienne de cas en Bretagne

castbzh = dcast(bzh, date~categorie, value.var = "nombre")
castbzh$diffcas = c(NA,diff(castbzh$cas))
summary(castbzh)

ggplot(data=castbzh) + theme_classic() +
	aes(y=diffcas, x=date) + geom_col(fill="royalblue") +
	labs(y="", 
		caption=paste("donn�es mises � jour le",aujourdhui,"@MaelaKloareg"))+
	ggtitle("Augmentation quotidienne du nombre de cas COVID-19 d�clar�s par l'ARS en r�gion Bretagne") +
	annotate("text", x = dateconfinement , y = 40, label = "D�but du confinement", angle = 90)


#############################
# nombre de cas par d�partement

dep = read_excel("ARS_BZH.xlsx", sheet = "covid19_ARS_cas_par_departement")
dep$D�partement=as.factor(dep$D�partement)

sort(tapply(dep$Nombre, dep$D�partement, max, na.rm=TRUE), decreasing = TRUE)
DepNewLevels=names(sort(tapply(dep$Nombre, dep$D�partement, max, na.rm=TRUE), decreasing = TRUE))
dep$D�partement=factor(dep$D�partement,DepNewLevels)

summary(dep)

ggplot(data=dep) + aes(y=Nombre, x=Date, col=D�partement) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas COVID-19 d�clar�s par l'ARS en r�gion Bretagne", 
		caption=paste("mis � jour le",aujourdhui))

# �chelle log
ggplot(data=dep) + aes(y=Nombre, x=Date, col=D�partement) +geom_point() + geom_line() + theme_classic() +
	scale_y_continuous(trans = 'log10') +
	annotation_logticks(sides="l") + 
	labs(y="Nombre total de cas d�clar�s par l'ARS (�chelle logarithmique)")


# grafik e bzhg
dep$Departamant=as.factor(dep$D�partement)
levels(dep$Departamant)=c("Aodo� an Arvor", "Penn ar bed", "Il ha Gwilun", "Morbihan")

ggplot(data=dep) + aes(y=Nombre, x=Date, col=Departamant) +geom_point() + geom_line() + theme_classic() +
	labs(y="Niver a dud kla�v gant ar COVID-19 diskleriet gant an ARS", x="Deiziad")

