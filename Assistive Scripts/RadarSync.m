%% Synchronise radar data to sync triggers from QTM files
%  Section 1: Select files, including UWB radar data file and corresponding
%             QTM file for sync trigger pulses
%  Section 2: Synchronise UWB radar data to identified QTM trigger syncs
%  Section 3: Save output of each coefficient component of synchronised
%             gait cycle
%% Section 1: Select files
clear variables;

path = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data";
uwbFileName = fullfile(path,"UWB\S03\Raw data\VNA Data 2026_03_11 16-18-39_clean");
qtmFileName = fullfile(path,"EXO_UWB\Data\ExoUWB_S03\ExoUWB_S03_Trial_0015.mat");
outName = fullfile(path, "UWB\S03\RadarData_S03_Trial_0015.mat");

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
% syncIdx = 4251;

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
S11_MdB_sync = zeros(51,5000);
S11_P_sync = zeros(51,5000);
S22_MdB_sync = zeros(51,5000);
S22_P_sync = zeros(51,5000);
S12_MdB_sync = zeros(51,5000);
S12_P_sync = zeros(51,5000);
S21_MdB_sync = zeros(51,5000);
S21_P_sync = zeros(51,5000);
for freq = 1 : 51
    S11_MdB_filt = filtfilt(b, a, S11_MdB(freq,:));
    S11_MdB_sync(freq, :) = interp1(times_uwb(freq,:), S11_MdB_filt, qtm_125hz_times, "spline", nan);
  
    S11_P_filt = filtfilt(b, a, S11_P(freq,:));
    S11_P_sync(freq, :) = interp1(times_uwb(freq,:), S11_P_filt, qtm_125hz_times, "spline", nan);

    S22_MdB_filt = filtfilt(b, a, S22_MdB(freq,:));
    S22_MdB_sync(freq, :) = interp1(times_uwb(freq,:), S22_MdB_filt, qtm_125hz_times, "spline", nan);
  
    S22_P_filt = filtfilt(b, a, S22_P(freq,:));
    S22_P_sync(freq, :) = interp1(times_uwb(freq,:), S22_P_filt, qtm_125hz_times, "spline", nan);

    S12_MdB_filt = filtfilt(b, a, S12_MdB(freq,:));
    S12_MdB_sync(freq, :) = interp1(times_uwb(freq,:), S12_MdB_filt, qtm_125hz_times, "spline", nan);
  
    S12_P_filt = filtfilt(b, a, S12_P(freq,:));
    S12_P_sync(freq, :) = interp1(times_uwb(freq,:), S12_P_filt, qtm_125hz_times, "spline", nan);

    S21_MdB_filt = filtfilt(b, a, S21_MdB(freq,:));
    S21_MdB_sync(freq, :) = interp1(times_uwb(freq,:), S21_MdB_filt, qtm_125hz_times, "spline", nan);
  
    S21_P_filt = filtfilt(b, a, S21_P(freq,:));
    S21_P_sync(freq, :) = interp1(times_uwb(freq,:), S21_P_filt, qtm_125hz_times, "spline", nan);
end


grf_r = qtmFile.(fieldName{1}).Force(2).Force(3,:);
figure(2); clf
plot(GaitCycleSplit(grf_r, S22_MdB_sync(10,:),qtm_125hz_times))

figure(3); clf
tiledlayout(2, 4)
nexttile; plot(S11_MdB_sync')
nexttile; plot(S12_MdB_sync')
nexttile; plot(S21_MdB_sync')
nexttile; plot(S22_MdB_sync')
nexttile; plot(S11_P_sync')
nexttile; plot(S12_P_sync')
nexttile; plot(S21_P_sync')
nexttile; plot(S22_P_sync')

%% Section 3: Save output

save(outName,"S11_MdB_sync","S11_P_sync","S22_MdB_sync","S22_P_sync", ...
    "S12_MdB_sync","S12_P_sync","S21_MdB_sync","S21_P_sync");
