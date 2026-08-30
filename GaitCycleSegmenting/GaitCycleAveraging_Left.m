%% Gait Cycle Averaging Left Leg data
% Extracts data from previous averaged data

PIDs = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10"];

for i = 1:10
    prevFile_loc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged\Thesis data\S" + PIDs(i);
    prevFile_all = dir(fullfile(prevFile_loc, "*.mat"));

    outDest = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged\LeftLegAverage\S" + PIDs(i);

    for j = 1:12
        prevFile = load(prevFile_all(j).name); 
        PID = prevFile.ALL_norm.ValDat.PID;
        COND = prevFile.ALL_norm.ValDat.COND;
        LG_EMG = prevFile.ALL_norm.ValDat.LG;
        MG_EMG = prevFile.ALL_norm.ValDat.MG;
        SOL_EMG = prevFile.ALL_norm.ValDat.SOL;
        TA_EMG = prevFile.ALL_norm.ValDat.TA;
        MG_FL = prevFile.ALL_norm.ValDat.FL;
        MG_FA = prevFile.ALL_norm.ValDat.FA;
        MG_FP = prevFile.ALL_norm.ValDat.FP;
        MG_FV = prevFile.ALL_norm.ValDat.FV;

        ALL = struct("PID", PID, "COND", COND, ...
            "LG_EMG", LG_EMG, "MG_EMG", MG_EMG, "SOL_EMG", SOL_EMG, "TA_EMG", TA_EMG, ...
            "MG_FL", MG_FL, "MG_FA", MG_FA, "MG_FP", MG_FP, "MG_FV", MG_FV);
        
        save(fullfile(outDest, replace(prevFile_all(j).name, "_ALL", "_Left")), "ALL");
    end
end