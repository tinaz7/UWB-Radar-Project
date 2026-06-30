% UWB Radar-Based Ankle Joint Torque Estimation - cross-participant 
% Section 1: Initial LME model training from all conditions of 9
%            participants, leaving out testPID
%            - Must specify PID to be excluded from testing
%            - Outputs the LME model in the directory of LMEDir 
% Section 2: Train all conditions of the testPID participant, and plot 
%            individual all conditions of said participant
%% Section 1: Training for estimation
myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged";
LMEDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\" + ...
         "Participant independent\Unnormalised Torque";

PIDs = ['01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'];
testPID = '10'; % Participant to exclude from training

f = waitbar(0,'Loading Data','Name','Status');
set(groot, 'defaultTextInterpreter', 'none');

PID_weight = [80.22, 62.98, 79.34, 65.9, 66.33, 100.29, 63.91, 73.22, 90.58, 67.51];

nDat = 12*9; % number of training conditions
% Intialisation of validation variables
PID = zeros(nDat * 100, 1); COND = zeros(nDat * 100, 1);
TL = zeros(nDat * 100, 1); TR = zeros(nDat * 100, 1);
MG = zeros(nDat * 100, 1); LG = zeros(nDat * 100, 1);
FL = zeros(nDat * 100, 1); FV = zeros(nDat * 100, 1);
FA = zeros(nDat * 100, 1); FP = zeros(nDat * 100, 1);

% Initialisation of estimation variables
S11_M = zeros(nDat*100, 51); S11_P = zeros(nDat*100, 51);
S21_M = zeros(nDat*100, 51); S21_P = zeros(nDat*100, 51);
S22_M = zeros(nDat*100, 51); S22_P = zeros(nDat*100, 51);
    
% Load all  PID data, one participant at a time, one condition of each 
% % participant at a time
count = 0;
for k = 1 : size(PIDs, 1)

    % Skip the test participant from being added to training dataset
    if k == str2double(testPID)
        continue
    end
    
    n = PIDs(k,:); fprintf("In training: S" + n +"\n")
    files = dir(fullfile(myDir, ['S', n], '*.mat'));
    weight = PID_weight(1, str2double(n));
    
    % Reference measurements
    for l = 1 : length(files)
        file = load(fullfile(myDir, ['S', n], files(l).name));
        data = file.ALL.ValDat;
        PID(count*100 + 1 : 100*(count+1)) = data.PID(2:end);
        COND(count*100 + 1 : 100*(count+1)) = data.COND(2:end);
        TL(count*100 + 1 : 100*(count+1)) = data.TL(2:end);
        % Un-normalise torque by multiplying participant mass
        TR(count*100 + 1 : 100*(count+1)) = -data.TR(2:end) .* weight;
        MG(count*100 + 1 : 100*(count+1)) = data.MG(2:end);
        LG(count*100 + 1 : 100*(count+1)) = data.LG(2:end);
        FL(count*100 + 1 : 100*(count+1)) = data.FL(2:end);
        FA(count*100 + 1 : 100*(count+1)) = data.FA(2:end);
        FP(count*100 + 1 : 100*(count+1)) = data.FP(2:end);
        FV(count*100 + 1 : 100*(count+1)) = data.FV(2:end);

        data = file.ALL;
        S11_M(count*100 + 1 : 100*(count+1), :) = data.S11_M_Dat{2:end, :};
        S11_P(count*100 + 1 : 100*(count+1), :) = data.S11_P_Dat{2:end, :};
        S21_M(count*100 + 1 : 100*(count+1), :) = data.S21_M_Dat{2:end, :};
        S21_P(count*100 + 1 : 100*(count+1), :) = data.S21_P_Dat{2:end, :};
        S22_M(count*100 + 1 : 100*(count+1), :) = data.S22_M_Dat{2:end, :};
        S22_P(count*100 + 1 : 100*(count+1), :) = data.S22_P_Dat{2:end, :};
        count = count + 1;
    end
end

% Sort each array into a table for easier access of each frequency
S11_M_table = array2table(S11_M); S11_P_table = array2table(S11_P);
S21_M_table = array2table(S21_M); S21_P_table = array2table(S21_P);
S22_M_table = array2table(S22_M); S22_P_table = array2table(S22_P);
S11_M_table.Properties.VariableNames = strcat("S11_M_", string(1:51));
S11_P_table.Properties.VariableNames = strcat("S11_P_", string(1:51));
S21_M_table.Properties.VariableNames = strcat("S21_M_", string(1:51));
S21_P_table.Properties.VariableNames = strcat("S21_P_", string(1:51));
S22_M_table.Properties.VariableNames = strcat("S22_M_", string(1:51));
S22_P_table.Properties.VariableNames = strcat("S22_P_", string(1:51));

tbl2 = table(PID, COND, TL, TR, MG, LG, FL, FA, FP, FV);
tbl2 = [tbl2, S11_M_table, S11_P_table, ...
        S21_M_table, S21_P_table, S22_M_table, S22_P_table];

