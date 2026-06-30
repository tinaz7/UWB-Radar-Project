% Quantifying decoupling from pooled participant data
% Section 1: Loading all conditions of all participant
%            - Also computes the MG/(LG+MG) ratio for each condition, and
%              the pennation angles to determine the range
% Section 2: Fit LM and LME regressions to all data
% Section 3: Plot all data (LM)
%            - Figure 1: all musculoskeletal factors against torque
%            - Figure 2: MG vs. LG and fascicle strain vs. strain rate
% Section 4: Plot all data (LME)
%            - Figure 3: all musculoskeletal factors against torque (LM)
%            - Figure 4: MG vs. LG and fascicle strain vs. strain rate (LM)
%% Section 1: Pool data of all conditions from all participants
clear

myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged";

PIDs = dir(fullfile(myDir, "S*"));
restLen = [12.83, 12.54, 13.19, 12.99, 14.03, 11.16, 13.67, 13.48, 10.71, 15.55];

TL = []; MG = []; LG = [];
FL = []; FA = []; FV = [];
PID = []; COND = [];

% MG/(MG+LG) ratios and range of pennation angles were required for thesis
% discussion, computed here
MGLGRatio = []; allPennation = [];

count = 0;

for i = 1 : length(PIDs)
    trials = dir(fullfile(myDir, string(PIDs(i).name), "*.mat"));
    for j = 1 : length(trials)
        file = load(fullfile(myDir, PIDs(i).name, trials(j).name));
        data = file.ALL.ValDat;
        
        TL(count*100+1:100*(count+1), 1) = data.TL(2:end);
        MG(count*100+1:100*(count+1), 1) = data.MG(2:end) .* 100;
        LG(count*100+1:100*(count+1), 1) = data.LG(2:end) .* 100;
        FL(count*100+1:100*(count+1), 1) = data.FL(2:end) .* 100;
        FA(count*100+1:100*(count+1), 1) = data.FA(2:end);
        FV(count*100+1:100*(count+1), 1) = data.FV(2:end) .* 100;
        PID(count*100+1:100*(count+1), 1) = data.PID(2:end);
        COND(count*100+1:100*(count+1), 1) = data.COND(2:end);
        
        MGLGRatio(count + 1, 1) = max(data.MG(2:end)) / ...
                                 (max(data.MG(2:end)) + max(data.LG(2:end)));
        allPennation(count*100+1:100*(count+1), 1) = data.FP(2:end) + restLen(i);

        count = count + 1;
    end
end

allTable = table(TL, MG, LG, FL, FA, FV, PID, COND);

%% Section 2: LM and LME fitting

% Musculoskeletal factors against torque
% Standard linear regression
lmTLvMG = fitlme(allTable,'TL~MG');
lmTLvLG = fitlme(allTable,'TL~LG');
lmTLvFL = fitlme(allTable,'TL~FL');
lmTLvFA = fitlme(allTable,'TL~FA');
lmTLvFV = fitlme(allTable,'TL~FV');
% Linear mixed effects
lmeTLvMG = fitlme(allTable,'TL~MG+(1|PID)');
lmeTLvLG = fitlme(allTable,'TL~LG+(1|PID)');
lmeTLvFL = fitlme(allTable,'TL~FL+(1|PID)');
lmeTLvFA = fitlme(allTable,'TL~FA+(1|PID)');
lmeTLvFV = fitlme(allTable,'TL~FV+(1|PID)');

% Between musculoskeletal factors
% Standard linear regression
lmMGvLG = fitlme(allTable,'MG~LG');
lmFLvFA = fitlme(allTable,'FL~FA');
% Linear mixed effects
lmeMGvLG = fitlme(allTable,'MG~LG+(1|PID)');
lmeFLvFA = fitlme(allTable,'FL~FA+(1|PID)');

% Display lme R^2 values
fprintf('TL-MG LME Rsqaured: ' + string(lmeTLvMG.Rsquared.Adjusted) + '\n')
fprintf('TL-LG LME Rsqaured: ' + string(lmeTLvLG.Rsquared.Adjusted) + '\n')
fprintf('TL-FL LME Rsqaured: ' + string(lmeTLvFL.Rsquared.Adjusted) + '\n')
fprintf('TL-FA LME Rsqaured: ' + string(lmeTLvFA.Rsquared.Adjusted) + '\n')
fprintf('TL-FV LME Rsqaured: ' + string(lmeTLvFV.Rsquared.Adjusted) + '\n')
fprintf('MG-LG LME Rsqaured: ' + string(lmeMGvLG.Rsquared.Adjusted) + '\n')
fprintf('FL-FA LME Rsqaured: ' + string(lmeFLvFA.Rsquared.Adjusted) + '\n')


