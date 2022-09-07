/*

Solutions to TI SUmmer School PS on CompNet data - 2022 

*/

* Set up environment
global cd "C:\Users\a_zon\Dropbox\PHD VU\Teaching\TI Summer School"
global output = "$cd" + "\output"
global data = "$cd" + "\Data"

********************************************
* PS 2 - Market power *
********************************************

* Data preparation ------------------------------------------------------------

use "$data\unconditional_country_all_weighted.dta", clear

local var CE38_markup_l_0
*PV04_lnsr

keep country year `var'*

gen coverage = `var'_N/`var'_sw
sum coverage, de

keep if coverage >= 0.1 & `var'_p10!= . & `var'_p90!= .
drop if country == "ITALY"

* Descriptive analysis ---------------------------------------------------------

egen g_country = group(country)
xtset g_country year

gen neg_year = -year
sort country neg_year
by country: gen `var'_mn_first_year = `var'_mn[_N]
gen demeaned_`var'_mn = `var'_mn / `var'_mn_first_year

twoway (line demeaned_`var'_mn year)  ///
			, by(country, yrescale)  legend( label(1 "average markup"))    
graph export "$output\avg_mkp.pdf", replace
			
* Which industries display highest markups? ------------------------------------

use "$data\unconditional_mac_sector_all_weighted.dta", clear

* again, restrict to big enough sample size
local var CE38_markup_l_0
keep country mac_sector year `var'*

gen coverage = `var'_N/`var'_sw
sum coverage, de

keep if coverage >= 0.1 & `var'_p10!= . & `var'_p90!= .

* make sure we use a balanced panel
tab mac_sector year
drop if year < 2013 | year >2018

* winsorize top 1% per year
levelsof mac_sector, local(sectors)
foreach m of local sectors{
	qui sum `var'_mn if mac_sec == `m', de
	local p95 = r(p95)
	replace `var'_mn = `p95' if `var'_mn > `p95' & mac_sec == `m'
}
tab country

graph hbar (mean) weighted = `var'_mn [pweight = coverage], over(mac_sector)
graph export "$output\mac_sec_distr_mkp.pdf", replace

* Determinants of market power -------------------------------------------------
*(here you can basically play around, the one below is just an example)

use "$data\unconditional_industry2d_all_weighted.dta", clear

* again, restrict to big enough sample size
local var CE38_markup_l_0

gen coverage = `var'_N/`var'_sw
sum coverage, de

keep if coverage >= 0.1 

egen g_country = group(country)
gen log_LV21_l_mn = log(LV21_l_mn)

reg `var'_mn FR11_ifa_k_mn log_LV21_l_mn OV00_firm_age_mn TD14_exp_mn  i.year i.industry2d i.year [pweight=coverage]

* this one below shows too many covariates so no real result
reg `var'_mn CE38_markup_l_0_mn FR17_lc_m_mn FR24_rd_m_mn LR03_ulc_mn LV21_l_mn OV00_firm_age_mn TD14_exp_mn i.year i.industry2d i.year [pweight=coverage]

* Bonus - markups and intangibles ----------------------------------------------

use "$data\jd_prod_ifa_country_all_weighted.dta", clear

local var FR36_ifa_rev
keep country year by_var by_var_value `var'*
keep if by_var == "CE45_markup_m_1"

gen coverage = `var'_N/`var'_sw
sum coverage, de

keep if coverage >= 0.1 

* winsorize top 1% per decile
levelsof by_var_value, local(deciles)
foreach m of local sectors{
	qui sum `var'_mn if by_var_value == `m', de
	local p95 = r(p95)
	replace `var'_mn = `p95' if `var'_mn > `p95' & by_var_value == `m'
}

graph bar (mean) weighted = `var'_mn [pweight = coverage], over(by_var_value)
graph export "$output\jd_mkp_ifa.pdf", replace
