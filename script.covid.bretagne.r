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

#############################
# nombre de cas par département

meltbzh=melt(bzh[,1:8], id.vars ="Date")
summary(meltbzh)

levels(meltbzh$variable) =c("Morbihan" , "Ille-et-Vilaine", "Finistère",            
"Côtes d'Armor", "Département non connu" ,"Non résidents",  "Loire-Atlantique" )

depNewLevels=c("Loire-Atlantique","Ille-et-Vilaine","Morbihan", "Finistère","Côtes d'Armor","Département non connu","Non résidents")
meltbzh$variable=factor(meltbzh$variable,depNewLevels)

ggplot(data=meltbzh) + aes(y=value, x=Date, col=variable) +geom_point() + geom_line() + theme_classic() +
	labs(title="Nombre de cas déclarés par l'ARS Bretagne et en Loire Atlantique", col="", y="", 
		#caption=paste("données mises à jour le",aujourdhui))
		caption=paste("données mises à jour le",hier,"@MaelaKloareg"))+ 
  	scale_colour_brewer(palette="Set1")

ggsave("cas_BZH.png")


#############################
# augmentation quotidienne des cas en Bretagne

bzh$diffcas = c(NA,diff(bzh$cas4dep))
summary(bzh)

ggplot(data=bzh) + theme_classic() +
	aes(y=diffcas, x=Date) + geom_col(fill="royalblue") +
	labs(y="", 
		caption=paste("données mises à jour le",hier,"@MaelaKloareg"))+
	ggtitle("Augmentation quotidienne du nombre de cas COVID-19 déclarés par l'ARS en région Bretagne") +
	annotate("text", x = dateconfinement , y = 40, label = "Début du confinement", angle = 90)
ggsave("diffcas_BZH.png")
