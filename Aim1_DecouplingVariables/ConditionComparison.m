%% Comparison of Musculoskeletal Responses Between Different Conditions
% Section 1: Pool all data
%            - Find all participant data from gait cycle averaged datasets
%            - Sort data by condition so that each condition contains one
%              gait cycle from all 10 participants
% Section 2: Plot Level vs. Incline data at no assistance and 100% PWS
% Section 3: Plot Assistance vs. No Assistance data at level and 100% PWS
% Section 4: Plot Slow vs. Medium vs. Fast data at level and no assistance
%% Section 1: Pool All Data
clear

myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged\Thesis Data";

PIDs = ['02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'];
gaitcycle = 0:1:100;
count = 0;

I0_A00_S085_MG = zeros(101, 10); I0_A00_S085_TA = zeros(101, 10);
I0_A00_S085_LG = zeros(101, 10); I0_A00_S085_SOL = zeros(101, 10);
I0_A00_S085_FL = zeros(101, 10); I0_A00_S085_FV = zeros(101, 10);
I0_A00_S085_FA = zeros(101, 10); I0_A00_S085_TL = zeros(101, 10);

I0_A00_S100_MG = zeros(101, 10); I0_A00_S100_TA = zeros(101, 10);
I0_A00_S100_LG = zeros(101, 10); I0_A00_S100_SOL = zeros(101, 10);
I0_A00_S100_FL = zeros(101, 10); I0_A00_S100_FV= zeros(101, 10); 
I0_A00_S100_FA = zeros(101, 10); I0_A00_S100_TL = zeros(101, 10);

I0_A00_S115_MG = zeros(101, 10); I0_A00_S115_TA = zeros(101, 10); 
I0_A00_S115_LG = zeros(101, 10); I0_A00_S115_SOL = zeros(101, 10);
I0_A00_S115_FL = zeros(101, 10); I0_A00_S115_FV = zeros(101, 10); 
I0_A00_S115_FA = zeros(101, 10); I0_A00_S115_TL = zeros(101, 10); 

I0_A15_S085_MG = zeros(101, 10); I0_A15_S085_TA = zeros(101, 10);
I0_A15_S085_LG = zeros(101, 10); I0_A15_S085_SOL = zeros(101, 10);
I0_A15_S085_FL = zeros(101, 10); I0_A15_S085_FV = zeros(101, 10);
I0_A15_S085_FA = zeros(101, 10); I0_A15_S085_TL = zeros(101, 10);

I0_A15_S100_MG = zeros(101, 10); I0_A15_S100_TA = zeros(101, 10);
I0_A15_S100_LG = zeros(101, 10); I0_A15_S100_SOL = zeros(101, 10);
I0_A15_S100_FL = zeros(101, 10); I0_A15_S100_FV = zeros(101, 10); 
I0_A15_S100_FA = zeros(101, 10); I0_A15_S100_TL = zeros(101, 10);

I0_A15_S115_MG = zeros(101, 10); I0_A15_S115_TA = zeros(101, 10);
I0_A15_S115_LG = zeros(101, 10); I0_A15_S115_SOL = zeros(101, 10);
I0_A15_S115_FL = zeros(101, 10); I0_A15_S115_FV = zeros(101, 10); 
I0_A15_S115_FA = zeros(101, 10); I0_A15_S115_TL = zeros(101, 10);

I5_A00_S085_MG = zeros(101, 10); I5_A00_S085_TA = zeros(101, 10);
I5_A00_S085_LG = zeros(101, 10); I5_A00_S085_SOL = zeros(101, 10);
I5_A00_S085_FL = zeros(101, 10); I5_A00_S085_FV = zeros(101, 10); 
I5_A00_S085_FA = zeros(101, 10); I5_A00_S085_TL = zeros(101, 10);

