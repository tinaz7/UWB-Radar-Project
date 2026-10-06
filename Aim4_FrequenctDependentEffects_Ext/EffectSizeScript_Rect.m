%% Effect Sizes of Each Musculoskeletal Factor on UWB Radar Response
% Section 1: Frequency-dependent relationships in all variables
%            - LME models are created for each S-parameter component at
%              each frequency with their corresponding musculoskeletal
%              predictors
%            - This can be created for fascicle strain or fascicle
%              pennation or both, but must be specified/commented out
% Section 2: Plots of effects sizes for each musculoskeletal variable when
%            the UWB radar response is fitted with fascicle strain
% Section 3: Plots of adjusted R2 values from the LME
% Section 4: Plots of effects sizes for each musculoskeletal variable when
%            the UWB radar response is fitted with fascicle pennation
%% Section 1: Frequency-dependent relationships in all variables
clear

left_loc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged\LeftLegAverage";
right_loc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged\RightLegAverage_LP";
PIDs = ['02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10']; 
nDat = 12*9;

set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',14);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

% Initialise predictors and response variables
PID = zeros(nDat * 100, 1); COND = zeros(nDat * 100, 1);
TRIAL = zeros(nDat * 100, 1); 
MG_EMG = zeros(nDat * 100, 1); LG_EMG = zeros(nDat * 100, 1);
MG_FL = zeros(nDat * 100, 1); MG_FV = zeros(nDat * 100, 1);
MG_FA = zeros(nDat * 100, 1); MG_FP = zeros(nDat * 100, 1);

Torque = zeros(nDat * 100, 1);

S11_R = zeros(nDat*100, 51); S11_I = zeros(nDat*100, 51);
S21_R = zeros(nDat*100, 51); S21_I = zeros(nDat*100, 51);
S22_R = zeros(nDat*100, 51); S22_I = zeros(nDat*100, 51);

count = 0;
for k = 1 : size(PIDs, 1)
    % Load all PID data
    n = PIDs(k,:);

    left_files = dir(fullfile(left_loc, ['S', n], '*.mat'));
    right_files = dir(fullfile(right_loc, ['S', n], '*.mat'));

    for l = 1 : 12
        left_file = load(fullfile(left_loc, ['S', n], left_files(l).name));
        left_data = left_file.ALL;

        PID(count*100 + 1 : 100*(count+1)) = left_data.PID(2:end);
        COND(count*100 + 1 : 100*(count+1)) = left_data.COND(2:end);
        MG_EMG(count*100 + 1 : 100*(count+1)) = left_data.MG_EMG(2:end);
        LG_EMG(count*100 + 1 : 100*(count+1)) = left_data.LG_EMG(2:end);
        MG_FL(count*100 + 1 : 100*(count+1)) = left_data.MG_FL(2:end);
        MG_FA(count*100 + 1 : 100*(count+1)) = left_data.MG_FA(2:end);
        MG_FP(count*100 + 1 : 100*(count+1)) = left_data.MG_FP(2:end);
        MG_FV(count*100 + 1 : 100*(count+1)) = left_data.MG_FV(2:end);

        right_file = load(fullfile(right_loc, ['S', n], right_files(l).name));
        right_data = right_file.ALL;

        Torque(count*100 + 1 : 100*(count+1), :) = -right_data.Torque(1:end);

        S11_R(count*100 + 1 : 100*(count+1), :) = right_data.S11_R_Dat{1:end, :};
        S11_I(count*100 + 1 : 100*(count+1), :) = right_data.S11_I_Dat{1:end, :};
        S21_R(count*100 + 1 : 100*(count+1), :) = right_data.S21_R_Dat{1:end, :};
        S21_I(count*100 + 1 : 100*(count+1), :) = right_data.S21_I_Dat{1:end, :};
        S22_R(count*100 + 1 : 100*(count+1), :) = right_data.S22_R_Dat{1:end, :};
        S22_I(count*100 + 1 : 100*(count+1), :) = right_data.S22_I_Dat{1:end, :};

        count = count + 1;
    end
end

