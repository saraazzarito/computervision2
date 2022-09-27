cd "C:\Users\berna\OneDrive - London School of Economics\Dati CompNet\Full sample\Descriptives"

use unconditional_sector_full_countries.dta, clear

***** Univariate regression

gen LogLabourCost=log(lc_mean/l_mean)
gen LogLabourProductivity=log(rva_mean/l_mean)

*OLS

xi: reg LogLabourCost LogLabourProductivity

*OLS with FE

xi: reg LogLabourCost LogLabourProductivity i.sec i.country i.year

*Exporting results in a Word file

outreg2 using univariate.doc, addtext(Country FE, YES, Sector FE, YES, Year FE, YES) drop(_I*) word replace

*Scatter plot with fitted line

twoway ///
(scatter LogLabourCost LogLabourProductivity) ///
(lfitci LogLabourCost LogLabourProductivity, ciplot(rline)), ///
title(Labour cost and productivity) subtitle(Each dot is a country-sector-year observation) ///
ytitle(Sectoral labour cost) xtitle(Sectoral labour productivity) ///
graphregion(color(white))

*Adding the p-value to show significance of the relation

xi: reg LogLabourCost LogLabourProductivity

local t=_b[LogLabourProductivity]/_se[LogLabourProductivity]
local p=round(2*ttail(e(df_r),abs(`t')),0.01)

twoway ///
(scatter LogLabourCost LogLabourProductivity) ///
(lfitci LogLabourCost LogLabourProductivity, ciplot(rline)), ///
title(Labour cost and productivity) subtitle(Each dot is a country-sector-year observation) ///
ytitle(Sectoral labour cost) xtitle(Sectoral labour productivity) ///
graphregion(color(white)) note(p-value=`p')

***** Multivariate regression

use unconditional_sector_full_countries.dta, clear

gen Productivity=log(rva_mean/l_mean)
gen CapitalIntensity=log(rk_mean/l_mean)
gen HumanCapital=log(lc_mean/l_mean)
gen CreditAccess=1-SAFE_mean
gen Concentration=hhi_rev_nom_sec_mean

merge 1:1 country sector year using prod_decomp_sectorop_full_countries.dta
drop _merge
gen Allocation=OP_lnlprod

xi: reg Productivity CapitalIntensity HumanCapital CreditAccess Concentration  ///
Allocation i.year i.country i.sec

*Exporting results in a Word file

outreg2 using multivariate.doc, addtext(Country FE, YES, Sector FE, YES, Year FE, YES) drop(_I*) word replace

*Visual representation of the estimated coefficients and confidence intervals

coefplot, drop(_*) vertical graphregion(color(white)) ///
title("Estimated coefficients and confidence intervals") ///
subtitle("Dep. var.: Labour productivity")

*Using the coefficients to build a contribution chart at country-level

xi: reg Productivity CapitalIntensity HumanCapital CreditAccess Concentration Allocation

local var CapitalIntensity HumanCapital CreditAccess Concentration Allocation

foreach v of local var {
local b_`v'=_b[`v']
}

use unconditional_country_full_countries.dta, clear
merge 1:1 country year using prod_decomp_countryop_full_countries.dta
drop _merge

gen CapitalIntensity=`b_CapitalIntensity'*log(rk_mean/l_mean)
gen HumanCapital=`b_HumanCapital'*log(lc_mean/l_mean)
gen CreditAccess=`b_CreditAccess'*(1-SAFE_mean)
gen Concentration=`b_Concentration'*hhi_rev_nom_country_mean
gen Allocation=`b_Allocation'*OP_lnlprod

graph bar CapitalIntensity HumanCapital CreditAccess Concentration Allocation ///
if year==2014, over(country, label(angle(45))) stack per graphregion(color(white)) ///
nolabel title("Drivers of Labour Productivity, 2014") ///
ytitle("") subtitle("Based on regressions estimated at sectoral level")

graph bar CapitalIntensity HumanCapital CreditAccess Concentration Allocation ///
if country=="ITALY", over(year, label(angle(45))) stack per graphregion(color(white)) ///
nolabel title("Drivers of Labour Productivity, Italy") ///
ytitle("") nofill subtitle("Based on regressions estimated at sectoral level")
