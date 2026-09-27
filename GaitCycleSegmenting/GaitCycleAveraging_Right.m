%% Gait Cycle Averaging script to compile previous EMG and US cycles with new force and UWB cycles (both polar and rectangular)
% Section 1: Loading all file inputs and parameters
%            - Manually enter the PID, trial number, and condition number
%            - EMG MVC values and resting fascicle architecture values are
%              extracted from the Participant Summary file
% Section 2: Processes all UWB radar data and ankle torques from the right
%            leg by removing the same outliers from both, and gait cycle 
%            averaging
% Section 3: Plots resulting mean response of all musculoskeletal
%            parameters and UWB radar data, and saves it to the destDir 
%            specified in Section 1

%% Section 1: Inputs
clear
summary1 = readtable('Participant Data Summary Export.xlsx', 'Sheet', 'Data Collection', 'VariableNamingRule', 'preserve');
summary2 = readtable('Participant Data Summary Export.xlsx', 'Sheet', 'Normalising', 'VariableNamingRule', 'preserve');

n = "15"; % Trial number
PID = "10"; % PID

mass_all = [80.22, 62.98, 79.34, 65.93, 66.33, 100.29, 63.91, 73.22, 90.58, 67.51];
PIDn = str2double(PID);
mass = mass_all(PIDn);

nMin = 10; % Number of gait cycles to keep
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
id_fileName = "ExoUWB_S" + PID + "_Trial_00" + n + "_ID_Resampled.mot";
id_file = readtable(fullfile(ik_fileLoc, id_fileName), "FileType","text");

qtm_fileLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\EXO_UWB\Data\ExoUWB_S" + PID;
qtm_fileName = "ExoUWB_S" + PID + "_Trial_00" + n + ".mat";
qtm_file = load(fullfile(qtm_fileLoc, qtm_fileName));

uwb_fileLoc = "Z:\Data Collection 3\Processed Data\S" + PID + "\Synchronised UWB Rect No Highpass";
uwb_fileName = "RadarData_S" + PID + "_Trial_00" + n + ".mat";
uwb_file = load(fullfile(uwb_fileLoc, uwb_fileName));

force_fileLoc = "Z:\Data Collection 3\Processed Data\S" + PID + "\Muscle Redundancy Solver";
force_fileName = "ExoUWB_S" + PID + "_Trial_00" + n + "_Results.mat";
force_file = load(fullfile(force_fileLoc, force_fileName));

times_qtm = (0:49999)/1250;
full_time = 0:1:100;
qtm_125hz_times = (0 : 4999) / 125;
time = id_file{:, "time"};

[b_grf_lp, a_grf_lp] = butter(6, 10/(1250/2));

fieldName = fields(qtm_file);
GRF_Right = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(2).Force(3,:));

%% Section 2: Rectangular UWB Processing

% Extract data from LP file
S11_R = uwb_file.S11_R; S11_I = uwb_file.S11_I;
S21_R = uwb_file.S21_R; S21_I = uwb_file.S21_I;
S22_R = uwb_file.S22_R; S22_I = uwb_file.S22_I;

[~,idx_start] = min(abs(time - min(uwb_file.times_uwb(:,1))));
[~,idx_end] = min(abs(time - max(uwb_file.times_uwb(:, end))));

uwb_times = linspace(max(uwb_file.times_uwb(:,1)), ...
                     min(uwb_file.times_uwb(:,end)), 2155);
time_cropped = time(idx_start+1:idx_end-1);

% Use the UWB start and end times to crop the ankle moments
ankle_r_moment = id_file{:, "ankle_angle_r_moment"} ./ weight;
ankle_r_moment_interp = interp1(time, ankle_r_moment, time_cropped, "spline");
ankle_r_moment_split = GaitCycleSplit(GRF_Right, ankle_r_moment_interp, time_cropped);

% Initialise for BP radar data
S11_R_split = []; S11_I_split = []; 
S22_R_split = []; S22_I_split = [];
S21_R_split = []; S21_I_split = [];

%Gait cycle split every frequency for each S coefficient
for i = 1 : 51
    S11_R_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S11_R(i,:)', uwb_file.times_uwb(i, :));
    S11_I_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S11_I(i,:)', uwb_file.times_uwb(i, :));
    S21_R_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S21_R(i,:)', uwb_file.times_uwb(i, :));
    S21_I_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S21_I(i,:)', uwb_file.times_uwb(i, :));
    S22_R_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S22_R(i,:)', uwb_file.times_uwb(i, :));
    S22_I_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S22_I(i,:)', uwb_file.times_uwb(i, :));
