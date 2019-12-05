* model fitting
use "./Xiru Lyu/Data/final.dta", clear

* transform the dependent variable
gen ldl2 = sqrt(ldl)

* multiple linear regression
regress ldl2 age i.race i.gender bmi weight height di sy chol fat trig

* backward selection
xi: stepwise, pr(.1): regress ldl2 age i.race i.gender bmi weight height di ///
sy chol fat trig

* forward selection
xi: stepwise, pe(.1): regress ldl2 age i.race i.gender bmi weight height di ///
sy chol fat trig

* add another transformation to the independent variable 
gen trig2 = trig^2
gen age2 = age^2

* multiple linear regression
regress ldl2 age age2 i.race i.gender bmi weight height di sy chol fat trig trig2

* backward selection
xi: stepwise, pr(.05): regress ldl2 age age2 i.race i.gender bmi weight  ///
height di sy chol fat trig trig2

* forward selection
xi: stepwise, pe(.05): regress ldl2 age age2 i.race i.gender bmi weight ///
height di sy chol fat trig trig2

* mixed model
mixed ldl2 age height weight bmi fat chol sy di trig || gender: || race:, reml
