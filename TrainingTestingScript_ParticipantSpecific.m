% UWB Radar-Based Ankle Joint Torque Estimation - participant-specific 
% Section 1: Initial LME model training from 11 conditions of a specific
%            participant + Testing of the LME model on the 12th condition
% Section 2:

%% Training for estimation
myDir = "C:\Users\Marcus\Desktop\Tina\Data";
LMEDir = "C:\Users\Marcus\Desktop\Tina\LME Outputs\Participant Dependent";
PIDsAll = ['10'];
cond = 1; % Condition for testing (to be excluded from training)
% not working:
% cond 1: 2, 4, 7, 9, 10

tic
for i = 1
    PIDs = PIDsAll(i,:);
    nDat = 11; % number of training conditions
    % Validation variables
    PID = zeros(nDat * 100, 1); COND = zeros(nDat * 100, 1);
    TL = zeros(nDat * 100, 1); TR = zeros(nDat * 100, 1);
    MG = zeros(nDat * 100, 1); LG = zeros(nDat * 100, 1);
    FL = zeros(nDat * 100, 1); FV = zeros(nDat * 100, 1);
    FA = zeros(nDat * 100, 1); FP = zeros(nDat * 100, 1);
    
    S11_M = zeros(nDat*100, 51); S11_P = zeros(nDat*100, 51);
    S12_M = zeros(nDat*100, 51); S12_P = zeros(nDat*100, 51);
    S21_M = zeros(nDat*100, 51); S21_P = zeros(nDat*100, 51);
    S22_M = zeros(nDat*100, 51); S22_P = zeros(nDat*100, 51);

    count = 0;
    for j = 1 : size(PIDs, 1)
        n = PIDs(j,:);
        files = dir(fullfile(myDir, ['S', n], '*.mat'));
      
        for k = 1 : 12
            
            % Skip the test condition from being added to training dataset
            if k == cond
                continue
            end

            fprintf("In training dataset: " + string(k) + "\n")
            file = load(fullfile(myDir, ['S', n], files(k).name));
            ResDat = file.ALL.ValDat;
            FixDat = file.ALL;
            bounds = count*100 + 1 : 100*(count+1);
            
            PID(bounds) = ResDat.PID(2:end);
            COND(bounds) = ResDat.COND(2:end);
            TL(bounds) = ResDat.TL(2:end); TR(bounds) = -ResDat.TR(2:end);
            MG(bounds) = ResDat.MG(2:end); LG(bounds) = ResDat.LG(2:end);
            FL(bounds) = ResDat.FL(2:end); FA(bounds) = ResDat.FA(2:end);
            FP(bounds) = ResDat.FP(2:end); FV(bounds) = ResDat.FV(2:end);

            file = load(fullfile(myDir, ['S', n], files(k).name));
            S11_M(bounds, :) = FixDat.S11_M_Dat{2:end, :};
            S11_P(bounds, :) = FixDat.S11_P_Dat{2:end, :};
            S12_M(bounds, :) = FixDat.S12_M_Dat{2:end, :};
            S12_P(bounds, :) = FixDat.S12_P_Dat{2:end, :};
            S21_M(bounds, :) = FixDat.S21_M_Dat{2:end, :};
            S21_P(bounds, :) = FixDat.S21_P_Dat{2:end, :};
            S22_M(bounds, :) = FixDat.S22_M_Dat{2:end, :};
            S22_P(bounds, :) = FixDat.S22_P_Dat{2:end, :};

            count = count + 1;
        end
    end
    
    % Sort each array into a table for easier access of each frequency
    S11_M_table = array2table(S11_M); S11_P_table = array2table(S11_P);
    S12_M_table = array2table(S12_M); S12_P_table = array2table(S12_P);
    S21_M_table = array2table(S21_M); S21_P_table = array2table(S21_P);
    S22_M_table = array2table(S22_M); S22_P_table = array2table(S22_P);
    S11_M_table.Properties.VariableNames = strcat("S11_M_", string(1:51));
    S11_P_table.Properties.VariableNames = strcat("S11_P_", string(1:51));
    S12_M_table.Properties.VariableNames = strcat("S12_M_", string(1:51));
    S12_P_table.Properties.VariableNames = strcat("S12_P_", string(1:51));
    S21_M_table.Properties.VariableNames = strcat("S21_M_", string(1:51));
    S21_P_table.Properties.VariableNames = strcat("S21_P_", string(1:51));
    S22_M_table.Properties.VariableNames = strcat("S22_M_", string(1:51));
    S22_P_table.Properties.VariableNames = strcat("S22_P_", string(1:51));
    
    tbl1 = table(PID, COND, TL, TR, MG, LG, FL, FA, FP, FV);
    tbl1 = [tbl1, S11_M_table, S11_P_table, S12_M_table, S12_P_table, ...
                S21_M_table, S21_P_table, S22_M_table, S22_P_table];
    
    % Create LME formula
    % TR ~ S-parameters + COND + (1|PID) + (COND|PID)
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
    
    formulaTR = "TR ~ " + fixed_AllUWB + " + COND + (1|PID) + (COND|PID)";
    
    % Train LME
    TR_lme1 = fitlme(tbl1, formulaTR);
    
    p0 = 0.05; pValues = TR_lme1.Coefficients.pValue;
    names = TR_lme1.Coefficients.Name;
    while ((sum(pValues(2:end) >= p0) > 0) || (length(pValues) > 100))
        
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
        eq = eq + " COND + (1|PID) + (COND|PID)";
        
        % Re-fit LME on revised equation, repeat
        TR_lme2 = fitlme(tbl1, eq);
        pValues = TR_lme2.Coefficients.pValue;
        names = TR_lme2.Coefficients.Name;
        disp(length(pValues))
    end
    fprintf("TR Rsqaured = " + string(TR_lme2.Rsquared.Adjusted) + "\n")
    
    % Test LME on remaining condition
    TR_lme = TR_lme2;
    
    % Initialise validation variables
    PID = zeros(100, 1); COND = zeros(100, 1);
    TL = zeros(100, 1); TR = zeros(100, 1);
    MG = zeros(100, 1); LG = zeros(100, 1);
    FL = zeros(100, 1); FV = zeros(100, 1);
    FA = zeros(100, 1); FP = zeros(100, 1);

    % Initialise estimation variables
    S11_M = zeros(100, 51); S11_P = zeros(100, 51);
    S12_M = zeros(100, 51); S12_P = zeros(100, 51);
    S21_M = zeros(100, 51); S21_P = zeros(100, 51);
    S22_M = zeros(100, 51); S22_P = zeros(100, 51);
    
    count = 0;
    for j = 1 : size(PIDs, 1)
        n = PIDs(j,:);
        files = dir(fullfile(myDir, ['S', n], '*.mat'));
        
        % Fill in each variable array for only test condition
        for k = cond
            file = load(fullfile(myDir, ['S', n], files(k).name));
            ResDat = file.ALL.ValDat;
            FixDat = file.ALL;
            bounds = count*100 + 1 : 100*(count+1);
            
            PID(bounds) = ResDat.PID(2:end);
            COND(bounds) = ResDat.COND(2:end);
            TL(bounds) = ResDat.TL(2:end); TR(bounds) = -ResDat.TR(2:end);
            MG(bounds) = ResDat.MG(2:end); LG(bounds) = ResDat.LG(2:end);
            FL(bounds) = ResDat.FL(2:end); FA(bounds) = ResDat.FA(2:end);
            FP(bounds) = ResDat.FP(2:end); FV(bounds) = ResDat.FV(2:end);

            file = load(fullfile(myDir, ['S', n], files(k).name));
            S11_M(bounds, :) = FixDat.S11_M_Dat{2:end, :};
            S11_P(bounds, :) = FixDat.S11_P_Dat{2:end, :};
            S12_M(bounds, :) = FixDat.S12_M_Dat{2:end, :};
            S12_P(bounds, :) = FixDat.S12_P_Dat{2:end, :};
            S21_M(bounds, :) = FixDat.S21_M_Dat{2:end, :};
            S21_P(bounds, :) = FixDat.S21_P_Dat{2:end, :};
            S22_M(bounds, :) = FixDat.S22_M_Dat{2:end, :};
            S22_P(bounds, :) = FixDat.S22_P_Dat{2:end, :};
            count = count + 1;
        end
    end
    
    % Sort each array into a table for easier access of each frequency
    S11_M_table = array2table(S11_M); S11_P_table = array2table(S11_P);
    S12_M_table = array2table(S12_M); S12_P_table = array2table(S12_P);
    S21_M_table = array2table(S21_M); S21_P_table = array2table(S21_P);
    S22_M_table = array2table(S22_M); S22_P_table = array2table(S22_P);
    S11_M_table.Properties.VariableNames = strcat("S11_M_", string(1:51));
    S11_P_table.Properties.VariableNames = strcat("S11_P_", string(1:51));
    S12_M_table.Properties.VariableNames = strcat("S12_M_", string(1:51));
    S12_P_table.Properties.VariableNames = strcat("S12_P_", string(1:51));
    S21_M_table.Properties.VariableNames = strcat("S21_M_", string(1:51));
    S21_P_table.Properties.VariableNames = strcat("S21_P_", string(1:51));
    S22_M_table.Properties.VariableNames = strcat("S22_M_", string(1:51));
    S22_P_table.Properties.VariableNames = strcat("S22_P_", string(1:51));
    
    tbl3 = table(PID, COND, TL, TR, MG, LG, FL, FA, FP, FV);
    tbl3 = [tbl3, S11_M_table, S11_P_table, S12_M_table, S12_P_table, ...
                S21_M_table, S21_P_table, S22_M_table, S22_P_table];
   
    TR_pred = predict(TR_lme, tbl3);
    
    % Save experimental and predicted results
    fileLoc = fullfile(LMEDir, "Cond_0" + string(cond));
    save(fullfile(fileLoc, ['Cond_0', num2str(cond), '_S', PIDs,'_meas.mat']), 'TR')
    save(fullfile(fileLoc, ['Cond_0', num2str(cond), '_S', PIDs,'_pred.mat']), 'TR_pred')
