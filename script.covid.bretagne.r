library(readxl)
library(ggplot2)

setwd("D:/Kuzulia/Docs_stat/2020_covid")

#############################
# cumul sur la r�gion

cumul = read_excel("ARS_BZH.xlsx", sheet = "covid19_ARS_Bretagne")

cumul$date=as.Date(cumul$date, format="%d/%m/%Y")
summary(cumul)

ggplot(data=cumul) + aes(y=nombre, x=date, col=categorie) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas d�clar�s par l'ARS en r�gion Bretagne", col="")

# �chelle log
ggplot(data=cumul) + aes(y=nombre, x=date, col=categorie) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas d�clar�s par l'ARS en r�gion Bretagne (�chelle logarithmique)", col="") +
	scale_y_continuous(trans = 'log10') +
	annotation_logticks(sides="l")

#############################
# nombre de cas par d�partement

bzh = read_excel("ARS_BZH.xlsx", sheet = "covid19_ARS_cas_par_departement")
bzh$D�partement=as.factor(bzh$D�partement)

sort(tapply(bzh$Nombre, bzh$D�partement, max, na.rm=TRUE), decreasing = TRUE)
DepNewLevels=names(sort(tapply(bzh$Nombre, bzh$D�partement, max, na.rm=TRUE), decreasing = TRUE))
bzh$D�partement=factor(bzh$D�partement,DepNewLevels)

summary(bzh)

ggplot(data=bzh) + aes(y=Nombre, x=Date, col=D�partement) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas d�clar�s par l'ARS en r�gion Bretagne")

# �chelle log
ggplot(data=bzh) + aes(y=Nombre, x=Date, col=D�partement) +geom_point() + geom_line() + theme_classic() +
	scale_y_continuous(trans = 'log10') +
	annotation_logticks(sides="l") + 
	labs(y="Nombre total de cas d�clar�s par l'ARS (�chelle logarithmique)")


# grafik e bzhg
bzh$Departamant=as.factor(bzh$D�partement)
levels(bzh$Departamant)=c("Aodo� an Arvor", "Penn ar bed", "Il ha Gwilun", "Morbihan")

ggplot(data=bzh) + aes(y=Nombre, x=Date, col=Departamant) +geom_point() + geom_line() + theme_classic() +
	labs(y="Niver a dud kla�v gant ar COVID-19 diskleriet gant an ARS", x="Deiziad")

