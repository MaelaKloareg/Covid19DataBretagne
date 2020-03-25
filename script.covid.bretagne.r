library(readxl)
library(ggplot2)

setwd("D:/Kuzulia/Docs_stat/2020_covid")

#############################
# cumul sur la région

cumul = read_excel("ARS_BZH.xlsx", sheet = "covid19_ARS_Bretagne")

cumul$date=as.Date(cumul$date, format="%d/%m/%Y")
summary(cumul)

ggplot(data=cumul) + aes(y=nombre, x=date, col=categorie) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas déclarés par l'ARS en région Bretagne", col="")

# échelle log
ggplot(data=cumul) + aes(y=nombre, x=date, col=categorie) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas déclarés par l'ARS en région Bretagne (échelle logarithmique)", col="") +
	scale_y_continuous(trans = 'log10') +
	annotation_logticks(sides="l")

#############################
# nombre de cas par département

bzh = read_excel("ARS_BZH.xlsx", sheet = "covid19_ARS_cas_par_departement")
bzh$Département=as.factor(bzh$Département)

sort(tapply(bzh$Nombre, bzh$Département, max, na.rm=TRUE), decreasing = TRUE)
DepNewLevels=names(sort(tapply(bzh$Nombre, bzh$Département, max, na.rm=TRUE), decreasing = TRUE))
bzh$Département=factor(bzh$Département,DepNewLevels)

summary(bzh)

ggplot(data=bzh) + aes(y=Nombre, x=Date, col=Département) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas déclarés par l'ARS en région Bretagne")

# échelle log
ggplot(data=bzh) + aes(y=Nombre, x=Date, col=Département) +geom_point() + geom_line() + theme_classic() +
	scale_y_continuous(trans = 'log10') +
	annotation_logticks(sides="l") + 
	labs(y="Nombre total de cas déclarés par l'ARS (échelle logarithmique)")


# grafik e bzhg
bzh$Departamant=as.factor(bzh$Département)
levels(bzh$Departamant)=c("Aodoù an Arvor", "Penn ar bed", "Il ha Gwilun", "Morbihan")

ggplot(data=bzh) + aes(y=Nombre, x=Date, col=Departamant) +geom_point() + geom_line() + theme_classic() +
	labs(y="Niver a dud klañv gant ar COVID-19 diskleriet gant an ARS", x="Deiziad")

