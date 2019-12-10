### Using this file for regression.

## load the packages
library(lme4)
library(data.table)
library(foreign)
library(MASS)
library(car)

## set the working directory
setwd("/Users/lihuayu/Documents/UMich-New Start/506/Project")

## Read the cleaned data; after reading, we remove the seqn variable, 
## and set gender and race as factor variables
Data=fread('Final.csv')
DT=Data[,.(gender=as.factor(gender),age,race=as.factor(race),intake_fat,intake_chol,
         systolic,diastolic,ldl,triglycerides,weight,height,bmi)]

## First of all, we will fit the model with all variables, and then give 
## the residual plot of the model.
L1=lm(ldl~.,data=DT)
summary(L1)
plot(L1$fitted.values,L1$residuals)

## Here, it seems that some transformations should be used upon ldl. Here
## we do the Box-Cox test.
boxcox(L1,plotit=TRUE,lambda=seq(0,1,1/100))

## Here it seems that lambda=0.5 is the best choice, that is, to use sqrt(ldl).
## Here we make the transformation and then do the regression again.
L2=lm(sqrt(ldl)~.,data=DT)
summary(L2)

## There are too many variables in the regression model, so here we will do
## the model selection and choose the variables. Here we do both the forward
## and backward selections.
L3=step(L2,direction='both')
summary(L3)

## By the way, in the models before, we didn't consider transformations 
## upon predictors; in the coming part, we will consider adding some
## nonlinear terms.
crPlots(L2,layout=c(4,3))

## From the partial residual plots, we can find out that for triglycerides and age,
## some nonlinear transformation forms should be add. We add this term, and the
## regression result is as following:
L4=lm(sqrt(ldl)~gender+age+race+intake_fat+intake_chol+systolic+diastolic+
             weight+height+bmi+triglycerides+I(triglycerides^2)+I(age^2),data=DT)
summary(L4)

## Just the same, do the model selection.
L5=step(L4,direction='both')
summary(L5)


## By the way, we will have the linear mixed model upon the dataset:
LM=lmer(ldl~age+intake_fat+intake_chol+systolic+diastolic+
          weight+height+bmi+triglycerides+(1|gender)+(1|race),data=DT)
summary(LM)












