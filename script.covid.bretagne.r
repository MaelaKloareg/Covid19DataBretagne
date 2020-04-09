library(readxl)
library(ggplot2)
library(reshape2) # melt() et dcast()

setwd("D:/Kuzulia/Docs_stat/2020_covid")

aujourdhui=format(Sys.Date(),"%d/%m%/%Y")
hier=format(Sys.Date()-1,"%d/%m%/%Y")
dateconfinement = as.Date("2020-03-17")

#############################
# importation

bzh = read_excel("ARS_BZH.xlsx", sheet = "covid19_ARS_Bretagne")

bzh = read.csv2("Covid19_Bretagne.csv")

bzh$Date=as.Date(bzh$Date, format="%d/%m/%Y")
summary(bzh)

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

#############################
# nombre de cas par d�partement

meltbzh=melt(bzh[,1:8], id.vars ="Date")
summary(meltbzh)

levels(meltbzh$variable) =c("Morbihan" , "Ille-et-Vilaine", "Finist�re",            
"C�tes d'Armor", "D�partement non connu" ,"Non r�sidents",  "Loire-Atlantique" )

depNewLevels=c("Loire-Atlantique","Ille-et-Vilaine","Morbihan", "Finist�re","C�tes d'Armor","D�partement non connu","Non r�sidents")
meltbzh$variable=factor(meltbzh$variable,depNewLevels)

ggplot(data=meltbzh) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Nombre de cas d�clar�s par l'ARS Bretagne et en Loire Atlantique", col="", y="", 
		#caption=paste("donn�es mises � jour le",aujourdhui))
		caption=paste("donn�es mises � jour le",hier,"@MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")

ggsave("cas_BZH.png")


#############################
# augmentation quotidienne des cas en Bretagne

bzh$diffcas = c(NA,diff(bzh$cas4dep))
summary(bzh)

ggplot(data=bzh) + theme_classic() +
	aes(y=diffcas, x=Date) + geom_col(fill="royalblue") +
	labs(y="", 
		caption=paste("donn�es mises � jour le",hier,"@MaelaKloareg"))+
	ggtitle("Augmentation quotidienne du nombre de cas COVID-19 d�clar�s par l'ARS en r�gion Bretagne") +
	annotate("text", x = dateconfinement , y = 40, label = "D�but du confinement", angle = 90)
ggsave("diffcas_BZH.png")
