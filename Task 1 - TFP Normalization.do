********************************************************************************
* TASK 1 TFP NORMALIZATION 
********************************************************************************

//  Parametric measures of Total Factor Productivity are identified up to a constant
// 	using a control function approach. This implies that TFP values (residuals)
// 	are comparable ONLY among results from the same regression and NOT across
// 	regressions. Hence, we need to normalize such index in order to make it
// 	comparable over time. This do-file provides a routine to do such normalization.
// 	For further details, please refer to the slides/user guide. 
	
//  Please keep in mind that this normalization procedure can be used for any 
//  other indicator.	
	

// The structure of the do-file is as follow:
// 	1) Normalization at the country level	
// 	2) Normalization at the macrosector level	
// 	3) Normalization at the sector level	
// 	4) Normalization with size classes	
	
	
	
// 1) Normalization at the country level	
cd "<insert relevant directory for unconditional files>"

use unconditional_country_20e_countries.dta, clear

* Here we provide an examples with the median of the TFP distribution, you
* can replace it with any other moment. 
* The two lines below produce a new time series of the TFP evolution using the
* first year for which information are avalable as baseline.
gen tfp50 = .
by country: replace tfp50 = tfp_va_secCD_p50/tfp_va_secCD_p50[1]

br country year tfp50 // this is to see the result

* Now you can plot the indicator and compare the evolution over time
* For example
twoway (line tfp50 year if country == "BELGIUM") ///
	(line tfp50 year if country == "FRANCE"), title(TFP evolution in BE and FR) ///
	legend(label(1 Belgium) label(2 France))
	
	
	
// 2) Normalization at the macrosector level	
use unconditional_mac_sector_20e_countries.dta, clear

gen tfp50 = .
by country mac: replace tfp50 = tfp_va_secCD_p50/tfp_va_secCD_p50[1]

br country mac year tfp50 

* An example in Manufacturing (you can find the list of sectors in the user guide)
twoway (line tfp50 year if country == "BELGIUM" & mac == 1) ///
	(line tfp50 year if country == "FRANCE" & mac == 1), ///
	title(TFP evolution in BE and FR) subtitle(Manufacturing) ///
	legend(label(1 Belgium) label(2 France))	

	
	
// 3) Normalization at the sector level	
use unconditional_sector_20e_countries.dta, clear

gen tfp50 = .
by country sector: replace tfp50 = tfp_va_secCD_p50/tfp_va_secCD_p50[1]

br country sector year tfp50 

* An example in Manufacturing of Food products (you can find the list of sectors in the user guide)
twoway (line tfp50 year if country == "BELGIUM" & sector == 10) ///
	(line tfp50 year if country == "FRANCE" & sector == 10), ///
	title(TFP evolution in BE and FR) subtitle(Manufacturing of Foor Products) ///
	legend(label(1 Belgium) label(2 France))	
	
	
	
// 	4) Normalization with size classes	
use unconditional_macsec_szcl_20e_countries.dta, clear

* here information on macrosectors and size classes are embedded in a string variable
* so we need first to transform this information in numeric values
split macsec_szcl, parse(_) destring gen(var)
drop macsec_szcl var1 var2 var3
rename var4 sizeclass
order mac sizeclass, after(year) 

* normalization is then similar to what we did for countries, macrosectors and sectors
gen tfp50 = .
bys country mac sizeclass: replace tfp50 = tfp_va_secCD_p50/tfp_va_secCD_p50[1]

br country mac sizeclass year tfp50

* An example in Manufacturing in France
twoway (line tfp50 year if sizeclass == 3) (line tfp50 year if sizeclass == 4) ///
	(line tfp50 year if sizeclass == 5) if country == "FRANCE" & mac == 1, ///
	title(TFP evolution in France) subtitle(Manufacturing) ///
	legend(label(1 Small) label(2 Medium) label(3 Large))
	
