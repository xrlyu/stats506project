# STATS 506, FALL 2019
#
# Quantile.R
#
# This file contains quantile regression results and the quantile regression plot.
#
# Author: Xiru Lyu, xlyu@umich.edu
#
# Last Updated: Dec 11, 2019

# Load required packages
library(quantreg)
library(tidyverse)
library(ggplot2)

# Import the dataset
data <- readRDS("./Xiru Lyu/Cleaning/final.rds")

# Set quantiles
tau <- c(0.05, 0.25, 0.5, .75, 0.9)

# Fit quantile regression with different quantiles
fit1 <- rq(sqrt(ldl) ~ trig, tau = tau[1], data = data)
fit2 <- rq(sqrt(ldl) ~ trig, tau = tau[2], data = data)
fit3 <- rq(sqrt(ldl) ~ trig, tau = tau[3], data = data)
fit4 <- rq(sqrt(ldl) ~ trig, tau = tau[4], data = data)
fit5 <- rq(sqrt(ldl) ~ trig, tau = tau[5], data = data)

data2 <- data %>% select(ldl, trig) %>%
  mutate(ldl2 = sqrt(ldl))

# Graph the quantile regression plot
ggplot() + 
  geom_point(data = data2, aes(x = trig, y = ldl2), color = "grey39") +
  geom_abline(aes(intercept = fit1$coefficients[1], slope = fit1$coefficients[2],
              color = "0.05")) +
  geom_abline(aes(intercept = fit2$coefficients[1], slope = fit2$coefficients[2],
              color = "0.25")) +
  geom_abline(aes(intercept = fit3$coefficients[1], slope = fit3$coefficients[2],
              color = "0.50")) +
  geom_abline(aes(intercept = fit4$coefficients[1], slope = fit4$coefficients[2],
              color = "0.75")) +
  geom_abline(aes(intercept = fit5$coefficients[1], slope = fit5$coefficients[2],
              color = "0.90")) +
  labs(color = "Quantile",
       x = "triglyceride", y = "sqrt(ldl)") +
  theme_bw()
