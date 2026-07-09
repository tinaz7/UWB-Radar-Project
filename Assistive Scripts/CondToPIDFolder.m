%% Sort LME results from Condition-specific to participant-specific folders
%  This script sorts the outputs from TrainingTesting_participantSpecific.m
%  e.g. Cond_01 contained all estimated torques of all participants within
%       condition 1. This script moves estimates torques of each
%       participant to their respective folders so that S01_All has
%       estimated torques from all 12 conditions

myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\Participant dependent";
sourceFolders = dir(fullfile(myDir, "Cond_*"));
destFolders = dir(fullfile(myDir, "S*ALL"));

for i = 1:12
    for j = 1:10
        n1 = (j-1)*2 + 1; n2 = j*2;
    
        sourceFiles = dir(fullfile(myDir, sourceFolders(i).name, "Cond_*.mat"));
        sourceFile1 = fullfile(myDir, sourceFolders(i).name, sourceFiles(n1).name);
        sourceFile2 = fullfile(myDir, sourceFolders(i).name, sourceFiles(n2).name);
    
        destFolder = fullfile(myDir, destFolders(j).name);

        copyfile(sourceFile1, destFolder);
        copyfile(sourceFile2, destFolder);
    end
end