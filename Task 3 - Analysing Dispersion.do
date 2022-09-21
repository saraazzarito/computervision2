********************************************************************************
* TASK 3 - ANALYSING DISPERSION 
********************************************************************************


// In this do-file, we show how to display infomation on the dispersion of a variable
// over time at different level of aggregation. To do so, we combine information
// on different moments of the distribution of the variable in analysis. For the
// purpose of this exercise, we focus on the evolution on median values together 
// with interquantile range and other extreme values.
// For further details, please refer to the slides/user guide. 

cd "<insert relevant directory for unconditional files>"

// A) INTERQUANTILE RANGES

// 1) Country level
use unconditional_country_full_countries.dta, clear

twoway (rarea tfp_va_macCD_p75 tfp_va_macCD_p25 year, fi(inten30) lwidth(none)) ///
	(line tfp_va_macCD_p50 year, lw(medthick)) if country == "FRANCE", ///
	title(TFP Evolution) subtitle(France) ///
	ytitle(TFP) xtitle("")  ///
	legend(order(2 1) label(1 "Interquartile range") label(2 "Median")) 
	

* Adding p1 and p99
twoway (rarea tfp_va_macCD_p75 tfp_va_macCD_p25 year, fi(inten30) lwidth(none)) ///
	(line tfp_va_macCD_p50 year, lw(medthick)) (line tfp_va_macCD_p1 year, lw(medthick)) ///
	(line tfp_va_macCD_p99 year, lw(medthick)) if country == "FRANCE", ///
	title(TFP Evolution) subtitle(France) ///
	ytitle(TFP) xtitle("")  ///
	legend(order(2 1) label(1 "Interquartile range") label(2 "Median") ///
	label(3 "p1") label(4 "p99")) 	


* Comparison across countries: cannot use TFP, will use lprod
	
* in order to produce this graph, we need to reshape and change the dataset so you
* will need to re-upload it for the rest of the do-file or use a preserve/restore
* command

gen lprod_wm = rva_mean/l_mean

keep if year == 2014
collapse (mean) lprod_p10 lprod_p25 lprod_p50 lprod_p75 lprod_p90 lprod_wm, by(country)
		
egen id=rank(lprod_p75)

* this command needs to be installed manually, please type: help gr0034 
labmask id, values(country)	

twoway (rcap lprod_p10 lprod_p90 id, horizontal fcolor(navy) lwidth(thick) ) ///
	(rbar lprod_p25 lprod_p75 id, horizontal fcolor(sandb)) ///
	(scatter id lprod_p50, msize(large) mcolor(maroon) mlabcolor(red)) ///
	(scatter id lprod_wm, msize(large) mcolor(dkgreen) mlabgap(large)  ///
	mlabposition(9) mlabangle(horizontal)), title(Productivity dispersion) ///
	legend(order(3 2 4 1) label(1 "p10 - p90") label(2 "p25 - p75") ///
	label(3 Median) label(4 Weighted mean) rows(1)) ytitle("")  ///
	ylabel(1(1)15, angle(horizontal) valuelabels labsize(small)) ///
	xtitle("Labour productivity level") 

		
	
// 2) Macrosector level
use unconditional_mac_sector_full_countries.dta, clear

twoway (rarea tfp_va_macCD_p75 tfp_va_macCD_p25 year, fi(inten30) lwidth(none)) ///
	(line tfp_va_macCD_p50 year, lw(medthick)) if country == "FRANCE" & mac == 1, ///
	title(TFP Evolution) subtitle(France - Manufacturig) ///
	ytitle(TFP) xtitle("")  ///
	legend(order(2 1) label(1 "Interquartile range") label(2 "Median") ) 


* Adding p1 and p99
twoway (rarea tfp_va_macCD_p75 tfp_va_macCD_p25 year, fi(inten30) lwidth(none)) ///
	(line tfp_va_macCD_p50 year, lw(medthick)) (line tfp_va_macCD_p1 year, lw(medthick)) ///
	(line tfp_va_macCD_p99 year, lw(medthick)) if country == "FRANCE" & mac == 1, ///
	title(TFP Evolution) subtitle(France - Manufacturig) ///
	ytitle(TFP) xtitle("")  ///
	legend(order(2 1) label(1 "Interquartile range") label(2 "Median") ///
	label(3 "p1") label(4 "p99")) 