S11_R_table = array2table(S11_R); S11_I_table = array2table(S11_I);
S21_R_table = array2table(S21_R); S21_I_table = array2table(S21_I);
S22_R_table = array2table(S22_R); S22_I_table = array2table(S22_I);
S11_R_table.Properties.VariableNames = strcat("S11_R_", string(1:51));
S11_I_table.Properties.VariableNames = strcat("S11_I_", string(1:51));
S21_R_table.Properties.VariableNames = strcat("S21_R_", string(1:51));
S21_I_table.Properties.VariableNames = strcat("S21_I_", string(1:51));
S22_R_table.Properties.VariableNames = strcat("S22_R_", string(1:51));
S22_I_table.Properties.VariableNames = strcat("S22_I_", string(1:51));

tbl1 = table(PID, COND, TRIAL, MG_EMG, LG_EMG, MG_FL, MG_FA, MG_FP, MG_FV, Torque);
tbl1.TRIAL = "P" + tbl1.PID + "C" + tbl1.COND;
tbl1 = [tbl1, S11_R_table, S11_I_table, ...
            S21_R_table, S21_I_table, S22_R_table, S22_I_table];

% Store effect size and CI for each coefficient across all frequencies
MG_FL_ES = zeros(51, 3, 6); MG_FA_ES = zeros(51, 3, 6);
MG_FV_ES = zeros(51, 3, 6);
MG_EMG_ES = zeros(51, 3, 6); LG_EMG_ES = zeros(51, 3, 6); 
MG_Force_ES = zeros(51, 3, 6); LG_Force_ES = zeros(51, 3, 6);
Torque_ES = zeros(51, 3, 6);

R2 = zeros(51, 1, 6);

for i = 1:51

    S11_R_i = strcat("S11_R_", string(i)); S11_I_i = strcat("S11_I_", string(i));
    S21_R_i = strcat("S21_R_", string(i)); S21_I_i = strcat("S21_I_", string(i));
    S22_R_i = strcat("S22_R_", string(i)); S22_I_i = strcat("S22_I_", string(i));

    models{1} = fitlme(tbl1, strcat(S11_R_i, " ~ MG_FL + MG_FV + MG_EMG + Torque + (1|TRIAL)"));
    models{2} = fitlme(tbl1, strcat(S11_I_i, " ~ MG_FL + MG_FV + MG_EMG + Torque + (1|TRIAL)"));
    models{3} = fitlme(tbl1, strcat(S22_R_i, " ~ LG_EMG + Torque + (1|TRIAL)"));
    models{4} = fitlme(tbl1, strcat(S22_I_i, " ~ LG_EMG + Torque + (1|TRIAL)"));
    models{5} = fitlme(tbl1, strcat(S21_R_i, " ~ MG_FL + MG_FV + MG_EMG + LG_EMG + Torque + (1|TRIAL)"));
    models{6} = fitlme(tbl1, strcat(S21_I_i, " ~ MG_FL + MG_FV + MG_EMG + LG_EMG + Torque + (1|TRIAL)"));

    for j = 1:6
        R2(i, 1, j) = models{1, j}.Rsquared.Adjusted;

        Torque_idx = find(strcmp(models{1, j}.Coefficients.Name, 'Torque'));
        Torque_ES(i, 1, j) = models{1, j}.Coefficients.Estimate(Torque_idx);
        Torque_ES(i, 2, j) = models{1, j}.Coefficients.Lower(Torque_idx);
        Torque_ES(i, 3, j) = models{1, j}.Coefficients.Upper(Torque_idx);

        if j ~= 3 && j ~= 4
            MG_FL_idx = find(strcmp(models{1, j}.CoefficientNames, 'MG_FL'));
            MG_FL_ES(i, 1, j) = models{1, j}.Coefficients.Estimate(MG_FL_idx);
            MG_FL_ES(i, 2, j) = models{1, j}.Coefficients.Lower(MG_FL_idx);
            MG_FL_ES(i, 3, j) = models{1, j}.Coefficients.Upper(MG_FL_idx);

            MG_FV_idx = find(strcmp(models{1, j}.Coefficients.Name, 'MG_FV'));
            MG_FV_ES(i, 1, j) = models{1, j}.Coefficients.Estimate(MG_FV_idx);
            MG_FV_ES(i, 2, j) = models{1, j}.Coefficients.Lower(MG_FV_idx);
            MG_FV_ES(i, 3, j) = models{1, j}.Coefficients.Upper(MG_FV_idx);
            
            MG_EMG_idx = find(strcmp(models{1, j}.Coefficients.Name, 'MG_EMG'));
            MG_EMG_ES(i, 1, j) = models{1, j}.Coefficients.Estimate(MG_EMG_idx);
            MG_EMG_ES(i, 2, j) = models{1, j}.Coefficients.Lower(MG_EMG_idx);
            MG_EMG_ES(i, 3, j) = models{1, j}.Coefficients.Upper(MG_EMG_idx);
        end
    
        if j ~= 1 && j ~= 2
            LG_EMG_idx = find(strcmp(models{1, j}.Coefficients.Name, 'LG_EMG'));
            LG_EMG_ES(i, 1, j) = models{1, j}.Coefficients.Estimate(LG_EMG_idx);
            LG_EMG_ES(i, 2, j) = models{1, j}.Coefficients.Lower(LG_EMG_idx);
            LG_EMG_ES(i, 3, j) = models{1, j}.Coefficients.Upper(LG_EMG_idx);
        end
    end
