********************************************************************************
* TASK 4 - UNDERSTANDING COMPOSITION 
********************************************************************************

// In this do-file, we show how to understand the composition of the economy 
// by groupping the firms according to selected characteristics, e.g.
// profitability, exporting status and sectoral composition. 
// For further details, please refer to the slides/user guide. 

// The structure of the do-file is as follow:
// 1) Graphs using unconditional statistics (zombie firms)	
// 2) Graphs using trade dataset (export)
// 3) Graphs for better understaing the dataset


// 1) Graphs for zombie firms

* In this section we explore the share of zombie firms in the economy where by
* zombie firms we mean firms with negative profits for 3 consecutive years.
* Of course, this is just an example and any information plotted can be changed 
* with any other of the information available in the database

// 1.1) Country level
cd "<insert relevant directory for unconditional files"

use unconditional_country_all_weighted.dta, clear

gen healtyfirms = 1 - FD07_zombie_negprof_mn

* All countries pooled over time
graph bar FD07_zombie_negprof_mn healtyfirms if healtyfirms !=., over(country, label(angle(30))) ///
	stack title(Share of firms with negative profits) ///
	legend(label(1 Firms with negative profits (%)) ///
	label(2 Firms with positive profits (%))) 

* One country over time	
graph bar FD07_zombie_negprof_mn healtyfirms if country == "FRANCE" & healtyfirms !=., ///
	over(year, label(angle(30))) stack title(Share of firms with negative profits) ///
	subtitle(France) legend(label(1 Firms with negative profits (%)) ///
	label(2 Firms with positive profits (%))) 
	
// 1.2) Macrosector level
use unconditional_mac_sector_all_weighted.dta, clear

*Labeling for graphs: refer to the user guide for more details
label define macrosectors 1  "Manufacturing" 2 "Construction" 3 "Wholesale" 4 "Transportation" 5 "Accommodation" 6 "ICT" 7 "Real estate" 8 "Professional activities" 9 "Administrative activities"
label values mac_sector macrosectors

gen healtyfirms = 1 - FD07_zombie_negprof_mn

* All sectors pooled over time
graph bar FD07_zombie_negprof_mn healtyfirms if country=="FRANCE", over(mac, label(angle(45))) ///
	stack title(Share of firms with negative profits) subtitle(France) ///
	legend(label(1 Firms with negative profits (%)) ///
	label(2 Firms with positive profits (%))) 

* One sector over time	
graph bar FD07_zombie_negprof_mn healtyfirms if country=="FRANCE" & mac == 1 & healtyfirms !=., ///
	over(year, label(angle(45))) stack title(Share of firms with negative profits) ///
	subtitle(France - Manufacturing) legend(label(1 Firms with negative profits (%)) ///
	label(2 Firms with positive profits (%))) 

	
// 1.3) Macrosector and sizeclass level ***CHECK
use nconditional_mac_sector_all_weighted.dta.dta, clear

* here information on macrosectors and size classes are embedded in a string variable
* so we need first to transform this information in numveric values
split macsec_szcl, parse(_) destring gen(var) 
drop macsec_szcl var1 var2 var3
rename var4 sizeclass
order mac sizeclass, after(year) 

*Labeling for graphs: refer to the user guide for more details
label define szcl 3  "Small" 4 "Medium" 5 "Large" 
label values sizeclass szcl

gen healtyfirms = 1 - FD07_zombie_negprof_mn

* All sectors pooled over time
graph bar FD07_zombie_negprof_mn healtyfirms if country=="FRANCE" & healtyfirms !=., ///
	over(sizeclass, label(angle(45))) over(mac, label(angle(45))) ///
	stack title(Share of firms with negative profits) subtitle(France) ///
	legend(label(1 Firms with negative profits (%)) ///
	label(2 Firms with positive profits (%))) 

* One sector over time	
graph bar FD07_zombie_negprof_mn healtyfirms if country=="FRANCE" & mac == 1 & healtyfirms !=., ///
	over(sizeclass, label(angle(45))) over(year) stack title(Share of firms with negative profits) ///
	subtitle(France - Manufacturing) legend(label(1 Firms with negative profits (%)) ///
	label(2 Firms with positive profits (%))) 

// 1.4) Sector level
use unconditional_country_20e_weighted.dta, clear

gen healtyfirms = 1 - FD07_zombie_negprof_mn

* One sector over time	
graph bar FD07_zombie_negprof_mn healtyfirms if country=="FRANCE" & sec == 10 & healtyfirms !=., ///
	over(year, label(angle(45))) stack title(Share of firms with negative profits) ///
	subtitle(France - Manufacturing of Food Product) ///
	legend(label(1 Firms with negative profits (%)) ///
	label(2 Firms with positive profits (%))) 


	
	
// 2) Graphs for exporting status 