end

toc
%% Plot idv PID
figure(1); clf; hold on

PIDDir = "C:\Users\Marcus\Desktop\Tina\LME Outputs\Participant Dependent\Cond_01";
PID = '08';

set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 10);

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; col2 = colset(5, :);

meas_file = fullfile(PIDDir, ['Cond_0', num2str(cond), '_S', PID, '_meas.mat']);
pred_file = fullfile(PIDDir, ['Cond_0', num2str(cond), '_S', PID, '_pred.mat']);
meas = load(meas_file);
pred = load(pred_file);
meas_dat = meas.TR; pred_dat = pred.TR_pred;

offset_lm = fitlm(meas_dat, pred_dat);
offset = offset_lm.Coefficients.Estimate(1);
scale = 1 / offset_lm.Coefficients.Estimate(2);

plot(meas_dat, 'Linewidth', 2, 'Color', col2)
plot(scale * (pred_dat - offset), '.', 'MarkerSize', 8, 'Color', col1)

R = corr(meas_dat, scale * (pred_dat - offset));
Rsquared = R^2;
disp(Rsquared)

RMSE = sqrt(MSE(meas_dat, scale * (pred_dat - offset)));
NRMSE = RMSE / max(meas_dat);
disp(NRMSE)

%% Plot all PID
clear
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 10);

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; col2 = colset(4, :); col3 = colset(3, :); 
col4 = [0.3 0.3 0.3]; col2 = colset(5, :);

PIDDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\Participant dependent\Cond_11";

meas_files = dir(fullfile(PIDDir, '*_meas*.mat'));
pred_files = dir(fullfile(PIDDir, '*_pred*.mat'));
meas_dat = zeros(100, 12); pred_dat = zeros(100, 12);

for i = 1:10
    meas = load(meas_files(i).name);
    fprintf(string(meas_files(i).name) + "\n")
    pred = load(pred_files(i).name);
    meas_dat(:,i) = meas.TR; pred_dat(:,i) = pred.TR_pred;
end

figure(6); clf
tiledlayout(2, 5)
R2All = zeros(10, 1);
NRMSEAll = zeros(10, 1);

for i = 1:10
    offset_lm = fitlm(meas_dat(:,i), pred_dat(:,i));
    offset = offset_lm.Coefficients.Estimate(1);

    pred_dat(:,i) = pred_dat(:,i) - offset;

    nexttile; hold on; grid on
    plot(meas_dat(:,i), 'Linewidth', 4, 'Color', col2)
    plot(pred_dat(:,i), '.', 'MarkerSize', 10, 'Color', col1)
    ylim([-0.5 2.5])

    R = corr(meas_dat(:,i), pred_dat(:,i));
    Rsquared = R^2;
    R2All(i) = Rsquared;
    fprintf("S" + string(i) + " R2 = " + string(Rsquared) + "\n")

    RMSE = sqrt(MSE(meas_dat(:,i), pred_dat(:,i)));
    NRMSE = RMSE / max(meas_dat(:,i));
    NRMSEAll(i) = NRMSE;
    fprintf("S" + string(i) + " NRMSE = " + string(NRMSE) + "\n")