end

%% Save Data

outLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\Effect Size\Walking Data";
save(fullfile(outLoc, "RectangularTorqueES_LP.mat"), "MG_FL_ES", "MG_FV_ES", "MG_EMG_ES", "LG_EMG_ES", "Torque_ES")
%%

R2_ReS11 = R2(:, 1, 1);
R2_ImS11 = R2(:, 1, 2);
R2_ReS21 = R2(:, 1, 5);
R2_ImS21 = R2(:, 1, 6);
R2_ReS22 = R2(:, 1, 3);
R2_ImS22 = R2(:, 1, 4);

R2_tbl = table(R2_ReS11, R2_ImS11, R2_ReS21, R2_ImS21, R2_ReS22, R2_ImS22);

outLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\Effect Size\Walking Data";
save(fullfile(outLoc, "RectangularTorqueES_LP_R2.mat"), "R2_tbl")

%% Section 2: Fascicle Length Effect Size Plots

load("Walking Data\RectangularTorqueES_LP.mat");

set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',8);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 8);

colset = orderedcolors("gem12");
col1 = colset(4, :); col2 = colset(7, :); col3 = colset(2, :); 
col5 = colset(9, :);
markerSize = 4;
lineWidth = 0.2;
capSize = 1;

fig = figure(1); clf
fig.Units = 'inches';
fig.Position = [2, 2, 7.16, 6];

fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 7.16 6];
fig.PaperSize = [7.16 6];

tiledlayout(4, 6, 'TileSpacing', 'loose', 'Padding', 'compact');

function maxlim = plotFormat(yLab, xLab)
    arguments
        yLab = 0
        xLab = 0
    end
    grid on

    ylimit = get(gca, 'YLim'); 
    maxlim = 1.1 * max(abs(ylimit)); set(gca, 'YLim', [-maxlim maxlim]);
    yticks([-maxlim -maxlim*0.5 0 maxlim*0.5 maxlim]);
    yticklabels([])
    yline(0, '--','Layer', 'bottom')

    xlim([0 52]); xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; 
    xticklabels([])
    
    if yLab == 1
        % text(-7, maxlim*0.85, '$+$'); text(-7, -maxlim*0.85, '$-$'); text(-7, 0, '0')
    end
    if xLab == 1
        % text(0, -maxlim*1.25, '0.31', 'HorizontalAlignment', 'center'); 
        % text(26, -maxlim*1.25, '1.25', 'HorizontalAlignment', 'center'); 
        % text(52, -maxlim*1.25, '2.19', 'HorizontalAlignment', 'center')
        % xlabel({'', '', 'Frequency (GHz)'})
    end
    axis square
    ax = gca; 
    ax.GridColor = [0.25 0.25 0.25];
    ax.GridLineWidth = 0.3;

end

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(1); hold on; % title('Re(S11)')
% ylabel({'MG Fascicle Strain', 'Effect Size',''})
errorbar(1:51, MG_FL_ES(:,1,1), MG_FL_ES(:,1,1)-MG_FL_ES(:,2,1), MG_FL_ES(:,3,1)-MG_FL_ES(:,1,1), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col1, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1, 'LineWidth', lineWidth)
plotFormat(1)

