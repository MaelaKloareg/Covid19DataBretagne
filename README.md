# Covid19DataBretagne
Nombre de cas Covid-19 en région Bretagne, par département et cumulés sur la région, depuis le 06/03/2020

Le fichier Covid19_Bretagne.csv contient les données compilées à partir des sources : 

https://www.bretagne.ars.sante.fr/

http://www.prefectures-regions.gouv.fr/bretagne/Actualites/Coronavirus-informations-recommandations-et-mesures-sanitaires

Et, pour la Loire-Atlantique : https://br.wikipedia.org/wiki/Bedreuziad_COVID-19_e_2019-2020

Remarques concernant les modalités de comptage : 
- il s'agit du nombre de cas de "Coronavirus Covid-19 confirmés en Bretagne par diagnostic biologique (PCR)", donc bien en dessous du nombre de cas réels;
- les morts sont comptabilisées "dans le cadre des prises en charge hospitalières", donc très probablement en dessous de la réalité. Depuis début avril, le site de la préfecture donne également les décès en EHPAD, qui ne sont pas comptabilisés dans mes fichiers.

Le script R permet de faire des graphiques sur ces données, avec le package ggplot2.
