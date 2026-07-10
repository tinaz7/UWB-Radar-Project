%% Script to resample all ID.sto files to match timestamps of IK.sto files
%  Completed on a participant specific basis
% Section 1: Specify PID to be processed and find location and names of all
%            IK, ID, and exo files
% Section 2: Resample all ID files to match the timestamps of the IK files
%            and subtract exo torques from resampled data
%            - Completes processing of all ID files in folder of specified
%              PID and saves as new ID_resampled.sto file
%% Section 1: Select PID and grab all raw IK, ID and exo files
clear

IKID_dir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\EXO_UWB\Data";
Exo_dir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\Exo";

% Select PID to process
PID = "01";

IKID_path = fullfile(IKID_dir, "ExoUWB_S" + PID, "Scaling, IK, ID OUTPUT");
IKFiles = dir(fullfile(IKID_path, '*IK.mot'));
IDFiles = dir(fullfile(IKID_path, '*ID.sto'));

Exo_path = fullfile(Exo_dir, "S" + PID);
ExoFiles = dir(fullfile(Exo_path, 'Trial_*'));

AllFileDir = strings(length(ExoFiles), 3);

for i = 1 : length(ExoFiles)
    AllFileDir(i, 1) = replace(ExoFiles(i).name, '.mat','');
    AllFileDir(i, 2) = IKFiles(find(contains({IKFiles.name}, AllFileDir(i, 1)))).name;
    AllFileDir(i, 3) = IDFiles(find(contains({IDFiles.name}, AllFileDir(i, 1)))).name;
end

AllFileDir = array2table(AllFileDir, 'VariableNames', {'Trial', 'IK Name', 'ID Name'});

%% Section 2: Resample and account for exo torques
for k = 1 : height(AllFileDir)
    IKfullFileName = fullfile(IKID_path, AllFileDir{k, "IK Name"});
    IKData = readtable(IKfullFileName, "FileType", "text");

    IDfullFileName = fullfile(IKID_path, AllFileDir{k, "ID Name"});
    IDData = readtable(IDfullFileName, "FileType", "text");

    ExofullFileName = fullfile(Exo_path, AllFileDir{k, "Trial"} + ".mat");
    ExoData = importdata(ExofullFileName);

    % Resampling ID to IK times
    IDResampled = interp1(IDData{:,1}, IDData{:,2:end}, IKData{:,1}, "spline");
    IDTable = array2table([IKData{:,1}, IDResampled], "VariableNames", IDData.Properties.VariableNames);

    % Subtracting exo torque
    Exo_L = ExoData.Exo_L';
    Exo_R = ExoData.Exo_R';

    ankle_angle_r_moment = IDTable{:, "ankle_angle_r_moment"};
    ankle_angle_l_moment = IDTable{:, "ankle_angle_l_moment"};

    % Plots of left and right ankle torques before accounting for exo
    figure(1); clf; hold on
    plot(ankle_angle_l_moment)
    figure(2); clf; hold on
    plot(ankle_angle_r_moment)

    IDTable{:, "ankle_angle_r_moment"} = ankle_angle_r_moment - Exo_R;
    IDTable{:, "ankle_angle_l_moment"} = ankle_angle_l_moment - Exo_L;

    % Plots of left and right ankle torques after accounting for exo
    figure(3); clf hold on
    plot(IDTable{:, "ankle_angle_l_moment"})
    figure(4); clf; hold on
    plot(IDTable{:, "ankle_angle_r_moment"})

    % Save resampled + exo subtracted ID data as new .mot file
    newFileName = replace(IDfullFileName,'ID.sto', 'ID_Resampled.mot');
    fid = fopen(newFileName, 'w');
    fprintf(fid, 'Inverse Dynamics Generalized Forces\n');
    fprintf(fid, 'version=1\n');
    fprintf(fid, 'nRows=5000\n');
    fprintf(fid, 'nColumns=26\n');
    fprintf(fid, 'inDegrees=no\n');
    fprintf(fid, 'endheader\n');

    headers = IDData.Properties.VariableNames;
    fprintf(fid, '%s\t', headers{1:end});
    
    fclose(fid);
    writetable(IDTable, newFileName, 'WriteMode', 'Append', 'FileType', 'text', 'Delimiter', '\t');
end

