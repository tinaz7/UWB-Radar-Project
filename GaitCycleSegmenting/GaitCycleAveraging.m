%% Gait Cycle Averaging script for EMG data, fascicle dynamics, and torques
% Section 1: Loading all file inputs and parameters
%            - Manually enter the PID, trial number, and condition number
%            - EMG MVC values and resting fascicle architecture values are
%              extracted from the Participant Summary file
% Section 2: Processes all EMG data by filtering, normalising, rectifying,
%            removing outliers, and gait cycle averaging
%            - Figure 1: Plot of all selected EMG responses from remaining
%              gait cycles after removing outliers
% Section 3: Processes all ultrasound data by filtering, normalising,
%            removing outliers, and gait cycle averaging
%            - Figure 2: Plot of all fascicle dynamics from remaining gait
%              cycles after removing outliers
% Section 4: Processes ankle torques from the left leg by normalising,
%            removing outliers, and gait cycle averaging
% Section 5: Processes all UWB radar data and ankle torques from the right
%            leg by removing the same outliers from both, and gait cycle 
%            averaging
%            - Figure 3: Plot of left and right leg ankle torques from
%              remaining gait cycles after removing outliers
% Section 6: Plots resulting mean response of all musculoskeletal
%            parameters and UWB radar data, and saves it to the destDir 
%            specified in Section 1
%            - Figure 4: Plot of all mean responses of variables with the
%              values of how they are saved
% Section 7: For one participant, the trials to be processed were saved
%            under two different trial numbers - this script accomodates 
%            that but must be commented out when not being used
%% Section 1: Inputs
clear
summary1 = readtable('Participant Data Summary Export.xlsx', 'Sheet', 'Data Collection', 'VariableNamingRule', 'preserve');
summary2 = readtable('Participant Data Summary Export.xlsx', 'Sheet', 'Normalising', 'VariableNamingRule', 'preserve');
destDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged\S" + PID;

n = "25"; % Trial number
PID = "03"; % PID
COND = "10"; % Condition number (1-10)

nMin = 10; % Number of gait cycles to keep
disp(n); disp(COND)
format long

idx = find(strcmp(summary2.PID, "S" + PID));
weight = summary2.Weight(idx);
% EMG MVCs - FROM OPTIMISED MSR VALUES
MVC_MG = summary2.MG_MVC(idx); MVC_LG = summary2.LG_MVC(idx);
MVC_SOL = summary2.SOL_MVC(idx); MVC_TA = summary2.TA_MVC(idx);
% Optimal fascicle length
opt_FL = summary2.FL_opt(idx); opt_FA = summary2.FA_opt(idx);
opt_FP = summary2.FP_opt(idx);

ik_fileLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\EXO_UWB\Data\ExoUWB_S" + PID + ...
    "\Scaling, IK, ID OUTPUT";
ik_fileName = "ExoUWB_S" + PID + "_Trial_00" + n + "_IK.mot";
ik_file = readtable(fullfile(ik_fileLoc, ik_fileName), "FileType","text");

id_fileName = "ExoUWB_S" + PID + "_Trial_00" + n + "_ID_Resampled.mot";
id_file = readtable(fullfile(ik_fileLoc, id_fileName), "FileType","text");

qtm_fileLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\EXO_UWB\Data\ExoUWB_S" + PID;
qtm_fileName = "ExoUWB_S" + PID + "_Trial_00" + n + ".mat";
qtm_file = load(fullfile(qtm_fileLoc, qtm_fileName));

us_fileLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\US\S" + PID;
us_fileName = "nn00" + n + "_tracked_Q=001.mat";
us_file = load(fullfile(us_fileLoc, us_fileName));

uwb_fileLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\UWB\S" + PID;
uwb_fileName = "RadarData_S" + PID + "_Trial_00" + n + ".mat";
uwb_file = load(fullfile(uwb_fileLoc, uwb_fileName));

times_ik = ik_file.time;
times_us = (0:4999)/125;
times_qtm = (0:49999)/1250;
times_emg = (0:79999)/2000;
full_time = 0:1:100;

[b_emg_lp, a_emg_lp] = butter(4, 10/(2000/2));
[b_emg_bp, a_emg_bp] = butter(4, [20/(2000/2), 400/(2000/2)]);
[b_us_lp, a_us_lp] = butter(4, 10/(125/2));
[b_grf_lp, a_grf_lp] = butter(6, 10/(1250/2));

fieldName = fields(qtm_file);

GRF_Left = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(1).Force(3,:));
GRF_Right = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(2).Force(3,:));

%% Section 2: EMG Processing

