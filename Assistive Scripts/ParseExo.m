%% Script to parse exo .csv file to a .mat file
%  Obtains the applied torque, set torque, state, and FSR reading of each
%  ankle and saves as new .mat file
clear variables

myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data/Exo/S10";
files = dir(fullfile(myDir, '*.csv'));

for i = 1: length(files)
    file = files(i).name;
    fileName = fullfile(myDir, file);

    T = readtable(fileName, 'VariableNamingRule', 'preserve');
    T = rows2vars(T);
    
    arr = table2array(T(2:end,:));
    varNames = T{1,:};
    
    M = zeros(size(arr));
    
    for i = 1 : size(arr,2)
        for j = 1 : size(arr,1)
    
            if isnumeric(arr{j,i})
                M(j,i) = arr{j,i};
                continue
            end
    
            if ischar(arr{j,i})
                M(j,i) = str2double(arr{j,i});
                continue
            end
        end
    end
    
    M(isnan(M)) = 0;
    
    ExoRTorque_idx = find(cellfun(@(x)isequal(x,'RTorque'), varNames));
    ExoRSetP_idx = find(cellfun(@(x)isequal(x,'RSetP'), varNames));
    ExoRState_idx = find(cellfun(@(x)isequal(x,'RState'), varNames));
    ExoLTorque_idx = find(cellfun(@(x)isequal(x,'LTorque'), varNames));
    ExoLSetP_idx = find(cellfun(@(x)isequal(x,'LSetP'), varNames));
    ExoLState_idx = find(cellfun(@(x)isequal(x,'LState'), varNames));
    ExoSync_idx = find(cellfun(@(x)isequal(x,'Opt2'), varNames));
    LFsr_idx = find(cellfun(@(x)isequal(x,'LFsr'), varNames));
    RFsr_idx = find(cellfun(@(x)isequal(x,'RFsr'), varNames));
    
    ExoRTorque = M(:,ExoRTorque_idx)';
    ExoRSetP = M(:,ExoRSetP_idx)';
    ExoRState = M(:,ExoRState_idx)';
    ExoLTorque = M(:,ExoLTorque_idx)';
    ExoLSetP = M(:, ExoLSetP_idx)';
    ExoLState = M(:,ExoLState_idx)';
    ExoSync = M(:,ExoSync_idx)';
    LFsr = M(:,LFsr_idx)';
    RFsr = M(:,RFsr_idx)';
    
    save(replace(fileName, ".csv", ".mat"), "ExoRTorque", "ExoRSetP", "ExoRState", ...
        "ExoLTorque", "ExoLSetP", "ExoLState", "ExoSync", "LFsr", "RFsr");
end