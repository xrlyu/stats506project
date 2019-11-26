* import demographic data
import sasxport "./Original Data/DEMO_I.XPT.txt", clear

rename riagendr gender
rename ridageyr age
rename ridreth3 race

keep seqn gender age race

save "./Xiru Lyu/Data/demo.dta", replace

* import diet data
import sasxport "./Original Data/DR1TOT_I.XPT.txt", clear

rename dr1ttfat fat
rename dr1tchol chol
generate day = 1

keep seqn fat chol day

save "./Xiru Lyu/Data/diet1.dta", replace

import sasxport "./Original Data/DR2TOT_I.XPT.txt", clear

rename dr2ttfat fat
rename dr2tchol chol
generate day = 2

keep seqn fat chol day

save "./Xiru Lyu/Data/diet2.dta", replace

* import LDL & triglycerides data
import sasxport "./Original Data/TRIGLY_I.XPT.txt", clear

rename lbdldl ldl
rename lbxtr trig

keep seqn ldl trig

save "./Xiru Lyu/Data/ldl.dta", replace

* import blood pressure data
import sasxport "./Original Data/BPX_I.XPT.txt", clear

rename bpxsy1 sy1
rename bpxsy2 sy2
rename bpxsy3 sy3
rename bpxsy4 sy4
rename bpxdi1 di1
rename bpxdi2 di2
rename bpxdi3 di3
rename bpxdi4 di4

egen sy = rowmean(sy1 sy2 sy3 sy4)
egen di = rowmean(di1 di2 di3 di4)

keep seqn sy di

save "./Xiru Lyu/Data/bp.dta", replace

* import body measure data
import sasxport "./Original Data/BMX_I.XPT.txt", clear

rename bmxwt weight
rename bmxbmi bmi
rename bmxht height

keep seqn weight height bmi

save "./Xiru Lyu/Data/bm.dta", replace

preserve

// merge datasets
merge 1:1 seqn using "./Xiru Lyu/Data/demo.dta"

keep if _merge == 3
drop _merge

merge 1:1 seqn using "./Xiru Lyu/Data/diet1.dta"

keep if _merge == 3
drop _merge

merge 1:1 seqn using "./Xiru Lyu/Data/bp.dta"

keep if _merge == 3
drop _merge

merge 1:1 seqn using "./Xiru Lyu/Data/ldl.dta"

keep if _merge == 3
drop _merge

save "./Xiru Lyu/Data/day1.dta", replace



use "./Xiru Lyu/Data/bm.dta", clear

merge 1:1 seqn using "./Xiru Lyu/Data/demo.dta"

keep if _merge == 3
drop _merge

merge 1:1 seqn using "./Xiru Lyu/Data/diet2.dta"

keep if _merge == 3
drop _merge

merge 1:1 seqn using "./Xiru Lyu/Data/bp.dta"

keep if _merge == 3
drop _merge

merge 1:1 seqn using "./Xiru Lyu/Data/ldl.dta"

keep if _merge == 3
drop _merge

append using "./Xiru Lyu/Data/day1.dta"

foreach var of varlist age bmi chol day di fat gender height ldl race seqn ///
sy trig weight{
drop if missing(`var')
}

save "./Xiru Lyu/Data/final.dta", replace
