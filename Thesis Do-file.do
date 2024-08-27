
*Import data from excel
import excel "C:\Users\Awa Gaye\Desktop\GMDATA.xlsx", sheet("Sheet1") firstrow

*Generate Country number for list of countries
egen countrynumber = group ( Countryname )

*Generate dummy Variable if a country like The Gambia belong to the ECOWAS
gen ECOWAS = 0
replace ECOWAS = 1 if countrynumber == 5
replace ECOWAS = 1 if countrynumber == 9
replace ECOWAS = 1 if countrynumber == 10
replace ECOWAS = 1 if countrynumber == 11
replace ECOWAS = 1 if countrynumber == 15
replace ECOWAS = 1 if countrynumber == 17
replace ECOWAS = 1 if countrynumber == 18
replace ECOWAS = 1 if countrynumber == 19

*Generate dummy variable for Language if a country like The Gambia speaks either English Fula Mandinka or Wollof
gen LANGUAGE = 0
replace LANGUAGE = 1 if countrynumber == 2
replace LANGUAGE = 1 if countrynumber == 4
replace LANGUAGE = 1 if countrynumber == 5
replace LANGUAGE = 1 if countrynumber == 9
replace LANGUAGE = 1 if countrynumber == 10
replace LANGUAGE = 1 if countrynumber == 11
replace LANGUAGE = 1 if countrynumber == 12
replace LANGUAGE = 1 if countrynumber == 15
replace LANGUAGE = 1 if countrynumber == 17
replace LANGUAGE = 1 if countrynumber == 18
replace LANGUAGE = 1 if countrynumber == 19
replace LANGUAGE = 1 if countrynumber == 20
replace LANGUAGE = 1 if countrynumber == 23
replace LANGUAGE = 1 if countrynumber == 24


*Generate dummy variable if a country belongs to the EU 
gen EU  = 0
replace EU = 1 if countrynumber == 1
replace EU = 1 if countrynumber == 6
replace EU = 1 if countrynumber == 7
replace EU = 1 if countrynumber == 8
replace EU = 1 if countrynumber == 13
replace EU = 1 if countrynumber == 16
replace EU = 1 if countrynumber == 21


*Summarize all the variables
summarize Trade_ij GDP_i GDP_j PCGDPD_ij Population_i Population_j RBER_ij Distance_ij ECOWAS LANGUAGE EU

*Destring all variables to be numeric
destring, replace

*Set as Panel data
xtset countrynumber YEAR, yearly

*Generate log variables
gen lnTrade_ij = log( Trade_ij)
gen lnGDP_i = log( GDP_i)
gen lnGDP_j = log( GDP_j)
gen lnPCGDPD_ij = log( PCGDPD_ij)
gen lnPopulation_i = log( Population_i)
gen lnPopulation_j = log( Population_j)
gen lnDistance_ij = log( Distance_ij)
gen lnRBER_ij = log( RBER_ij)

*Pool estimate
reg lnTrade_ij lnGDP_i lnGDP_j lnPCGDPD_ij lnPopulation_i lnPopulation_j lnDistance_ij lnRBER_ij ECOWAS LANGUAGE EU

*Random Effect estimate
xtreg lnTrade_ij lnGDP_i lnGDP_j lnPCGDPD_ij lnPopulation_i lnPopulation_j lnDistance_ij lnRBER_ij ECOWAS LANGUAGE EU, re

*Fixed Effect estimate
xtreg lnTrade_ij lnGDP_i lnGDP_j lnPCGDPD_ij lnPopulation_i lnPopulation_j lnDistance_ij lnRBER_ij ECOWAS LANGUAGE EU, fe

*Generate country specific effect
predict alphafehat, u

*regress country specific effects on fixed variables
reg alphafehat lnDistance_ij ECOWAS LANGUAGE EU

*Hausman test
quietly xtreg lnTrade_ij lnGDP_i lnGDP_j lnPCGDPD_ij lnPopulation_i lnPopulation_j lnDistance_ij lnRBER_ij ECOWAS LANGUAGE EU, fe
estimates store fixed
quietly xtreg lnTrade_ij lnGDP_i lnGDP_j lnPCGDPD_ij lnPopulation_i lnPopulation_j lnDistance_ij lnRBER_ij ECOWAS LANGUAGE EU, re
estimates store random
hausman fixed random

* Breusch-Pagan LM test
quietly xtreg lnTrade_ij lnGDP_i lnGDP_j lnPCGDPD_ij lnPopulation_i lnPopulation_j lnDistance_ij lnRBER_ij ECOWAS LANGUAGE EU, re
xttest0

*Multicollinearity
corr Trade_ij GDP_i GDP_j PCGDPD_ij Population_i Population_j RBER_ij Distance_ij ECOWAS LANGUAGE EU

