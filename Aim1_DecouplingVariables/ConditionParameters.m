%% Obtaining values from each condition for comparison
% Section 1: Select all data from all participants and assign to each
%            specific condition
% Section 2: Order each musculoskeletal response in order of conditions
% Section 3: Obtain peak/average/difference values from each condition of
%            each participant
%            - Each column corresponds to a musculoskeletal parameter
%            - Each row corresponds to a condition of each participant
%% Section 1: Select Data
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

%% Section 2: Condition Order
TL{1,:} = I0_A00_S085_TL;
TL{2,:} = I0_A00_S100_TL;
TL{3,:} = I0_A00_S115_TL;
TL{4,:} = I0_A15_S085_TL;
TL{5,:} = I0_A15_S100_TL;
TL{6,:} = I0_A15_S115_TL;
TL{7,:} = I5_A00_S085_TL;
TL{8,:} = I5_A00_S100_TL;
TL{9,:} = I5_A00_S115_TL;
TL{10,:} = I5_A15_S085_TL;
TL{11,:} = I5_A15_S100_TL;
TL{12,:} = I5_A15_S115_TL;

FL{1,:} = I0_A00_S085_FL;
FL{2,:} = I0_A00_S100_FL;
FL{3,:} = I0_A00_S115_FL;
FL{4,:} = I0_A15_S085_FL;
FL{5,:} = I0_A15_S100_FL;
FL{6,:} = I0_A15_S115_FL;
FL{7,:} = I5_A00_S085_FL;
FL{8,:} = I5_A00_S100_FL;
FL{9,:} = I5_A00_S115_FL;
FL{10,:} = I5_A15_S085_FL;
FL{11,:} = I5_A15_S100_FL;
FL{12,:} = I5_A15_S115_FL;

FA{1,:} = I0_A00_S085_FA;
FA{2,:} = I0_A00_S100_FA;
FA{3,:} = I0_A00_S115_FA;
FA{4,:} = I0_A15_S085_FA;
FA{5,:} = I0_A15_S100_FA;
FA{6,:} = I0_A15_S115_FA;
FA{7,:} = I5_A00_S085_FA;
FA{8,:} = I5_A00_S100_FA;
FA{9,:} = I5_A00_S115_FA;
FA{10,:} = I5_A15_S085_FA;
FA{11,:} = I5_A15_S100_FA;
FA{12,:} = I5_A15_S115_FA;

FV{1,:} = I0_A00_S085_FV;
FV{2,:} = I0_A00_S100_FV;
FV{3,:} = I0_A00_S115_FV;
FV{4,:} = I0_A15_S085_FV;
FV{5,:} = I0_A15_S100_FV;
FV{6,:} = I0_A15_S115_FV;
FV{7,:} = I5_A00_S085_FV;
FV{8,:} = I5_A00_S100_FV;
FV{9,:} = I5_A00_S115_FV;
FV{10,:} = I5_A15_S085_FV;
FV{11,:} = I5_A15_S100_FV;
FV{12,:} = I5_A15_S115_FV;

MG{1,:} = I0_A00_S085_MG;
MG{2,:} = I0_A00_S100_MG;
MG{3,:} = I0_A00_S115_MG;
MG{4,:} = I0_A15_S085_MG;
MG{5,:} = I0_A15_S100_MG;
MG{6,:} = I0_A15_S115_MG;
MG{7,:} = I5_A00_S085_MG;
MG{8,:} = I5_A00_S100_MG;
MG{9,:} = I5_A00_S115_MG;
MG{10,:} = I5_A15_S085_MG;
MG{11,:} = I5_A15_S100_MG;
MG{12,:} = I5_A15_S115_MG;

LG{1,:} = I0_A00_S085_LG;
LG{2,:} = I0_A00_S100_LG;
LG{3,:} = I0_A00_S115_LG;
LG{4,:} = I0_A15_S085_LG;
LG{5,:} = I0_A15_S100_LG;
LG{6,:} = I0_A15_S115_LG;
LG{7,:} = I5_A00_S085_LG;
LG{8,:} = I5_A00_S100_LG;
LG{9,:} = I5_A00_S115_LG;
LG{10,:} = I5_A15_S085_LG;
LG{11,:} = I5_A15_S100_LG;
LG{12,:} = I5_A15_S115_LG;

SOL{1,:} = I0_A00_S085_SOL;
SOL{2,:} = I0_A00_S100_SOL;
SOL{3,:} = I0_A00_S115_SOL;
SOL{4,:} = I0_A15_S085_SOL;
SOL{5,:} = I0_A15_S100_SOL;
SOL{6,:} = I0_A15_S115_SOL;
SOL{7,:} = I5_A00_S085_SOL;
SOL{8,:} = I5_A00_S100_SOL;
SOL{9,:} = I5_A00_S115_SOL;
SOL{10,:} = I5_A15_S085_SOL;
SOL{11,:} = I5_A15_S100_SOL;
SOL{12,:} = I5_A15_S115_SOL;