I5_A00_S100_MG = zeros(101, 10); I5_A00_S100_TA = zeros(101, 10); 
I5_A00_S100_LG = zeros(101, 10); I5_A00_S100_SOL = zeros(101, 10);
I5_A00_S100_FL = zeros(101, 10); I5_A00_S100_FV = zeros(101, 10); 
I5_A00_S100_FA = zeros(101, 10); I5_A00_S100_TL = zeros(101, 10); 

I5_A00_S115_MG = zeros(101, 10); I5_A00_S115_TA = zeros(101, 10); 
I5_A00_S115_LG = zeros(101, 10); I5_A00_S115_SOL = zeros(101, 10);
I5_A00_S115_FL = zeros(101, 10); I5_A00_S115_FV = zeros(101, 10); 
I5_A00_S115_FA= zeros(101, 10); I5_A00_S115_TL = zeros(101, 10); 

I5_A15_S085_MG = zeros(101, 10); I5_A15_S085_TA = zeros(101, 10);
I5_A15_S085_LG = zeros(101, 10); I5_A15_S085_SOL = zeros(101, 10);
I5_A15_S085_FL = zeros(101, 10); I5_A15_S085_FV = zeros(101, 10); 
I5_A15_S085_FA = zeros(101, 10); I5_A15_S085_TL = zeros(101, 10);

I5_A15_S100_MG = zeros(101, 10); I5_A15_S100_TL = zeros(101, 10);
I5_A15_S100_LG = zeros(101, 10); I5_A15_S100_SOL = zeros(101, 10);
I5_A15_S100_FL = zeros(101, 10); I5_A15_S100_FV = zeros(101, 10); 
I5_A15_S100_FA = zeros(101, 10); I5_A15_S100_TA = zeros(101, 10);

I5_A15_S115_MG = zeros(101, 10); I5_A15_S115_TA = zeros(101, 10);
I5_A15_S115_LG = zeros(101, 10); I5_A15_S115_SOL = zeros(101, 10);
I5_A15_S115_FL = zeros(101, 10); I5_A15_S115_FV = zeros(101, 10); 
I5_A15_S115_FA = zeros(101, 10); I5_A15_S115_TL = zeros(101, 10);

summary = readtable('GaitCycleSegmenting\Participant Data Summary Export.xlsx', 'Sheet', 'Data Collection', 'VariableNamingRule', 'preserve');