* llc Unit root test with lag
xtset countrynumber YEAR
xtunitroot llc Trade_ij, lags(1)
xtunitroot llc d.Trade_ij, lags(1)
xtunitroot llc d.d.Trade_ij, lags(1)
xtset countrynumber YEAR
xtunitroot llc GDP_i, lags(1)
xtunitroot llc d.GDP_i, lags(1)
xtunitroot llc d.d.GDP_i, lags(1)
xtset countrynumber YEAR
xtunitroot llc GDP_j, lags(1)
xtunitroot llc d.GDP_j, lags(1)
xtunitroot llc d.d.GDP_j, lags(1)
xtset countrynumber YEAR
xtunitroot llc PCGDPD_ij, lags(1)
xtunitroot llc d.PCGDPD_ij, lags(1)
xtunitroot llc d.d.PCGDPD_ij, lags(1)
xtset countrynumber YEAR
xtunitroot llc Population_i, lags(1)
xtunitroot llc d.Population_i, lags(1)
xtunitroot llc d.d.Population_i, lags(1)
xtset countrynumber YEAR
xtunitroot llc Population_j, lags(1)
xtunitroot llc d.Population_j, lags(1)
xtunitroot llc d.d.Population_j, lags(1)
xtset countrynumber YEAR
xtunitroot llc RBER_ij, lags(1)
xtunitroot llc d.RBER_ij, lags(1)
xtunitroot llc d.d.RBER_ij, lags(1)
xtset countrynumber YEAR


*lps test with lag
xtset countrynumber YEAR
xtunitroot ips Trade_ij, lags(1)
xtunitroot ips d.Trade_ij, lags(1)
xtunitroot ips d.d.Trade_ij, lags(1)
xtset countrynumber YEAR
xtunitroot ips GDP_i, lags(1)
xtunitroot ips d.GDP_i, lags(1)
xtunitroot ips d.d.GDP_i, lags(1)
xtset countrynumber YEAR
xtunitroot ips GDP_j, lags(1)
xtunitroot ips d.GDP_j, lags(1)
xtunitroot ips d.d.GDP_j, lags(1)
xtset countrynumber YEAR
xtunitroot ips PCGDPD_ij, lags(1)
xtunitroot ips d.PCGDPD_ij, lags(1)
xtunitroot ips d.d.PCGDPD_ij, lags(1)
xtset countrynumber YEAR
xtunitroot ips Population_i, lags(1)
xtunitroot ips d.Population_i, lags(1)
xtunitroot ips d.d.Population_i, lags(1)
xtset countrynumber YEAR
xtunitroot ips Population_i, lags(1)
xtunitroot ips d.Population_i, lags(1)
xtunitroot ips d.d.Population_i, lags(1)
xtset countrynumber YEAR
xtunitroot ips Population_j, lags(1)
xtunitroot ips d.Population_j, lags(1)
xtunitroot ips d.d.Population_j, lags(1)
xtset countrynumber YEAR
xtunitroot ips RBER_ij, lags(1)
xtunitroot ips d.RBER_ij, lags(1)
xtunitroot ips d.d.RBER_ij, lags(1)

*llc with trend and lag
xtunitroot llc Trade_ij, trend lags(1)
xtunitroot llc d.Trade_ij, trend lags(1)
xtunitroot llc d.d.Trade_ij, trend lags(1)
xtset countrynumber YEAR
xtunitroot llc GDP_i, trend lags(1)
xtunitroot llc d.GDP_i, trend lags(1)
xtunitroot llc d.d.GDP_i, trend lags(1)
xtset countrynumber YEAR
xtunitroot llc GDP_j, trend lags(1)
xtunitroot llc d.GDP_j, trend lags(1)
xtunitroot llc d.d.GDP_j, trend lags(1)
xtset countrynumber YEAR
xtunitroot llc PCGDPD_ij, trend lags(1)
xtunitroot llc d.PCGDPD_ij, trend lags(1)
xtunitroot llc d.d.PCGDPD_ij, trend lags(1)
xtset countrynumber YEAR
xtunitroot llc Population_i, trend lags(1)
xtunitroot llc d.Population_i, trend lags(1)
xtunitroot llc d.d.Population_i, trend lags(1)
xtset countrynumber YEAR
xtunitroot llc Population_j, trend lags(1)
xtunitroot llc d.Population_j, trend lags(1)
xtunitroot llc d.d.Population_j, trend lags(1)
xtset countrynumber YEAR
xtunitroot llc RBER_ij, trend lags(1)
xtunitroot llc d.RBER_ij, trend lags(1)
xtunitroot llc d.d.RBER_ij, trend lags(1)


*ips with trend and lag
xtset countrynumber YEAR
xtunitroot ips Trade_ij, trend lags(1)
xtunitroot ips d.Trade_ij, trend lags(1)
xtunitroot ips d.d.Trade_ij, trend lags(1)
xtset countrynumber YEAR
xtunitroot ips GDP_i, trend lags(1)
xtunitroot ips d.GDP_i, trend lags(1)
xtunitroot ips d.d.GDP_i, trend lags(1)
xtset countrynumber YEAR
xtunitroot ips GDP_j, trend lags(1)
xtunitroot ips d.GDP_j, trend lags(1)
xtunitroot ips d.d.GDP_j, trend lags(1)
xtset countrynumber YEAR
xtunitroot ips PCGDPD_ij, trend lags(1)
xtunitroot ips d.PCGDPD_ij, trend lags(1)
xtunitroot ips d.d.PCGDPD_ij, trend lags(1)
xtset countrynumber YEAR
xtunitroot ips Population_i, trend lags(1)
xtunitroot ips d.Population_i, trend lags(1)
xtunitroot ips d.d.Population_i, trend lags(1)
xtset countrynumber YEAR
xtunitroot ips Population_j, trend lags(1)
xtunitroot ips d.Population_j, trend lags(1)
xtunitroot ips d.d.Population_j, trend lags(1)
xtset countrynumber YEAR
xtunitroot ips RBER_ij, trend lags(1)
xtunitroot ips d.RBER_ij, trend lags(1)
xtunitroot ips d.d.RBER_ij, trend lags(1)