TA{1,:} = I0_A00_S085_TA;
TA{2,:} = I0_A00_S100_TA;
TA{3,:} = I0_A00_S115_TA;
TA{4,:} = I0_A15_S085_TA;
TA{5,:} = I0_A15_S100_TA;
TA{6,:} = I0_A15_S115_TA;
TA{7,:} = I5_A00_S085_TA;
TA{8,:} = I5_A00_S100_TA;
TA{9,:} = I5_A00_S115_TA;
TA{10,:} = I5_A15_S085_TA;
TA{11,:} = I5_A15_S100_TA;
TA{12,:} = I5_A15_S115_TA;
%% Section 3: Condition Comparison

savePath = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Assessment\Final Report";

fullStance = 2:61;
semiStance = 21:61;
fullGait = 2:101;
pushOff = 41:81;
fullSwing = 81:100;

TL_avg = zeros(12, 10); 
MG_avg = zeros(12, 10); LG_avg = zeros(12, 10); 
SOL_avg = zeros(12, 10); TA_avg = zeros(12, 10);
FL_avg = zeros(12, 10); FA_avg = zeros(12, 10); FV_avg = zeros(12, 10);

TL_peak = zeros(12, 10);
MG_peak = zeros(12, 10); LG_peak = zeros(12, 10); 
SOL_peak = zeros(12, 10); TA_peak = zeros(12, 10);
FV_peak = zeros(12, 10); FV_peak2 = zeros(12, 10);

FL_diff = zeros(12, 10); FA_diff = zeros(12, 10);

FL_min = zeros(12,10);

for i = 1:12

    % Average 0 - 60%
    TL_avg(i,:) = mean(TL{i,1}(fullStance,:));
    MG_avg(i,:) = mean(MG{i,1}(fullStance,:));
    LG_avg(i,:) = mean(LG{i,1}(fullStance,:));
    SOL_avg(i,:) = mean(SOL{i,1}(fullStance,:));
    TA_avg(i,:) = mean(TA{i,1}(fullStance,:));
    % Average 20 - 60%
    FL_avg(i,:) = mean(FL{i,1}(semiStance,:));
    FA_avg(i,:) = mean(FA{i,1}(semiStance,:));
    FV_avg(i,:) = mean(FV{i,1}(semiStance,:));
    % Average 0 - 100%
    TA_avg(i,:) = mean(TA{i,1}(fullGait,:));

    % Peak
    TL_peak(i,:) = max(TL{i,1}(fullStance,:));
    MG_peak(i,:) = max(MG{i,1}(fullStance,:));
    LG_peak(i,:) = max(LG{i,1}(fullStance,:));
    SOL_peak(i,:) = max(SOL{i,1}(fullStance,:));
    TA_peak(i,:) = max(TA{i,1}(fullGait,:));
    FV_peak(i,:) = min(FV{i,1}(pushOff,:));
    FV_peak2(i,:) = max(FV{i,1}(fullSwing,:));

    % Diff
    FL_diff(i,:) = max(FL{i,1}(semiStance,:)) - min(FL{i,1}(fullGait,:));
    FA_diff(i,:) = max(FA{i,1}(fullGait,:)) - min(FA{i,1}(semiStance,:));

    % Other
    FL_min(i,:) = min(FL{i,1}(fullGait,:));

end

% Summary table
summary = zeros(120, 18);

for j = 1:12
    startIdx = (j - 1)*10 + 1; endIdx = startIdx + 9;
    summary(startIdx:endIdx, 1) = TL_avg(j, :)';
    summary(startIdx:endIdx, 2) = TL_peak(j, :)';

    summary(startIdx:endIdx, 3) = FL_avg(j, :)';
    summary(startIdx:endIdx, 4) = FL_diff(j, :)';
    summary(startIdx:endIdx, 5) = FA_avg(j, :)';
    summary(startIdx:endIdx, 6) = FA_diff(j, :)';
    summary(startIdx:endIdx, 7) = FV_avg(j, :)';
    summary(startIdx:endIdx, 8) = FV_peak(j, :)';
    summary(startIdx:endIdx, 9) = MG_avg(j, :)';
    summary(startIdx:endIdx, 10) = MG_peak(j, :)';
    summary(startIdx:endIdx, 11) = LG_avg(j, :)';
    summary(startIdx:endIdx, 12) = LG_peak(j, :)';
    summary(startIdx:endIdx, 13) = SOL_avg(j, :)';
    summary(startIdx:endIdx, 14) = SOL_peak(j, :)';
    summary(startIdx:endIdx, 15) = TA_avg(j, :)';
    summary(startIdx:endIdx, 16) = TA_peak(j, :)';
    summary(startIdx:endIdx, 17) = FL_min(j, :)';
    summary(startIdx:endIdx, 18) = FV_peak2(j, :)';
end

writematrix(summary, fullfile(savePath, "Comparison Parameters.xlsx"))