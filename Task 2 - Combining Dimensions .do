********************************************************************************
* TASK 2 - COMBINING DIMENSIONS 
********************************************************************************

// In this do-file, we show how to retrieve and display information with a double 
// level of aggregation. Indeed, CompNet offers information at the 
// country/macrosector/sector level that can be further disaggregated by credit 
// constraint, size class,  export status, productivity level, etc.
// For further details, please refer to the slides/user guide. 

// The structure of the do-file is as follow:
// 	1) Graphs by joint distributions (deciles)	
// 	2) Graphs by joint distributions (dummies)
// 	3) Graphs by joint distributions (extra dimension)
// 	4) Graphs by joint distributions (exporters)

// JOINT DISTRIBUTION FILES
// NOTE that in this do-file we will often use the joint distribution datasets.
// These include information on a distribution of indicator conditional on another 
// distribution. For example, you can find the distribution of markups for firms
// that are credit constrained and the same for non-credit constrained firms. Or
// the distribution of balance sheet information for the most productive firms as
// well as for the least productive ones.
// From a technical perspective, this means that there is a further identifier
// for each cell in the data in addition to the normal country/sector/year data.
// It is indeed the decile of the distribution you are conditioning on.
// For example, the file jd_lnlprod_country_20e_countries includes the variable
// ct_lnlprod which indicates to which decile of the labour productivity distribution 
// the raw refers to. For further details, please refer to the slides/user guide. 



// 1) Graphs by joint distributions (deciles)

* In this section we explore the median number of employees, median labour cost 
* over employment and median capital intensity labour cost for firms ranked according
* to their labour productivity and their respective level of capital intensity. 
* Of course, this is just an example and both the variable of interest 
* (labour costs - lc_p50, capital intensity - rk_l_p50) and the distribution to 
* condition on (labour productivity - lnlprod) can be changed with any other of 
* the information available in the database

// 1.1) Country level
cd "<insert relevant directory for joint distributions files>"

use jd_lnlprod_country_20e_countries.dta, clear

graph hbar l_p50 if country == "FRANCE", over(ct_lnlprod, descending) ///
	title(Employment over Labour Productivity Deciles) subtitle(France) ///
	ytitle(Median Number of Employees) l1title(Deciles of Labour Productivity)

graph hbar lc_l_p50 if country == "FRANCE", over(ct_lnlprod, descending) ///
	title(Labour Cost over Labour Productivity Deciles) subtitle(France) ///
	ytitle(Median Labour Cost over Employment) l1title(Deciles of Labour Productivity)
	
graph hbar rk_l_p50 if country == "FRANCE", over(ct_lnlprod, descending) ///
	title(Capital Intensity over Labour Productivity Deciles) subtitle(France) ///
	ytitle(Median Capital Intensity) l1title(Deciles of Labour Productivity)
	
	
// 1.2) Macrosector level
use jd_lnlprod_mac_sector_20e_countries.dta, clear

graph hbar l_p50 if country == "FRANCE" & mac == 1, over(ct_lnlprod, descending) ///
	title(Employment over Labour Productivity Deciles) subtitle(France - Manufacturing) ///
	ytitle(Median Number of Employees) l1title(Deciles of Labour Productivity)

graph hbar lc_l_p50 if country == "FRANCE" & mac == 1, over(ct_lnlprod, descending) ///
	title(Labour Cost over Labour Productivity Deciles) subtitle(France - Manufacturing) ///
	ytitle(Median Labour Costs over Employment) l1title(Deciles of Labour Productivity)	
	
graph hbar rk_l_p50 if country == "FRANCE" & mac == 1, over(ct_lnlprod, descending) ///
	title(Capital Intensity over Labour Productivity Deciles) subtitle(France - Manufacturing) ///
	ytitle(Median Capital Intensity) l1title(Deciles of Labour Productivity)
	
	
// 1.3) Macrosector and sizeclass level
use jd_lnlprod_macsec_szcl_20e_countries.dta, clear

* here information on macrosectors and size classes are embedded in a string variable
* so we need first to transform this information in numveric values
split macsec_szcl, parse(_) destring gen(var)
drop macsec_szcl var1 var2 var3
rename var4 sizeclass
order mac sizeclass, after(year) 

gen l_p50_small = l_p50 if sizeclass == 3
gen l_p50_medium = l_p50 if sizeclass == 4
gen l_p50_large = l_p50 if sizeclass == 5

gen lc_l_p50_small = lc_l_p50 if sizeclass == 3
gen lc_l_p50_medium = lc_l_p50 if sizeclass == 4
gen lc_l_p50_large = lc_l_p50 if sizeclass == 5

gen rk_l_p50_small = rk_l_p50 if sizeclass == 3
gen rk_l_p50_medium = rk_l_p50 if sizeclass == 4
gen rk_l_p50_large = rk_l_p50 if sizeclass == 5