%% Section 3: Plots (LM)

set(groot, 'DefaultTextInterpreter', 'latex', ...
           'DefaultAxesTickLabelInterpreter', 'latex', ...
           'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultAxesFontSize', 14, ...
           'DefaultTextFontSize', 14, ...
           'DefaultLegendFontSize', 14)   
colourset1 = orderedcolors("gem12");
colourset2 = orderedcolors("gem12") .* 0.8;

syms x

% Musculoskeletal factors against torque
figure (1)
tiledlayout(2, 6)
nexttile([1 3]); grid on; hold on
scatter(MG, TL, 'Filled', 'MarkerFaceColor', colourset1(3, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmTLvMG.Coefficients.Estimate(2)*x + lmTLvMG.Coefficients.Estimate(1), ...
    'Color', colourset2(3, :), 'LineWidth', 3)
xlabel('MG Activation (\% MVC)'); ylabel('Ankle Joint Torque (Nm/kg)')
text(0.95,0.9, "$R^2 =$ " + string(round(lmTLvMG.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile([1 3]); grid on; hold on
scatter(LG, TL, 'Filled', 'MarkerFaceColor', colourset1(5, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmTLvLG.Coefficients.Estimate(2)*x + lmTLvLG.Coefficients.Estimate(1), ...
    'Color', colourset2(5, :), 'LineWidth', 3)
xlabel('LG Activation (\% MVC)');
yticklabels([])
text(0.95,0.9, "$R^2 =$" + string(round(lmTLvLG.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile([1 2]); grid on; hold on
scatter(FL, TL, 'Filled', 'MarkerFaceColor', colourset1(2, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmTLvFL.Coefficients.Estimate(2)*x + lmTLvFL.Coefficients.Estimate(1), ...
    'Color', colourset2(2, :), 'LineWidth', 3)
xlabel('Fasicle Strain (\% from rest)'); ylabel('Ankle Joint Torque (Nm/kg)')
text(0.05,0.1, "$R^2 =$" + string(round(lmTLvFL.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'bottom', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile([1 2]); grid on; hold on
scatter(FA, TL, 'Filled', 'MarkerFaceColor', colourset1(9, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmTLvFA.Coefficients.Estimate(2)*x + lmTLvFA.Coefficients.Estimate(1), ...
    'Color', colourset2(9, :), 'LineWidth', 3)
xlabel('Fasicle Pennation ($^{o}$ from rest)');
yticklabels([])
text(0.95,0.1, "$R^2 =$" + string(round(lmTLvFA.Rsquared.Adjusted,3 )), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'bottom', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile([1 2]); grid on; hold on
scatter(FV, TL, 'Filled', 'MarkerFaceColor', colourset1(4, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmTLvFV.Coefficients.Estimate(2)*x + lmTLvFV.Coefficients.Estimate(1), ...
    'Color', colourset2(4, :), 'LineWidth', 3)
xlabel('Fascicle Strain Rate (\% $\cdot s^{-1}$)');
yticklabels([])
text(0.95,0.1, "$R^2 =$" + string(round(lmTLvFV.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'bottom', 'EdgeColor', 'k', 'BackgroundColor', 'w');

% Between musculoskeletal factors
figure (2); clf
tiledlayout(2,2)
nexttile; grid on; hold on
scatter(LG, MG, 'Filled', 'MarkerFaceColor', colourset1(3, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmMGvLG.Coefficients.Estimate(2)*x + lmMGvLG.Coefficients.Estimate(1), ...
    'Color', colourset2(3, :), 'LineWidth', 3)
xlabel('LG Activation (\% MVC)'); ylabel('MG Activation (\% MVC)')
text(0.95,0.1, "$R^2 =$ " + string(round(lmMGvLG.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'bottom', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile; grid on; hold on
scatter(FA, FL, 'Filled', 'MarkerFaceColor', colourset1(5, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmFLvFA.Coefficients.Estimate(2)*x + lmFLvFA.Coefficients.Estimate(1), ...
    'Color', colourset2(5, :), 'LineWidth', 3)
xlabel('Fascicle Pennation ($^{o}$ from rest)'); ylabel('Fascicle Strain (\% MVC)')
text(0.95,0.9, "$R^2 =$" + string(round(lmFLvFA.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile; axis off
nexttile; axis off

%% Section 4: Plots (LME)

set(groot, 'DefaultTextInterpreter', 'latex', ...
           'DefaultAxesTickLabelInterpreter', 'latex', ...
           'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultAxesFontSize', 14, ...
           'DefaultTextFontSize', 14, ...
           'DefaultLegendFontSize', 14)   
colourset1 = orderedcolors("gem12");
colourset2 = orderedcolors("gem12") .* 0.8;

syms x

% Musculoskeletal factors against torque
figure (3)
tiledlayout(2, 6)
nexttile([1 3]); grid on; hold on
scatter(MG, TL, 'Filled', 'MarkerFaceColor', colourset1(3, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmeTLvMG.Coefficients.Estimate(2)*x + lmeTLvMG.Coefficients.Estimate(1), ...
    'Color', colourset2(3, :), 'LineWidth', 3)
xlabel('MG Activation (\% MVC)'); ylabel('Ankle Joint Torque (Nm/kg)')
text(0.95,0.9, "$R^2 =$ " + string(round(lmeTLvMG.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile([1 3]); grid on; hold on
scatter(LG, TL, 'Filled', 'MarkerFaceColor', colourset1(5, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmeTLvLG.Coefficients.Estimate(2)*x + lmeTLvLG.Coefficients.Estimate(1), ...
    'Color', colourset2(5, :), 'LineWidth', 3)
xlabel('LG Activation (\% MVC)');
yticklabels([])
text(0.95,0.9, "$R^2 =$" + string(round(lmeTLvLG.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile([1 2]); grid on; hold on
scatter(FL, TL, 'Filled', 'MarkerFaceColor', colourset1(2, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmeTLvFL.Coefficients.Estimate(2)*x + lmeTLvFL.Coefficients.Estimate(1), ...
    'Color', colourset2(2, :), 'LineWidth', 3)
xlabel('Fasicle Strain (\% from rest)'); ylabel('Ankle Joint Torque (Nm/kg)')
text(0.05,0.1, "$R^2 =$" + string(round(lmeTLvFL.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'bottom', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile([1 2]); grid on; hold on
scatter(FA, TL, 'Filled', 'MarkerFaceColor', colourset1(9, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmeTLvFA.Coefficients.Estimate(2)*x + lmeTLvFA.Coefficients.Estimate(1), ...
    'Color', colourset2(9, :), 'LineWidth', 3)
xlabel('Fasicle Pennation ($^{o}$ from rest)');
yticklabels([])
text(0.95,0.1, "$R^2 =$" + string(round(lmeTLvFA.Rsquared.Adjusted,3 )), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'bottom', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile([1 2]); grid on; hold on
scatter(FV, TL, 'Filled', 'MarkerFaceColor', colourset1(4, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmeTLvFV.Coefficients.Estimate(2)*x + lmeTLvFV.Coefficients.Estimate(1), ...
    'Color', colourset2(4, :), 'LineWidth', 3)
xlabel('Fascicle Strain Rate (\% $\cdot s^{-1}$)');
yticklabels([])
text(0.95,0.1, "$R^2 =$" + string(round(lmeTLvFV.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'bottom', 'EdgeColor', 'k', 'BackgroundColor', 'w');

% Between musculoskeletal factors
figure (4); clf
tiledlayout(2,2)
nexttile; grid on; hold on
scatter(LG, MG, 'Filled', 'MarkerFaceColor', colourset1(3, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmeMGvLG.Coefficients.Estimate(2)*x + lmeMGvLG.Coefficients.Estimate(1), ...
    'Color', colourset2(3, :), 'LineWidth', 3)
xlabel('LG Activation (\% MVC)'); ylabel('MG Activation (\% MVC)')
text(0.95,0.1, "$R^2 =$ " + string(round(lmeMGvLG.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'bottom', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile; grid on; hold on
scatter(FA, FL, 'Filled', 'MarkerFaceColor', colourset1(5, :), ...
    'MarkerFaceAlpha', 0.2)
axis manual;
fplot(lmeFLvFA.Coefficients.Estimate(2)*x + lmeFLvFA.Coefficients.Estimate(1), ...
    'Color', colourset2(5, :), 'LineWidth', 3)
xlabel('Fascicle Pennation ($^{o}$ from rest)'); ylabel('Fascicle Strain (\% MVC)')
text(0.95,0.9, "$R^2 =$" + string(round(lmeFLvFA.Rsquared.Adjusted, 3)), ...
    'Units', 'normalized', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top', 'EdgeColor', 'k', 'BackgroundColor', 'w');

nexttile; axis off
nexttile; axis off