* Comparison across macro-sectors: now we can use TFP
* in order to produce this graph, we need to reshape and change the dataset so you
* will need to re-upload it for the rest of the do-file or use a preserve/restore
* command

keep if country == "FRANCE" & year==2014

collapse (mean) tfp_va_macCD_p10 tfp_va_macCD_p25 tfp_va_macCD_p50 tfp_va_macCD_p75 ///
	tfp_va_macCD_p90 tfp_va_macCD_mean, by(mac)
	
	
*Labeling for graphs: refer to the user guide for more details
tostring mac, replace

replace mac="Manufacturing" if mac == "1"
replace mac="Construction" if mac == "2"
replace mac="Wholesale & retail trade" if mac == "3"
replace mac="Transportation" if mac == "4"
replace mac="Accommodation" if mac == "5"
replace mac="ICT" if mac == "6"
replace mac="Real estate" if mac == "7"
replace mac="Professional activities" if mac == "8"
replace mac="Administrative activities" if mac == "9"
		
egen id=rank(tfp_va_macCD_p75)

* this command needs to be installed manually, please type: help gr0034 
labmask id, values(mac)	

twoway (rcap tfp_va_macCD_p10 tfp_va_macCD_p90 id, horizontal fcolor(navy) lwidth(thick) ) ///
	(rbar tfp_va_macCD_p25 tfp_va_macCD_p75 id, barwidth(.8) horizontal fcolor(sandb)) ///
	(scatter id tfp_va_macCD_p50, msize(large) mcolor(maroon) mlabcolor(red)) ///
	(scatter id tfp_va_macCD_mean, msize(large) mcolor(dkgreen) mlabgap(large)  ///
	mlabposition(9) mlabangle(horizontal)), title(TFP dispersion in France) ///
	subtitle(Manufacturing) ///
	legend(order(3 2 4 1) label(1 "p10 - p90") label(2 "p25 - p75") ///
	label(3 Median) label(4 Mean) rows(1)) ytitle("")  ///
	ylabel(1(1)9, angle(horizontal) valuelabels) xtitle("TFP level") 
	
	

// 3) Macrosector and sizeclass level
use unconditional_macsec_szcl_full_countries.dta, clear

* here information on macrosectors and size classes are embedded in a string variable
* so we need first to transform this information in numveric values
split macsec_szcl, parse(_) destring gen(var)
drop macsec_szcl var1 var2 var3
rename var4 sizeclass
order mac sizeclass, after(year) 

twoway (rarea tfp_va_macCD_p75 tfp_va_macCD_p25 year, fi(inten30) lwidth(none)) ///
	(line tfp_va_macCD_p50 year, lw(medthick)) if country == "FRANCE" & mac == 1 & sizeclass == 3, ///
	title(TFP Evolution) subtitle(France - Small Firms in Manufacturig) ///
	ytitle(TFP) xtitle("")  ///
	legend(order(2 1) label(1 "Interquartile range") label(2 "Median")) 

	
* Comparison across size classes: now we can use TFP
* in order to produce this graph, we need to reshape and change the dataset so you
* will need to re-upload it for the rest of the do-file or use a preserve/restore
* command

keep if country == "FRANCE" & mac == 1 & year==2014
collapse (mean) tfp_va_macCD_p10 tfp_va_macCD_p25 tfp_va_macCD_p50 tfp_va_macCD_p75 ///
	tfp_va_macCD_p90 tfp_va_macCD_mean, by(sizeclass )
	
	
*Labeling for graphs: refer to the user guide for more details
tostring sizeclass, replace

replace sizeclass = "Micro" if sizeclass == "1"
replace sizeclass = "Very small" if sizeclass == "2"
replace sizeclass = "Small" if sizeclass == "3"
replace sizeclass = "Medium" if sizeclass == "4"
replace sizeclass = "Large" if sizeclass == "5"
		
egen id=rank(tfp_va_macCD_p75)

