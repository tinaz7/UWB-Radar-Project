rm(list=ls())
library(data.table)
library(dplyr)
library(nlme)
require(multcomp)
library(lattice)
library(emmeans)

#### first, we need to make sure R can find the data file
setwd("C:/Users/zheng/OneDrive/Desktop/ENGG7291 Data/Condition Significance")

#### fread is the function to read data into R using data.table
ex <- fread('R2 Results_CrossParticipant.csv')
ex <- fread('R2 Results_ParticipantSpecific.csv')

#### lets check we've read the data in properly
head(ex)
str(ex)

#need to tag as numbers and factors
ex$PID <- as.factor(ex$PID)
ex$COND <- as.factor(ex$COND)
ex$Incline <- as.factor(ex$Incline)
ex$Speed <- as.factor(ex$Speed)
ex$Assistance <- as.factor(ex$Assistance)

####double check that they are now factors (need to understand if they are factors or numbers)
str(ex)

# LMEs ------------------------------------------------------------------------
## Participant Specific
m1 = lme(Rsq ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
emm <- emmeans(m1, ~ Assistance | Incline)
plot(emm)
pairs(emm)

## Cross Participant
m1 = lme(Rsq ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
# No significant interaction effects
m1 = lme(Rsq ~ Incline + Assistance + Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
# Only Incline is significant
m1 = lme(Rsq ~ Incline, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
contrast(emmeans(m1, ~ Incline), "pairwise")
