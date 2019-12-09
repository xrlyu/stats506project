* import the data
use "./Xiru Lyu/Data/final.dta", clear

// Core analysis

* transform the dependent variable
generate ldl2 = sqrt(ldl)

* fit a multiple linear regression model
regress ldl2 age i.race i.gender bmi weight height diastolic systolic chol ///
fat trig

* backward selection
xi: stepwise, pr(.1): regress ldl2 age i.race i.gender bmi weight height ///
diastolic systolic chol fat triglyceride

* forward selection
xi: stepwise, pe(.1): regress ldl2 age i.race i.gender bmi weight height ///
diastolic systolioc chol fat triglyceride

* transform covariates
generate triglyceride2 = triglyceride^2
generate age2 = age^2

* fit a multiple linear regression model
regress ldl2 age age2 i.race i.gender bmi weight height diastolic systolic ///
chol fat triglyceride triglyceride2

* backward selection
xi: stepwise, pr(.05): regress ldl2 age age2 i.race i.gender bmi weight  ///
height diastolic systolic chol fat triglyceride triglyceride2

* forward selection
xi: stepwise, pe(.05): regress ldl2 age age2 i.race i.gender bmi weight ///
height diastolic systolic chol fat triglyceride triglyceride2

* compare AIC & BIC of two nested models
regress ldl2 age height weight diastolic triglyceride
estat ic

regress ldl2 age age2 height weight bmi diastolic systolic triglyceride ///
triglyceride2
estat ic

// Additional Analysis

* quantile regression for triglyceride over multiple quantiles
qreg ldl2 triglyceride, quantile(0.05)
qreg ldl2 triglyceride, quantile(0.25)
qreg ldl2 triglyceride, quantile(0.5)
qreg ldl2 triglyceride, quantile(0.75)
qreg ldl2 triglyceride, quantile(0.90)
