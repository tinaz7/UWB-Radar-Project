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

myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\Data Collection\Left Leg Average - US, EMG";

PIDs = ['01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'];
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


for k = 1:length(PIDs)

    % Load all PID data
    PID = PIDs(k,:);

    files = dir(fullfile(myDir, ['S', PID], '*.mat'));
    summary = readtable('Participant Data Summary Export.xlsx', 'Sheet', 'Data Collection', 'VariableNamingRule', 'preserve');
    
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
    I0_A00_S085_FA(count*101+1:101*(count+1), k) = I0_A00_S085.FA(1:end);

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
set(groot, 'DefaultAxesFontSize',13);
set(groot, 'DefaultTextFontSize', 13);

colset1 = orderedcolors("gem12");
col1 = [colset1(9,:), 0.25]; col2 = [colset1(3,:), 0.25];
col3 = colset1(9,:); col4 = colset1(3,:);
lw2 = 2;

figure(1); clf

tiledlayout(4,3);

nexttile(10); hold on
plot(NaN, NaN, 'Color', col3, "LineWidth", lw2);
plot(NaN, NaN, 'Color', col4, "LineWidth", lw2);

leg = legend({'Level ($0^{o}$)', 'Incline ($5^{o}$)'});
leg.Layout.Tile = 10; leg.FontName = 'Times New Roman'; leg.FontSize = 12;
axis off

nexttile(2);
ylabel({'Ankle Joint Torque','(Nm$\cdot$ kg$^{-1}$)'})
hold on; grid on

p1Dat = I0_A00_S100_TL; p2Dat = I5_A00_S100_TL;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)], ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)], ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2), 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2), 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 
ylim([-inf 2.5])
yline(0, '--', 'Layer', 'bottom')

nexttile(5); 
ylabel({'MG Fascicle Strain', '(\% from rest)'})
hold on; grid on

p1Dat = I0_A00_S100_FL; p2Dat = I5_A00_S100_FL;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(8);
ylabel({'MG Fascicle Pennation', '($^{o}$ from rest)'})
hold on; grid on

p1Dat = I0_A00_S100_FA; p2Dat = I5_A00_S100_FA;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)], ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)], ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) , 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) , 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(11); 
xlabel("Gait Cycle (\%)"); ylabel({'MG Fascicle Strain Rate', '(\%$\cdot s^{-1}$)'})
hold on; grid on

p1Dat = I0_A00_S100_FV; p2Dat = I5_A00_S100_FV;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]);
yline(0, '--', 'Layer', 'bottom')

nexttile(3); 
ylabel({'MG Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S100_MG; p2Dat = I5_A00_S100_MG;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(6);
ylabel({'LG Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S100_LG; p2Dat = I5_A00_S100_LG;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(9);
ylabel({'SOL Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S100_SOL; p2Dat = I5_A00_S100_SOL;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(12);
xlabel("Gait Cycle (\%)"); ylabel({'TA Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S100_TA; p2Dat = I5_A00_S100_TA;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]);

%% Section 3: Assistance vs. No Assistance
colset1 = orderedcolors("gem12");
col1 = [colset1(9,:), 0.25];
col2 = [colset1(3,:), 0.25];
col3 = colset1(9,:); col4 = colset1(3,:);
lw2 = 2;

figure(2); clf

tiledlayout(4,3);

nexttile(2);
ylabel({'Ankle Joint Torque', '(Nm$\cdot$ kg$^{-1}$)'})
hold on; grid on

p1Dat = I0_A00_S100_TL; p2Dat = I0_A15_S100_TL;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)], ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)], ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2), 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2), 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 
yline(0, '--', 'Layer', 'bottom')


nexttile(5);
ylabel({'MG Fascicle Strain', '(\% from rest)'})
hold on; grid on

p1Dat = I0_A00_S100_FL; p2Dat = I0_A15_S100_FL;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(8);
ylabel({'MG Fascicle Pennation', '($^{o}$ from rest)'})
hold on; grid on

p1Dat = I0_A00_S100_FA; p2Dat = I0_A15_S100_FA;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)], ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)], ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2), 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2), 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(11);
xlabel("Gait Cycle (\%)"); 
ylabel({'MG Fascicle Strain Rate', '(\%$\cdot s^{-1}$)'})
hold on; grid on

p1Dat = I0_A00_S100_FV; p2Dat = I0_A15_S100_FV;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]);
yline(0, '--', 'Layer', 'bottom')

nexttile(3); ylabel({'MG Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S100_MG; p2Dat = I0_A15_S100_MG;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(6); ylabel({'LG Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S100_LG; p2Dat = I0_A15_S100_LG;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(9); ylabel({'SOL Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S100_SOL; p2Dat = I0_A15_S100_SOL;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(12); ylabel({'TA Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S100_TA; p2Dat = I0_A15_S100_TA;
p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col3, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]);
xlabel("Gait Cycle (\%)"); 

nexttile(10); hold on

plot(NaN, NaN, 'Color', col3, "LineWidth", lw2);
plot(NaN, NaN, 'Color', col4, "LineWidth", lw2);

leg = legend({'No Assistance (0Nm $\cdot $kg$^{-1}$)', 'Assistance (0.15Nm$\cdot $kg$^{-1}$)'});
leg.Layout.Tile = 10; leg.FontName = 'Times New Roman'; leg.FontSize = 12;
axis off

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

figure(3); clf

tiledlayout(4, 3);

nexttile(2); 
ylabel({'Ankle Joint Torque', '(Nm$\cdot$ kg$^{-1}$)'})
hold on; grid on

p1Dat = I0_A00_S085_TL; p2Dat = I0_A00_S100_TL; p3Dat = I0_A00_S115_TL;

p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);
p3S = std(p3Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)], ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)], ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)], ...
    col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2), 'Color', col4, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2), 'Color', col5, 'LineWidth', lw2);
