%% Validation of symmetry between left and right limbs during walking
% Section 1: This script runs on a PID and trial-specific basis
%            - Gets the inverse kinematics and dynamics files to grab the
%              knee and ankle torques and ground reaction forces.
% Section 2: Comparison of both left and right knee and ankle torques and
%            angles, including the RMSE and NRMSE
% Section 3: Comparison of the polar measurements of ground reaction forces
%            of the left and right limb, including magnitude, polar, and 
%            azimuth angles.
% Section 4: Comparison of duty factors between every gait cycle in the
%            trial, and between the mean gait cycle duty factors of each
%            limb.
%% Section 1: Specify PID and Trial To Be Analysed
clear
PID = '10';
Trial = '27';
nMin = 12;
[b_grf_lp, a_grf_lp] = butter(6, 10/(1250/2));

path = 'C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data';
ikid_path = fullfile(path, ['EXO_UWB\Data\ExoUWB_S', PID, '\Scaling, IK, ID OUTPUT']);
ik_file = readtable(fullfile(ikid_path, ['ExoUWB_S', PID, '_Trial_00', Trial, '_IK.mot']), "FileType", "text");
id_file = readtable(fullfile(ikid_path, ['ExoUWB_S', PID, '_Trial_00', Trial, '_ID_Resampled.mot']), "FileType", "text");

left_kneeAngle = ik_file.knee_angle_l;  left_ankleAngle = ik_file.ankle_angle_l;
right_kneeAngle = ik_file.knee_angle_r; right_ankleAngle = ik_file.ankle_angle_r;
left_kneeTorque = id_file.knee_angle_l_moment; left_ankleTorque = id_file.ankle_angle_l_moment;
right_kneeTorque = id_file.knee_angle_r_moment; right_ankleTorque = id_file.ankle_angle_r_moment;

qtm_path = fullfile(path, ['EXO_UWB\Data\ExoUWB_S', PID]);
qtm_file = load(fullfile(qtm_path, ['ExoUWB_S', PID, '_Trial_00', Trial, '.mat']));
fieldName = fields(qtm_file);

left_grfx = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(1).Force(1,:));  
left_grfy = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(1).Force(2,:)); 
left_grfz = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(1).Force(3,:));
right_grfx = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(2).Force(1,:)); 
right_grfy = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(2).Force(2,:)); 
right_grfz = filtfilt(b_grf_lp, a_grf_lp, qtm_file.(fieldName{1}).Force(2).Force(3,:)); 
times_ik = ik_file.time; times_id = id_file.time;

times_qtm = (0:49999)/1250;
full_time = 0:1:100;
%% Section 2: Angle and Torque Comparisons
% Knee Angles
l_kneeAngle_split = GaitCycleSplit(left_grfz, left_kneeAngle, times_ik, 100);
l_kneeAngle_splitClean = GaitCycleRemoveOutliers(l_kneeAngle_split, nMin);
l_kneeAngle_avg = interp1(1:1:100, mean(l_kneeAngle_splitClean, 2), full_time, "spline", "extrap")';

r_kneeAngle_split = GaitCycleSplit(right_grfz, right_kneeAngle, times_ik, 100);
r_kneeAngle_splitClean = GaitCycleRemoveOutliers(r_kneeAngle_split, nMin);
r_kneeAngle_avg = interp1(1:1:100, mean(r_kneeAngle_splitClean, 2), full_time, "spline", "extrap")';

% Ankle Angles
l_ankleAngle_split = GaitCycleSplit(left_grfz, left_ankleAngle, times_ik, 100);
l_ankleAngle_splitClean = GaitCycleRemoveOutliers(l_ankleAngle_split, nMin);
l_ankleAngle_avg = interp1(1:1:100, mean(l_ankleAngle_splitClean, 2), full_time, "spline", "extrap")';

r_ankleAngle_split = GaitCycleSplit(right_grfz, right_ankleAngle, times_ik, 100);
r_ankleAngle_splitClean = GaitCycleRemoveOutliers(r_ankleAngle_split, nMin);
r_ankleAngle_avg = interp1(1:1:100, mean(r_ankleAngle_splitClean, 2), full_time, "spline", "extrap")';