graph hbar l_p50_small l_p50_medium l_p50_large if country == "FRANCE" & mac == 1, ///
	over(ct_lnlprod, descending) legend(label(1 Small) label(2 Medium) label(3 Large) rows(1)) ///
	title(Employment over Labour Productivity Deciles) subtitle(France - Manufacturing) ///
	ytitle(Median Number of Employees) l1title(Deciles of Labour Productivity)

graph hbar lc_l_p50_small lc_l_p50_medium lc_l_p50_large if country == "FRANCE" & mac == 1, ///
	over(ct_lnlprod, descending) legend(label(1 Small) label(2 Medium) label(3 Large) rows(1)) ///
	title(Labour Cost over Labour Productivity Deciles) subtitle(France - Manufacturing) ///
	ytitle(Median Labour Costs over Employment) l1title(Deciles of Labour Productivity)

graph hbar rk_l_p50_small rk_l_p50_medium rk_l_p50_large if country == "FRANCE" & ///
	mac == 1, over(ct_lnlprod, descending) legend(label(1 Small) label(2 Medium) ///
	label(3 Large) rows(1)) title(Capital Intensity over Labour Productivity Deciles) ///
	subtitle(France - Manufacturing) ytitle(Median Capital Intensity)  ///
	l1title(Deciles of Labour Productivity)
	

	
// 1.4) Sector level
use jd_lnlprod_sector_20e_countries.dta, clear

graph hbar l_p50 if country == "FRANCE" & sector == 10, over(ct_lnlprod, descending) ///
	title(Employment over Labour Productivity Deciles) ///
	subtitle(France - Manufacturing of Food Product) ///
	ytitle(Median Number of Employees) l1title(Deciles of Labour Productivity)

graph hbar lc_l_p50 if country == "FRANCE" & sector == 10, over(ct_lnlprod, descending) ///
	title(Labour Cost over Labour Productivity Deciles) ///
	subtitle(France - Manufacturing of Food Product) ///
	ytitle(Median Labour Costs over Employment) l1title(Deciles of Labour Productivity)

graph hbar rk_l_p50 if country == "FRANCE" & sector == 10, over(ct_lnlprod, descending) ///
	title(Capital Intensity over Labour Productivity Deciles) ///
	subtitle(France - Manufacturing of Food Product) ///
	ytitle(Median Capital Intensity) l1title(Deciles of Labour Productivity)
	
	
********************************************************************************
// 2) Graphs by joint distributions (dummy)	

* In this section we explore the median capital intensity and TFPfor firms according
* to their access to the credit market. Of course, this is just an example and both the 
* variable of interest (e.g. capital intensity - rk_l_p50) and the distribution to condition 
* on (credit constraints - SAFE) can be changed with any other of the 
* information available in the database

// 2.1) Country level
cd "<insert relevant directory for joint distributions files>"

use jd_safe_country_20e_countries.dta, clear

label define status 0 "Unconstrained" 1 "Constrained"
label values SAFE status

graph hbar rk_l_p50 if country == "FRANCE", over(SAFE, descending) ///
	title(Capitaly Intensity vs Access to Credit) subtitle(France) ///
	ytitle(Median Capital Intensity) 

graph hbar tfp_va_secCD_p50 if country == "FRANCE", over(SAFE, descending) ///
	title(TFP vs Access to Credit) subtitle(France) ///
	ytitle(Median TFP) 
	
	
	
// 2.2) Macrosector level
use jd_safe_mac_sector_20e_countries.dta, clear

label define status 0 "Unconstrained" 1 "Constrained"
label values SAFE status

graph hbar rk_l_p50 if country == "FRANCE" & mac ==1, over(SAFE, descending) ///
	title(Capitaly Intensity vs Access to Credit) subtitle(France - Manufacturing) ///
	ytitle(Median Capital Intensity)

graph hbar tfp_va_secCD_p50 if country == "FRANCE" & mac ==1, over(SAFE, descending) ///
	title(TFP vs Access to Credit) subtitle(France) ///
	ytitle(Median TFP) 
	
	
// 2.3) Macrosector and sizeclass level
use jd_safe_macsec_szcl_20e_countries.dta, clear

label define status 0 "Unconstrained" 1 "Constrained"
label values SAFE status

* here information on macrosectors and size classes are embedded in a string variable
* so we need first to transform this information in numveric values
split macsec_szcl, parse(_) destring gen(var)
drop macsec_szcl var1 var2 var3
rename var4 sizeclass
order mac sizeclass, after(year) 

gen rk_l_p50_small = rk_l_p50 if sizeclass == 3
gen rk_l_p50_medium = rk_l_p50 if sizeclass == 4
gen rk_l_p50_large = rk_l_p50 if sizeclass == 5

