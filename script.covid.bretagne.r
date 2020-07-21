
library(RcmdrMisc)
library(ggplot2)
library(reshape2) # melt() et dcast()

setwd("D:/Kuzulia/Docs_stat/2020_covid")

aujourdhui=format(Sys.Date(),"%d/%m%/%Y")
hier=format(Sys.Date()-1,"%d/%m%/%Y")
dateconfinement = as.Date("2020-03-17")
dateDeconfinement = as.Date("2020-05-11")

#############################
# importation

bzh = readXL("Covid19_Bretagne.xlsx", sheet = "Covid19_Bretagne")

bzh$Date=as.Date(bzh$Date, format="%d/%m/%Y")
summary(bzh)

# calcul des augmentations quotidiennes
names(bzh)
bzh$diffDate = c(NA,diff(bzh$Date))
bzh$diffcas = c(NA,diff(bzh$cas4dep))/bzh$diffDate
bzh$diffcasFinist�re = c(NA,diff(bzh$Finist�re))/bzh$diffDate
bzh$diffcasC�tes.d.Armor = c(NA,diff(bzh$C�tes.d.Armor))/bzh$diffDate
bzh$diffcasMorbihan = c(NA,diff(bzh$Morbihan))/bzh$diffDate
bzh$diffcasIlle.et.Vilaine = c(NA,diff(bzh$Ille.et.Vilaine))/bzh$diffDate
bzh$diffcasNon.r�sidents = c(NA,diff(bzh$Non.r�sidents))/bzh$diffDate

summary(bzh)


#############################
# nombre de cas par d�partement r�gion Bretagne (donn�es ARS)
names(bzh)
meltbzh=melt(bzh[,c(1:5, 8, 14:18)], id.vars ="Date")
summary(meltbzh)
levels(meltbzh$variable)

meltbzhcumulcas = droplevels(subset(meltbzh, variable%in%levels(meltbzh$variable)[1:5]))
summary(meltbzhcumulcas)
levels(meltbzhcumulcas$variable)=c("Finist�re", "C�tes d'Armor", "Morbihan" , "Ille-et-Vilaine", "Non r�sidents" )

meltbzhdiffcas = droplevels(subset(meltbzh, variable%in%levels(meltbzh$variable)[6:10]))
summary(meltbzhdiffcas)
levels(meltbzhdiffcas$variable)=c("Finist�re", "C�tes d'Armor", "Morbihan" , "Ille-et-Vilaine", "Non r�sidents" )

############
# cumul cas 
ggplot(data=meltbzhcumulcas ) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Nombre de cas d�clar�s par l'ARS Bretagne", col="", y="", 
		caption=paste("donn�es mises � jour le",aujourdhui)) +
		#caption=paste("donn�es mises � jour le",hier,"@MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")

ggsave("cas_BZH.png")

# depuis le d�confinement
sel=which(meltbzh$Date>=dateDeconfinement)
ggplot(data=meltbzhcumulcas[sel,] ) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Nombre de cas d�clar�s par l'ARS Bretagne", col="", y="", 
		caption=paste("donn�es mises � jour le",aujourdhui)) +
		#caption=paste("donn�es mises � jour le",hier,"@MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")

#############################
# augmentation quotidienne des cas en r�gion Bretagne

# depuis le d�confinement
sel=which(meltbzhdiffcas$Date>=dateDeconfinement)
ggplot(data=meltbzhdiffcas[sel,] ) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Nombre de cas d�clar�s par l'ARS Bretagne", col="", y="", 
		caption=paste("donn�es mises � jour le",aujourdhui)) +
		#caption=paste("donn�es mises � jour le",hier,"@MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")

# depuis d�but juillet
sel=which(meltbzhdiffcas$Date>="2020-07-01")
ggplot(data=meltbzhdiffcas[sel,] ) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Covid19 en r�gion Bretagne : nombre moyen de tests PCR positifs par jour", col="", y="", caption=paste("moyenne quotidienne sur les donn�es ARS, @MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")


############################################################################
# archives (pour le nb de morts, cf aussi donn�es nationales)
#############################
# nombre de cas sur la r�gion Bretagne

ggplot(data=bzh) + aes(y=cas4dep, x=Date) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas d�clar�s par l'ARS en r�gion Bretagne", col="", 
		#caption=paste("donn�es mises � jour le",aujourdhui))
		caption=paste("donn�es mises � jour le",hier,"@MaelaKloareg"))

#############################
# nombre de morts sur la r�gion Bretagne

ggplot(data=bzh) + aes(y=morts4dep, x=Date) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de morts d�clar�s par l'ARS en r�gion Bretagne", col="", 
		#caption=paste("donn�es mises � jour le",aujourdhui))
		caption=paste("donn�es mises � jour le",hier,"@MaelaKloareg"))