emg_labels = qtm_file.(fieldName{1}).Analog(2).Labels;
emg_data = qtm_file.(fieldName{1}).Analog(2).Data';

% Finding index of EMG Data in labels
TA_idx = find(cellfun(@(x)isequal(x,'TA'), emg_labels));
MG_idx = find(cellfun(@(x)isequal(x,'GM'), emg_labels));
LG_idx = find(cellfun(@(x)isequal(x,'GL'), emg_labels));
SOL_idx = find(cellfun(@(x)isequal(x,'SOL'), emg_labels));

% bandpassed 20-500Hz, then rectified, then low-pass filtered 12Hz
TA = emg_data(:, TA_idx);
TA_bp = filtfilt(b_emg_bp, a_emg_bp, TA);
TA_rect = abs(TA_bp);
TA_env = filtfilt(b_emg_lp, a_emg_lp, TA_rect);
TA_filtered = max(0,TA_env)/MVC_TA;

MG = emg_data(:,MG_idx);
MG_bp = filtfilt(b_emg_bp, a_emg_bp, MG);
MG_rect = abs(MG_bp);
MG_env = filtfilt(b_emg_lp, a_emg_lp, MG_rect);
MG_filtered = max(0,MG_env)/MVC_MG;

LG = emg_data(:,LG_idx);
LG_bp = filtfilt(b_emg_bp, a_emg_bp, LG);
LG_rect = abs(LG_bp);
LG_env = filtfilt(b_emg_lp, a_emg_lp, LG_rect);
LG_filtered = max(0,LG_env)/MVC_LG;

SOL = emg_data(:,SOL_idx);
SOL_bp = filtfilt(b_emg_bp, a_emg_bp, SOL);
SOL_rect = abs(SOL_bp);
SOL_env = filtfilt(b_emg_lp, a_emg_lp, SOL_rect);
SOL_filtered = max(0,SOL_env)/MVC_SOL;

% split gait cycles, removing outliers, and resampling to 0-100%
TA_split = GaitCycleSplit(GRF_Left, TA_filtered, times_emg, 100);
TA_splitClean = GaitCycleRemoveOutliers(TA_split, nMin);
TA_avg = interp1(1:1:100, mean(TA_splitClean, 2), full_time, "spline", "extrap")';

MG_split = GaitCycleSplit(GRF_Left, MG_filtered, times_emg, 100);
MG_splitClean = GaitCycleRemoveOutliers(MG_split, nMin);
MG_avg = interp1(1:1:100, mean(MG_splitClean, 2), full_time, "spline", "extrap")';

LG_split = GaitCycleSplit(GRF_Left, LG_filtered, times_emg, 100);
LG_splitClean = GaitCycleRemoveOutliers(LG_split, nMin);
LG_avg = interp1(1:1:100, mean(LG_splitClean, 2), full_time, "spline", "extrap")';

SOL_split = GaitCycleSplit(GRF_Left, SOL_filtered, times_emg, 100);
SOL_splitClean = GaitCycleRemoveOutliers(SOL_split, nMin);
SOL_avg = interp1(1:1:100, mean(SOL_splitClean, 2), full_time, "spline", "extrap")';

figure(1); clf
tiledlayout("flow")
nexttile; plot(TA_splitClean); title("TA, n=10")
nexttile; plot(MG_splitClean); title("MG, n=10")
nexttile; plot(LG_splitClean); title("LG, n=10")
nexttile; plot(SOL_splitClean); title("SOL, n=10")

%% Section 3: US Processing
FL = us_file.Fdat.Region.fas_length;
FA = us_file.Fdat.Region.fas_ang;
FP = us_file.Fdat.Region.fas_pen;
time = us_file.Fdat.Region.Time;

FL_filt = filtfilt(b_us_lp, a_us_lp, FL)/opt_FL;
FA_filt = filtfilt(b_us_lp, a_us_lp, FA) - opt_FA;
FP_filt = filtfilt(b_us_lp, a_us_lp, FP) - opt_FP;

FV_filt = diff(FL_filt) ./ diff(time);
FV_interp = interp1(0.5/125 + (0:4998)/125, FV_filt(:, 1), times_us, 'spline')';

FL_split = GaitCycleSplit(GRF_Left, FL_filt, times_us, 100);
FL_splitClean = GaitCycleRemoveOutliers(FL_split, nMin);
FL_avg = interp1(1:1:100, mean(FL_splitClean, 2), full_time, "spline", "extrap")';

FA_split = GaitCycleSplit(GRF_Left, FA_filt, times_us, 100);
FA_splitClean = GaitCycleRemoveOutliers(FA_split, nMin);
FA_avg = interp1(1:1:100, mean(FA_splitClean, 2), full_time, "spline", "extrap")';

