// STATS 506, FALL 2019
//
// Cleaning.do
//
// This file contains codes for cleaning datasets.
//
// Author: Xiru Lyu, xlyu@umich.edu
//
// Last Updated: Dec 11, 2019


* import demographic data
import sasxport "./Original Data/DEMO_I.XPT.txt", clear

* rename variables
rename riagendr gender
rename ridageyr age
rename ridreth3 race

* select variables of focus
keep seqn gender age race

* save the cleaned demographics data
save "./Xiru Lyu/Data/demo.dta", replace

* import diet (day 1) data
import sasxport "./Original Data/DR1TOT_I.XPT.txt", clear

* rename variables
rename dr1ttfat fat1
rename dr1tchol chol1

* select variables of interest
keep seqn fat1 chol1

* save the cleaned diet (day 1) dataset
save "./Xiru Lyu/Data/diet1.dta", replace

* import diet (day 2) data
import sasxport "./Original Data/DR2TOT_I.XPT.txt", clear

* rename variables
rename dr2ttfat fat2
rename dr2tchol chol2

* select variables of focus
keep seqn fat2 chol2

* save the cleaned diet (day 2) dataset
save "./Xiru Lyu/Data/diet2.dta", replace

* import LDL & triglyceride data
import sasxport "./Original Data/TRIGLY_I.XPT.txt", clear

* rename variables
rename lbdldl ldl
rename lbxtr triglyceride

* select variables of interest
keep seqn ldl trig

* save the cleaned cholesterol dataset
save "./Xiru Lyu/Data/ldl.dta", replace

* import blood pressure data
import sasxport "./Original Data/BPX_I.XPT.txt", clear

* rename variables
rename bpxsy1 sy1
rename bpxsy2 sy2
rename bpxsy3 sy3
rename bpxsy4 sy4
rename bpxdi1 di1
rename bpxdi2 di2
rename bpxdi3 di3
rename bpxdi4 di4

* compute averaged systolic and diastolic blood pressure for each participant
egen systolic = rowmean(sy1 sy2 sy3 sy4)
egen diastolic = rowmean(di1 di2 di3 di4)

* select variables of interest
keep seqn systolic diastolic

* save the cleaned blood pressure dataset
save "./Xiru Lyu/Data/bp.dta", replace

* import body measure data
import sasxport "./Original Data/BMX_I.XPT.txt", clear

* rename variables
rename bmxwt weight
rename bmxbmi bmi
rename bmxht height

* select variables of interest
keep seqn weight height bmi

* merge datasets by seqn
merge 1:1 seqn using "./Xiru Lyu/Data/demo.dta"
keep if _merge == 3
drop _merge
merge 1:1 seqn using "./Xiru Lyu/Data/diet1.dta"
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

* compute averaged intakes of fat and cholesterol
egen fat = rowmean(fat1 fat2)
egen chol = rowmean(chol1 chol2)

* drop extra columns
drop fat1 fat2 chol1 chol2

* drop rows with missing values
foreach var of varlist age bmi chol diastolic fat gender height ldl race ///
seqn systolic triglyceride weight{
drop if missing(`var')
}

* save the dataset for data analysis
save "./Xiru Lyu/Data/final.dta", replace
