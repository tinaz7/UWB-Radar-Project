rm(list=ls())
library(data.table)
library(dplyr)
library(nlme)
require(multcomp)
library(lattice)
library(emmeans)

#### Find file
setwd("C:/Users/zheng/OneDrive/Desktop/ENGG7291 Data/Condition Significance")
ex <- fread('ComparisonParameters.csv') #this is all data

ex$PID <- as.factor(ex$PID)
ex$COND <- as.factor(ex$COND)
ex$Incline <- as.factor(ex$Incline)
ex$Speed <- as.factor(ex$Speed)
ex$Assistance <- as.factor(ex$Assistance)
str(ex)

## Mean and SD for all parameters
# Ankle Joint Torque ----------------------------------------------------------

aggregate(ex$TL_Avg,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$TL_Avg,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$TL_Peak,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$TL_Peak,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

# Fascicle Kinematics ---------------------------------------------------------

aggregate(ex$FL_Avg,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$FL_Avg,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$FL_Diff,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$FL_Diff,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$FA_Avg,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$FL_Avg,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$FA_Diff,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$FA_Diff,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$FV_Peak,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$FV_Peak,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$FV_Peak2,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$FV_Peak2,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

# Peak Activations ------------------------------------------------------------
aggregate(ex$MG_Peak,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$MG_Peak,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$LG_Peak,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$LG_Peak,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$SOL_Peak,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$SOL_Peak,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$TA_Peak,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$TA_Peak,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

# Average Activations ---------------------------------------------------------

aggregate(ex$MG_Avg,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$MG_Avg,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$LG_Avg,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$LG_Avg,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$SOL_Avg,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$SOL_Avg,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

aggregate(ex$TA_Avg,by=list(Speed=ex$Speed),FUN=mean, na.rm=TRUE)
sds<-aggregate(ex$TA_Avg,by=list(Speed=ex$Speed),FUN=sd, na.rm=TRUE)
sds

### LME models s to check significance ----------------------------------------
## Checking for interactions
m1 = lme(TL_Avg ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(TL_Peak ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)

m1 = lme(FL_Avg ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(FL_Diff ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(FA_Avg ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(FA_Diff ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(FV_Peak ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(FV_Peak2 ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)

m1 = lme(MG_Avg ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(MG_Peak ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(LG_Avg ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(LG_Peak ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(SOL_Avg ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(SOL_Peak ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(TA_Avg ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
m1 = lme(TA_Peak ~ Incline * Assistance * Speed, random = ~1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m1)
# None of the above relationships revealed significant interaction effects
# between conditions, thus, interaction effects were removed

## Checking main effects
m2 = lme(TL_Avg ~ Incline + Assistance + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Assistance), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(TL_Peak ~ Incline + Assistance + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Assistance), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(FL_Avg ~ Incline + Assistance, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Speed was insignificant (p = 0.1555) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Assistance), "pairwise")

m2 = lme(FL_Diff ~ Incline + Assistance, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Speed was insignificant (p = 0.0513) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Assistance), "pairwise")

m2 = lme(FA_Avg ~ Incline, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Assistance and Speed were insignificant (p >= 0.3363) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")

m2 = lme(FA_Diff ~ Incline + Assistance + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Assistance and Speed were insignificant (p >= 0.2233) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")

m2 = lme(FV_Peak ~ Assistance + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Incline was insignificant (p = 0.6651) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Assistance), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(FV_Peak2 ~ Incline + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Assistance was insignificant (p = 0.1368) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(MG_Avg ~ Incline + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Assistance was insignificant (p = 0.4594) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(MG_Peak ~ Incline + Assistance + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Assistance was insignificant (p = 0.5064) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(LG_Avg ~ Incline + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Assistance was insignificant (p = 0.0676) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(LG_Peak ~ Incline + Assistance + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Assistance), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(SOL_Avg ~ Incline + Assistance + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Assistance), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(SOL_Peak ~ Incline + Assistance + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Assistance), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(TA_Avg ~ Incline + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Assistance was insignificant (p = 0.4525) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")

m2 = lme(TA_Peak ~ Incline + Speed, random = ~ 1|PID, data=ex, method ='ML', na.action = "na.omit")
# Assistance was insignificant (p = 0.7522) and therefore removed
anova(m2)
contrast(emmeans(m2, ~ Incline), "pairwise")
contrast(emmeans(m2, ~ Speed), "pairwise")
