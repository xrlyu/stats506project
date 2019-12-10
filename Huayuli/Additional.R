## Additional Analysis
## Some extra graphs

## load the packages
library(lme4)
library(data.table)
library(foreign)
library(MASS)
library(car)
library(ggplot2)
library(gridExtra)

## set the working directory
setwd("/Users/lihuayu/Documents/UMich-New Start/506/Project")

## Read the cleaned data; after reading, we remove the seqn variable, 
## and set gender and race as factor variables
Data=fread('Final.csv')
DT=Data[,.(gender=as.factor(gender),age,race=as.factor(race),intake_fat,intake_chol,
           systolic,diastolic,ldl,triglycerides,weight,height,bmi)]


## Some regression models in the former file
L2=lm(sqrt(ldl)~.,data=DT)
L3=step(L2,direction='backward')
L4=lm(sqrt(ldl)~gender+age+race+intake_fat+intake_chol+systolic+diastolic+
        weight+height+bmi+triglycerides+I(triglycerides^2)+I(age^2),data=DT)
L5=step(L4,direction='backward')

## Graph 1: Some Diagnosis upon these models
### F1: Checking error assumptions--residual plots
R1=data.table(fitted_values=L2$fitted.values,residuals=L2$residuals)
R2=data.table(fitted_values=L3$fitted.values,residuals=L3$residuals)
R3=data.table(fitted_values=L4$fitted.values,residuals=L4$residuals)
R4=data.table(fitted_values=L5$fitted.values,residuals=L5$residuals)
rs1=ggplot(R1,aes(x=fitted_values,y=residuals))+geom_point(size=1,colour='blue')+
  labs(title='Model 1')
rs2=ggplot(R2,aes(x=fitted_values,y=residuals))+geom_point(size=1,colour='blue')+
  labs(title='Model 2')
rs3=ggplot(R3,aes(x=fitted_values,y=residuals))+geom_point(size=1,colour='blue')+
  labs(title='Model 3')
rs4=ggplot(R4,aes(x=fitted_values,y=residuals))+geom_point(size=1,colour='blue')+
  labs(title='Model 4') 
grid.arrange(rs1,rs2,rs3,rs4,nrow=2)
  
## Graph 2: QQ-plots of the models
par(mfrow=c(2,2))
qqnorm(R1$residuals, ylab="Residuals",main='Q-Q Plot of Model 1')
qqline(R1$residuals)
qqnorm(R2$residuals, ylab="Residuals",main='Q-Q Plot of Model 2')
qqline(R2$residuals)
qqnorm(R3$residuals, ylab="Residuals",main='Q-Q Plot of Model 3')
qqline(R3$residuals)
qqnorm(R4$residuals, ylab="Residuals",main='Q-Q Plot of Model 4')
qqline(R4$residuals)

## Graph 3: Partial Residual Plots upon Model 3 and 4
crPlots(L4,layout=c(5,3))
crPlots(L5)

## Graph 4: Relationships between ldl and gender/race.  We have the mean level of
## ldl between different gender and race (For CI, we will use the JackKnife 
## standard error.)
Mean_JK = function(x){
  lx=length(x)
  MX=matrix(rep(x,rep(lx-1,lx)),ncol=lx,byrow=TRUE)
  theta=colMeans(MX)
  mean_theta=mean(theta)
  std_theta={(lx-1)/lx*sum((theta-mean_theta)^2)}^(1/2)
  std_theta
}

Gend=DT[,.(gender,ldl)]
Race=DT[,.(race,ldl)]
MG=Gend[,.(mean_ldl=mean(ldl),l_ldl=mean(ldl)+qnorm(0.025)*Mean_JK(ldl),
           r_ldl=mean(ldl)+qnorm(0.975)*Mean_JK(ldl)),by=gender]
MR=Race[,.(mean_ldl=mean(ldl),l_ldl=mean(ldl)+qnorm(0.025)*Mean_JK(ldl),
           r_ldl=mean(ldl)+qnorm(0.975)*Mean_JK(ldl)),by=race]

gend=ggplot(Gend,aes(x=gender,y=ldl))+geom_point(size=1,colour='blue')+
  labs(title='ldl~gender')
race=ggplot(Race,aes(x=race,y=ldl))+geom_point(size=1,colour='blue')+
  labs(title='ldl~race') 
mean_gend=ggplot(MG,aes(x=gender,y=mean_ldl))+geom_point(shape=16,col='red')+
  geom_segment(data=MG,mapping=aes(x=gender,xend=gender,y=l_ldl,yend=r_ldl),
               col='blue')+
  labs(title = 'Mean level of ldl between genders')
mean_race=ggplot(MR,aes(x=race,y=mean_ldl))+geom_point(shape=16,col='red')+
  geom_segment(data=MR,mapping=aes(x=race,xend=race,y=l_ldl,yend=r_ldl),
               col='blue')+
  labs(title = 'Mean level of ldl between races')

grid.arrange(gend,race,mean_gend,mean_race,nrow=2)  











