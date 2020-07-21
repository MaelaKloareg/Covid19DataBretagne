
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
bzh$diffcasFinistère = c(NA,diff(bzh$Finistère))/bzh$diffDate
bzh$diffcasCôtes.d.Armor = c(NA,diff(bzh$Côtes.d.Armor))/bzh$diffDate
bzh$diffcasMorbihan = c(NA,diff(bzh$Morbihan))/bzh$diffDate
bzh$diffcasIlle.et.Vilaine = c(NA,diff(bzh$Ille.et.Vilaine))/bzh$diffDate
bzh$diffcasNon.résidents = c(NA,diff(bzh$Non.résidents))/bzh$diffDate

summary(bzh)


#############################
# nombre de cas par département région Bretagne (données ARS)
names(bzh)
meltbzh=melt(bzh[,c(1:5, 8, 14:18)], id.vars ="Date")
summary(meltbzh)
levels(meltbzh$variable)

meltbzhcumulcas = droplevels(subset(meltbzh, variable%in%levels(meltbzh$variable)[1:5]))
summary(meltbzhcumulcas)
levels(meltbzhcumulcas$variable)=c("Finistère", "Côtes d'Armor", "Morbihan" , "Ille-et-Vilaine", "Non résidents" )

meltbzhdiffcas = droplevels(subset(meltbzh, variable%in%levels(meltbzh$variable)[6:10]))
summary(meltbzhdiffcas)
levels(meltbzhdiffcas$variable)=c("Finistère", "Côtes d'Armor", "Morbihan" , "Ille-et-Vilaine", "Non résidents" )

############
# cumul cas 
ggplot(data=meltbzhcumulcas ) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Nombre de cas déclarés par l'ARS Bretagne", col="", y="", 
		caption=paste("données mises à jour le",aujourdhui)) +
		#caption=paste("données mises à jour le",hier,"@MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")

ggsave("cas_BZH.png")

# depuis le déconfinement
sel=which(meltbzh$Date>=dateDeconfinement)
ggplot(data=meltbzhcumulcas[sel,] ) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Nombre de cas déclarés par l'ARS Bretagne", col="", y="", 
		caption=paste("données mises à jour le",aujourdhui)) +
		#caption=paste("données mises à jour le",hier,"@MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")

#############################
# augmentation quotidienne des cas en région Bretagne

# depuis le déconfinement
sel=which(meltbzhdiffcas$Date>=dateDeconfinement)
ggplot(data=meltbzhdiffcas[sel,] ) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Nombre de cas déclarés par l'ARS Bretagne", col="", y="", 
		caption=paste("données mises à jour le",aujourdhui)) +
		#caption=paste("données mises à jour le",hier,"@MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")

# depuis début juillet
sel=which(meltbzhdiffcas$Date>="2020-07-01")
ggplot(data=meltbzhdiffcas[sel,] ) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Covid19 en région Bretagne : nombre moyen de tests PCR positifs par jour", col="", y="", caption=paste("moyenne quotidienne sur les données ARS, @MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")


############################################################################
# archives (pour le nb de morts, cf aussi données nationales)
#############################
# nombre de cas sur la région Bretagne

ggplot(data=bzh) + aes(y=cas4dep, x=Date) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de cas déclarés par l'ARS en région Bretagne", col="", 
		#caption=paste("données mises à jour le",aujourdhui))
		caption=paste("données mises à jour le",hier,"@MaelaKloareg"))

#############################
# nombre de morts sur la région Bretagne

ggplot(data=bzh) + aes(y=morts4dep, x=Date) +geom_point() + geom_line() + theme_classic() +
	labs(y="Nombre de morts déclarés par l'ARS en région Bretagne", col="", 
		#caption=paste("données mises à jour le",aujourdhui))
		caption=paste("données mises à jour le",hier,"@MaelaKloareg"))