FP_split = GaitCycleSplit(GRF_Left, FP_filt, times_us, 100);
FP_splitClean = GaitCycleRemoveOutliers(FP_split, nMin);
FP_avg = interp1(1:1:100, mean(FP_splitClean, 2), full_time, "spline", "extrap")';

FV_split = GaitCycleSplit(GRF_Left, FV_interp, times_us, 100);
FV_splitClean = GaitCycleRemoveOutliers(FV_split, nMin);
FV_avg = interp1(1:1:100, mean(FV_splitClean, 2), full_time, "spline", "extrap")';

figure(2); clf
tiledlayout("flow")
nexttile; plot(FL_splitClean); title("MG fascicle length, n=10")
nexttile; plot(FA_splitClean); title("MG fascicle angle, n=10")
nexttile; plot(FP_splitClean); title("MG fascicle pennation, n=10")
nexttile; plot(FV_splitClean); title("MG fascicle velocity, n=10")

%% Section 4: Ankle Joint Torque Processing

time = id_file{:, "time"};
ankle_r_moment = id_file{:, "ankle_angle_r_moment"} ./ weight;
ankle_l_moment = id_file{:, "ankle_angle_l_moment"} ./ weight;

ankle_l_moment_split = GaitCycleSplit(GRF_Left, ankle_l_moment, time);
ankle_l_moment_splitClean = GaitCycleRemoveOutliers(ankle_l_moment_split, nMin);
ankle_l_moment_avg = interp1(1:1:100, mean(ankle_l_moment_splitClean, 2), full_time, "spline", "extrap")';

%% Section 5: Right Leg Processing
qtm_125hz_times = (0 : 4999) / 125;

ankle_r_moment_split = GaitCycleSplit(GRF_Right, ankle_r_moment, time);

S11_M = uwb_file.S11_MdB_sync; S11_P = uwb_file.S11_P_sync;
S12_M = uwb_file.S12_MdB_sync; S12_P = uwb_file.S12_P_sync;
S21_M = uwb_file.S21_MdB_sync; S21_P = uwb_file.S21_P_sync;
S22_M = uwb_file.S22_MdB_sync; S22_P = uwb_file.S22_P_sync;