% Knee Torques
l_kneeTorque_split = GaitCycleSplit(left_grfz, left_kneeTorque, times_ik, 100);
l_kneeTorque_splitClean = GaitCycleRemoveOutliers(l_kneeTorque_split, nMin);
l_kneeTorque_avg = interp1(1:1:100, mean(l_kneeTorque_splitClean, 2), full_time, "spline", "extrap")';

r_kneeTorque_split = GaitCycleSplit(right_grfz, right_kneeTorque, times_ik, 100);
r_kneeTorque_splitClean = GaitCycleRemoveOutliers(r_kneeTorque_split, nMin);
r_kneeTorque_avg = interp1(1:1:100, mean(r_kneeTorque_splitClean, 2), full_time, "spline", "extrap")';

% Ankle Torques
l_ankleTorque_split = GaitCycleSplit(left_grfz, left_ankleTorque, times_ik, 100);
l_ankleTorque_splitClean = GaitCycleRemoveOutliers(l_ankleTorque_split, nMin);
l_ankleTorque_avg = interp1(1:1:100, mean(l_ankleTorque_splitClean, 2), full_time, "spline", "extrap")';

r_ankleTorque_split = GaitCycleSplit(right_grfz, right_ankleTorque, times_ik, 100);
r_ankleTorque_splitClean = GaitCycleRemoveOutliers(r_ankleTorque_split, nMin);
r_ankleTorque_avg = interp1(1:1:100, mean(r_ankleTorque_splitClean, 2), full_time, "spline", "extrap")';

% NRMSE
kneeAngle_rmse = sqrt(MSE(l_kneeAngle_avg, r_kneeAngle_avg));
kneeAngle_mean = mean([l_kneeAngle_avg, r_kneeAngle_avg], 2);
kneeAngle_nrmse = kneeAngle_rmse / (max(kneeAngle_mean) - min(kneeAngle_mean));

ankleAngle_rmse = sqrt(MSE(l_ankleAngle_avg, r_ankleAngle_avg));
ankleAngle_mean = mean([l_ankleAngle_avg, r_ankleAngle_avg], 2);
ankleAngle_nrmse = ankleAngle_rmse / (max(ankleAngle_mean) - min(ankleAngle_mean));

kneeTorque_rmse = sqrt(MSE(l_kneeTorque_avg, r_kneeTorque_avg));
kneeTorque_mean = mean([l_kneeTorque_avg, r_kneeTorque_avg], 2);
kneeTorque_nrmse = kneeTorque_rmse / (max(kneeTorque_mean) - min(kneeTorque_mean));

ankleTorque_rmse = sqrt(MSE(l_ankleTorque_avg, r_ankleTorque_avg));
ankleTorque_mean = mean([l_ankleTorque_avg, r_ankleTorque_avg], 2);
ankleTorque_nrmse = ankleTorque_rmse / (max(ankleTorque_mean) - min(ankleTorque_mean));

