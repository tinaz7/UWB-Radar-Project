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

myDir = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\GaitCycleAveraged";

PIDs = ['01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10']; 
nDat = 12*10;

set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',14);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

% Initialise predictors and response variables
PID = zeros(nDat * 100, 1); COND = zeros(nDat * 100, 1);
TL = zeros(nDat * 100, 1); TR = zeros(nDat * 100, 1);
MG = zeros(nDat * 100, 1); LG = zeros(nDat * 100, 1);
FL = zeros(nDat * 100, 1); FV = zeros(nDat * 100, 1);
FA = zeros(nDat * 100, 1); FP = zeros(nDat * 100, 1);
S11_M = zeros(nDat*100, 51); S11_P = zeros(nDat*100, 51);
S21_M = zeros(nDat*100, 51); S21_P = zeros(nDat*100, 51);
S22_M = zeros(nDat*100, 51); S22_P = zeros(nDat*100, 51);

count = 0;
for k = 1 : size(PIDs, 1)
    % Load all PID data
    n = PIDs(k,:);

    files = dir(fullfile(myDir, ['S', n], '*.mat'));

    for l = 1 : length(files)
        file = load(fullfile(myDir, ['S', n], files(l).name));
        data = file.ALL.ValDat;

        PID(count*100 + 1 : 100*(count+1)) = data.PID(2:end);
        COND(count*100 + 1 : 100*(count+1)) = data.COND(2:end);
        TL(count*100 + 1 : 100*(count+1)) = data.TL(2:end);
        TR(count*100 + 1 : 100*(count+1)) = -data.TR(2:end);
        MG(count*100 + 1 : 100*(count+1)) = data.MG(2:end);
        LG(count*100 + 1 : 100*(count+1)) = data.LG(2:end);
        FL(count*100 + 1 : 100*(count+1)) = data.FL(2:end);
        FA(count*100 + 1 : 100*(count+1)) = data.FA(2:end);
        FP(count*100 + 1 : 100*(count+1)) = data.FP(2:end);
        FV(count*100 + 1 : 100*(count+1)) = data.FV(2:end);

        file = load(fullfile(myDir, ['S', n], files(l).name));

        S11_M(count*100 + 1 : 100*(count+1), :) = file.ALL.S11_M_Dat{2:end, :};
        S11_P(count*100 + 1 : 100*(count+1), :) = file.ALL.S11_P_Dat{2:end, :};
        S12_M(count*100 + 1 : 100*(count+1), :) = file.ALL.S12_M_Dat{2:end, :};
        S12_P(count*100 + 1 : 100*(count+1), :) = file.ALL.S12_P_Dat{2:end, :};
        S22_M(count*100 + 1 : 100*(count+1), :) = file.ALL.S22_M_Dat{2:end, :};
        S22_P(count*100 + 1 : 100*(count+1), :) = file.ALL.S22_P_Dat{2:end, :};

        count = count + 1;
    end
end


S11_M_table = array2table(S11_M); S11_P_table = array2table(S11_P);
S12_M_table = array2table(S12_M); S12_P_table = array2table(S12_P);
S21_M_table = array2table(S21_M); S21_P_table = array2table(S21_P);
S22_M_table = array2table(S22_M); S22_P_table = array2table(S22_P);
S11_M_table.Properties.VariableNames = strcat("S11_M_", string(1:51));
S11_P_table.Properties.VariableNames = strcat("S11_P_", string(1:51));
S21_M_table.Properties.VariableNames = strcat("S21_M_", string(1:51));
S21_P_table.Properties.VariableNames = strcat("S21_P_", string(1:51));
S22_M_table.Properties.VariableNames = strcat("S22_M_", string(1:51));
S22_P_table.Properties.VariableNames = strcat("S22_P_", string(1:51));

tbl1 = table(PID, COND, TL, TR, MG, LG, FL, FA, FP, FV);
tbl1 = [tbl1, S11_M_table, S11_P_table, ...
            S21_M_table, S21_P_table, S22_M_table, S22_P_table];