* this command needs to be installed manually, please type: help gr0034 
labmask id, values(sizeclass)	

twoway (rcap tfp_va_macCD_p10 tfp_va_macCD_p90 id, horizontal fcolor(navy) lwidth(thick) ) ///
	(rbar tfp_va_macCD_p25 tfp_va_macCD_p75 id, barwidth(.5) horizontal fcolor(sandb)) ///
	(scatter id tfp_va_macCD_p50, msize(large) mcolor(maroon) mlabcolor(red)) ///
	(scatter id tfp_va_macCD_mean, msize(large) mcolor(dkgreen) mlabgap(large)  ///
	mlabposition(9) mlabangle(horizontal)), title(TFP dispersion in France) ///
	subtitle(Manufacturing) ///
	legend(order(3 2 4 1) label(1 "p10 - p90") label(2 "p25 - p75") ///
	label(3 Median) label(4 Mean) rows(2)) ytitle("")  ///
	ylabel(1(1)5, angle(horizontal) valuelabels) xtitle("TFP level") 


// B) DISTRIBUTIONS OF SECTORAL LABOUR PRODUCTIVITY 

use unconditional_sector_full_countries.dta, clear

gen LogLabourProductivity=log(rva_mean/l_mean)

*Across countries
twoway (kdensity LogLabourProductivity if year==2014 & country=="FRANCE") ///
	(kdensity LogLabourProductivity if year==2014 & country=="ITALY"), ///
	legend(label(1 "France") label(2 "Italy")) ///
	title("Distributions of sectoral Labour Productivity (in logs)") subtitle("2014") ///
	ytitle("") xtitle("")

*Across time
twoway (kdensity LogLabourProductivity if year==2005 & country=="ITALY") ///
	(kdensity LogLabourProductivity if year==2008 & country=="ITALY") ///
	(kdensity LogLabourProductivity if year==2011 & country=="ITALY") ///
	(kdensity LogLabourProductivity if year==2014 & country=="ITALY"), ///
	legend(label(1 "2005") label(2 "2008") label(3 "2011") label(4 "2014")) ///
	title("Distributions of sectoral Labour Productivity (in logs)") subtitle("Italy") ///
	ytitle("") xtitle("")

*Across macro-sectors
twoway (kdensity LogLabourProductivity if year==2014 & country=="ITALY" & mac==1) ///
	(kdensity LogLabourProductivity if year==2014 & country=="ITALY" & mac==2) ///
	(kdensity LogLabourProductivity if year==2014 & country=="ITALY" & mac==3) ///
	(kdensity LogLabourProductivity if year==2014 & country=="ITALY" & mac==4), ///
	legend(label(1 "Manufacturing") label(2 "Construction") ///
	label(3 "Wholesale and reatail trade") label(4 "Trasportation")) ///
	title("Distributions of sectoral Labour Productivity (in logs)") subtitle("Italy in 2014") ///
	ytitle("") xtitle("")

*By financial status
cd "<insert relevant directory for joint distributions files in the trade section>"

use jd_safe_sector_all_countries.dta, clear

keep if country=="ITALY" & year==2014

gen LogLabourProductivity=log(rva_mean/l_mean)

twoway (kdensity LogLabourProductivity if year==2014 & SAFE==0) ///
	(kdensity LogLabourProductivity if year==2014 & SAFE==1), ///
	legend(label(1 "Unconstrained firms") label(2 "Constrained firms")) ///
	title("Distributions of sectoral Labour Productivity (in logs)") subtitle("Italy in 2014") ///
	ytitle("") xtitle("")

*By export status
cd "<insert relevant directory for unconditional files>"

use jd_dummy_exp_sector_full_countries.dta, clear

keep if country=="ITALY" & year==2014

gen LogLabourProductivity=log(rva_mean/l_mean)

twoway (kdensity LogLabourProductivity if year==2014 & Dummy_exp==0) ///
	(kdensity LogLabourProductivity if year==2014 & Dummy_exp==1), ///
	legend(label(1 "Non exporters") label(2 "Exporters")) ///
	title("Distributions of sectoral Labour Productivity (in logs)") subtitle("Italy in 2014") ///
	ytitle("") xtitle("")