% Plot
figure(1); clf; tiledlayout('Flow')
nexttile; hold on; title('Knee Angles');
plot(0:1:100, l_kneeAngle_avg); plot(0:1:100, r_kneeAngle_avg);
legend('Left', 'Right'); 
text(0.05,0.95, "NRMSE = " + string(kneeAngle_nrmse) + newline + 'RMSE = ' + string(kneeAngle_rmse), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
nexttile; hold on; title('Ankle Angles');
plot(0:1:100, l_ankleAngle_avg); plot(0:1:100, r_ankleAngle_avg);
legend('Left', 'Right')
text(0.05,0.95, "NRMSE = " + string(ankleAngle_nrmse) + newline + 'RMSE = ' + string(ankleAngle_rmse), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

nexttile; hold on; title('Knee Torques');
plot(0:1:100, l_kneeTorque_avg); plot(0:1:100, r_kneeTorque_avg);
legend('Left', 'Right')
text(0.05,0.95, "NRMSE = " + string(kneeTorque_nrmse) + newline + 'RMSE = ' + string(kneeTorque_rmse), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
nexttile; hold on; title('Ankle Torques');
plot(0:1:100, l_ankleTorque_avg); plot(0:1:100, r_ankleTorque_avg);
legend('Left', 'Right')
text(0.05,0.95, "NRMSE = " + string(ankleTorque_nrmse) + newline + 'RMSE = ' + string(ankleTorque_rmse), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%% Section 3: GRF Comparisons

l_grfz_split = GaitCycleSplit(left_grfz, left_grfz, times_qtm, 100);
r_grfz_split = GaitCycleSplit(right_grfz, right_grfz, times_qtm, 100);

% Magnitude
l_grfMag = sqrt(left_grfx.^2 + left_grfy.^2 + left_grfz.^2);
r_grfMag = sqrt(right_grfx.^2 + right_grfy.^2 + right_grfz.^2);

l_grfMag_split = GaitCycleSplit(left_grfz, l_grfMag, times_qtm, 100);
l_grfMag_splitClean = GaitCycleRemoveOutliersv2(l_grfMag_split, l_grfz_split, nMin);
l_grfMag_avg = interp1(1:1:100, mean(l_grfMag_splitClean, 2), full_time, "spline", "extrap")';

r_grfMag_split = GaitCycleSplit(right_grfz, r_grfMag, times_qtm, 100);
r_grfMag_splitClean = GaitCycleRemoveOutliersv2(r_grfMag_split, r_grfz_split, nMin);
r_grfMag_avg = interp1(1:1:100, mean(r_grfMag_splitClean, 2), full_time, "spline", "extrap")';

% Polar angle
l_grfPhi = acos(left_grfz ./ l_grfMag);
r_grfPhi = acos(right_grfz ./ r_grfMag);

l_grfPhi_split = GaitCycleSplit(left_grfz, l_grfPhi, times_qtm, 100);
l_grfPhi_splitClean = GaitCycleRemoveOutliersv2(l_grfPhi_split, l_grfz_split, nMin);
l_grfPhi_avg = interp1(1:1:100, mean(l_grfPhi_splitClean, 2), full_time, "spline", "extrap")';

r_grfPhi_split = GaitCycleSplit(right_grfz, r_grfPhi, times_qtm, 100);
r_grfPhi_splitClean = GaitCycleRemoveOutliersv2(r_grfPhi_split, r_grfz_split, nMin);
r_grfPhi_avg = interp1(1:1:100, mean(r_grfPhi_splitClean, 2), full_time, "spline", "extrap")';

% Azimuth angle
l_grfTheta = atan(left_grfy ./ left_grfx);
r_grfTheta = -atan(right_grfy ./ right_grfx);

l_grfTheta_split = GaitCycleSplit(left_grfz, l_grfTheta, times_qtm, 100);
l_grfTheta_splitClean = GaitCycleRemoveOutliersv2(l_grfTheta_split, l_grfz_split, nMin);
l_grfTheta_avg = interp1(1:1:100, mean(l_grfTheta_splitClean, 2), full_time, "spline", "extrap")';

r_grfTheta_split = GaitCycleSplit(right_grfz, r_grfTheta, times_qtm, 100);
r_grfTheta_splitClean = GaitCycleRemoveOutliersv2(r_grfTheta_split, r_grfz_split, nMin);
r_grfTheta_avg = interp1(1:1:100, mean(r_grfTheta_splitClean, 2), full_time, "spline", "extrap")';

% NRMSE
mag_rmse = sqrt(MSE(l_grfMag_avg, r_grfMag_avg));
mag_mean = mean([l_grfMag_avg, r_grfMag_avg], 2);
mag_nrmse = mag_rmse / (max(mag_mean) - min(mag_mean));

phi_rmse = sqrt(MSE(l_grfPhi_avg, r_grfPhi_avg));
phi_mean = mean([l_grfPhi_avg, r_grfPhi_avg], 2);
phi_nrmse = phi_rmse / (max(phi_mean) - min(phi_mean));

theta_rmse = sqrt(MSE(l_grfTheta_avg, r_grfTheta_avg));
theta_mean = mean([l_grfTheta_avg, r_grfTheta_avg], 2);
theta_nrmse = theta_rmse / (max(theta_mean) - min(theta_mean));

% Plots
figure(2); clf; tiledlayout(2, 2)
nexttile([1 2]); hold on; title('GRF magnitude')
plot(l_grfMag_avg); plot(r_grfMag_avg); legend("Left", "Right")
text(0.05, 0.95, "NRMSE = " + string(mag_nrmse) + newline + 'RMSE = ' + string(mag_rmse), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

nexttile; hold on; title('GRF polar angle')
plot(l_grfPhi_avg); plot(r_grfPhi_avg); legend("Left", "Right")
text(0.05, 0.95, "NRMSE = " + string(phi_nrmse) + newline + 'RMSE = ' + string(phi_rmse), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

nexttile; hold on; title('GRF azimuth angle')
plot(l_grfTheta_avg); plot(r_grfTheta_avg); legend("Left", "Right")
text(0.05, 0.95, "NRMSE = " + string(theta_nrmse)+ newline + 'RMSE = ' + string(theta_rmse), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
%% Section 4: Duty Factor

l_grfMag_raw = sqrt(qtm_file.(fieldName{1}).Force(1).Force(1,:) .^2 + ...
                    qtm_file.(fieldName{1}).Force(1).Force(2,:) .^2 + ...
                    qtm_file.(fieldName{1}).Force(1).Force(3,:) .^2);

r_grfMag_raw = sqrt(qtm_file.(fieldName{1}).Force(2).Force(1,:) .^2 + ...
                    qtm_file.(fieldName{1}).Force(2).Force(2,:) .^2 + ...
                    qtm_file.(fieldName{1}).Force(2).Force(3,:) .^2);

grf_threshold = 150;    % Threshold for detecting steps
Fs_grf = 1250;          % GRF sampling rate (fixed 1.25kHz)

grf_times = (0 : (length(l_grfMag_raw)-1)) / Fs_grf;

% Very low cut-off (4Hz) to minimise false positives
[b,a] = butter(4, 4/(Fs_grf/2));
GrfL_filt = filtfilt(b, a, l_grfMag_raw);
GrfR_filt = filtfilt(b, a, r_grfMag_raw);

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

% Left leg
% Start with first recorded heel strike
if heelStrikeLIdcs(1) > toeOffLIdcs(1)
    toeOffLIdcs_new = toeOffLIdcs(2:end);
else
    toeOffLIdcs_new =toeOffLIdcs(1:end);
end
% End with last recorded heel strike
if toeOffLIdcs_new(end) > heelStrikeLIdcs(end)
    toeOffLIdcs_new = toeOffLIdcs_new(1:end-1);
else
    toeOffLIdcs_new = toeOffLIdcs_new(1:end);
end

l_dutyFactor = zeros(1, length(toeOffLIdcs_new));

for i = 1:length(toeOffLIdcs_new)
    strideDuration = heelStrikeLIdcs(i+1) - heelStrikeLIdcs(i);
    stanceDuration = toeOffLIdcs_new(i) - heelStrikeLIdcs(i) ;
    l_dutyFactor(i) = stanceDuration / strideDuration;
end

% Right leg
% Start with first recorded heel strike
if heelStrikeRIdcs(1) > toeOffRIdcs(1)
    toeOffRIdcs_new = toeOffRIdcs(2:end);
else
    toeOffRIdcs_new =toeOffRIdcs(1:end);
end
% End with last recorded heel strike
if toeOffRIdcs_new(end) > heelStrikeRIdcs(end)
    toeOffRIdcs_new = toeOffRIdcs_new(1:end-1);
else
    toeOffRIdcs_new = toeOffRIdcs_new(1:end);
end

r_dutyFactor = zeros(1, length(toeOffRIdcs_new));

for i = 1:length(toeOffRIdcs_new)
    strideDuration = heelStrikeRIdcs(i+1) - heelStrikeRIdcs(i);
    stanceDuration = toeOffRIdcs_new(i) - heelStrikeRIdcs(i) ;
    r_dutyFactor(i) = stanceDuration / strideDuration;
end

% Plots
figure(3); clf; hold on; title("Duty Factor")
plot(l_dutyFactor,'linestyle','none','marker','o')
plot(r_dutyFactor,'linestyle','none','marker','^')
legend("Left (Mean = " + string(mean(l_dutyFactor)) + ")", ...
       "Right (Mean = " + string(mean(r_dutyFactor)) + ")")
