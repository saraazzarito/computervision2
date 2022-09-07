/*

Solutions to TI SUmmer School PS on CompNet data - 2022 

*/

* Set up environment
global cd "C:\Users\a_zon\Dropbox\PHD VU\Teaching\TI Summer School"
global output = "$cd" + "\output"
global data = "$cd" + "\Data"

********************************************
* PS 1 - Productivity growth and dispersion*
********************************************

* Data preparation ------------------------------------------------------------

use "$data\unconditional_country_all_weighted.dta", clear

local var PV02_lnlprod_rev
*PV04_lnsr

keep country year `var'*

gen coverage = `var'_N/`var'_sw
sum coverage, de

keep if coverage >= 0.1 & `var'_p10!= . & `var'_p90!= .

* Descriptive analysis ---------------------------------------------------------

egen g_country = group(country)
xtset g_country year

gen neg_year = -year
sort country neg_year
by country: gen `var'_p10_first_year = `var'_p10[_N]
gen demeaned_`var'_p10 = `var'_p10 / `var'_p10_first_year
by country: gen `var'_p90_first_year = `var'_p90[_N]
gen demeaned_`var'_p90 = `var'_p90 / `var'_p90_first_year
		
*tsline `var'_p90 `var'_p10, by(country)
twoway (line demeaned_`var'_p10 year) (line demeaned_`var'_p90 year)  ///
			, by(country, yrescale)  legend(rows(2) label(1 "productivity bottom 10% percentile (SR)")   label(2 "productivity top 10% percentile (SR)")   ) 
graph export "$output\disp_prod.pdf", replace
			
* Which industries display fastest prodctivity growth? -------------------------

use "$data\unconditional_mac_sector_all_weighted.dta", clear

* again, restrict to big enough sample size
local var PV02G1_lnlprod_rev
keep country mac_sector year `var'*

gen coverage = `var'_N/`var'_sw
sum coverage, de

keep if coverage >= 0.1 & `var'_p10!= . & `var'_p90!= .

* make sure we use a balanced panel
tab mac_sector year
drop if year < 2013 | year >2018

* winsorize top and bottom 1% per year
levelsof mac_sector, local(sectors)
foreach m of local sectors{
	qui sum `var'_mn if mac_sec == `m', de
	local p95 = r(p95)
	local p5 = r(p5)
	replace `var'_mn = `p95' if `var'_mn > `p95' & mac_sec == `m'
	replace `var'_mn = `p5' if `var'_mn < `p5' & mac_sec == `m'
}
tab country

graph hbar (mean) weighted = `var'_mn [pweight = coverage], over(mac_sector) 
graph export "$output\mac_sec_growth_prod.pdf", replace


* Determinants of productivity growth ------------------------------------------
*(here you can basically play around, the one below is just an example)

use "$data\unconditional_industry2d_all_weighted.dta", clear

* again, restrict to big enough sample size
local var PV02_lnlprod_rev

gen coverage = `var'_N/`var'_sw
sum coverage, de

keep if coverage >= 0.1 

egen g_country = group(country)
gen log_LV21_l_mn = log(LV21_l_mn)

reg `var'_mn LR03_ulc_mn FV25_invest_intan_mn LV21_l_mn OV00_firm_age_mn TD14_exp_mn i.year i.industry2d i.year [pweight=coverage]

* this one below shows too many covariates so no real result
reg `var'_mn CE38_markup_l_0_mn FR17_lc_m_mn FR24_rd_m_mn LR03_ulc_mn LV21_l_mn OV00_firm_age_mn TD14_exp_mn i.year i.industry2d i.year [pweight=coverage]

* Bonus - productivity and intangibles -----------------------------------------

use "$data\jd_inp_fin_country_all_weighted.dta", clear

local var PV03_lnlprod_va 
keep country year by_var by_var_value `var'*
keep if by_var == "FV31_rinvest_intan"

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
graph export "$output\jd_prod_ifa.pdf", replace