% Writing LME formula
predAll = ["S11_M", "S11_P", "S21_M", "S21_P", "S22_M", "S22_P"];
fixed_AllUWB = "";
for pred = 1:length(predAll)
    for i = 1:51
        if pred == 1 && i == 1
            fixed_AllUWB = strcat(fixed_AllUWB, predAll(pred), "_", string(i));
        else
            fixed_AllUWB = strcat(fixed_AllUWB, " + ", predAll(pred), "_", string(i));
        end
    end
end

formulaTR = "TR ~ " + fixed_AllUWB + " + (1|PID) + (COND|PID)";

TR_lme1 = fitlme(tbl2, formulaTR);

p0 = 0.001; pValues = TR_lme1.Coefficients.pValue;
names = TR_lme1.Coefficients.Name;
while ((sum(pValues(2:end) >= p0) > 0) || (length(pValues) > 50))
    
    eq = "TR ~ ";
    % Determine UWB trace with highest p value (to remove)
    [~, idxMax] = max(pValues(2:end));
    idxMax = idxMax + 1; 
    % Note the first element in pValues is from intercept, hence '+1'
    for i = 2 : length(pValues)
        if i == idxMax
            continue
        end
        eq = eq + names{i} + " + ";
    end
    eq = eq + "(1|PID) + (COND|PID)";
    
    % Re-fit LME on revised equation, repeat
    TR_lme2 = fitlme(tbl2, eq);
    pValues = TR_lme2.Coefficients.pValue;
    names = TR_lme2.Coefficients.Name;

    % Update waitbar
    % status = (307 - length(pValues)) / 257;
    % waitbar(status, f, ...
    %     sprintf("Training: " + string(round(status * 100, 1)) + "%%"))

end

% Save experimental and predicted results
waitbar(status, f, ...
    sprintf("Saving"))

save(fullfile(LMEDir, ['LME_NoS', testPID, '.mat']), 'TR_lme2')

delete(f)


%% Section 2: Testing for estimation
myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged";
LMEDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\Participant independent\Unnormalised Torque";
testPID = '10';
PID_weight = [80.22, 62.98, 79.34, 65.9, 66.33, 100.29, 63.91, 73.22, 90.58, 67.51];
nDat = 12;
LME_load = load(fullfile(LMEDir, ['LME_NoS', testPID, '.mat']));
fieldName = fields(LME_load);
TR_lme = LME_load.(fieldName{1});

% Intialisation of validation variables
PID = zeros(nDat * 100, 1); COND = zeros(nDat * 100, 1);
TL = zeros(nDat * 100, 1); TR = zeros(nDat * 100, 1);
MG = zeros(nDat * 100, 1); LG = zeros(nDat * 100, 1);
FL = zeros(nDat * 100, 1); FV = zeros(nDat * 100, 1);
FA = zeros(nDat * 100, 1); FP = zeros(nDat * 100, 1);

% Initialisation of estimation variables
S11_M = zeros(nDat*100, 51); S11_P = zeros(nDat*100, 51);
S21_M = zeros(nDat*100, 51); S21_P = zeros(nDat*100, 51);
S22_M = zeros(nDat*100, 51); S22_P = zeros(nDat*100, 51);

count = 0;
% Load all PID data
files = dir(fullfile(myDir, ['S', testPID], '*.mat'));
weight = PID_weight(1, str2double(testPID));
    
for l = 1 : length(files)
    file = load(fullfile(myDir, ['S', testPID], files(l).name));
    data = file.ALL.ValDat;
    
    PID(count*100 + 1 : 100*(count+1)) = data.PID(2:end);
    COND(count*100 + 1 : 100*(count+1)) = data.COND(2:end);
    TL(count*100 + 1 : 100*(count+1)) = data.TL(2:end);
    TR(count*100 + 1 : 100*(count+1)) = -data.TR(2:end) .* weight;
    MG(count*100 + 1 : 100*(count+1)) = data.MG(2:end);
    LG(count*100 + 1 : 100*(count+1)) = data.LG(2:end);
    FL(count*100 + 1 : 100*(count+1)) = data.FL(2:end);
    FA(count*100 + 1 : 100*(count+1)) = data.FA(2:end);
    FP(count*100 + 1 : 100*(count+1)) = data.FP(2:end);
    FV(count*100 + 1 : 100*(count+1)) = data.FV(2:end);

    data = file.ALL;
    S11_M(count*100 + 1 : 100*(count+1), :) = data.S11_M_Dat{2:end, :};
    S11_P(count*100 + 1 : 100*(count+1), :) = data.S11_P_Dat{2:end, :};
    S21_M(count*100 + 1 : 100*(count+1), :) = data.S21_M_Dat{2:end, :};
    S21_P(count*100 + 1 : 100*(count+1), :) = data.S21_P_Dat{2:end, :};
    S22_M(count*100 + 1 : 100*(count+1), :) = data.S22_M_Dat{2:end, :};
    S22_P(count*100 + 1 : 100*(count+1), :) = data.S22_P_Dat{2:end, :};

    count = count + 1;
