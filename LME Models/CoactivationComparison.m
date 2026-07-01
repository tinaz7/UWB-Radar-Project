%% Coactivation and Estimation Error Comparison Script
% Section 1: Compute Coactivation Indices
%            - The coactivation index was computed between the MG and LG
%              across the gait cycle and averaged for a mean CI
% Section 2: Compute Significance
%            - Estimation error was loaded in from an external document, as
%              errors were computed individually for each participant from
%              participant-specific and cross-participant models in the
%              following scripts:
%              - TrainingTesting_ParticipantSpecific.m
%              - TrainingTesting_CrossParticipant_RawTorque.m
%% Section 1: Compute Coactivation Indices
filePath = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\Data Collection\Left Leg Average - US, EMG\S01";
files = dir(fullfile(filePath, "*.mat"));

CI = zeros(12*100, 1);

for i = 1:12
    file = load(fullfile(filePath, files(i).name));
    TA = file.ALL.ValDat.TA;
    MG = file.ALL.ValDat.MG;
    LG = file.ALL.ValDat.LG;

    num1 = min(LG, TA);
    den1 = 2 * max(min(LG,TA));

    num2 = min(MG, TA);
    den2 = 2 * max(min(MG,TA));

    CI((i-1)*100+1 : i*100) = num1(2:101) / den1 + num2(2:101) / den2;
end

%% Section 2: Compute Significance

error = readtable(fullfile("C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\Condition Significance", ...
                           "Coactivation Comparison.csv"), "FileType", "text");

PSline = fitlme(error, "DiffPS ~ CCINorm + (1|cID) + (-1 + CCINorm | cID)");
disp(PSline)

CPline = fitlme(error, "DiffCP ~ CCINorm + (1|cID) + (-1 + CCINorm | cID)");
disp(CPline)