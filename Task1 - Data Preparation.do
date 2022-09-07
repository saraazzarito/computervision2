********************************************************************************
* TASK 1 - DATA PREPARATION
********************************************************************************

* Before using this do-file, the user should download the data from the CompNet
* website. Please refer to the slides for further details.

****** Housekeeping
clear all


****** Setting directory
* You can tell STATA the folder you want to work in such that you do not need to
* specify the folder path everytime you wish to open or save a file.

* Examples:
* Windows
cd "C:\Users\jamesbond\Desktop\CompNet Data"

* Mac
*cd "/Users/jamesbond/Desktop/CompNet Data"



****** Opening a dataset
* Option 1: include the name of the file below. You must first set the right 
*			working directory
use "unconditional_country_20e_countries.dta", clear

* Option 2: if you do not wish to set a working directory, you can just 
*			double-click on the file you want to open



***** Focusing on specific country/year
* if you wish to focus only on selected countries or years you can use these commands
* BE AWARE that once the information are dropped they will be erased permanently 
* from STATA so if you wish to revise them you will need to reload them again
 
keep if country == "ITALY" 		// keeps only information on Italy
drop if country == "ITALY" 		// drops information on Italy

keep if year == 2012 			// keeps only information in 2012
drop if year == 2012 | == 2013 	// drops information in 2012 and 2013

* Information available only in datasets with macrosectoral disaggregation
keep if mac == 1 				// keeps only information on Manufacturing
drop if mac == 3				// drops information on Wholesale and Retail

* Information available only in datasets with sectoral disaggregation
keep if mac == 10 				// keeps only information on Manufacturing of food
drop if mac == 13				// drops information on Manufacturing of textiles



***** Focusing on specific indicators
keep country year l_* 			// drops all information besides cell identifiers 
								// and the full distribution of labor
							
* Information available only in datasets with macrosectoral disaggregation
keep country mac year l_* 		// drops all information besides cell identifiers 
								// and the full distribution of labor

* Information available only in datasets with sectoral disaggregation
keep country mac sector year l_* // drops all information besides cell identifiers 
								// and the full distribution of labor

								
***** Merging with other datafiles
merge 1:1 country year using prod_decomp_countryop_20e_countries.dta
drop _merge



**** Sorting data by the variables of interest
sort country year 



**** Generating aggregate values from firm averages

gen lprod_aggregate=rva_mean/l_mean	// aggregate values of ratios