end

nexttile(8)
xlabel("Gait Cycle (\%)")
%% Plot all cond of one PID
SDir = 'C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\Participant dependent\S09 ALL';
condAll = ['01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12'];

set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',16);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 14);
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; col2 = colset(4, :); col3 = colset(3, :); 
col4 = [0.3 0.3 0.3]; col2 = colset(5, :);

maxRsquared = 0; NRMSEAll = zeros(12, 1);
Rsquared = zeros(12, 1);
maxRsquaredCond = 0;
maxRsquaredOffset = 0;

figure(3); clf
tiledlayout(5, 4)

nexttile([2, 4]); hold on
grid on
Diff = zeros(12*100, 1);

for i = 1:12
    % Grab data
    cond = condAll(i, :);
    measFileName = dir(fullfile(SDir, ['Cond_', cond, '*_meas.mat']));
    measFile = load(fullfile(SDir, measFileName.name));
    measDat = measFile.TR;

    predFileName = dir(fullfile(SDir, ['Cond_', cond, '*_pred.mat']));
    predFile = load(fullfile(SDir, predFileName.name));
    predDat = predFile.TR_pred;

    % Plot all individual conditions
    bounds = (i - 1) * 100 + 1 : i * 100;

    offset_lm = fitlm(measDat, predDat);
    offset = offset_lm.Coefficients.Estimate(1);
    scale = 1 / offset_lm.Coefficients.Estimate(2);

    Diff(bounds, 1) = abs(measDat - scale*(predDat - offset)) / max(measDat);

    plot(bounds, measDat, 'Linewidth', 3, 'Color', col2)
    plot(bounds, scale*(predDat - offset), '.', 'MarkerSize', 10, 'Color', col1)
    xline(i*100, '--k')
    
    R = corr(measDat, predDat-offset);
    Rsquared(i) = R^2;
    disp(Rsquared(i))

    RMSE = sqrt(MSE(measDat, scale*(predDat - offset)));
    NRMSE = RMSE / max(measDat);
    NRMSEAll(i, 1) = NRMSE;

    if Rsquared(i) > maxRsquared
        maxRsquared = Rsquared(i);
        maxRsquaredCond = cond;
        maxRsquaredOffset = offset;
    end
end

yline(0, '--k', 'Layer', 'bottom')
ax = gca; range = 1:12; ax.XGrid = 'off'; ax.XAxis.TickLength = [0 0];
ax.XTick = range .* 100 - 50; ax.XTickLabels = string(range); xlabel('Condition');
ylabel('Ankle Joint Torque ($Nm\cdot kg^{-1}$)')
ylim([-1 3])

nexttile([3, 3]); hold on; grid on
measFileName = dir(fullfile(SDir, ['Cond_', maxRsquaredCond, '*_meas.mat']));
measFile = load(fullfile(SDir, measFileName.name));
measDat = measFile.TR;

predFileName = dir(fullfile(SDir, ['Cond_', maxRsquaredCond, '*_pred.mat']));
predFile = load(fullfile(SDir, predFileName.name));
predDat = predFile.TR_pred;

bounds = 1:100;
yline(0, '--k', 'Layer', 'bottom')
plot(bounds, measDat, 'Linewidth', 5, 'Color', col2)
plot(bounds, predDat - maxRsquaredOffset, '.', 'MarkerSize', 17, 'Color', col1)
ylabel('Ankle Joint Torque ($Nm\cdot kg^{-1}$)')
xlabel('Gait Cycle (\%)');
ylim([-0.5 2.5])
yLim = ylim; yMin = yLim(1); yMax = yLim(2);
ax = gca; 
text(85, yMax * 0.8, strcat("$R^2=$", string(round(maxRsquared, 3))), ...
         'HorizontalAlign', 'center', 'EdgeColor', 'k', 'BackgroundColor', 'w', ...
         'FontSize', 16)

nexttile([1, 1]); hold on
plot(NaN, NaN, 'Linewidth', 5, 'Color', col2)
plot(NaN, NaN, '.', 'MarkerSize', 17, 'Color', col1)
leg = legend('Measured', 'Estimated', 'Location', 'best');
leg.Layout.Tile = 12; leg.FontName = 'Times New Roman'; leg.FontSize = 14;
axis off