nexttile(2); hold on; %  title('Im(S11)'); 
errorbar(1:51, MG_FL_ES(:,1,2), MG_FL_ES(:,1,2)-MG_FL_ES(:,2,2), MG_FL_ES(:,3,2)-MG_FL_ES(:,1,2), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col1, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1, 'LineWidth', lineWidth)
plotFormat()

nexttile(3); hold on; %  title('Re(S21)')
errorbar(1:51, MG_FL_ES(:,1,5), MG_FL_ES(:,1,5)-MG_FL_ES(:,2,5), MG_FL_ES(:,3,5)-MG_FL_ES(:,1,5), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col1, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1, 'LineWidth', lineWidth)
plotFormat()

nexttile(4); hold on; %  title('Im(S21)');
errorbar(1:51, MG_FL_ES(:,1,6), MG_FL_ES(:,1,6)-MG_FL_ES(:,2,6), MG_FL_ES(:,3,6)-MG_FL_ES(:,1,6), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col1, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1, 'LineWidth', lineWidth)
plotFormat()

%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Rate Effects %%%%%%%%%%%%%%%%%%%%%%
nexttile(7); hold on
% ylabel({'MG Fascicle Strain Rate', 'Effect Size',''}); 
errorbar(1:51, MG_FV_ES(:, 1, 1), MG_FV_ES(:, 1, 1)-MG_FV_ES(:, 2, 1), MG_FV_ES(:, 3, 1)-MG_FV_ES(:, 1, 1), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col2, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2, 'LineWidth', lineWidth)
plotFormat(1)

nexttile(8); hold on
errorbar(1:51, MG_FV_ES(1:51, 1, 2), MG_FV_ES(1:51, 1, 2)-MG_FV_ES(1:51, 2, 2), MG_FV_ES(1:51, 3, 2)-MG_FV_ES(1:51, 1, 2), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col2, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2, 'LineWidth', lineWidth)
plotFormat()

nexttile(9); hold on
errorbar(1:51, MG_FV_ES(:, 1, 5), MG_FV_ES(:, 1, 5)-MG_FV_ES(:, 2, 5), MG_FV_ES(:, 3, 5)-MG_FV_ES(:, 1, 5), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col2, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2, 'LineWidth', lineWidth)
plotFormat()

nexttile(10); hold on
errorbar(1:51, MG_FV_ES(1:51, 1, 6), MG_FV_ES(1:51, 1, 6)-MG_FV_ES(1:51, 2, 6), MG_FV_ES(1:51, 3, 6)-MG_FV_ES(1:51, 1, 6), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col2, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2, 'LineWidth', lineWidth)
plotFormat()

%%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(13); hold on
% ylabel({'MG Activation', 'Effect Size',''})
errorbar(1:51, MG_EMG_ES(:, 1, 1), MG_EMG_ES(:, 1, 1) - MG_EMG_ES(:, 2, 1), MG_EMG_ES(:, 3, 1) - MG_EMG_ES(:, 1, 1), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col3, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3, 'LineWidth', lineWidth)
plotFormat(1)

nexttile(14); hold on
errorbar(1:51, MG_EMG_ES(:, 1,2), MG_EMG_ES(:,1,2)-MG_EMG_ES(:,2,2), MG_EMG_ES(:,3,2)-MG_EMG_ES(:,1,2), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col3, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3, 'LineWidth', lineWidth)
plotFormat()

nexttile(15); hold on
errorbar(1:51, MG_EMG_ES(:, 1, 5), MG_EMG_ES(:, 1, 5) - MG_EMG_ES(:, 2, 5), MG_EMG_ES(:, 3, 5) - MG_EMG_ES(:, 1, 5), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col3, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3, 'LineWidth', lineWidth)
plotFormat()

nexttile(16); hold on
errorbar(1:51, MG_EMG_ES(:,1,6), MG_EMG_ES(:,1,6)-MG_EMG_ES(:,2,6), MG_EMG_ES(:,3,6)-MG_EMG_ES(:,1,6), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col3, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3, 'LineWidth', lineWidth)
plotFormat()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Torque %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(19); hold on;
% ylabel({'Ankle Torque', 'Effect Size',''});
errorbar(1:51, Torque_ES(:,1,1), Torque_ES(:,1,1)-Torque_ES(:,2,1), Torque_ES(:,3,1)-Torque_ES(:,1,1), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col5, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5, 'LineWidth', lineWidth);
plotFormat(1, 1);