gen tfp_p50_small = tfp_va_secCD_p50 if sizeclass == 3
gen tfp_p50_medium = tfp_va_secCD_p50 if sizeclass == 4
gen tfp_p50_large = tfp_va_secCD_p50 if sizeclass == 5


graph hbar rk_l_p50_small rk_l_p50_medium rk_l_p50_large if country == "FRANCE" & mac == 1, ///
	over(SAFE, descending) legend(label(1 Small) label(2 Medium) label(3 Large) rows(1)) ///
	title(Capitaly Intensity vs Access to Credit) subtitle(France - Manufacturing) ///
	ytitle(Median Capital Intensity) 

graph hbar tfp_p50_small tfp_p50_medium tfp_p50_large if country == "FRANCE" & mac == 1, ///
	over(SAFE, descending) legend(label(1 Small) label(2 Medium) label(3 Large) rows(1)) ///
	title(TFP vs Access to Credit) subtitle(France - Manufacturing) ///
	ytitle(Median TFP) 
	
	
// 2.4) Sector level
use jd_safe_sector_20e_countries.dta, clear

label define status 0 "Unconstrained" 1 "Constrained"
label values SAFE status

graph hbar rk_l_p50 if country == "FRANCE" & sector == 10, over(SAFE, descending) ///
	title(Capitaly Intensity vs Access to Credit) ///
	subtitle(France - Manufacturing of Food Product) ///
	ytitle(Median Capital Intensity) 

graph hbar tfp_va_secCD_p50 if country == "FRANCE" & sector == 10, over(SAFE, descending) ///
	title(TFP vs Access to Credit) subtitle(France - Manufacturing of Food Product) ///
	ytitle(Median TFP) 
	

// 3) Graphs by joint distributions (extra dimension)	

* In this section we explore the median labour cost for firms ranked according
* to their labour productivity. With respect to previous sections, we add the
* variation over time or sector as an example of further disaggreagtion of the
* data. Examples are provided only at country and sectoral level, however they 
* can be extended over other dimensions following the guidelines of the previous
* sections.

// 3.1) Time dimension
cd "<insert relevant directory for joint distributions files>"

use jd_lnlprod_country_20e_countries.dta, clear

* in order to produce these graphs, we need to change the structure of the data.
* Before proceeding, we are restricting the focus only on selected years to
* have a more clear exposition. The following steps are not strictly necessary and
* can be performed using preserve/restore.

keep if year == 2008 | year == 2013
keep country year ct_lnlprod lc_l_p50
reshape wide lc_l_p50, i(country ct_lnlprod) j(year) 

graph hbar lc_l_p502008 lc_l_p502013 if country == "FRANCE", over(ct_lnlprod, descending) ///
	title(Labour Cost over Labour Productivity Deciles) subtitle(France) ///
	ytitle(Median Labour Costs over Employment) l1title(Deciles of Labour Productivity) ///
	legend(label(1 2008) label(2 2013))

// 3.2) Sectoral dimension
use jd_lnlprod_mac_sector_20e_countries.dta, clear

* in order to produce these graphs, we need to change the structure of the data.
* Before proceeding, we are restricting the focus only on selected sectors to
* have a more clear exposition. The following steps are not strictly necessary and
* can be performed using preserve/restore.

keep if mac == 1 | mac == 2 | mac == 3
keep country year mac ct_lnlprod lc_l_p50
reshape wide lc_l_p50, i(country year ct_lnlprod) j(mac) 

graph hbar lc_l_p501 lc_l_p502 lc_l_p503 if country == "FRANCE", over(ct_lnlprod, descending) ///
	title(Labour Cost over Labour Productivity Deciles) subtitle(France) ///
	ytitle(Median Labour Costs) l1title(Deciles of Labour Productivity) ///
	legend(label(1 Manufacturing) label(2 Construction) label(3 Wholesale) rows(1))
	
	
// 4) Graphs by joint distributions (dummies)	

* In this section we explore the median labour productivity, share of credit 
* constrained firms and median real value added for firms according
* to their exporting status. Of course, this is just an example and both the 
* variable of interest (e.g. labour productivity - lprod_p50) and the distribution to condition 
* on (exporters - Dummy_exp) can be changed with any other of the information
* available in the database

// 4.1) Country level
cd "<insert relevant directory for joint distribution files in the trade section>"

use jd_dummy_exp_country_20e_countries.dta, clear

twoway (line lprod_p50 year if Dummy_exp == 1) (line lprod_p50 year if Dummy_exp == 0) ///
	if country == "FRANCE", title(Labour Productivity by Exporting Status) ///
	subtitle(France) ytitle(Median Labour Productivity) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))
	