figure(5); clf
tiledlayout("flow")
nexttile; plot(S12_P')
nexttile; plot(S21_P')

S11_M_split = []; S11_P_split = []; S22_M_split = []; S22_P_split = [];
S12_M_split = []; S12_P_split = []; S21_M_split = []; S21_P_split = [];

% Gait cycle split every frequency for each S coefficient
for i = 1 : 51
    S11_M_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S11_M(i,:)', qtm_125hz_times);
    S11_P_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S11_P(i,:)', qtm_125hz_times);
    S12_M_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S12_M(i,:)', qtm_125hz_times);
    S12_P_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S12_P(i,:)', qtm_125hz_times);
    S21_M_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S21_M(i,:)', qtm_125hz_times);
    S21_P_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S21_P(i,:)', qtm_125hz_times);
    S22_M_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S22_M(i,:)', qtm_125hz_times);
    S22_P_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S22_P(i,:)', qtm_125hz_times);
end

% Remove the same outliers for all UWB frequencies and right ankle torque
[S11_M_splitClean, S11_P_splitClean, S12_M_splitClean, S12_P_splitClean, ...
 S21_M_splitClean, S21_P_splitClean, S22_M_splitClean, S22_P_splitClean, ...
 ankle_r_moment_splitClean] = GaitCycleRemoveSameOutliers(...
 S11_M_split, S11_P_split, S12_M_split, S12_P_split, ...
 S21_M_split, S21_P_split, S22_M_split, S22_P_split,ankle_r_moment_split, nMin);

S11_M_avg = zeros(101, 51); S11_P_avg = zeros(101, 51);
S12_M_avg = zeros(101, 51); S12_P_avg = zeros(101, 51);
S21_M_avg = zeros(101, 51); S21_P_avg = zeros(101, 51);
S22_M_avg = zeros(101, 51); S22_P_avg = zeros(101, 51);

ankle_r_moment_avg = interp1(1:1:100, mean(ankle_r_moment_splitClean, 2), full_time, "spline", "extrap")';
for i = 1:51
    S11_M_avg(:, i) = interp1(1:1:100, mean(S11_M_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
    S11_P_avg(:, i) = interp1(1:1:100, mean(S11_P_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
    S12_M_avg(:, i) = interp1(1:1:100, mean(S12_M_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
    S12_P_avg(:, i) = interp1(1:1:100, mean(S12_P_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
    S21_M_avg(:, i) = interp1(1:1:100, mean(S21_M_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
    S21_P_avg(:, i) = interp1(1:1:100, mean(S21_P_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
    S22_M_avg(:, i) = interp1(1:1:100, mean(S22_M_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
    S22_P_avg(:, i) = interp1(1:1:100, mean(S22_P_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
end

figure(3); clf
tiledlayout("flow")
nexttile; plot(ankle_l_moment_splitClean); title("Ankle moment (L), n=10")
nexttile; plot(ankle_r_moment_splitClean); title("Ankle moment (R), n=10")

%% Section 6: Plotting and saving
labels = {'PID', 'COND', 'TA', 'MG', 'LG', 'SOL', 'FL', 'FA', 'FP', 'FV', 'TL', 'TR'};

S11_M_labels = cell(1, 51); S11_P_labels = cell(1, 51);
S12_M_labels = cell(1, 51); S12_P_labels = cell(1, 51);
S21_M_labels = cell(1, 51); S21_P_labels = cell(1, 51);
S22_M_labels = cell(1, 51); S22_P_labels = cell(1, 51);

for i = 1:51
    S11_M_labels(1, i) = cellstr(string(i)); S11_P_labels(1, i) = cellstr(string(i));
    S12_M_labels(1, i) = cellstr(string(i)); S12_P_labels(1, i) = cellstr(string(i));
    S21_M_labels(1, i) = cellstr(string(i)); S21_P_labels(1, i) = cellstr(string(i));
    S22_M_labels(1, i) = cellstr(string(i)); S22_P_labels(1, i) = cellstr(string(i));
end

PIDN = ones(101, 1) .* str2double(PID);
CONDN = ones(101, 1) .* str2double(COND);

ValDat = array2table([PIDN, CONDN, TA_avg, MG_avg, LG_avg, SOL_avg, ...
                      FL_avg, FA_avg, FP_avg, FV_avg, ...
                      ankle_l_moment_avg, ankle_r_moment_avg], ...
                      "VariableNames", labels);
S11_M_Dat = array2table(S11_M_avg, "VariableNames", S11_M_labels);
S11_P_Dat = array2table(S11_P_avg, "VariableNames", S11_P_labels);
S12_M_Dat = array2table(S12_M_avg, "VariableNames", S12_M_labels);
S12_P_Dat = array2table(S12_P_avg, "VariableNames", S12_P_labels);
S21_M_Dat = array2table(S21_M_avg, "VariableNames", S21_M_labels);
S21_P_Dat = array2table(S21_P_avg, "VariableNames", S21_P_labels);
S22_M_Dat = array2table(S22_M_avg, "VariableNames", S22_M_labels);
S22_P_Dat = array2table(S22_P_avg, "VariableNames", S22_P_labels);

ALL = struct('ValDat', ValDat, ...
             'S11_M_Dat', S11_M_Dat, 'S11_P_Dat', S11_P_Dat, ...
             'S12_M_Dat', S12_M_Dat, 'S12_P_Dat', S12_P_Dat, ...
             'S21_M_Dat', S21_M_Dat, 'S21_P_Dat', S21_P_Dat, ...
             'S22_M_Dat', S22_M_Dat, 'S22_P_Dat', S22_P_Dat);

save(fullfile(destDir, "S" + PID + "_Trial_00" + n + "_ALL.mat"), 'ALL')

figure(4); clf
nexttile; plot(TA_avg); title("TA avg");
nexttile; plot(MG_avg); title("MG avg");
nexttile; plot(LG_avg); title("LG avg");
nexttile; plot(SOL_avg); title("SOL avg");

nexttile; plot(FL_avg); title("FL avg")
nexttile; plot(FA_avg); title("FA avg")
nexttile; plot(FP_avg); title("FP avg")
nexttile; plot(FV_avg); title("FV avg")

nexttile; plot(S11_M_avg); title("S11 Mag avg")
nexttile; plot(S11_P_avg); title("S11 Phase avg")
nexttile; plot(S12_M_avg); title("S12 Mag avg")
nexttile; plot(S12_P_avg); title("S12 Phase avg")
nexttile; plot(S21_M_avg); title("S21 Mag avg")
nexttile; plot(S21_P_avg); title("S21 Phase avg")
nexttile; plot(S22_M_avg); title("S22 Mag avg")
nexttile; plot(S22_P_avg); title("S22 Phase avg")
%% Section 6: Different files - COMMENT OUT
% clear
% [b_emg_lp, a_emg_lp] = butter(4, 10/(2000/2));
% [b_emg_bp, a_emg_bp] = butter(4, [20/(2000/2), 400/(2000/2)]);
% [b_us_lp, a_us_lp] = butter(4, 10/(125/2));
% [b_grf_lp, a_grf_lp] = butter(6, 10/(1250/2));
% 
% % Trial number and number of gait cycles to keep
% 
% n1 = "08";
% n2 = "09";
% 
% COND = "3";
% PID = "04";
% nMin = 12;
% weight = 65.93;
% 
% % EMG MVCs - FROM OPTIMISED MSR VALUES
% MG_MVC = 167.6227;
% LG_MVC  = 73.442;
% SOL_MVC = 116.1283;
% TA_MVC = 205.6779;
% 
% % Optimal fascicle length
% FL_opt = 84.99430997; % mean static
% FA_opt = 10.00306667; % mean static
% FP_opt = 12.99368198; % mean static
% 
% LG_discard = []; 
% MG_discard = [];
% 
% 
% ik_fileLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\EXO_UWB\Data\ExoUWB_S" + PID + ...
%     "\Scaling, IK, ID OUTPUT";
% ik_fileName = "ExoUWB_S" + PID + "_Trial_00" + n1 + "_IK.mot";
% ik_file = readtable(fullfile(ik_fileLoc, ik_fileName), "FileType","text");
% 
% id_fileName = "ExoUWB_S" + PID + "_Trial_00" + n1 + "_ID_Resampled.mot";
% id_file = readtable(fullfile(ik_fileLoc, id_fileName), "FileType","text");
% 
% qtm_fileLoc1 = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\EXO_UWB\Data\ExoUWB_S" + PID;
% qtm_fileName1 = "ExoUWB_S" + PID + "_Trial_00" + n1 + ".mat";
% qtm_file1 = load(fullfile(qtm_fileLoc1, qtm_fileName1));
% 
% qtm_fileLoc2 = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\EXO_UWB\Data\ExoUWB_S" + PID;
% qtm_fileName2 = "ExoUWB_S" + PID + "_Trial_00" + n2 + ".mat";
% qtm_file2 = load(fullfile(qtm_fileLoc2, qtm_fileName2));
% 
% us_fileLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\US\S" + PID;
% us_fileName = "nn00" + n2 + "_tracked_Q=001.mat";
% us_file = load(fullfile(us_fileLoc, us_fileName));
% 
% uwb_fileLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\UWB\S" + PID;
% uwb_fileName = "RadarData_S" + PID + "_Trial_00" + n1 + ".mat";
% uwb_file = load(fullfile(uwb_fileLoc, uwb_fileName));
% 
% 
% times_ik = ik_file.time;
% times_us = (0:4999)/125;
% times_qtm = (0:49999)/1250;
% times_emg = (0:79999)/2000;
% full_time = 0:1:100;
% 
% fieldName1 = fields(qtm_file1); fieldName2 = fields(qtm_file2);
% 
% GRF_Left1 = filtfilt(b_grf_lp, a_grf_lp, qtm_file1.(fieldName1{1}).Force(1).Force(3,:));
% GRF_Right1 = filtfilt(b_grf_lp, a_grf_lp, qtm_file1.(fieldName1{1}).Force(2).Force(3,:));
% 
% GRF_Left2 = filtfilt(b_grf_lp, a_grf_lp, qtm_file2.(fieldName2{1}).Force(1).Force(3,:));
% GRF_Right2 = filtfilt(b_grf_lp, a_grf_lp, qtm_file2.(fieldName2{1}).Force(2).Force(3,:));
% 
% 
% % EMG Processing
% 
% emg_labels = qtm_file2.(fieldName2{1}).Analog(2).Labels;
% emg_data = qtm_file2.(fieldName2{1}).Analog(2).Data';
% 
% % Finding index of EMG Data in labels
% TA_idx = find(cellfun(@(x)isequal(x,'TA'), emg_labels));
% MG_idx = find(cellfun(@(x)isequal(x,'GM'), emg_labels));
% LG_idx = find(cellfun(@(x)isequal(x,'GL'), emg_labels));
% SOL_idx = find(cellfun(@(x)isequal(x,'SOL'), emg_labels));
% 
% % bandpassed 20-500Hz, then rectified, then low-pass filtered 12Hz
% TA = emg_data(:, TA_idx);
% TA_bp = filtfilt(b_emg_bp, a_emg_bp, TA);
% TA_rect = abs(TA_bp);
% TA_env = filtfilt(b_emg_lp, a_emg_lp, TA_rect);
% TA_filtered = max(0,TA_env)/TA_MVC;
% 
% MG = emg_data(:,MG_idx);
% MG_bp = filtfilt(b_emg_bp, a_emg_bp, MG);
% MG_rect = abs(MG_bp);
% MG_env = filtfilt(b_emg_lp, a_emg_lp, MG_rect);
% MG_filtered = max(0,MG_env)/MG_MVC;
% 
% LG = emg_data(:,LG_idx);
% LG_bp = filtfilt(b_emg_bp, a_emg_bp, LG);
% LG_rect = abs(LG_bp);
% LG_env = filtfilt(b_emg_lp, a_emg_lp, LG_rect);
% LG_filtered = max(0,LG_env)/LG_MVC;
% 
% SOL = emg_data(:,SOL_idx);
% SOL_bp = filtfilt(b_emg_bp, a_emg_bp, SOL);
% SOL_rect = abs(SOL_bp);
% SOL_env = filtfilt(b_emg_lp, a_emg_lp, SOL_rect);
% SOL_filtered = max(0,SOL_env)/SOL_MVC;
% 
% % split gait cycles, removing outliers, and resampling to 0-100%
% TA_split = GaitCycleSplit(GRF_Left2, TA_filtered, times_emg, 100);
% TA_splitClean = GaitCycleRemoveOutliers(TA_split, nMin);
% TA_avg = interp1(1:1:100, mean(TA_splitClean, 2), full_time, "spline", "extrap")';
% 
% MG_split = GaitCycleSplit(GRF_Left2, MG_filtered, times_emg, 100);
% if isempty(MG_discard) ~= 1
%     for i = 1 : length(MG_discard)
%         MG_split(:, MG_discard(i)) = [];
%         MG_discard = MG_discard - 1;
%     end
% end
% MG_splitClean = GaitCycleRemoveOutliers(MG_split, nMin);
% MG_avg = interp1(1:1:100, mean(MG_splitClean, 2), full_time, "spline", "extrap")';
% 
% LG_split = GaitCycleSplit(GRF_Left2, LG_filtered, times_emg, 100);
% if isempty(LG_discard) ~= 1
%     for i = 1 : length(LG_discard)
%         LG_split(:, LG_discard(i)) = [];
%         LG_discard = LG_discard - 1;
%     end
% end
% LG_splitClean = GaitCycleRemoveOutliers(LG_split, nMin);
% LG_avg = interp1(1:1:100, mean(LG_splitClean, 2), full_time, "spline", "extrap")';
% 
% SOL_split = GaitCycleSplit(GRF_Left2, SOL_filtered, times_emg, 100);
% SOL_splitClean = GaitCycleRemoveOutliers(SOL_split, nMin);
% SOL_avg = interp1(1:1:100, mean(SOL_splitClean, 2), full_time, "spline", "extrap")';
% 
% figure(1); clf
% tiledlayout("flow")
% nexttile; plot(TA_splitClean); title("TA")
% nexttile; plot(MG_splitClean); title("MG")
% nexttile; plot(LG_splitClean); title("LG")
% nexttile; plot(SOL_splitClean); title("SOL")
% 
% % US Processing
% FL = us_file.Fdat.Region.fas_length;
% FA = us_file.Fdat.Region.fas_ang;
% FP = us_file.Fdat.Region.fas_pen;
% time = us_file.Fdat.Region.Time;
% 
% FL_filt = filtfilt(b_us_lp, a_us_lp, FL)/FL_opt;
% FA_filt = filtfilt(b_us_lp, a_us_lp, FA) - FA_opt;
% FP_filt = filtfilt(b_us_lp, a_us_lp, FP) - FP_opt;
% 
% FV_filt = diff(FL_filt) ./ diff(time);
% FV_interp = interp1(0.5/125 + (0:4998)/125, FV_filt(:, 1), times_us, 'spline')';
% 
% FL_split = GaitCycleSplit(GRF_Left2, FL_filt, times_us, 100);
% FL_splitClean = GaitCycleRemoveOutliers(FL_split, nMin);
% FL_avg = interp1(1:1:100, mean(FL_splitClean, 2), full_time, "spline", "extrap")';
% 
% FA_split = GaitCycleSplit(GRF_Left2, FA_filt, times_us, 100);
% FA_splitClean = GaitCycleRemoveOutliers(FA_split, nMin);
% FA_avg = interp1(1:1:100, mean(FA_splitClean, 2), full_time, "spline", "extrap")';
% 
% FP_split = GaitCycleSplit(GRF_Left2, FP_filt, times_us, 100);
% FP_splitClean = GaitCycleRemoveOutliers(FP_split, nMin);
% FP_avg = interp1(1:1:100, mean(FP_splitClean, 2), full_time, "spline", "extrap")';
% 
% FV_split = GaitCycleSplit(GRF_Left2, FV_interp, times_us, 100);
% FV_splitClean = GaitCycleRemoveOutliers(FV_split, nMin);
% FV_avg = interp1(1:1:100, mean(FV_splitClean, 2), full_time, "spline", "extrap")';
% 
% figure(2); clf
% tiledlayout("flow")
% nexttile; plot(FL_splitClean); title("MG fascicle length")
% nexttile; plot(FA_splitClean); title("MG fascicle angle")
% nexttile; plot(FP_splitClean); title("MG fascicle pennation")
% nexttile; plot(FV_splitClean); title("MG fascicle velocity")
% 
% 
% % Ankle Joint Torque Processing
% 
% time = id_file{:, "time"};
% ankle_r_moment = id_file{:, "ankle_angle_r_moment"} ./ weight;
% ankle_l_moment = id_file{:, "ankle_angle_l_moment"} ./ weight;
% 
% ankle_l_moment_split = GaitCycleSplit(GRF_Left1, ankle_l_moment, time);
% ankle_l_moment_splitClean = GaitCycleRemoveOutliers(ankle_l_moment_split, nMin);
% ankle_l_moment_avg = interp1(1:1:100, mean(ankle_l_moment_splitClean, 2), full_time, "spline", "extrap")';
% 
% % Right Leg Processing
% qtm_125hz_times = (0 : 4999) / 125;
% 
% ankle_r_moment_split = GaitCycleSplit(GRF_Right1, ankle_r_moment, time);
% 
% S11_M = uwb_file.S11_MdB_sync; S11_P = uwb_file.S11_P_sync;
% S12_M = uwb_file.S12_MdB_sync; S12_P = uwb_file.S12_P_sync;
% S21_M = uwb_file.S21_MdB_sync; S21_P = uwb_file.S21_P_sync;
% S22_M = uwb_file.S22_MdB_sync; S22_P = uwb_file.S22_P_sync;
% 
% figure(5); clf
% tiledlayout("flow")
% nexttile; plot(S12_P')
% nexttile; plot(S21_P')
% 
% S11_M_split = []; S11_P_split = [];
% S12_M_split = []; S12_P_split = [];
% S21_M_split = []; S21_P_split = [];
% S22_M_split = []; S22_P_split = [];
% 
% 
% for i = 1 : 51
%     S11_M_split(1:100, :, i) = GaitCycleSplit(GRF_Right1, S11_M(i,:)', qtm_125hz_times);
%     S11_P_split(1:100, :, i) = GaitCycleSplit(GRF_Right1, S11_P(i,:)', qtm_125hz_times);
%     S12_M_split(1:100, :, i) = GaitCycleSplit(GRF_Right1, S12_M(i,:)', qtm_125hz_times);
%     S12_P_split(1:100, :, i) = GaitCycleSplit(GRF_Right1, S12_P(i,:)', qtm_125hz_times);
%     S21_M_split(1:100, :, i) = GaitCycleSplit(GRF_Right1, S21_M(i,:)', qtm_125hz_times);
%     S21_P_split(1:100, :, i) = GaitCycleSplit(GRF_Right1, S21_P(i,:)', qtm_125hz_times);
%     S22_M_split(1:100, :, i) = GaitCycleSplit(GRF_Right1, S22_M(i,:)', qtm_125hz_times);
%     S22_P_split(1:100, :, i) = GaitCycleSplit(GRF_Right1, S22_P(i,:)', qtm_125hz_times);
% end
% 
% [S11_M_splitClean, S11_P_splitClean, ...
%  S12_M_splitClean, S12_P_splitClean, ...
%  S21_M_splitClean, S21_P_splitClean, ...
%  S22_M_splitClean, S22_P_splitClean, ...
%  ankle_r_moment_splitClean] = GaitCycleRemoveSameOutliers(...
%  S11_M_split, S11_P_split, S12_M_split, S12_P_split, ...
%  S21_M_split, S21_P_split, S22_M_split, S22_P_split,ankle_r_moment_split, nMin);
% 
% S11_M_avg = zeros(101, 51); S11_P_avg = zeros(101, 51);
% S12_M_avg = zeros(101, 51); S12_P_avg = zeros(101, 51);
% S21_M_avg = zeros(101, 51); S21_P_avg = zeros(101, 51);
% S22_M_avg = zeros(101, 51); S22_P_avg = zeros(101, 51);
% 
% ankle_r_moment_avg = interp1(1:1:100, mean(ankle_r_moment_splitClean, 2), full_time, "spline", "extrap")';
% for i = 1:51
%     S11_M_avg(:, i) = interp1(1:1:100, mean(S11_M_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
%     S11_P_avg(:, i) = interp1(1:1:100, mean(S11_P_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
%     S12_M_avg(:, i) = interp1(1:1:100, mean(S12_M_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
%     S12_P_avg(:, i) = interp1(1:1:100, mean(S12_P_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
%     S21_M_avg(:, i) = interp1(1:1:100, mean(S21_M_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
%     S21_P_avg(:, i) = interp1(1:1:100, mean(S21_P_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
%     S22_M_avg(:, i) = interp1(1:1:100, mean(S22_M_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
%     S22_P_avg(:, i) = interp1(1:1:100, mean(S22_P_splitClean(:,:,i), 2), full_time, "spline", "extrap")';
% end
% 
% labels = {'PID', 'COND', 'TA', 'MG', 'LG', 'SOL', 'FL', 'FA', 'FP', 'FV', 'TL', 'TR'};
% 
% S11_M_labels = cell(1, 51); S11_P_labels = cell(1, 51);
% S12_M_labels = cell(1, 51); S12_P_labels = cell(1, 51);
% S21_M_labels = cell(1, 51); S21_P_labels = cell(1, 51);
% S22_M_labels = cell(1, 51); S22_P_labels = cell(1, 51);
% 
% for i = 1:51
%     S11_M_labels(1, i) = cellstr(string(i)); S11_P_labels(1, i) = cellstr(string(i));
%     S12_M_labels(1, i) = cellstr(string(i)); S12_P_labels(1, i) = cellstr(string(i));
%     S21_M_labels(1, i) = cellstr(string(i)); S21_P_labels(1, i) = cellstr(string(i));
%     S22_M_labels(1, i) = cellstr(string(i)); S22_P_labels(1, i) = cellstr(string(i));
% end
% 
% PIDN = ones(101, 1) .* str2double(PID);
% CONDN = ones(101, 1) .* str2double(COND);
% 
% tempDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\Data Collection\Left Leg Average - US, EMG\S" + PID;
% 
% ValDat = array2table([PIDN, CONDN, TA_avg, MG_avg, LG_avg, SOL_avg, ...
%                       FL_avg, FA_avg, FP_avg, FV_avg, ...
%                       ankle_l_moment_avg, ankle_r_moment_avg], ...
%                       "VariableNames", labels);
% S11_M_Dat = array2table(S11_M_avg, "VariableNames", S11_M_labels);
% S11_P_Dat = array2table(S11_P_avg, "VariableNames", S11_P_labels);
% S12_M_Dat = array2table(S12_M_avg, "VariableNames", S12_M_labels);
% S12_P_Dat = array2table(S12_P_avg, "VariableNames", S12_P_labels);
% S21_M_Dat = array2table(S21_M_avg, "VariableNames", S21_M_labels);
% S21_P_Dat = array2table(S21_P_avg, "VariableNames", S21_P_labels);
% S22_M_Dat = array2table(S22_M_avg, "VariableNames", S22_M_labels);
% S22_P_Dat = array2table(S22_P_avg, "VariableNames", S22_P_labels);
% 
% ALL = struct('ValDat', ValDat, ...
%              'S11_M_Dat', S11_M_Dat, 'S11_P_Dat', S11_P_Dat, ...
%              'S12_M_Dat', S12_M_Dat, 'S12_P_Dat', S12_P_Dat, ...
%              'S21_M_Dat', S21_M_Dat, 'S21_P_Dat', S21_P_Dat, ...
%              'S22_M_Dat', S22_M_Dat, 'S22_P_Dat', S22_P_Dat);
% 
% save(fullfile(tempDir, "S" + PID + "_Trial_00" + n1 + "_" + n2 + "_ALL.mat"), 'ALL')
% 
% figure(4); clf
% tiledlayout("flow")
% nexttile; plot(TA_avg); title("TA avg");
% nexttile; plot(MG_avg); title("MG avg");
% nexttile; plot(LG_avg); title("LG avg");
% nexttile; plot(SOL_avg); title("SOL avg");
% 
% nexttile; plot(FL_avg); title("FL avg")
% nexttile; plot(FA_avg); title("FA avg")
% nexttile; plot(FP_avg); title("FP avg")
% nexttile; plot(FV_avg); title("FV avg")
% 
% nexttile; plot(S11_M_avg); title("S11 Mag avg")
% nexttile; plot(S11_P_avg); title("S11 Phase avg")
% nexttile; plot(S12_M_avg); title("S12 Mag avg")
% nexttile; plot(S12_P_avg); title("S12 Phase avg")
% nexttile; plot(S21_M_avg); title("S21 Mag avg")
% nexttile; plot(S21_P_avg); title("S21 Phase avg")
% nexttile; plot(S22_M_avg); title("S22 Mag avg")
% nexttile; plot(S22_P_avg); title("S22 Phase avg")