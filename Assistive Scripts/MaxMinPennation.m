%% Find maximum and minimum fascicle pennation between all participants

myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged";
PIDs = ['01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'];
restLen = [12.83, 12.54, 13.19, 12.99, 14.03, 11.16, 13.67, 13.48, 10.71, 15.55];

AllPen = [];

count = 1;
for i = 1:10
    PID = PIDs(i, :);
    AllFiles = dir(fullfile(myDir, ['S', PID], '*.mat'));
    for j = 1:12
        file = load(fullfile(myDir, ['S', PID], AllFiles(j).name));
        pen = file.ALL.ValDat.FP;
        startIdx = (count - 1) *100 + 1; endIdx = count*100;
        AllPen(startIdx : endIdx, 1) = pen(2:101) + restLen(i);
        count = count + 1;
    end
end

maxPen = max(AllPen);
minPen = min(AllPen);
disp(maxPen); disp(minPen);