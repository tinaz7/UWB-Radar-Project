# UWB-Radar-Project
This repository contains the main scripts used within my thesis. Since much of the working was completed manually and with many different filetypes and file locations, the code in this repository is not intended for use, but rather as a point of reference. This has been separated into three folders:

**Aim 1: Decoupling of musculoskeletal variables**
- *ConditionComparison.m*: Comparison of musculoskeletal responses from all participant data shown in Figure 20-22 of the thesis
- *ConditionSignificanceScript.R*: Statistical analysis completed for comparisons between conditions in Sections 5.1.1.1- 5.1.1.3
    - *Condition Parameters.csv* contains the biomechanical parameters that were found
    - *note:* for fascicle strain rate, peak = minimum during stance and peak2 = maximum during swing
- *Decoupling.m*: LM and LME models applied to obtain the decoupling behaviour shown in Figure 23 and 24 of the thesis

**Aim 2: Frequency-dependent effects of musculoskeletal variables**
- *EffectSizeScript.m*: LME models developed for the effects of each musculoskeletal variable on each frequency of each S-parameter component. This script can be edited (instructions included) to choose between modelling with fascicle strain or fascicle pennation. This script was also used to create Figures 25-27 of the thesis

**Aim 3: Validation of UWB radar-based estimation of ankle torque**
- *CoactivationComparison.m*: Computation of the coactivation indices and LME models to compare coactivation with the estimation error
    - Resulting coactivation indices and estimation errors can be found in *CoactivationVsPerformanceValues.csv*
- *ConditionPerformanceScript.R*: Statistical analysis completed for determining the effect of condition on the R2 performance
    - *R2 Results_ParticipantSpecific.csv* and *R2 Results_CrossParticipant.csv* contain the resulting R2 and NRMSE values and their corresponding condition on which this script was run
- *TrainingTesting_CrossParticpant_RawTorque.m*: Cross-participant LME models developed for estimation of ankle torque from the UWB radar data, as well as the comparisons between estimated and measured results shown in Figure 31 of the thesis
- *TrainingTesting_ParticipantSpecific.m*: Participant-specific LME models developed for estimation of ankle torque from the UWB radar data, as well as the comparisons between estimated and measured results shown in Figure 30 of the thesis

**Notes:**
- For all scripts, a common notation was used, where FL = fascicle strain, FA = fascicle pennation, FV = fascicle strain rate, TL = torque of the left ankle, TR = torque of the right ankle, and MG, LG, SOL, and TA the EMG values of the respective muscles.
- Gait Cycle Segmentation scripts were also included to show the data processing performed on each dataset to achieve the gait cycle-averaged results for each musculoskeletal response and UWB radar response
