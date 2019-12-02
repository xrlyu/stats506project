#### Data cleaning using data.table 

## Package setting
library(data.table)
library(foreign)
library(tidyverse) 

## Set the working directory
#setwd('/Users/lihuayu/Documents/UMich-New Start/506/Project')

## Read the datasets
demo=data.table(read.xport("DEMO_I.XPT.txt"))
tot1=data.table(read.xport("DR1TOT_I.XPT.txt"))
tot2=data.table(read.xport("DR2TOT_I.XPT.txt"))
b_pres=data.table(read.xport("BPX_I.XPT.txt"))
ldl=data.table(read.xport("TRIGLY_I.XPT.txt"))
measure=data.table(read.xport("BMX_I.XPT.txt"))

## For each dataset, choose the proper variables and make 
## some transformation.

# For demo dataset, we choose seqn, gender, age and race variables
Demo=demo[,.(seqn=SEQN,gender=RIAGENDR,
             age=RIDAGEYR,race=RIDRETH3)]

# For dietary data, we choose seqn, intake fat, intake cholesterol
# for each day.
TOT1=tot1[,.(seqn=SEQN,intake_fat1=DR1TTFAT,
             intake_chol1=DR1TCHOL)]
TOT2=tot2[,.(seqn=SEQN,intake_fat2=DR2TTFAT,
             intake_chol2=DR2TCHOL)]

# For blood pressure, we choose seqn, systolic pressures and diastolic 
# pressures. We then use the average pressure as the final pressure.
pres_type=c(paste('sys',1:4,sep=''),paste('dia',1:4,sep=''))
B_pres=b_pres[,.(seqn=SEQN,sys1=BPXSY1,sys2=BPXSY2,sys3=BPXSY3,sys4=BPXSY4,
                 dia1=BPXDI1,dia2=BPXDI2,dia3=BPXDI3,dia4=BPXDI4)]
B_pres=melt(B_pres,measure=pres_type)[,
                                      .(seqn,type=factor(variable,pres_type,
                                                         c(rep('s',times=4),rep('d',times=4))),
                                        variable,pressure=value)
                                      ][
                                        ,.(pres=mean(pressure,na.rm=TRUE)),by=.(seqn,type)
                                        ]
B_pres=dcast(B_pres,...~type,value.var=c('pres'))[
  ,.(seqn,systolic=s,diastolic=d)
  ]

# For ldl dataset, we choose seqn, LDL-cholesterol and Triglyceride
# for mg/dL.
LDL=ldl[,.(seqn=SEQN,ldl=LBDLDL,triglycerides=LBXTR)]

# For body measure dataset, we choose weight height and bmi as our 
# variables.
Measure=measure[,.(seqn=SEQN,weight=BMXWT,height=BMXHT,bmi=BMXBMI)]


## Next we will use the average intake of the two days into
## our model. The average step is as following:

TOT=TOT1%>%merge(.,TOT2,by='seqn',all=FALSE)%>%
  .[,.(seqn,intake_fat=(intake_fat1+intake_fat2)/2,
       intake_chol=(intake_chol1+intake_chol2)/2)]

## Now merge the datasets into one whole, with the seqn as
## the merging label. By the way, some seqn labels 
## should be removed, for they are not included in LDL dataset.

Data=Demo%>%merge(.,TOT,by='seqn',all=FALSE)%>%
  merge(.,B_pres,by='seqn',all=FALSE)%>%
  merge(.,LDL,by='seqn',all=FALSE)%>%
  merge(.,Measure,by='seqn',all=FALSE)%>%
  na.omit()

## Now save the cleaned data
fwrite(Data,file='Final.csv')