plot(gaitcycle, mean(p3Dat, 2), 'Color', col6, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 
yline(0, '--', 'Layer', 'bottom')


nexttile(5);
ylabel({'MG Fascicle Strain', '(\% from rest)'})
hold on; grid on

p1Dat = I0_A00_S085_FL; p2Dat = I0_A00_S100_FL; p3Dat = I0_A00_S115_FL;

p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);
p3S = std(p3Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)] .* 100, ...
    col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col5, 'LineWidth', lw2);
plot(gaitcycle, mean(p3Dat, 2) .* 100, 'Color', col6, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(8);
ylabel({'MG Fascicle Pennation', '($^{o}$ from rest)'})
hold on; grid on

p1Dat = I0_A00_S085_FA; p2Dat = I0_A00_S100_FA; p3Dat = I0_A00_S115_FA;

p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);
p3S = std(p3Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)], ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)], ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)], ...
    col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2), 'Color', col4, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2), 'Color', col5, 'LineWidth', lw2);
plot(gaitcycle, mean(p3Dat, 2), 'Color', col6, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(11); 
xlabel("Gait Cycle (\%)"); ylabel({'MG Fascicle Strain Rate', '(\%$\cdot s^{-1}$)'})
hold on; grid on

p1Dat = I0_A00_S085_FV; p2Dat = I0_A00_S100_FV; p3Dat = I0_A00_S115_FV;

p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);
p3S = std(p3Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)] .* 100, ...
    col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col5, 'LineWidth', lw2);
plot(gaitcycle, mean(p3Dat, 2) .* 100, 'Color', col6, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]);
yline(0, '--', 'Layer', 'bottom')

nexttile(3); ylabel({'MG Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S085_MG; p2Dat = I0_A00_S100_MG; p3Dat = I0_A00_S115_MG;

p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);
p3S = std(p3Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)] .* 100, ...
    col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col5, 'LineWidth', lw2);
plot(gaitcycle, mean(p3Dat, 2) .* 100, 'Color', col6, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(6); ylabel({'LG Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S085_LG; p2Dat = I0_A00_S100_LG; p3Dat = I0_A00_S115_LG;

p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);
p3S = std(p3Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)] .* 100, ...
    col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col5, 'LineWidth', lw2);
plot(gaitcycle, mean(p3Dat, 2) .* 100, 'Color', col6, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(9); ylabel({'SOL Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S085_SOL; p2Dat = I0_A00_S100_SOL; p3Dat = I0_A00_S115_SOL;

p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);
p3S = std(p3Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)] .* 100, ...
    col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col5, 'LineWidth', lw2);
plot(gaitcycle, mean(p3Dat, 2) .* 100, 'Color', col6, 'LineWidth', lw2);
xticks([0, 20, 40, 60, 80, 100]); xticklabels([]); 

nexttile(12); ylabel({'TA Activation', '(\% MVC)'})
hold on; grid on

p1Dat = I0_A00_S085_TA; p2Dat = I0_A00_S100_TA; p3Dat = I0_A00_S115_TA;

p1S = std(p1Dat, 0, 2);
p2S = std(p2Dat, 0 ,2);
p3S = std(p3Dat, 0 ,2);

fill([gaitcycle';flip(gaitcycle')], [mean(p1Dat, 2) - p1S; flip(mean(p1Dat, 2) + p1S)] .* 100, ...
    col1(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p2Dat, 2) - p2S; flip(mean(p2Dat, 2) + p2S)] .* 100, ...
    col2(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([gaitcycle';flip(gaitcycle')], [mean(p3Dat, 2) - p3S; flip(mean(p3Dat, 2) + p3S)] .* 100, ...
    col3(1, 1:3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(gaitcycle, mean(p1Dat, 2) .* 100, 'Color', col4, 'LineWidth', lw2);
plot(gaitcycle, mean(p2Dat, 2) .* 100, 'Color', col5, 'LineWidth', lw2);
plot(gaitcycle, mean(p3Dat, 2) .* 100, 'Color', col6, 'LineWidth', lw2);
xlabel("Gait Cycle (\%)"); 
xticks([0, 20, 40, 60, 80, 100]);

nexttile(10); hold on
plot(NaN, NaN, 'Color', col4, "LineWidth", lw2);
plot(NaN, NaN, 'Color', col5, "LineWidth", lw2);
plot(NaN, NaN, 'Color', col6, "LineWidth", lw2);

leg = legend({'Slow (85\% PWS)', 'Medium (100\% PWS)', 'Fast (115\% PWS)'});
leg.Layout.Tile = 10; leg.FontName = 'Times New Roman'; leg.FontSize = 12;
axis off