for k = 1:length(PIDs)

    % Load all PID data
    PID = PIDs(k,:);

    files = dir(fullfile(myDir, ['S', PID], '*.mat'));
    
    
    useIdx = find(and(strcmp(summary.PID, ['S', PID]), strcmp(summary.("Use?"), 'Use')));
    allFiles = strings(length(files), 6);
    
    for i = 1:12

        if length(num2str(summary{useIdx(i), "File Name"})) == 2
            allFiles(i,1) = "Trial_00" + summary{useIdx(i), "File Name"};
        else
            allFiles(i,1) = "Trial_000" + summary{useIdx(i), "File Name"};
        end
        
        allFiles(i, 2) = files(find(contains({files.name}', allFiles(i, 1)))).name;
        allFiles(i, 3) = summary{useIdx(i), "Condition"};
        allFiles(i, 4) = summary{useIdx(i), "Incline (degrees)"};
        allFiles(i, 5) = str2double(summary{useIdx(i), "Assistance (Nm/100kg)"});
        allFiles(i, 6) = str2double(summary{useIdx(i), "Speed (% PWS)"});
    end
    
    allFileTable = array2table(allFiles, "VariableNames", {'Trial', 'File Name', 'Condition', 'Incline', 'Assistance', 'Speed'});
    allFileStruct = table2struct(allFileTable);
    
    numFiles = 1;
    for j = 1:12
        file = load(fullfile(myDir, ['S', PID], files(numFiles).name));
        allFileStruct(j).('File') = file.ALL.ValDat;
        numFiles = numFiles + 1;
    end
    
    incline = [allFileStruct.Incline]'; 
    assistance = [allFileStruct.Assistance]'; 
    speed = [allFileStruct.Speed]';

    % Associate data to condition
    I0_A00_S085 = allFileStruct(find(strcmp(incline, "0") & strcmp(assistance, "0") & strcmp(speed, "85"))).File;
    I0_A00_S100 = allFileStruct(find(strcmp(incline, "0") & strcmp(assistance, "0") & strcmp(speed, "100"))).File;
    I0_A00_S115 = allFileStruct(find(strcmp(incline, "0") & strcmp(assistance, "0") & strcmp(speed, "115"))).File;
    
    I0_A15_S085 = allFileStruct(find(strcmp(incline, "0") & strcmp(assistance, "15") & strcmp(speed, "85"))).File;
    I0_A15_S100 = allFileStruct(find(strcmp(incline, "0") & strcmp(assistance, "15") & strcmp(speed, "100"))).File;
    I0_A15_S115 = allFileStruct(find(strcmp(incline, "0") & strcmp(assistance, "15") & strcmp(speed, "115"))).File;
    
    I5_A00_S085 = allFileStruct(find(strcmp(incline, "5") & strcmp(assistance, "0") & strcmp(speed, "85"))).File;
    I5_A00_S100 = allFileStruct(find(strcmp(incline, "5") & strcmp(assistance, "0") & strcmp(speed, "100"))).File;
    I5_A00_S115 = allFileStruct(find(strcmp(incline, "5") & strcmp(assistance, "0") & strcmp(speed, "115"))).File;
    
    I5_A15_S085 = allFileStruct(find(strcmp(incline, "5") & strcmp(assistance, "15") & strcmp(speed, "85"))).File;
    I5_A15_S100 = allFileStruct(find(strcmp(incline, "5") & strcmp(assistance, "15") & strcmp(speed, "100"))).File;
    I5_A15_S115 = allFileStruct(find(strcmp(incline, "5") & strcmp(assistance, "15") & strcmp(speed, "115"))).File;

    % Save data to condition
    % No incline, no assistance
    I0_A00_S085_MG(count*101+1:101*(count+1), k) = I0_A00_S085.MG(1:end);
    I0_A00_S085_LG(count*101+1:101*(count+1), k) = I0_A00_S085.LG(1:end);
    I0_A00_S085_SOL(count*101+1:101*(count+1), k) = I0_A00_S085.SOL(1:end);
    I0_A00_S085_TA(count*101+1:101*(count+1), k) = I0_A00_S085.TA(1:end);
    I0_A00_S085_TL(count*101+1:101*(count+1), k) = -I0_A00_S085.TL(1:end);
    I0_A00_S085_FL(count*101+1:101*(count+1), k) = I0_A00_S085.FL(1:end);
    I0_A00_S085_FV(count*101+1:101*(count+1), k) = I0_A00_S085.FV(1:end);

    I0_A00_S100_MG(count*101+1:101*(count+1), k) = I0_A00_S100.MG(1:end);
    I0_A00_S100_LG(count*101+1:101*(count+1), k) = I0_A00_S100.LG(1:end);
    I0_A00_S100_SOL(count*101+1:101*(count+1), k) = I0_A00_S100.SOL(1:end);
    I0_A00_S100_TA(count*101+1:101*(count+1), k) = I0_A00_S100.TA(1:end);
    I0_A00_S100_TL(count*101+1:101*(count+1), k) = -I0_A00_S100.TL(1:end);
    I0_A00_S100_FL(count*101+1:101*(count+1), k) = I0_A00_S100.FL(1:end);
    I0_A00_S100_FV(count*101+1:101*(count+1), k) = I0_A00_S100.FV(1:end);
    I0_A00_S100_FA(count*101+1:101*(count+1), k) = I0_A00_S100.FA(1:end);

    I0_A00_S115_MG(count*101+1:101*(count+1), k) = I0_A00_S115.MG(1:end);
    I0_A00_S115_LG(count*101+1:101*(count+1), k) = I0_A00_S115.LG(1:end);
    I0_A00_S115_SOL(count*101+1:101*(count+1), k) = I0_A00_S115.SOL(1:end);
    I0_A00_S115_TA(count*101+1:101*(count+1), k) = I0_A00_S115.TA(1:end);
    I0_A00_S115_TL(count*101+1:101*(count+1), k) = -I0_A00_S115.TL(1:end);
    I0_A00_S115_FL(count*101+1:101*(count+1), k) = I0_A00_S115.FL(1:end);
    I0_A00_S115_FV(count*101+1:101*(count+1), k) = I0_A00_S115.FV(1:end);
    I0_A00_S115_FA(count*101+1:101*(count+1), k) = I0_A00_S115.FA(1:end);
    % No incline, assistance
    I0_A15_S085_MG(count*101+1:101*(count+1), k) = I0_A15_S085.MG(1:end);
    I0_A15_S085_LG(count*101+1:101*(count+1), k) = I0_A15_S085.LG(1:end);
    I0_A15_S085_SOL(count*101+1:101*(count+1), k) = I0_A15_S085.SOL(1:end);
    I0_A15_S085_TA(count*101+1:101*(count+1), k) = I0_A15_S085.TA(1:end);
    I0_A15_S085_TL(count*101+1:101*(count+1), k) = -I0_A15_S085.TL(1:end);
    I0_A15_S085_FL(count*101+1:101*(count+1), k) = I0_A15_S085.FL(1:end);
    I0_A15_S085_FV(count*101+1:101*(count+1), k) = I0_A15_S085.FV(1:end);
    I0_A15_S085_FA(count*101+1:101*(count+1), k) = I0_A15_S085.FA(1:end);

    I0_A15_S100_MG(count*101+1:101*(count+1), k) = I0_A15_S100.MG(1:end);
    I0_A15_S100_LG(count*101+1:101*(count+1), k) = I0_A15_S100.LG(1:end);
    I0_A15_S100_SOL(count*101+1:101*(count+1), k) = I0_A15_S100.SOL(1:end);
    I0_A15_S100_TA(count*101+1:101*(count+1), k) = I0_A15_S100.TA(1:end);
    I0_A15_S100_TL(count*101+1:101*(count+1), k) = -I0_A15_S100.TL(1:end);
    I0_A15_S100_FL(count*101+1:101*(count+1), k) = I0_A15_S100.FL(1:end);
    I0_A15_S100_FV(count*101+1:101*(count+1), k) = I0_A15_S100.FV(1:end);
    I0_A15_S100_FA(count*101+1:101*(count+1), k) = I0_A15_S100.FA(1:end);

    I0_A15_S115_MG(count*101+1:101*(count+1), k) = I0_A15_S115.MG(1:end);
    I0_A15_S115_LG(count*101+1:101*(count+1), k) = I0_A15_S115.LG(1:end);
    I0_A15_S115_SOL(count*101+1:101*(count+1), k) = I0_A15_S115.SOL(1:end);
    I0_A15_S115_TA(count*101+1:101*(count+1), k) = I0_A15_S115.TA(1:end);
    I0_A15_S115_TL(count*101+1:101*(count+1), k) = -I0_A15_S115.TL(1:end);
    I0_A15_S115_FL(count*101+1:101*(count+1), k) = I0_A15_S115.FL(1:end);
    I0_A15_S115_FV(count*101+1:101*(count+1), k) = I0_A15_S115.FV(1:end);
    I0_A15_S115_FA(count*101+1:101*(count+1), k) = I0_A15_S115.FA(1:end);
    % Incline, no assistance
    I5_A00_S085_MG(count*101+1:101*(count+1), k) = I5_A00_S085.MG(1:end);
    I5_A00_S085_LG(count*101+1:101*(count+1), k) = I5_A00_S085.LG(1:end);
    I5_A00_S085_SOL(count*101+1:101*(count+1), k) = I5_A00_S085.SOL(1:end);
    I5_A00_S085_TA(count*101+1:101*(count+1), k) = I5_A00_S085.TA(1:end);
    I5_A00_S085_TL(count*101+1:101*(count+1), k) = -I5_A00_S085.TL(1:end);
    I5_A00_S085_FL(count*101+1:101*(count+1), k) = I5_A00_S085.FL(1:end);
    I5_A00_S085_FV(count*101+1:101*(count+1), k) = I5_A00_S085.FV(1:end);
    I5_A00_S085_FA(count*101+1:101*(count+1), k) = I5_A00_S085.FA(1:end);

    I5_A00_S100_MG(count*101+1:101*(count+1), k) = I5_A00_S100.MG(1:end);
    I5_A00_S100_LG(count*101+1:101*(count+1), k) = I5_A00_S100.LG(1:end);
    I5_A00_S100_SOL(count*101+1:101*(count+1), k) = I5_A00_S100.SOL(1:end);
    I5_A00_S100_TA(count*101+1:101*(count+1), k) = I5_A00_S100.TA(1:end);
    I5_A00_S100_TL(count*101+1:101*(count+1), k) = -I5_A00_S100.TL(1:end);
    I5_A00_S100_FL(count*101+1:101*(count+1), k) = I5_A00_S100.FL(1:end);
    I5_A00_S100_FV(count*101+1:101*(count+1), k) = I5_A00_S100.FV(1:end);
    I5_A00_S100_FA(count*101+1:101*(count+1), k) = I5_A00_S100.FA(1:end);

    I5_A00_S115_MG(count*101+1:101*(count+1), k) = I5_A00_S115.MG(1:end);
    I5_A00_S115_LG(count*101+1:101*(count+1), k) = I5_A00_S115.LG(1:end);
    I5_A00_S115_SOL(count*101+1:101*(count+1), k) = I5_A00_S115.SOL(1:end);
    I5_A00_S115_TA(count*101+1:101*(count+1), k) = I5_A00_S115.TA(1:end);
    I5_A00_S115_TL(count*101+1:101*(count+1), k) = -I5_A00_S115.TL(1:end);
    I5_A00_S115_FL(count*101+1:101*(count+1), k) = I5_A00_S115.FL(1:end);
    I5_A00_S115_FV(count*101+1:101*(count+1), k) = I5_A00_S115.FV(1:end);
    I5_A00_S115_FA(count*101+1:101*(count+1), k) = I5_A00_S115.FA(1:end);
    % Incline, assistance
    I5_A15_S085_MG(count*101+1:101*(count+1), k) = I5_A15_S085.MG(1:end);
    I5_A15_S085_LG(count*101+1:101*(count+1), k) = I5_A15_S085.LG(1:end);
    I5_A15_S085_SOL(count*101+1:101*(count+1), k) = I5_A15_S085.SOL(1:end);
    I5_A15_S085_TA(count*101+1:101*(count+1), k) = I5_A15_S085.TA(1:end);
    I5_A15_S085_TL(count*101+1:101*(count+1), k) = -I5_A15_S085.TL(1:end);
    I5_A15_S085_FL(count*101+1:101*(count+1), k) = I5_A15_S085.FL(1:end);
    I5_A15_S085_FV(count*101+1:101*(count+1), k) = I5_A15_S085.FV(1:end);
    I5_A15_S085_FA(count*101+1:101*(count+1), k) = I5_A15_S085.FA(1:end);

    I5_A15_S100_MG(count*101+1:101*(count+1), k) = I5_A15_S100.MG(1:end);
    I5_A15_S100_LG(count*101+1:101*(count+1), k) = I5_A15_S100.LG(1:end);
    I5_A15_S100_SOL(count*101+1:101*(count+1), k) = I5_A15_S100.SOL(1:end);
    I5_A15_S100_TA(count*101+1:101*(count+1), k) = I5_A15_S100.TA(1:end);
    I5_A15_S100_TL(count*101+1:101*(count+1), k) = -I5_A15_S100.TL(1:end);
    I5_A15_S100_FL(count*101+1:101*(count+1), k) = I5_A15_S100.FL(1:end);
    I5_A15_S100_FV(count*101+1:101*(count+1), k) = I5_A15_S100.FV(1:end);
    I5_A15_S100_FA(count*101+1:101*(count+1), k) = I5_A15_S100.FA(1:end);

    I5_A15_S115_MG(count*101+1:101*(count+1), k) = I5_A15_S115.MG(1:end);
    I5_A15_S115_LG(count*101+1:101*(count+1), k) = I5_A15_S115.LG(1:end);
    I5_A15_S115_SOL(count*101+1:101*(count+1), k) = I5_A15_S115.SOL(1:end);
    I5_A15_S115_TA(count*101+1:101*(count+1), k) = I5_A15_S115.TA(1:end);
    I5_A15_S115_TL(count*101+1:101*(count+1), k) = -I5_A15_S115.TL(1:end);
    I5_A15_S115_FL(count*101+1:101*(count+1), k) = I5_A15_S115.FL(1:end);
    I5_A15_S115_FV(count*101+1:101*(count+1), k) = I5_A15_S115.FV(1:end);
    I5_A15_S115_FA(count*101+1:101*(count+1), k) = I5_A15_S115.FA(1:end);
end
%% Section 2: Level vs. Incline

set(groot, 'DefaultTextInterpreter', 'latex', ...
           'DefaultAxesTickLabelInterpreter', 'latex', ...
           'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultAxesFontSize',16);
set(groot, 'DefaultTextFontSize', 14);

colset1 = orderedcolors("gem12");
col1 = [colset1(9,:), 0.25]; col2 = [colset1(3,:), 0.25];
col3 = colset1(9,:); col4 = colset1(3,:);
lw2 = 2;

fig = figure(1); clf

fig.Units = 'inches';
fig.Position = [0.1, 0.1, 22/16*9, 18]; % x, y, width, height in cm

tiledlayout(12,3);

function fillPlot(p1Dat, p2Dat, p3Dat)
    arguments
        p1Dat = 0;
        p2Dat = 0;
        p3Dat = 0;
    end

    gaitcycle = 0:1:100;
    colset1 = orderedcolors("gem12");
    col1 = [colset1(9,:), 0.25]; col2 = [colset1(3,:), 0.25];
    col3 = colset1(9,:); col4 = colset1(3,:);
    lw2 = 2;
    
    p1S = std(p1Dat, 0, 2);
    p2S = std(p2Dat, 0 ,2);
    if isequal(p3Dat, 0)
    fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)], ...
        col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)], ...
        col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    
    plot(gaitcycle, mean(p1Dat, 2), 'Color', col3, 'LineWidth', lw2);
    plot(gaitcycle, mean(p2Dat, 2), 'Color', col4, 'LineWidth', lw2);
    else
        col1 = [colset1(4,:), 0.3]; col2 = [colset1(9,:), 0.3]; col3 = [colset1(3,:), 0.3];
        col4 = colset1(4,:) .* 0.9; col5 = colset1(9,:) .* 1; col6 = colset1(3,:) .* 1;

        p3S = std(p3Dat, 0, 2);
        fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)], ...
        col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)], ...
        col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)], ...
        col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        plot(gaitcycle, mean(p1Dat, 2), 'Color', col4, 'LineWidth', lw2);
        plot(gaitcycle, mean(p2Dat, 2), 'Color', col5, 'LineWidth', lw2);
        plot(gaitcycle, mean(p3Dat, 2), 'Color', col6, 'LineWidth', lw2);
    end

    xticks([0, 20, 40, 60, 80, 100]); 
    yline(0, '--', 'Layer', 'bottom')

