%% Sync left and right exo torques with QTM timestamps
%  - Syncrhonises peak FSR times with peak GRF times, which reflect toe-off
% Section 1: Specify locations to find exo and qtm files
% Section 2: Determine times of peak toe-off in complete steps in the QTM
%            GRF data
% Section 3: Determine the times of the corresponding peak FSR in the exo
%            data
% Section 4: Convert the exo timestamps into QTM time
% Section 5: Resample exo torque data to match QTM peak GRF timestamps
%% Section 1: Specify locations and find files
clear variables
myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data";

PID = '10';
n = '02';
ExoFile = 'S10-ExoUWB-2026-04-08_14-12.mat';
ExoStartIdx = 15725;

load(ExoFile);
qtmFile = load(fullfile(myDir, "EXO_UWB\Data", "ExoUWB_S" + PID, "ExoUWB_S" + PID + "_Trial_00" + n + ".mat"));
outName = fullfile(myDir, "Exo", "S" + PID, "Trial_00" + n + ".mat");

field = fields(qtmFile);

ExoIdx = 1:length(ExoSync);

QtmExoSync = qtmFile.(field{1}).Analog(1).Data(16,:);

QtmExoTimeStamps = (0:49999)/1250;

QtmExoEdgeIdx = find(abs(diff(QtmExoSync)) > 1.5);

% Define transition time as half-way between the low/high points
QtmExoEdgeTimes = mean([QtmExoTimeStamps(QtmExoEdgeIdx); QtmExoTimeStamps(QtmExoEdgeIdx+1)]);

% Find the first n transition points after 'ExoStartIdx'
ExoEdgeIdx = ExoStartIdx - 0.5 + find(abs(diff(ExoSync(ExoStartIdx:end))), length(QtmExoEdgeIdx));

linFit = fitlm(ExoEdgeIdx, QtmExoEdgeTimes);

if linFit.Rsquared.Adjusted < 0.99995
    disp("Could Not Fit!");
    return
end
disp(linFit.Rsquared.Adjusted)

ApproxExoTimeStamps = linFit.Coefficients.Estimate(1) + ...
    ExoIdx * linFit.Coefficients.Estimate(2);

ExoSampleRate = 1 / linFit.Coefficients.Estimate(2);

[b, a] = butter(4, 10 / (ExoSampleRate / 2));

ExoLTorqueFilt = filtfilt(b, a, ExoLTorque);
ExoRTorqueFilt = filtfilt(b, a, ExoRTorque);

%% Section 2: Determine times of peak toe-off in complete steps in GRF

GrfL = sqrt(qtmFile.(field{1}).Force(1).Force(1,:) .^2 + ...
            qtmFile.(field{1}).Force(1).Force(2,:) .^2 + ...
            qtmFile.(field{1}).Force(1).Force(3,:) .^2);

GrfR = sqrt(qtmFile.(field{1}).Force(2).Force(1,:) .^2 + ...
            qtmFile.(field{1}).Force(2).Force(2,:) .^2 + ...
            qtmFile.(field{1}).Force(2).Force(3,:) .^2);

grf_threshold = 150;    % Threshold for detecting steps
Fs_grf = 1250;          % GRF sampling rate (fixed 1.25kHz)

grf_times = (0 : (length(GrfL)-1)) / Fs_grf;

% Very low cut-off (4Hz) to minimise false positives
[b,a] = butter(4, 4/(Fs_grf/2));
GrfL_filt = filtfilt(b, a, GrfL);
GrfR_filt = filtfilt(b, a, GrfR);

% All peaks
[~,GrfPkL_idx] = findpeaks(GrfL_filt);
[~,GrfPkR_idx] = findpeaks(GrfR_filt);

% Heel strikes and toe-offs
heelStrikeLIdcs = find([(GrfL_filt(1:end-1) < grf_threshold) & ...
    (GrfL_filt(2:end) >= grf_threshold),0]);
toeOffLIdcs = find([(GrfL_filt(1:end-1) > grf_threshold) & ...
    (GrfL_filt(2:end) <= grf_threshold),0]);
heelStrikeRIdcs = find([(GrfR_filt(1:end-1) < grf_threshold) & ...
    (GrfR_filt(2:end) >= grf_threshold),0]);
toeOffRIdcs = find([(GrfR_filt(1:end-1) > grf_threshold) & ...
    (GrfR_filt(2:end) <= grf_threshold),0]);