nexttile(20); hold on;
errorbar(1:51, Torque_ES(:,1,2), Torque_ES(:,1,2)-Torque_ES(:,2,2), Torque_ES(:,3,2)-Torque_ES(:,1,2), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col5, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5, 'LineWidth', lineWidth);
plotFormat(0, 1);

nexttile(21); hold on;
errorbar(1:51, Torque_ES(:,1,5), Torque_ES(:,1,5)-Torque_ES(:,2,5), Torque_ES(:,3,5)-Torque_ES(:,1,5), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col5, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5, 'LineWidth', lineWidth);
plotFormat(0, 1);

nexttile(22); hold on;
errorbar(1:51, Torque_ES(:,1,6), Torque_ES(:,1,6)-Torque_ES(:,2,6), Torque_ES(:,3,6)-Torque_ES(:,1,6), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col5, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5, 'LineWidth', lineWidth);
plotFormat(0, 1);

nexttile(23); hold on; %  title('Re(S22)')
errorbar(1:51, Torque_ES(:,1,3), Torque_ES(:,1,3)-Torque_ES(:,2,3), Torque_ES(:,3,3)-Torque_ES(:,1,3), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col5, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5, 'LineWidth', lineWidth);
plotFormat(0, 1);

nexttile(24); hold on; %  title('Im(S22)')
errorbar(1:51, Torque_ES(:,1,4), Torque_ES(:,1,4)-Torque_ES(:,2,4), Torque_ES(:,3,4)-Torque_ES(:,1,4), ...
         '.', 'Markersize', markerSize, 'CapSize', capSize, 'Color', col5, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5, 'LineWidth', lineWidth);
plotFormat(0, 1);

outLoc = 'C:\Users\zheng\OneDrive\Desktop\ENGG7291 Assessment\Paper\Figures';
print(fig, [outLoc, '\MG_EffectSize.svg'], '-dsvg');

%% Section 4: MG vs LG EMG Comparison
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; col2 = colset(4, :); col3 = colset(3, :); 
col4 = [0.5 0.5 0.5]; col5 = colset(5, :);

figure(2); clf
tiledlayout(2, 5);