end

nexttile(26, [4 1]);
ylabel({'Ankle Joint Torque','(Nm$\cdot$ kg$^{-1}$)'})
hold on; grid on
fillPlot(I0_A00_S100_TL, I5_A00_S100_TL)
xticklabels([]); ylim([-inf 2.5])

nexttile(2, [4, 1]); 
ylabel({'MG Fascicle Strain', '(\% from rest)'})
hold on; grid on
fillPlot(I0_A00_S100_FL*100, I5_A00_S100_FL*100)
xticklabels([]); ylim([-inf 150])

nexttile(14, [4 1]); 
xlabel("Gait Cycle (\%)"); ylabel({'MG Fascicle Strain Rate', '(\%$\cdot s^{-1}$)'})
hold on; grid on
fillPlot(I0_A00_S100_FV*100, I5_A00_S100_FV*100)

nexttile(3, [3 1]); 
ylabel({'MG Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S100_MG*100, I5_A00_S100_MG*100)
xticklabels([]); ylim([0 80.001])

nexttile(12, [3 1]);
ylabel({'LG Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S100_LG*100, I5_A00_S100_LG*100)
xticklabels([]); ylim([0 80.001])

nexttile(21, [3 1]);
ylabel({'SOL Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S100_SOL*100, I5_A00_S100_SOL*100)
xticklabels([]); ylim([0 80.001])

nexttile(30, [3 1]);
xlabel("Gait Cycle (\%)"); ylabel({'TA Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S100_TA*100, I5_A00_S100_TA*100)
ylim([0 80.001])

nexttile(31, [1 1]); hold on
plot(NaN, NaN, 'Color', col3, "LineWidth", lw2);
plot(NaN, NaN, 'Color', col4, "LineWidth", lw2);

leg = legend({'Level ($0^{o}$)', 'Incline ($5^{o}$)'});
leg.Layout.Tile = 31; leg.FontName = 'Times New Roman'; leg.FontSize = 12;
axis off

outLoc = 'C:\Users\zheng\OneDrive\Desktop\ENGG7291 Assessment\Paper\Figures';
print(fig, [outLoc, '\InclineVsLevel.svg'], '-dsvg');
%% Section 3: Assistance vs. No Assistance
colset1 = orderedcolors("gem12");
col3 = colset1(9,:); col4 = colset1(3,:);
lw2 = 2;

fig = figure(2); clf
fig.Units = 'inches';
fig.Position = [0.1, 0.1, 22/16*9, 18];
tiledlayout(12,3);

nexttile(10); hold on
plot(NaN, NaN, 'Color', col3, "LineWidth", lw2);
plot(NaN, NaN, 'Color', col4, "LineWidth", lw2);

leg = legend({'Zero Assistance ($0$ Nm$\cdot$kg$^{-1}$)', 'Assistance ($0.15$ Nm$\cdot$kg$^{-1}$)'});
leg.Layout.Tile = 31; leg.FontName = 'Times New Roman'; leg.FontSize = 12;
axis off

nexttile(26, [4 1]);
ylabel({'Ankle Joint Torque','(Nm$\cdot$ kg$^{-1}$)'})
hold on; grid on
fillPlot(I0_A00_S100_TL, I0_A15_S100_TL)
xticklabels([]); ylim([-inf 2])

nexttile(2, [4, 1]); 
ylabel({'MG Fascicle Strain', '(\% from rest)'})
hold on; grid on
fillPlot(I0_A00_S100_FL*100, I0_A15_S100_FL*100)
xticklabels([]); ylim([-inf 150])

nexttile(14, [4 1]); 
xlabel("Gait Cycle (\%)"); ylabel({'MG Fascicle Strain Rate', '(\%$\cdot s^{-1}$)'})
hold on; grid on
fillPlot(I0_A00_S100_FV*100, I0_A15_S100_FV*100)

nexttile(3, [3 1]); 
ylabel({'MG Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S100_MG*100, I0_A15_S100_MG*100)
xticklabels([]); ylim([0 60])

nexttile(12, [3 1]);
ylabel({'LG Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S100_LG*100, I0_A15_S100_LG*100)
xticklabels([]); ylim([0 60])

nexttile(21, [3 1]);
ylabel({'SOL Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S100_SOL*100, I0_A15_S100_SOL*100)
xticklabels([]); ylim([0 60])

nexttile(30, [3 1]);
xlabel("Gait Cycle (\%)"); ylabel({'TA Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S100_TA*100, I0_A15_S100_TA*100)
ylim([0 60])

outLoc = 'C:\Users\zheng\OneDrive\Desktop\ENGG7291 Assessment\Paper\Figures';
print(fig, [outLoc, '\ZeroVsActive.svg'], '-dsvg');
%% Section 4: Slow vs. Medium vs. Fast Speed

colset1 = orderedcolors("gem12");
colset2 = orderedcolors("glow12");
col2 = [colset1(9,:), 0.3];
col3 = [colset1(3,:), 0.3];
col1 = [colset1(4,:), 0.3];

col5 = colset1(9,:) .* 1;
col6 = colset1(3,:) .* 1;
col4 = colset1(4,:) .* 0.9;
lw2 = 2;

fig = figure(3); clf
fig.Units = 'inches';
fig.Position = [0.1, 0.1, 22/16*9, 18];
tiledlayout(12,3);

nexttile(26, [4 1]);
ylabel({'Ankle Joint Torque','(Nm$\cdot$ kg$^{-1}$)'})
hold on; grid on
fillPlot(I0_A00_S085_TL, I0_A00_S100_TL, I0_A00_S115_TL)
xticklabels([]); ylim([-inf 2])

nexttile(2, [4, 1]); 
ylabel({'MG Fascicle Strain', '(\% from rest)'})
hold on; grid on
fillPlot(I0_A00_S085_FL*100, I0_A00_S100_FL*100, I0_A00_S115_FL*100)
xticklabels([]); ylim([-inf 1.5*100])

nexttile(14, [4 1]); 
xlabel("Gait Cycle (\%)"); ylabel({'MG Fascicle Strain Rate', '(\%$\cdot s^{-1}$)'})
hold on; grid on
fillPlot(I0_A00_S085_FV*100, I0_A00_S100_FV*100, I0_A00_S115_FV*100)

nexttile(3, [3 1]); 
ylabel({'MG Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S085_MG*100, I0_A00_S100_MG*100, I0_A00_S115_MG*100)
xticklabels([]); ylim([0 0.6*100])

nexttile(12, [3 1]);
ylabel({'LG Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S085_LG*100, I0_A00_S100_LG*100, I0_A00_S115_LG*100)
xticklabels([]); ylim([0 0.6*100])

nexttile(21, [3 1]);
ylabel({'SOL Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S085_SOL*100, I0_A00_S100_SOL*100, I0_A00_S115_SOL*100)
xticklabels([]); ylim([0 0.6*100])

nexttile(30, [3 1]);
xlabel("Gait Cycle (\%)"); ylabel({'TA Activation', '(\% MVC)'})
hold on; grid on
fillPlot(I0_A00_S085_TA*100, I0_A00_S100_TA*100, I0_A00_S115_TA*100)
ylim([0 0.6*100])


nexttile(10); hold on
plot(NaN, NaN, 'Color', col4, "LineWidth", lw2);
plot(NaN, NaN, 'Color', col5, "LineWidth", lw2);
plot(NaN, NaN, 'Color', col6, "LineWidth", lw2);

leg = legend({'Slow (85\% PWS)', 'Medium (100\% PWS)', 'Fast (115\% PWS)'});
leg.Layout.Tile = 31; leg.FontName = 'Times New Roman'; leg.FontSize = 12;
axis off

outLoc = 'C:\Users\zheng\OneDrive\Desktop\ENGG7291 Assessment\Paper\Figures';
print(fig, [outLoc, '\SlowVsMedVsFast.svg'], '-dsvg');