twoway (line SAFE_mean year if Dummy_exp == 1) (line SAFE_mean year if Dummy_exp == 0) ///
	if country == "FRANCE", title(Access to Credit by Exporting Status) ///
	subtitle(France) ytitle(Share of Credit Constrained Firms) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))

twoway (line rva_p50 year if Dummy_exp == 1) (line rva_p50 year if Dummy_exp == 0) ///
	if country == "FRANCE", title(Real Value Added by Exporting Status) ///
	subtitle(France) ytitle(Median Real Value Added) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))
	
	
	
// 4.2) Macrosector level
use jd_dummy_exp_mac_sector_20e_countries.dta, clear
	
twoway (line lprod_p50 year if Dummy_exp == 1) (line lprod_p50 year if Dummy_exp == 0) ///
	if country == "ITALY" & mac == 1, title(Labour Productivity by Exporting Status) ///
	subtitle(Italy - Manufacturing) ytitle(Median Labour Productivity) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))
	
twoway (line SAFE_mean year if Dummy_exp == 1) (line SAFE_mean year if Dummy_exp == 0) ///
	if country == "ITALY" & mac == 1, title(Access to Credit by Exporting Status) ///
	subtitle(Italy - Manufacturing) ytitle(Share of Credit Constrained Firms) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))

twoway (line rva_p50 year if Dummy_exp == 1) (line rva_p50 year if Dummy_exp == 0) ///
	if country == "ITALY" & mac == 1, title(Real Value Added by Exporting Status) ///
	subtitle(Italy - Manufacturing) ytitle(Median Real Value Added) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))
		
	
	
// 4.3) Macrosector and sizeclass level
use jd_dummy_exp_macsec_szcl_20e_countries.dta, clear

* here information on macrosectors and size classes are embedded in a string variable
* so we need first to transform this information in numveric values
split macsec_szcl, parse(_) destring gen(var)
drop macsec_szcl var1 var2 var3
rename var4 sizeclass
order mac sizeclass, after(year) 

gen lprod_p50_small = lprod_p50 if sizeclass == 3
gen lprod_p50_medium = lprod_p50 if sizeclass == 4
gen lprod_p50_large = lprod_p50 if sizeclass == 5

// single size	
twoway (line lprod_p50_small year if Dummy_exp == 1) (line lprod_p50_small year if Dummy_exp == 0) ///
	if country == "FRANCE" & mac == 1, title(Labour Productivity by Exporting Status) ///
	subtitle(France - Small firms in manufacturing) ytitle(Median Labour Productivity) ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))
		
// all sizes	
twoway (line lprod_p50_small year if Dummy_exp == 1, lcolor(blue)) ///
	(line lprod_p50_small year if Dummy_exp == 0, lcolor(blue) lpattern(dash)) ///
	(line lprod_p50_medium year if Dummy_exp == 1, lcolor(red)) ///
	(line lprod_p50_medium year if Dummy_exp == 0, lcolor(red) lpattern(dash)) ///
	(line lprod_p50_large year if Dummy_exp == 1, lcolor(green)) ///
	(line lprod_p50_large year if Dummy_exp == 0, lcolor(green) lpattern(dash)) ///
	if country == "FRANCE" & mac == 1, title(Labour Productivity by Exporting Status) ///
	subtitle(France - Manufacturing) ytitle(Median Labour Productivity) xtitle() ///
	legend(label(1 "Small - Exporters") label(2 "Small - Non-exporters") ///
	label(3 "Medium - Exporters") label(4 "Medium - Non-exporters") ///
	label(5 "Large - Exporters") label(6 "Large - Non-exporters"))	


	
// 4.4) Sector level
use jd_dummy_exp_sector_20e_countries.dta, clear

twoway (line lprod_p50 year if Dummy_exp == 1) (line lprod_p50 year if Dummy_exp == 0) ///
	if country == "FRANCE" & sector == 10, title(Labour Productivity by Exporting Status) ///
	subtitle(France - Manufacturing of Food Products) ytitle(Median Labour Productivity) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))
	
twoway (line SAFE_mean year if Dummy_exp == 1) (line SAFE_mean year if Dummy_exp == 0) ///
	if country == "FRANCE" & sector == 10, title(Access to Credit by Exporting Status) ///
	subtitle(France - Manufacturing of Food Products) ytitle(Share of Credit Constrained Firms) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))

twoway (line rva_p50 year if Dummy_exp == 1) (line rva_p50 year if Dummy_exp == 0) ///
	if country == "FRANCE" & sector == 10, title(Real Value Added by Exporting Status) ///
	subtitle(France - Manufacturing of Food Products) ytitle(Median Real Value Added) xtitle() ///
	legend(label(1 "Exporters") label(2 "Non-exporters"))

	
