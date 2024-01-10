
# Before starting ---------------------------------------------------------

# lavaan stands for LAtent VAriable ANalysis

# If you know Mplus, remember the following tips about the commands:

# | Mplus command   |  lavaan command   |                 meaning                      |
# |-----------------|-------------------|----------------------------------------------|
# |    by           |       =~          | latent variable composed by                  |
# |    on           |        ~          | regressed on                                 |
# |    with         |       ~~          | (co)variance                                 |
# |    []           |       ~1          | intercept or mean                            |
# |    @1           |       1*          | fixed to be 1 (but you can change the value) |
# |    *            |       NA*         | frees parameter                              |
# |    (a)          |       a*          | label 'a' (but you can change the label)     |
  

# See also https://stats.oarc.ucla.edu/r/seminars/rsem/ -> "Quick reference of lavaan syntax"




# Preamble ----------------------------------------------------------------

rm(list = ls())    # clean your environment (or use a specific R project)

install.packages(c("lavaan",
                   "psych",
                   "dplyr",
                   "semPlot"),
                 dependencies = T) # just once

library(lavaan)  # load lavaan
library(psych)   # package useful for the "describe" function
library(dplyr)   # package useful for the "glimpse" function (but I suggest you to see the whole tidyverse ecosystem for data wrangling)
library(semPlot) # package useful for the "semPaths" function



# A CFA example -----------------------------------------------------------


# for more info, see https://lavaan.ugent.be/tutorial/cfa.html


## Step 0: Preliminary checks ---------------------------------------------

?HolzingerSwineford1939           # the HolzingerSwineford1939 dataset
                                  #  is included in lavaan
glimpse(HolzingerSwineford1939)
describe(HolzingerSwineford1939)


## Step 1: Model Formulation ----------------------------------------------

HS.model <- ' visual  =~ x1 + x2 + x3 
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '


## Step 2: Model Estimation -----------------------------------------------

fit <- cfa(HS.model,
           data = HolzingerSwineford1939)


## Step 3: Display output -------------------------------------------------

summary(fit,
        fit.measures = TRUE,
        rsquare=TRUE,
        standardized = TRUE) # remember that standardized parameters
                             #   are under `Std.all` column


## Step 4 (optional): Visualize Modification Indices ----------------------

modindices(fit,
           sort = TRUE,
           maximum.number = 5)


## Step 5 (optional): Visualize your SEM ----------------------------------

# For a paper, I suggest to do it on your own in Power Point, in particular
#  if the model is particularly complex

semPaths(fit,
         whatLabels = "std",
         sizeLat = 10,
         nCharNodes = 7)




# A SEM example -----------------------------------------------------------  


# for more info, see https://lavaan.ugent.be/tutorial/sem.html

## Step 0: Preliminary checks ---------------------------------------------

?PoliticalDemocracy   # the PoliticalDemocracy dataset is included in lavaan
glimpse(PoliticalDemocracy)
describe(PoliticalDemocracy)


## Step 1: Model Formulation ----------------------------------------------

model_sem <- '
  # measurement model
    ind60 =~ x1 + x2 + x3
    dem60 =~ y1 + y2 + y3 + y4
    dem65 =~ y5 + y6 + y7 + y8
    
  # regressions (structural model)
    dem60 ~ ind60
    dem65 ~ ind60 + dem60
    
  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'

## Step 2: Model Estimation -----------------------------------------------

fit_sem <- sem(model_sem,
               data = PoliticalDemocracy)


## Step 3: Display output -------------------------------------------------

summary(fit_sem,
        fit.measures = TRUE,
        rsquare=TRUE,
        standardized = TRUE) # remember that standardized parameters
                             #   are under `Std.all` column


## Step 4 (optional): Visualize Modification Indices ----------------------

modindices(fit_sem,
           sort = TRUE,
           maximum.number = 5)


## Step 5 (optional): Visualize your SEM ----------------------------------

semPaths(fit_sem,
         whatLabels = "std",
         sizeLat = 10,
         nCharNodes = 7)


# Save Workspace ----------------------------------------------------------

# This syntax allows you to save your workspace in a .RData (or .rda) file,
#  so that you can load all the objects and functions you have created.
#  Remember that you can specify the path in which to store this file, and you
#  can load the workspace with the syntax `load("./sem.RData")`

save.image("./sem.RData")
