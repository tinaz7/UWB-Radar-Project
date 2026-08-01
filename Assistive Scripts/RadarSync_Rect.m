%% Synchronise radar data to sync triggers from QTM files
%  Section 1: Select files, including UWB radar data file and corresponding
%             QTM file for sync trigger pulses
%  Section 2: Synchronise UWB radar data to identified QTM trigger syncs
%  Section 3: Save output of each coefficient component of synchronised
%             gait cycle
%% Section 1: Select files
clear variables;

PID = "01";

path = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data";
uwbFileName = fullfile(path,"UWB\S" + PID + "\RawData_Rect\" + ...
                       "VNA Data 2026_02_19 17-12-21.mat");
qtmFileName = fullfile(path,"EXO_UWB\Data\ExoUWB_S" + PID + "\" + ...
                       "ExoUWB_S" + PID + "_Trial_0028.mat");
outName = fullfile(path, "UWB\S" + PID + "\ProcessedData_Rect\" + ...
                       "RadarData_S" + PID + "_Trial_0028.mat");

load(uwbFileName)
qtmFile = load(qtmFileName);
fieldName = fields(qtmFile);

RadarTrig = qtmFile.(fieldName{1}).Analog(1).Data(15,:);

times_qtm = (0:49999) / 1250;

RadarPost = abs(RadarTrig) < 0.02;
RadarPost(1) = 0;

dRadarPost = [0, diff(RadarPost), 0];

starts = find(dRadarPost == 1);
ends = find(dRadarPost == -1);
numSearch = round(min([length(starts),length(ends)]) / 2);

[~, idx] = max(ends(1:numSearch) - starts(1:numSearch));

syncIdx = starts(idx);
syncIdx = 4251;

figure(1); clf
plot(RadarTrig)
hold on
plot([syncIdx, syncIdx], [-1, 1], LineWidth=1);
xlim([0.95*syncIdx, 1.01*syncIdx])

%% Section 2: Synchronise data

times_uwb = times_qtm(syncIdx) + (uwb_time_since_beep_ms / 1000);
qtm_125hz_times = (0 : 4999) / 125;

% 10 Hz LPF
[b, a] = butter(4, (10 * mean(diff(uwb_time_since_beep_ms'),'all') / 1000) * 2);

% Synchronise to 125 Hz UWB time
S11_R_sync = zeros(51,5000);
S11_I_sync = zeros(51,5000);
S22_R_sync = zeros(51,5000);
S22_I_sync = zeros(51,5000);
S12_R_sync = zeros(51,5000);
S12_I_sync = zeros(51,5000);
S21_R_sync = zeros(51,5000);
S21_I_sync = zeros(51,5000);
for freq = 1 : 51
    S11_R_filt = filtfilt(b, a, S11_R(freq,:));
    S11_R_sync(freq, :) = interp1(times_uwb(freq,:), S11_R_filt, qtm_125hz_times, "spline", nan);

    S11_I_filt = filtfilt(b, a, S11_I(freq,:));
    S11_I_sync(freq, :) = interp1(times_uwb(freq,:), S11_I_filt, qtm_125hz_times, "spline", nan);

    S22_R_filt = filtfilt(b, a, S22_R(freq,:));
    S22_R_sync(freq, :) = interp1(times_uwb(freq,:), S22_R_filt, qtm_125hz_times, "spline", nan);
  
    S22_I_filt = filtfilt(b, a, S22_I(freq,:));
    S22_I_sync(freq, :) = interp1(times_uwb(freq,:), S22_I_filt, qtm_125hz_times, "spline", nan);

    S12_R_filt = filtfilt(b, a, S12_R(freq,:));
    S12_R_sync(freq, :) = interp1(times_uwb(freq,:), S12_R_filt, qtm_125hz_times, "spline", nan);
  
    S12_I_filt = filtfilt(b, a, S12_I(freq,:));
    S12_I_sync(freq, :) = interp1(times_uwb(freq,:), S12_I_filt, qtm_125hz_times, "spline", nan);

    S21_R_filt = filtfilt(b, a, S21_R(freq,:));
    S21_R_sync(freq, :) = interp1(times_uwb(freq,:), S21_R_filt, qtm_125hz_times, "spline", nan);
  
    S21_I_filt = filtfilt(b, a, S21_I(freq,:));
    S21_I_sync(freq, :) = interp1(times_uwb(freq,:), S21_I_filt, qtm_125hz_times, "spline", nan);
end

grf_r = qtmFile.(fieldName{1}).Force(2).Force(3,:);
figure(2); clf
plot(GaitCycleSplit(grf_r, S22_R_sync(10,:),qtm_125hz_times))

figure(3); clf
tiledlayout(2, 4)
nexttile; plot(S11_R_sync')
nexttile; plot(S12_R_sync')
nexttile; plot(S21_R_sync')
nexttile; plot(S22_R_sync')
nexttile; plot(S11_I_sync')
nexttile; plot(S12_I_sync')
nexttile; plot(S21_I_sync')
nexttile; plot(S22_I_sync')

%% Section 3: Save output

save(outName,"S11_R_sync","S11_I_sync","S22_R_sync","S22_I_sync", ...
    "S12_R_sync","S12_I_sync","S21_R_sync","S21_I_sync");
