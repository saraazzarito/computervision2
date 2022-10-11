********************************************************************************
* TASK 4 - CHARTS FOR AGGREGATE ANALYSIS
********************************************************************************

* Windows
cd "C:\Users\jamesbond\Desktop\CompNet Data"

* Mac
*cd "/Users/jamesbond/Desktop/CompNet Data"


*****COUNTRY LEVEL, OVER TIME*****

use "unconditional_country_full_countries.dta", clear

*Credit

tw (con SAFE_mean year if country == "ITALY" & year>2004) ///
	(con SAFE_mean year if country == "FRANCE" & year>2004, ///
	graphregion(color(white))), legend(label(1 "Italy") ///
	label(2 "France")) xtitle("") ytitle("") ///
	title(Share of credit constrained firms)
	
*Employment
	
gen jdr_country_mean_neg=-jdr_country_mean

tw (con jcr_country_mean year if country == "ITALY" & year>2004) ///
	(con jdr_country_mean_neg year if country == "ITALY" & year>2004) ///
	(con jcr_country_mean year if country == "FRANCE" & year>2004) ///
	(con jdr_country_mean_neg year if country == "FRANCE" & year>2004, ///
	graphregion(color(white))), legend(label(1 "Job creation, Italy") ///
	label(2 "Job destruction, Italy") label(3 "Job creation, France") ///
	label(4 "Job destruction, France")) xtitle("") ytitle("") ///
	title(Job creation & job destruction)
	
*Productivity
	
gen lprod_wm=rva_mean/l_mean	// aggregate values as weighted mean of ratios
 
tw (con lprod_wm year if country == "ITALY" & year>2004) ///
	(con lprod_wm year if country == "FRANCE" & year>2004, ///
	graphregion(color(white))), legend(label(1 "Italy") ///
	label(2 "France")) xtitle("") ytitle("") ///
	title(Labour productivity)
	
	
*****MAC-SECTOR, 2014*****

use "unconditional_mac_sector_full_countries.dta", clear

drop if country!="ITALY" & country!="FRANCE"
keep if year==2014

gen mac_sector="Manufacturing" if mac==1
replace mac_sector="Construction" if mac==2
replace mac_sector="Wholesale & retail trade" if mac==3
replace mac_sector="Transportation" if mac==4
replace mac_sector="Accommodation & food" if mac==5
replace mac_sector="ICT" if mac==6
replace mac_sector="Real estate" if mac==7
replace mac_sector="Professional activities" if mac==8
replace mac_sector="Administration activities" if mac==9

*Credit

graph bar SAFE_mean, over(mac_sector, lab(angle(65))) ///
	by(country, graphregion(color(white)) ///
	title(Share of credit constrained firms by macro-sector)) ///
	ytitle("")
	
*Concentration
	
graph bar top_mac_mean, over(mac_sector, lab(angle(65))) ///
	by(country, graphregion(color(white)) ///
	title("Market share of the top 10 firms by macro-sector")) ///
	ytitle("")

*Employment

gen jdr_mac_mean_neg=-jdr_mac_mean

graph bar jcr_mac_mean jdr_mac_mean_neg, over(mac_sector, lab(angle(65))) ///
	by(country, legend(off) graphregion(color(white)) ///
	title("Job creation & job destruction by macro-sector")) ///
	ytitle("")
	
*Productivity
	
gen lprod_wm=rva_mean/l_mean	// aggregate values as weighted mean of ratios
 
graph bar lprod_wm, over(mac_sector, lab(angle(65))) ///
	by(country, graphregion(color(white)) ///
	title("Labour productivity by macro-sector")) ///
	ytitle("")
	

*****2-digit SECTORAL DATA: SCATTER PLOTS

use "unconditional_sector_full_countries.dta", clear

gen LogLabourProductivity=log(rva_mean/l_mean)
gen LogLabourCost=log(lc_mean/l_mean)
gen LogCapitalIntensity=log(rk_mean/l_mean)

scatter LogLabourCost LogLabourProductivity, ///
title(Labour cost & productivity (data in logs)) ///
subtitle(Full sample of countries and years) ///
ytitle(Sectoral labour cost) xtitle(Sectoral labour productivity) ///
graphregion(color(white))

drop if country!="ITALY" & country!="FRANCE"
drop if year<2004

scatter LogLabourCost LogLabourProductivity, by(country, ///
title("Labour cost and productivity (data in logs)") subtitle("2004-2014") ///
graphregion(color(white))) ytitle(Sectoral labour cost) xtitle(Sectoral labour productivity)



*****Need for parametric indicators

keep if mac==1

scatter LogLabourProductivity LogCapitalIntensity, by(country, ///
title("Labour productivity and capital intensity (data in logs)") subtitle("2004-2014") ///
graphregion(color(white))) ytitle(Sectoral labour productivity) xtitle(Sectoral capital intensity)



*****There is no representative firm

use "unconditional_mac_sector_full_countries.dta", clear

drop if country!="ITALY" & country!="FRANCE"
drop if year<2004
keep if mac==1

gen lprod_wm=rva_mean/l_mean

tw (con lprod_wm year) (con lprod_mean year) (con lprod_p50 year) ///
	(con lprod_p75 year), by(country, graphregion(color(white)) title(Labour productivity)) ///
	legend(label(1 "Weighted mean") label(2 "Arithmetic mean") label(3 "Median") ///
	label(4 "p75")) ytitle("") ytitle("")