% Store effect size and CI for each coefficient across all frequencies
FL_ES = zeros(51, 3, 6); FA_ES = zeros(51, 3, 6);
FV_ES = zeros(51, 3, 6); %FP_ES = zeros(51, 3, 6);
MG_ES = zeros(51, 3, 6); LG_ES = zeros(51, 3, 6); 
TR_ES = zeros(51, 3, 6);

RsquaredOrd = zeros(51, 6); RsquaredAdj = zeros(51, 6);

modelsFL = cell(6,1); modelsFA = cell(6,1);
AIC = zeros(51,6); BIC = zeros(51, 6);
test = cell(2,1); 
testCoeff = zeros(51, 3, 4);

for i = 1:51

    S11_M_i = strcat("S11_M_", string(i)); S11_P_i = strcat("S11_P_", string(i));
    S12_M_i = strcat("S12_M_", string(i)); S12_P_i = strcat("S12_P_", string(i));
    S21_M_i = strcat("S21_M_", string(i)); S21_P_i = strcat("S21_P_", string(i));
    S22_M_i = strcat("S22_M_", string(i)); S22_P_i = strcat("S22_P_", string(i));

    % LME models for each reflection/transmission coefficient - uncomment
    % for fascicle strain (FL), fascicle pennation (FA), or both

    modelsFL{1} = fitlme(tbl1, strcat(S11_M_i, " ~ FL + FV + MG + TR + (1|PID) + (COND|PID)"));
    modelsFL{2} = fitlme(tbl1, strcat(S11_P_i, " ~ FL + FV + MG + TR + (1|PID) + (COND|PID)"));
    modelsFL{3} = fitlme(tbl1, strcat(S22_M_i, " ~ LG + TR + (1|PID) + (COND|PID)"));
    modelsFL{4} = fitlme(tbl1, strcat(S22_P_i, " ~ LG + TR + (1|PID) + (COND|PID)"));
    modelsFL{5} = fitlme(tbl1, strcat(S21_M_i, " ~ FL + FV + MG + LG + TR + (1|PID) + (COND|PID)"));
    modelsFL{6} = fitlme(tbl1, strcat(S21_P_i, " ~ FL + FV + MG + LG + TR + (1|PID) + (COND|PID)"));

    % modelsFA{1} = fitlme(tbl1, strcat(S11_M_i, " ~ FA + FV + MG + TR + COND + (1|PID) + (COND|PID)"));
    % modelsFA{2} = fitlme(tbl1, strcat(S11_P_i, " ~ FA + FV + MG + TR + COND + (1|PID) + (COND|PID)"));
    % modelsFA{3} = fitlme(tbl1, strcat(S22_M_i, " ~ LG + TR + COND + (1|PID) + (COND|PID)"));
    % modelsFA{4} = fitlme(tbl1, strcat(S22_P_i, " ~ LG + TR + COND + (1|PID) + (COND|PID)"));
    % modelsFA{5} = fitlme(tbl1, strcat(S21_M_i, " ~ FA + FV + MG + LG + TR + COND + (1|PID) + (COND|PID)"));
    % modelsFA{6} = fitlme(tbl1, strcat(S21_P_i, " ~ FA + FV + MG + LG + TR + COND + (1|PID) + (COND|PID)"));
    
    % Only uncomment when running both fascicle strain (FL) and fascicle
    % pennation models (FA)
    for C = 1:6
        comp = compare(models{C}, modelsFA{C});
        AIC(i, C) = comp.AIC(1,1) - comp.AIC(2,1);
        BIC(i, C) = comp.BIC(1,1) - comp.BIC(2,1);
        pvals(i, C) = comp.pValue(1,1) - comp.pValue(2,1);
    end

    % Uncomment to record all R2 values
    for R = 1:6
        RsquaredAdj(i, R) = modelsFS{R,1}.Rsquared.Adjusted;
    end
    
    % Change modelsFL to modelsFA is fascicle pennation model coefficients
    % are to be obtained
    for j = 1 : 6
        TR_idx = find(strcmp(modelsFL{j, 1}.Coefficients.Name, 'TR'));
        TR_ES(i, 1, j) = modelsFL{j, 1}.Coefficients.Estimate(TR_idx);
        TR_ES(i, 2, j) = modelsFL{j, 1}.Coefficients.Lower(TR_idx);
        TR_ES(i, 3, j) = modelsFL{j, 1}.Coefficients.Upper(TR_idx);

        if j ~= 3 && j ~= 4
            % FA_idx = find(strcmp(modelsFA{j, 1}.Coefficients.Name, 'FA'));
            % FA_ES(i, 1, j) = modelsFA{j, 1}.Coefficients.Estimate(FA_idx);
            % FA_ES(i, 2, j) = modelsFA{j, 1}.Coefficients.Lower(FA_idx);
            % FA_ES(i, 3, j) = modelsFA{j, 1}.Coefficients.Upper(FA_idx);

            FL_idx = find(strcmp(modelsFL{j, 1}.Coefficients.Name, 'FA'));
            FL_ES(i, 1, j) = modelsFL{j, 1}.Coefficients.Estimate(FA_idx);
            FL_ES(i, 2, j) = modelsFL{j, 1}.Coefficients.Lower(FA_idx);
            FL_ES(i, 3, j) = modelsFL{j, 1}.Coefficients.Upper(FA_idx);

            FV_idx = find(strcmp(modelsFL{j, 1}.Coefficients.Name, 'FV'));
            FV_ES(i, 1, j) = modelsFL{j, 1}.Coefficients.Estimate(FV_idx);
            FV_ES(i, 2, j) = modelsFL{j, 1}.Coefficients.Lower(FV_idx);
            FV_ES(i, 3, j) = modelsFL{j, 1}.Coefficients.Upper(FV_idx);

            MG_idx = find(strcmp(modelsFL{j, 1}.Coefficients.Name, 'MG'));
            MG_ES(i, 1, j) = modelsFL{j, 1}.Coefficients.Estimate(MG_idx);
            MG_ES(i, 2, j) = modelsFL{j, 1}.Coefficients.Lower(MG_idx);
            MG_ES(i, 3, j) = modelsFL{j, 1}.Coefficients.Upper(MG_idx);
        end
        if j ~= 1 && j ~= 2
            LG_idx = find(strcmp(modelsFL{j, 1}.Coefficients.Name, 'LG'));
            LG_ES(i, 1, j) = modelsFL{j, 1}.Coefficients.Estimate(LG_idx);
            LG_ES(i, 2, j) = modelsFL{j, 1}.Coefficients.Lower(LG_idx);
            LG_ES(i, 3, j) = modelsFL{j, 1}.Coefficients.Upper(LG_idx);
        end
    end