end

% for S10 n = 15, uwb times were causing issues because of time differences
% between frequencies
% for i = 1 : 51
%     S11_R_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S11_R(i,:)', uwb_times);
%     S11_I_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S11_I(i,:)', uwb_times);
%     S21_R_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S21_R(i,:)', uwb_times);
%     S21_I_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S21_I(i,:)', uwb_times);
%     S22_R_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S22_R(i,:)', uwb_times);
%     S22_I_split(1:100, :, i) = GaitCycleSplit(GRF_Right, S22_I(i,:)', uwb_times);
% end

% Remove the same outliers for all UWB frequencies and right ankle torque
% BP
[S11_R_splitClean, S11_I_splitClean, S21_R_splitClean, S21_I_splitClean, ...
 S22_R_splitClean, S22_I_splitClean, ankle_r_moment_splitClean] = GaitCycleRemoveSameOutliers_nD(...
 S11_R_split, S11_I_split, S21_R_split, S21_I_split, ...
 S22_R_split, S22_I_split, ankle_r_moment_split, nMin);

S11_R_avg = zeros(100, 51); S11_I_avg = zeros(100, 51);
S21_R_avg = zeros(100, 51); S21_I_avg = zeros(100, 51);
S22_R_avg = zeros(100, 51); S22_I_avg = zeros(100, 51);

for i = 1:51
    S11_R_avg(:, i) = mean(S11_R_splitClean(:,:,i), 2)';
    S11_I_avg(:, i) = mean(S11_I_splitClean(:,:,i), 2)';
    S21_R_avg(:, i) = mean(S21_R_splitClean(:,:,i), 2)';
    S21_I_avg(:, i) = mean(S21_I_splitClean(:,:,i), 2)';
    S22_R_avg(:, i) = mean(S22_R_splitClean(:,:,i), 2)';
    S22_I_avg(:, i) = mean(S22_I_splitClean(:,:,i), 2)';
end

S11_M_avg = 20*log10(sqrt((S11_R_avg).^2 + (S11_I_avg).^2));
S11_P_avg = unwrap(atan2(S11_I_avg, S11_R_avg), [], 1);
S21_M_avg = 20*log10(sqrt((S21_R_avg).^2 + (S21_I_avg).^2));
S21_P_avg = unwrap(atan2(S21_I_avg, S21_R_avg), [], 1);
S22_M_avg = 20*log10(sqrt((S22_R_avg).^2 + (S22_I_avg).^2));
S22_P_avg = unwrap(atan2(S22_I_avg, S22_R_avg), [], 1);

figure(1); clf
tiledlayout(3,2)
nexttile(1); plot(S11_M_avg)
nexttile(2); plot(S11_P_avg)
nexttile(3); plot(S21_M_avg)
nexttile(4); plot(S21_P_avg)
nexttile(5); plot(S22_M_avg)
nexttile(6); plot(S22_P_avg)

figure(2); clf
tiledlayout(3,2)
nexttile(1); plot(S11_R_avg)
nexttile(2); plot(S11_I_avg)
nexttile(3); plot(S21_R_avg)
nexttile(4); plot(S21_I_avg)
nexttile(5); plot(S22_R_avg)
nexttile(6); plot(S22_I_avg)
    
%% Section 3: Gait Cycle Average Forces

% Interpolate force results to be the same as ID results
forces_interp = interp1(force_file.Results.Time.MTE, force_file.Results.TForce.MTE', time_cropped, "spline");

% Find specific force indices
idx_gaslat = find(strcmp(force_file.Results.MuscleNames,'gaslat_r'));
idx_gasmed = find(strcmp(force_file.Results.MuscleNames,'gasmed_r'));
idx_soleus = find(strcmp(force_file.Results.MuscleNames,'soleus_r'));
idx_tibant = find(strcmp(force_file.Results.MuscleNames,'tibant_r'));

force_LG = forces_interp(:, idx_gaslat);
force_MG = forces_interp(:, idx_gasmed);
force_SOL = forces_interp(:, idx_soleus);
force_TA = forces_interp(:, idx_tibant);

force_LG_split = GaitCycleSplit(GRF_Right, force_LG, time_cropped);
force_MG_split = GaitCycleSplit(GRF_Right, force_MG, time_cropped);
force_SOL_split = GaitCycleSplit(GRF_Right, force_SOL, time_cropped);
force_TA_split = GaitCycleSplit(GRF_Right, force_TA, time_cropped);

% Use the lowest MSE ankle moments to choose steps
force_LG_splitClean = GaitCycleRemoveSameOutliers_1D(force_LG_split, ankle_r_moment_split, nMin);
force_MG_splitClean = GaitCycleRemoveSameOutliers_1D(force_MG_split, ankle_r_moment_split, nMin);
force_SOL_splitClean = GaitCycleRemoveSameOutliers_1D(force_SOL_split, ankle_r_moment_split, nMin);
force_TA_splitClean = GaitCycleRemoveSameOutliers_1D(force_TA_split, ankle_r_moment_split, nMin);

force_LG_avg = mean(force_LG_splitClean,2)/mass;
force_MG_avg = mean(force_MG_splitClean,2)/mass;
force_SOL_avg = mean(force_SOL_splitClean,2)/mass;
force_TA_avg = mean(force_TA_splitClean,2)/mass;

ankle_r_moment_avg = mean(ankle_r_moment_splitClean, 2);

%% Section 3: Plotting and saving

ALL = struct('LG', force_LG_avg, 'MG', force_MG_avg,...
             'SOL', force_SOL_avg, 'TA', force_TA_avg, ...
             'Torque', ankle_r_moment_avg);

S11_R_labels = cell(1, 51); S11_I_labels = cell(1, 51);
S21_R_labels = cell(1, 51); S21_I_labels = cell(1, 51);
S22_R_labels = cell(1, 51); S22_I_labels = cell(1, 51);

S11_M_labels = cell(1, 51); S11_P_labels = cell(1, 51);
S21_M_labels = cell(1, 51); S21_P_labels = cell(1, 51);
S22_M_labels = cell(1, 51); S22_P_labels = cell(1, 51);

for i = 1:51
    S11_R_labels(1, i) = cellstr(string(i)); S11_I_labels(1, i) = cellstr(string(i));
    S21_R_labels(1, i) = cellstr(string(i)); S21_I_labels(1, i) = cellstr(string(i));
    S22_R_labels(1, i) = cellstr(string(i)); S22_I_labels(1, i) = cellstr(string(i));

    S11_M_labels(1, i) = cellstr(string(i)); S11_P_labels(1, i) = cellstr(string(i));
    S21_M_labels(1, i) = cellstr(string(i)); S21_P_labels(1, i) = cellstr(string(i));
    S22_M_labels(1, i) = cellstr(string(i)); S22_P_labels(1, i) = cellstr(string(i));
end

S11_R_Dat = array2table(S11_R_avg, "VariableNames", S11_R_labels);
S11_I_Dat = array2table(S11_I_avg, "VariableNames", S11_I_labels);
S21_R_Dat = array2table(S21_R_avg, "VariableNames", S21_R_labels);
S21_I_Dat = array2table(S21_I_avg, "VariableNames", S21_I_labels);
S22_R_Dat = array2table(S22_R_avg, "VariableNames", S22_R_labels);
S22_I_Dat = array2table(S22_I_avg, "VariableNames", S22_I_labels);

S11_M_Dat = array2table(S11_M_avg, "VariableNames", S11_M_labels);
S11_P_Dat = array2table(S11_P_avg, "VariableNames", S11_P_labels);
S21_M_Dat = array2table(S21_M_avg, "VariableNames", S21_M_labels);
S21_P_Dat = array2table(S21_P_avg, "VariableNames", S21_P_labels);
S22_M_Dat = array2table(S22_M_avg, "VariableNames", S22_M_labels);
S22_P_Dat = array2table(S22_P_avg, "VariableNames", S22_P_labels);

ALL.S11_R_Dat = S11_R_Dat; ALL.S11_I_Dat = S11_I_Dat;
ALL.S21_R_Dat = S21_R_Dat; ALL.S21_I_Dat = S21_I_Dat;
ALL.S22_R_Dat = S22_R_Dat; ALL.S22_I_Dat = S22_I_Dat;

ALL.S11_M_Dat = S11_M_Dat; ALL.S11_P_Dat = S11_P_Dat;
ALL.S21_M_Dat = S21_M_Dat; ALL.S21_P_Dat = S21_P_Dat;
ALL.S22_M_Dat = S22_M_Dat; ALL.S22_P_Dat = S22_P_Dat;

destDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged\RightLegAverage_LP\S" + PID;
save(fullfile(destDir, "S" + PID + "_Trial_00" + n + "_UWB_Forces.mat"), 'ALL')

