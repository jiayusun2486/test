log using jiayu_sun_final, text

**q4
use approval.dta

di (3/4)*(78^(1/3))
newey approve lrgasprice lcpifood lsp500 sep11 iraqinvade, lag(4)

prais approve lrgasprice lcpifood lsp500 sep11 iraqinvade, vce(robust)

reg approve lrgasprice lcpifood lsp500 sep11 iraqinvade, vce(robust)
predict r, resi
reg r L(1/1)r


prais approve L(0/4)lrgasprice lcpifood lsp500 sep11 iraqinvade, vce(robust)
lincom lrgasprice+L1.lrgasprice+L2.lrgasprice+L3.lrgasprice+L4.lrgasprice

clear

**q5 fsize
use 401ksubs.dta

keep if fsize==1

reg p401k e401k inc age agesq male pira

reg nettfa p401k inc age agesq male pira

ivregress 2sls nettfa  inc age agesq male pira (p401k=e401k)
estat endog

qui reg nettfa p401k inc age agesq male pira
estimate store b_ols_1
qui ivregress 2sls nettfa  inc age agesq male pira (p401k=e401k)
estimate store b_2sls_1
hausman b_2sls_1 b_ols_1

egen incmean=mean(inc)
gen incdm=inc-incmean

egen agemean=mean(age)
gen agedm=age-agemean

gen p401k_incdm=p401k*incdm
gen p401k_agedm=p401k*agedm
gen e401k_incdm=e401k*incdm
gen e401k_agedm=e401k*agedm

reg nettfa p401k p401k_incdm p401k_agedm inc age  agesq male pira
ivregress 2sls nettfa  inc age agesq male pira (p401k p401k_incdm p401k_agedm=e401k e401k_incdm e401k_agedm)

qui reg nettfa p401k p401k_incdm p401k_agedm inc age  agesq male pira
estimate store b_ols_2
qui ivregress 2sls nettfa  inc age agesq male pira (p401k p401k_incdm p401k_agedm=e401k e401k_incdm e401k_agedm)
estimate store b_2sls_2
hausman b_2sls_2 b_ols_2

gen e401k_male=e401k*male
gen e401k_pira=e401k*pira
ivregress 2sls nettfa  inc age agesq male pira (p401k p401k_incdm p401k_agedm=e401k e401k_incdm e401k_agedm e401k_male e401k_pira),vce(robust)
ivregress gmm nettfa  inc age agesq male pira (p401k p401k_incdm p401k_agedm=e401k e401k_incdm e401k_agedm e401k_male e401k_pira),wmat(robust)
estat overid