end

%% Section 2: Fascicle Length Effect Size Plots
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; col2 = colset(4, :); col3 = colset(3, :); 
col4 = [0.5 0.5 0.5]; col5 = colset(5, :);

figure(1); clf
tiledlayout(4, 6);

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(1); hold on; title('$|S11|$');ylabel({'MG Fascicle Strain', 'Effect Size',''}); yline(0, '--', 'Layer', 'bottom'); 
errorbar(1:51, FL_ES(:,1,1), FL_ES(:,1,1)-FL_ES(:,2,1), FL_ES(:,3,1)-FL_ES(:,1,1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1);

ylim([-0.9 0.9]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(3); hold on; title('$|S21|$'); yline(0, '--','Layer', 'bottom')
errorbar(1:51, FL_ES(:,1,5), FL_ES(:,1,5)-FL_ES(:,2,5), FL_ES(:,3,5)-FL_ES(:,1,5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-4.2 4.2]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(2); hold on; title('$\angle S11$'); freq = [1:21,25:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, FL_ES(freq,1,2), FL_ES(freq,1,2)-FL_ES(freq,2,2), FL_ES(freq,3,2)-FL_ES(freq,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-0.13 0.13]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(4); hold on; title('$\angle S21$'); freq = [1:6, 9:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, FL_ES(freq,1,6), FL_ES(freq,1,6)-FL_ES(freq,2,6), FL_ES(freq,3,6)-FL_ES(freq,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-1.1 1.1]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Rate Effects %%%%%%%%%%%%%%%%%%%%%%
nexttile(7); hold on; ylabel({'MG Fascicle Strain Rate', 'Effect Size',''}); yline(0, '--','Layer', 'bottom')
errorbar(1:51, FV_ES(:, 1, 1), FV_ES(:, 1, 1)-FV_ES(:, 2, 1), FV_ES(:, 3, 1)-FV_ES(:, 1, 1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.04 0.04]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(9); hold on; yline(0, '--','Layer', 'bottom')
errorbar(1:51, FV_ES(:, 1, 5), FV_ES(:, 1, 5)-FV_ES(:, 2, 5), FV_ES(:, 3, 5)-FV_ES(:, 1, 5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.3 0.3]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(8); hold on; freq = [1:6, 9:21, 25:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, FV_ES(freq, 1, 2), FV_ES(freq, 1, 2)-FV_ES(freq, 2, 2), FV_ES(freq, 3, 2)-FV_ES(freq, 1, 2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.004 0.004]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(10); hold on; freq = [1:6, 9:50]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, FV_ES(freq, 1, 6), FV_ES(freq, 1, 6)-FV_ES(freq, 2, 6), FV_ES(freq, 3, 6)-FV_ES(freq, 1, 6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.07 0.07]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

%%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(13); hold on; ylabel({'MG Activation', 'Effect Size',''}); yline(0, '--', 'Layer', 'bottom')
errorbar(1:51, MG_ES(:, 1, 1), MG_ES(:, 1, 1) - MG_ES(:, 2, 1), MG_ES(:, 3, 1) - MG_ES(:, 1, 1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-0.45 0.45]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(15); hold on; yline(0, '--', 'Layer', 'bottom')
errorbar(1:51, MG_ES(:, 1, 5), MG_ES(:, 1, 5) - MG_ES(:, 2, 5), MG_ES(:, 3, 5) - MG_ES(:, 1, 5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-3.2 3.2]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(14); hold on; freq = [1:21, 25:51]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, MG_ES(freq, 1,2), MG_ES(freq,1,2)-MG_ES(freq,2,2), MG_ES(freq,3,2)-MG_ES(freq,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-0.045 0.045]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(16); hold on; freq = [1:7, 9:51]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, MG_ES(freq,1,6), MG_ES(freq,1,6)-MG_ES(freq,2,6), MG_ES(freq,3,6)-MG_ES(freq,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-1 1]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

%%%%%%%%%%%%%%%%%%%%%%%%% Ankle Torque Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%
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
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

text(0, -1.2*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -1.2*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(23); hold on; yline(0, '--', 'Layer', 'bottom'); title('$|S22|$'); 
errorbar(1:51, TR_ES(:,1,3), TR_ES(:,1,3)-TR_ES(:,2,3), TR_ES(:,3,3)-TR_ES(:,1,3), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.22 0.22]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

text(0, -0.22*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.22*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(20); hold on; yline(0, '--', 'Layer', 'bottom'); freq = [1:21,  25:51];
errorbar(freq, TR_ES(freq, 1, 2), TR_ES(freq, 2, 2), TR_ES(freq, 3, 2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.07 0.07]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

text(0, -0.07*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.07*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(22); hold on; yline(0, '--', 'Layer', 'bottom'); freq = [1:6, 9:51];
errorbar(freq, TR_ES(freq,1,6), TR_ES(freq,1,6)-TR_ES(freq,2,6), TR_ES(freq,3,6)-TR_ES(freq,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.3 0.3]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

text(0, -0.3*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.3*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(24); hold on; yline(0, '--', 'Layer', 'bottom'); freq = [3:17, 23:51]; title('$\angle S22$'); 
errorbar(freq, TR_ES(freq,1,4), TR_ES(freq,1,4)-TR_ES(freq,2,4), TR_ES(freq,3,4)-TR_ES(freq,1,4), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);

ylim([-0.026 0.026]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

text(0, -0.026*1.2, '0.31', 'HorizontalAlignment', 'center'); text(52, -0.026*1.2, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})


%% Section 3: Rsquared Comparisons

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



%% Section 4: Fascicle Pennation Effect Size Plots
figure(3); clf
t1 = tiledlayout(4, 6);

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(1); hold on; title('$|S11|$');ylabel({'MG Fascicle Pennation', 'Effect Size',''}); yline(0, '--', 'Layer', 'bottom'); 
errorbar(1:51, FA_ES(:,1,1), FA_ES(:,1,1)-FA_ES(:,2,1), FA_ES(:,3,1)-FA_ES(:,1,1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1);

ylim([-0.05 0.05]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(3); hold on; title('$|S21|$'); yline(0, '--','Layer', 'bottom')
errorbar(1:51, FA_ES(:,1,5), FA_ES(:,1,5)-FA_ES(:,2,5), FA_ES(:,3,5)-FA_ES(:,1,5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-0.4 0.4]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(2); hold on; title('$\angle S11$'); freq = [1:21,25:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, FA_ES(freq,1,2), FA_ES(freq,1,2)-FA_ES(freq,2,2), FA_ES(freq,3,2)-FA_ES(freq,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-0.01 0.01]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(4); hold on; title('$\angle S21$'); freq = [1:6, 9:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, FA_ES(freq,1,6), FA_ES(freq,1,6)-FA_ES(freq,2,6), FA_ES(freq,3,6)-FA_ES(freq,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)

ylim([-0.065 0.065]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Rate Effects %%%%%%%%%%%%%%%%%%%%%%%
nexttile(7); hold on; ylabel({'MG Fascicle Strain Rate', 'Effect Size',''}); yline(0, '--','Layer', 'bottom')
errorbar(1:51, FV_ES(:, 1, 1), FV_ES(:, 1, 1)-FV_ES(:, 2, 1), FV_ES(:, 3, 1)-FV_ES(:, 1, 1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.04 0.04]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(9); hold on; yline(0, '--','Layer', 'bottom')
errorbar(1:51, FV_ES(:, 1, 5), FV_ES(:, 1, 5)-FV_ES(:, 2, 5), FV_ES(:, 3, 5)-FV_ES(:, 1, 5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.3 0.3]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(8); hold on; freq = [1:6, 9:21, 25:51]; yline(0, '--','Layer', 'bottom')
errorbar(freq, FV_ES(freq, 1, 2), FV_ES(freq, 1, 2)-FV_ES(freq, 2, 2), FV_ES(freq, 3, 2)-FV_ES(freq, 1, 2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.004 0.004]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(10); hold on; freq = [1:6, 9:50]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, FV_ES(freq, 1, 6), FV_ES(freq, 1, 6)-FV_ES(freq, 2, 6), FV_ES(freq, 3, 6)-FV_ES(freq, 1, 6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)

ylim([-0.07 0.07]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

%%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(13); hold on; ylabel({'MG Activation', 'Effect Size',''}); yline(0, '--', 'Layer', 'bottom')
errorbar(1:51, MG_ES(:, 1, 1), MG_ES(:, 1, 1) - MG_ES(:, 2, 1), MG_ES(:, 3, 1) - MG_ES(:, 1, 1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-0.45 0.45]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])
text(-6, limits(2)*0.85, '$+$'); text(-6, limits(1)*0.85, '$-$'); text(-6, 0, '0')

nexttile(15); hold on; yline(0, '--', 'Layer', 'bottom')
errorbar(1:51, MG_ES(:, 1, 5), MG_ES(:, 1, 5) - MG_ES(:, 2, 5), MG_ES(:, 3, 5) - MG_ES(:, 1, 5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-6.1 6.1]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(14); hold on; freq = [1:21, 25:51]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, MG_ES(freq, 1,2), MG_ES(freq,1,2)-MG_ES(freq,2,2), MG_ES(freq,3,2)-MG_ES(freq,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)

ylim([-0.045 0.045]); xlim([0 52]); limits = ylim;
yticks([limits(1) limits(1)*0.5 0 limits(2)*0.5 limits(2)]); grid on; yticklabels([]);
xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; xticklabels([])

nexttile(16); hold on; freq = [1:7, 9:51]; yline(0, '--', 'Layer', 'bottom')
errorbar(freq, MG_ES(freq,1,6), MG_ES(freq,1,6)-MG_ES(freq,2,6), MG_ES(freq,3,6)-MG_ES(freq,1,6), ...
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