end

S11_M_table = array2table(S11_M); S11_P_table = array2table(S11_P);
S21_M_table = array2table(S21_M); S21_P_table = array2table(S21_P);
S22_M_table = array2table(S22_M); S22_P_table = array2table(S22_P);
S11_M_table.Properties.VariableNames = strcat("S11_M_", string(1:51));
S11_P_table.Properties.VariableNames = strcat("S11_P_", string(1:51));
S21_M_table.Properties.VariableNames = strcat("S21_M_", string(1:51));
S21_P_table.Properties.VariableNames = strcat("S21_P_", string(1:51));
S22_M_table.Properties.VariableNames = strcat("S22_M_", string(1:51));
S22_P_table.Properties.VariableNames = strcat("S22_P_", string(1:51));

tbl3 = table(PID, COND, TL, TR, MG, LG, FL, FA, FP, FV);
tbl3 = [tbl3, S11_M_table, S11_P_table, ...
            S21_M_table, S21_P_table, S22_M_table, S22_P_table];

TR_pred = predict(TR_lme, tbl3);

% Plot testing from models
figure(1); clf
tiledlayout(5, 4)
condS = 1; condE = 12;

set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',16);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 14);

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; col2 = colset(4, :); col3 = colset(3, :); 
col4 = [0.3 0.3 0.3]; col5 = colset(5, :);

% Plot
nexttile([2,4]); hold on; grid on

maxRsquared = 0;
Rsquared = zeros(condE, 1); NRMSEAll = zeros(condE, 1);
diff = zeros(12*100, 1);

for  i = condS : condE
    bounds = (i - 1) * 100 + 1 : i * 100;
    expData = TR(bounds); estData = TR_pred(bounds);

    offset_lm = fitlm(expData, estData);
    offset = offset_lm.Coefficients.Estimate(1);
    scale = 1 / offset_lm.Coefficients.Estimate(2);

    diff(bounds, 1) = abs(expData - scale*(estData - offset)) / max(expData);

    plot(bounds, expData, 'Linewidth', 3, 'Color', col5)
    plot(bounds, scale * (estData - offset), '.', 'MarkerSize', 8, 'Color', col1)
    xline(i*100, '--k')
    R = corr(expData, scale * (estData - offset));
    Rsquared(i) = R^2;

    RMSE = sqrt(MSE(expData, scale * (estData - offset)));
    NRMSE = RMSE / max(TR(bounds, 1));
    NRMSEAll(i) = NRMSE;

    if Rsquared(i) > maxRsquared
        maxRsquared = Rsquared(i);
        maxRsquaredStep = i;
        maxRsquaredOffset = offset_lm;
    end
end

ax = gca; range = condS:condE; ax.XGrid = 'off'; ax.XAxis.TickLength = [0 0];
ax.XTick = range .* 100 - 50; ax.XTickLabels = string(range); xlabel('Condition');
ylim([-100 200]); yticks([-100, -50, 0, 50, 100, 150, 200, 250])
ylabel('Ankle Joint Torque ($Nm$)')
yline(0, '--', 'Layer', 'bottom')

% Magnified view of highest R2 example
nexttile([3, 3]); hold on; grid on

condS = maxRsquaredStep;
bounds = (condS - 1) * 100 + 1 : condS * 100;
expData = TR(bounds); estData = TR_pred(bounds);

offset = maxRsquaredOffset.Coefficients.Estimate(1);
scale = 1 / maxRsquaredOffset.Coefficients.Estimate(2);

plot(bounds, expData, 'Linewidth', 5, 'Color', col5)
plot(bounds, scale * (estData - offset), '.', 'MarkerSize', 17, 'Color', col1)

ylabel('Ankle Joint Torque ($Nm$)')
xlabel('Gait Cycle (\%)');
ylim([-40 140])
yticks([-60, -40, -20, 0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240])
% yticks([-80, -40, 0, 40, 80, 120, 160,200, 240, 280])

yLim = ylim; yMin = yLim(1); yMax = yLim(2);
yline(0, '--', 'Layer', 'bottom')

ax = gca; ax.XTick = (condS - 1) * 100:10: condS * 100;
          ax.XTickLabels = string(0:10:100);

text(condS * 100 - 15, yMax * 0.75, strcat("$R^2=$", string(round(maxRsquared, 3))), ...
         'HorizontalAlign', 'center', 'EdgeColor', 'k', 'BackgroundColor', 'w', ...
         'FontSize', 16)

nexttile([1, 1]); hold on
plot(NaN, NaN, 'Linewidth', 5, 'Color', col5)
plot(NaN, NaN, '.', 'MarkerSize', 15, 'Color', col1)
leg = legend('Measured', 'Estimated', 'Location', 'best');
leg.Layout.Tile = 12; leg.FontName = 'Times New Roman'; leg.FontSize = 12;
axis off
