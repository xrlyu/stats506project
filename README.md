# STATS 506 Project -- Group 4

The goal of this project is to explore factors that can affect the level of LDL in a human body, and the result is intended to help readers gain insights on how to balance the level of LDL in order to control/prevent cardiovascular diseases. It is shown that age, weight, height, BMI, systolic and diastolic blood pressures, and the level of triglyceride are all factors that can explain the variation in the level of LDL. 

## Outline

Here is our outline for this project:

(1) Data cleaning: choosing proper variables, merging datasets, reshaping the datasets, and deleting missing values

(2) Core analysis: building up multiple linear regression models, and then performing variable transformation and model selection techniques

(3) Additional analysis: creating additional plots for model interpretations and using quantile regressions for inference

## Group member & their technique tools

(1)**Xiru Lyu:**  Stata & quantile regression (`ldl~triglycerides`)

(2)**Huayu Li:**  R (data.table) and plotting (as well as linear mixed model)

(3)**Kai Liu:**  Python & quantile regression (`ldl~age`)

## Important files description

### Huayu Li

`Cleaning.R`, `Analyzing.R`, `Additional.R`  : Coding files of R.

`Boxcox.png`, `Partial.png`, `Residual_plot.png`: Some graphs for knitting Rmarkdown.

### Xiru Lyu

`Cleaning.do`, `Model.do`: Coding files of Stata

`*.dta`: Some data files during the process of running `Cleaning.do`

`Results/*.png`: Some plotting results running `*.do` for knitting Rmarkdown

`Cleaning.R`, `Quantile.R`: Files for creating the quantile regression plot

### Kai Liu

`*.ipynb`: Coding files of Python

`*.html`: Running results of Python

`failed picture in R markdown/*.png`: Some graphs for knitting Rmarkdown

### Other files

`Group4_project.Rmd`: Final Rmd file for project.

`Group4_project.html`: The submitting html file.