nexttile(1); hold on; title('Re(S11)')
ylabel({'MG EMG', 'Effect Size',''});
errorbar(1:51, MG_EMG_ES(:,1,1), MG_EMG_ES(:,1,1)-MG_EMG_ES(:,2,1), MG_EMG_ES(:,3,1)-MG_EMG_ES(:,1,1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
plotFormat();

nexttile(2); hold on; title('Im(S11)')
errorbar(1:51, MG_EMG_ES(:,1,2), MG_EMG_ES(:,1,2)-MG_EMG_ES(:,2,2), MG_EMG_ES(:,3,2)-MG_EMG_ES(:,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
plotFormat();

nexttile(6); hold on; title('Re(S22)')
ylabel({'MG EMG', 'Effect Size',''});
errorbar(1:51, LG_EMG_ES(:,1,3), LG_EMG_ES(:,1,3)-LG_EMG_ES(:,2,3), LG_EMG_ES(:,3,3)-LG_EMG_ES(:,1,3), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
plotFormat();

nexttile(7); hold on; title('Im(S22)')
errorbar(1:51, LG_EMG_ES(:,1,4), LG_EMG_ES(:,1,4)-LG_EMG_ES(:,2,4), LG_EMG_ES(:,3,4)-LG_EMG_ES(:,1,4), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
plotFormat();
%% Section A: Rsquared Comparisons

colset = orderedcolors("gem12");
colEdge = [1 1 1];
col1a = colset(9, :); col1b = colset(9, :); 
col2a = colset(4, :); col2b = colset(4, :); 
col3a = colset(3, :); col3b = colset(3, :);

figure(2); clf
tiledlayout(3, 1)

nexttile; hold on; grid on
plot(RsquaredAdj(:,1), 'o', 'MarkerSize', 7, 'MarkerEdgeColor', colEdge, 'MarkerFaceColor', col1a)
plot(RsquaredAdj(:,2), '^', 'MarkerSize', 7, 'MarkerEdgeColor', colEdge, 'MarkerFaceColor', col1b)
ylim([0.6 1.1]); xlim([0 52])
yline(1, '--k')
legend("$|S11|$", "$\angle S11$", 'Location', 'southeast', 'Interpreter', 'latex')
xticklabels([])
xticks(0:13:52); yticks(0.6:0.1:1.1)

nexttile; hold on; grid on
plot(RsquaredAdj(:,3), 'o', 'MarkerSize', 7, 'MarkerEdgeColor', colEdge, 'MarkerFaceColor', col3a)
plot(RsquaredAdj(:,4), '^', 'MarkerSize', 7, 'MarkerEdgeColor', colEdge, 'MarkerFaceColor', col3b)
ylim([0.6 1.1]); xlim([0 52])
yline(1, '--k')
legend("$|S22|$", "$\angle S22$", 'Location', 'southeast', 'Interpreter', 'latex')
ylabel("Coefficient of Determination ($R^2$)")
xticks(0:13:52); yticks(0.6:0.1:1.1)
xticklabels([])

nexttile; hold on; grid on
plot(RsquaredAdj(:,5), 'o', 'MarkerSize', 7, 'MarkerEdgeColor', colEdge, 'MarkerFaceColor', col2a)
plot(RsquaredAdj(:,6), '^', 'MarkerSize', 7, 'MarkerEdgeColor', colEdge, 'MarkerFaceColor', col2b)
ylim([0.6 1.1]); xlim([0 52])
yline(1, '--k')
legend("$|S21|$", "$\angle S21$", 'Location', 'southeast', 'Interpreter', 'latex')
xticks(0:13:52); yticks(0.6:0.1:1.1)
xticklabels([])
xlabel({'','Frequency (GHz)'})

text(0, 0.6*0.9, '0.31', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(13, 0.6*0.9, '0.78', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(26, 0.6*0.9, '1.25', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(39, 0.6*0.9, '1.72', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(52, 0.6*0.9, '2.19', 'HorizontalAlignment', 'center', 'FontSize', 10);



%% Section B: Fascicle Pennation Effect Size Plots
figure(3); clf
t1 = tiledlayout(4, 6);

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(1); hold on; title('$|S11|$');ylabel({'MG Fascicle Pennation', 'Effect Size',''}); yline(0, '--', 'Layer', 'bottom'); 
errorbar(1:51, MG_FA_ES(:,1,1), MG_FA_ES(:,1,1)-MG_FA_ES(:,2,1), MG_FA_ES(:,3,1)-MG_FA_ES(:,1,1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1);

ylim([-0.05 0.05]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(3); hold on; title('$|S21|$'); yline(0, '--','Layer', 'bottom')
errorbar(1:51, MG_FA_ES(:,1,5), MG_FA_ES(:,1,5)-MG_FA_ES(:,2,5), MG_FA_ES(:,3,5)-MG_FA_ES(:,1,5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-0.4 0.4]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(2); hold on; title('$\angle S11$'); freq = [1:21,25:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, MG_FA_ES(freq,1,2), MG_FA_ES(freq,1,2)-MG_FA_ES(freq,2,2), MG_FA_ES(freq,3,2)-MG_FA_ES(freq,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-0.01 0.01]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(4); hold on; title('$\angle S21$'); freq = [1:6, 9:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, MG_FA_ES(freq,1,6), MG_FA_ES(freq,1,6)-MG_FA_ES(freq,2,6), MG_FA_ES(freq,3,6)-MG_FA_ES(freq,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-0.065 0.065]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Rate Effects %%%%%%%%%%%%%%%%%%%%%%%
nexttile(7); hold on; ylabel({'MG Fascicle Strain Rate', 'Effect Size',''}); yline(0, '--','Layer', 'bottom')
errorbar(1:51, MG_FV_ES(:, 1, 1), MG_FV_ES(:, 1, 1)-MG_FV_ES(:, 2, 1), MG_FV_ES(:, 3, 1)-MG_FV_ES(:, 1, 1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.04 0.04]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(9); hold on; yline(0, '--','Layer', 'bottom')
errorbar(1:51, MG_FV_ES(:, 1, 5), MG_FV_ES(:, 1, 5)-MG_FV_ES(:, 2, 5), MG_FV_ES(:, 3, 5)-MG_FV_ES(:, 1, 5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.3 0.3]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(8); hold on; freq = [1:6, 9:21, 25:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, MG_FV_ES(freq, 1, 2), MG_FV_ES(freq, 1, 2)-MG_FV_ES(freq, 2, 2), MG_FV_ES(freq, 3, 2)-MG_FV_ES(freq, 1, 2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.004 0.004]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(10); hold on; freq = [1:6, 9:50]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, MG_FV_ES(freq, 1, 6), MG_FV_ES(freq, 1, 6)-MG_FV_ES(freq, 2, 6), MG_FV_ES(freq, 3, 6)-MG_FV_ES(freq, 1, 6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.07 0.07]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

%%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(13); hold on; ylabel({'MG Activation', 'Effect Size',''}); yline(0, '--', 'Layer', 'bottom')
errorbar(1:51, MG_EMG_ES(:, 1, 1), MG_EMG_ES(:, 1, 1) - MG_EMG_ES(:, 2, 1), MG_EMG_ES(:, 3, 1) - MG_EMG_ES(:, 1, 1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-0.45 0.45]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(15); hold on; yline(0, '--', 'Layer', 'bottom')
errorbar(1:51, MG_EMG_ES(:, 1, 5), MG_EMG_ES(:, 1, 5) - MG_EMG_ES(:, 2, 5), MG_EMG_ES(:, 3, 5) - MG_EMG_ES(:, 1, 5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-6.1 6.1]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(14); hold on; freq = [1:21, 25:51]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, MG_EMG_ES(freq, 1,2), MG_EMG_ES(freq,1,2)-MG_EMG_ES(freq,2,2), MG_EMG_ES(freq,3,2)-MG_EMG_ES(freq,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-0.045 0.045]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(16); hold on; freq = [1:7, 9:51]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, MG_EMG_ES(freq,1,6), MG_EMG_ES(freq,1,6)-MG_EMG_ES(freq,2,6), MG_EMG_ES(freq,3,6)-MG_EMG_ES(freq,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-1.2 1.2]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

%%%%%%%%%%%%%%%%%%%%%%%%%% Ankle Torque Effects %%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(19); hold on; yline(0, '--', 'Layer', 'bottom');
ylabel({'Ankle Joint Torque', 'Effect Size',''});
errorbar(1:51, TR_ES(:,1,1), TR_ES(:,1,1)-TR_ES(:,2,1), TR_ES(:,3,1)-TR_ES(:,1,1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.25 0.25]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

text(0, -0.25*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.25*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(21); hold on; yline(0, '--', 'Layer', 'bottom');
errorbar(1:51, TR_ES(:,1,5), TR_ES(:,1,5)-TR_ES(:,2,5), TR_ES(:,3,5)-TR_ES(:,1,5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-1.2 1.2]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

text(0, -1.2*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -1.2*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(23); hold on; yline(0, '--', 'Layer', 'bottom'); title('$|S22|$'); 
errorbar(1:51, TR_ES(:,1,3), TR_ES(:,1,3)-TR_ES(:,2,3), TR_ES(:,3,3)-TR_ES(:,1,3), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.22 0.22]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

text(0, -0.22*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.22*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(20); hold on; yline(0, '--', 'Layer', 'bottom'); freq = [1:21,  25:51];
errorbar(freq, TR_ES(freq, 1, 2), TR_ES(freq, 2, 2), TR_ES(freq, 3, 2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.07 0.07]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

text(0, -0.07*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.07*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(22); hold on; yline(0, '--', 'Layer', 'bottom'); freq = [1:6, 9:51];
errorbar(freq, TR_ES(freq,1,6), TR_ES(freq,1,6)-TR_ES(freq,2,6), TR_ES(freq,3,6)-TR_ES(freq,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.3 0.3]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

text(0, -0.3*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.3*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(24); hold on; yline(0, '--', 'Layer', 'bottom'); freq = [3:17, 23:51]; title('$\angle S22$'); 
errorbar(freq, TR_ES(freq,1,4), TR_ES(freq,1,4)-TR_ES(freq,2,4), TR_ES(freq,3,4)-TR_ES(freq,1,4), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.026 0.026]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

text(0, -0.026*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.026*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})