* In this section we explore the share of firms by exporting activities in the 
* economy. Of course, this is just an example and any information plotted can be  
* changed with any other of the information available in the database

// 2.1) Country level
cd "<insert relevant directory for unconditional files in the trade section>"

use unconditional_country_20e_weighted.dta, clear

gen nonexporters = 1 - TD14_exp_mn

* All countries pooled over time
graph bar TD14_exp_mn nonexporters, stack over(country, label(angle(30))) ///
	title(Share of Exporters) legend(label(1 Exporters) label(2 Non-exporters))
	
* One Country over time
graph bar TD14_exp_mn nonexporters if country == "FRANCE", stack ///
	over(year, label(angle(30))) title(Share of Exporters) subtitle(France) ///
	legend(label(1 Exporters) label(2 Non-exporters))	

	
// 2.2) Macrosector level
use unconditional_mac_sector_20e_weighted.dta, clear

*Labeling for graphs: refer to the user guide for more details
label define macrosectors 1  "Manufacturing" 2 "Construction" 3 "Wholesale" 4 "Transportation" 5 "Accommodation" 6 "ICT" 7 "Real estate" 8 "Professional activities" 9 "Administrative activities"
label values mac_sector macrosectors

gen nonexporters = 1 - TD14_exp_mn

* All sectors pooled over time
graph bar TD14_exp_mn nonexporters if country == "FRANCE", stack ///
	over(mac, label(angle(30))) title(Share of Exporters) subtitle(France) ///
	legend(label(1 Exporters) label(2 Non-exporters))
	
* One Sector over time
graph bar TD14_exp_mn nonexporters if country == "FRANCE" & mac == 1, stack ///
	over(year, label(angle(30))) title(Share of Exporters) subtitle(France - Manufacturing) ///
	legend(label(1 Exporters) label(2 Non-exporters))	


	
// 2.3) Macrosector and sizeclass level **check again
use unconditional_macsec_szcl_20e_weighted.dta.dta, clear

* here information on macrosectors and size classes are embedded in a string variable
* so we need first to transform this information in numveric values
split macsec_szcl, parse(_) destring gen(var)
drop macsec_szcl var1 var2 var3
rename var4 sizeclass
order mac sizeclass, after(year) 

*Labeling for graphs: refer to the user guide for more details
label define szcl 3  "Small" 4 "Medium" 5 "Large" 
label values sizeclass szcl

gen nonexporters = 1 - TD14_exp_mn

* All sectors pooled over time
graph bar TD14_exp_mn nonexporters if country=="FRANCE", ///
	over(sizeclass, label(angle(45))) over(mac, label(angle(45))) ///
	stack title(Share of Exporters) subtitle(France) ///
	legend(label(1 Exporters) label(2 Non-exporters))

* One sector over time	
graph bar TD14_exp_mn nonexporters if country=="FRANCE" & mac == 1, ///
	over(sizeclass, label(angle(45))) over(year) stack title(Share of Exporters) ///
	subtitle(France - Manufacturing) legend(label(1 Exporters) label(2 Non-exporters))


// 2.4) Sector level
use unconditional_sector_20e_countries.dta, clear

gen nonexporters = 1 - TD14_exp_mn

* One sector over time	
graph bar Dummy_exp_mean nonexporters if country=="FRANCE" & sector == 10, ///
	over(sizeclass, label(angle(45))) over(year) stack title(Share of Exporters) ///
	subtitle(France - Manufacturing of Food Product) legend(label(1 Exporters) ///
	label(2 Non-exporters))



// 3) Graphs for sectoral composition 

* In this section we try to understand the composition of the firms in the dataset

// 3.1) Sectoral Composition
cd "<insert relevant directory for unconditional files>"

use unconditional_mac_sector_20e_weighted.dta, clear

* Generating agggregate Employment 
* OLD gen aggregate_l = l_mean * l_sum_weights

gen aggregate_l =LV21_l_mn*LV21_l_sw

*vs CV21_hhi_l_pop_M_N or CV21_hhi_l_pop_M_tot? grah this to add in slides

keep country mac year aggregate_l

reshape wide aggregate_l, i(country year) j(mac_sector)



* Transforming in share to have comparability across countries
egen total_labor = rowtotal(aggregate_l*) if year == 2013
forvalues i = 1(1)9 {
	replace aggregate_l`i' = aggregate_l`i' / total_labor
}	

* Sectoral composition 
graph bar aggregate_l*, stack over(country, label(angle(30))) ///
	title(Sectoral Composition) subtitle(Employment in 2013) ///
	legend(label(1 Manufacturing) label(2 Construction) label(3 Wholesale) ///
	label(4 Transportation)	label(5 Accommodation) label(6 ICT) ///
	label(7 Real estate) label(8 Professional) ///
	label(9 Administrative) cols(3))
		