% Indices of peak grf that should line up with peak exo times
GrfPeakLIdcs = [];
for i = 1 : length(heelStrikeLIdcs)
    % Only accepts first toe-off if it also has heel-strike
    heelStrikeLIdx = heelStrikeLIdcs(i);
    % Find the corresponding toe-off from heelStrike
    toeOffLIdx = min(toeOffLIdcs(toeOffLIdcs > heelStrikeLIdx));
    if isempty(toeOffLIdx)
        % Incomplete step at end
        continue
    end
    GrfPeakLIdx = max(GrfPkL_idx(GrfPkL_idx < toeOffLIdx & GrfPkL_idx > heelStrikeLIdx));
    if isempty(GrfPeakLIdx)
        % Couldn't find peak inside step. Very very bad.
        disp("Couldn't find peak inside step!! Double-check everything");
        return;
    end
    GrfPeakLIdcs = [GrfPeakLIdcs, GrfPeakLIdx];
end

GrfPeakRIdcs = [];
for i = 1 : length(heelStrikeRIdcs)
    % Only accepts first toe-off if it also has heel-strike
    heelStrikeRIdx = heelStrikeRIdcs(i);
    % Find the corresponding toe-off from heelStrike
    toeOffRIdx = min(toeOffRIdcs(toeOffRIdcs > heelStrikeRIdx));
    if isempty(toeOffRIdx)
        % Incomplete step at end
        continue
    end
    GrfPeakRIdx = max(GrfPkR_idx(GrfPkR_idx < toeOffRIdx & GrfPkR_idx > heelStrikeRIdx));
    if isempty(GrfPeakRIdx)
        % Couldn't find peak inside step. Very very bad.
        disp("Couldn't find peak inside step!! Double-check everything");
        return;
    end
    GrfPeakRIdcs = [GrfPeakRIdcs, GrfPeakRIdx];
end

GrfPeakLTimes = grf_times(GrfPeakLIdcs);
GrfPeakRTimes = grf_times(GrfPeakRIdcs);

%% Section 3: Determine corresponding peak FSR times.


ApproxFsrPeakLTimes = (GrfPeakLTimes - linFit.Coefficients.Estimate(1)) ...
    / linFit.Coefficients.Estimate(2);

ApproxFsrPeakRTimes = (GrfPeakRTimes - linFit.Coefficients.Estimate(1)) ...
    / linFit.Coefficients.Estimate(2);

% Very low cut-off to minimise false positives
[b, a] = butter(4, 4 / (ExoSampleRate / 2));
ExoLFsrFilt = filtfilt(b, a, LFsr);
ExoRFsrFilt = filtfilt(b, a, RFsr);

ExoLFsrFilt(ExoLFsrFilt < 0.5) = 0;
ExoRFsrFilt(ExoRFsrFilt < 0.5) = 0;
[~, AllFsrPeakLTimes] = findpeaks(ExoLFsrFilt);
[~, AllFsrPeakRTimes] = findpeaks(ExoRFsrFilt);

FsrPeakLIdcs = zeros(1,length(ApproxFsrPeakLTimes));
for i = 1 : length(ApproxFsrPeakLTimes)
    [~, idx] = min(abs(ApproxFsrPeakLTimes(i) - AllFsrPeakLTimes));
    FsrPeakLIdcs(i) = AllFsrPeakLTimes(idx);
end

FsrPeakRIdcs = zeros(1,length(ApproxFsrPeakRTimes));
for i = 1 : length(ApproxFsrPeakRTimes)
    [~, idx] = min(abs(ApproxFsrPeakRTimes(i) - AllFsrPeakRTimes));
    FsrPeakRIdcs(i) = AllFsrPeakRTimes(idx);
end


%% Section 4: Convert exo timestamps into QTM time

ExoIdcsSync = [FsrPeakRIdcs,FsrPeakLIdcs];
QtmTimesSync = [GrfPeakRTimes,GrfPeakLTimes];
ExoTimesSync = interp1(ExoIdcsSync, QtmTimesSync, ExoIdx, 'spline', nan);

linFit = fitlm(ExoIdcsSync, QtmTimesSync);
if linFit.Rsquared.Adjusted < 0.99995
    disp("Could Not Fit Final!");
    return
end
disp(linFit.Rsquared.Adjusted)

ExoTimesSync2 = interp1(ExoIdcsSync, QtmTimesSync, ExoIdx, 'linear', 'extrap');

ExoTimesSync(isnan(ExoTimesSync)) = ExoTimesSync2(isnan(ExoTimesSync));

%% Section 5: Resample torque data based on new Exo times

outputTimes = (0:4999) / 125;

Exo_L = -interp1(ExoTimesSync, ExoLTorqueFilt, outputTimes, 'spline');
Exo_R = interp1(ExoTimesSync, ExoRTorqueFilt, outputTimes, 'spline');

save(outName, "Exo_R", "Exo_L");

figure(1); clf
plot(Exo_L);
figure(2); clf
plot(Exo_R);

figure(3); clf; hold on
plot(outputTimes, -Exo_L)
plot(QtmExoTimeStamps,GrfL/100)