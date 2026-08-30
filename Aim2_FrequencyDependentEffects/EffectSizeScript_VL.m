clear

load("C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\VL Dat\VL_Data_Rectangular.mat")

for i = 1:51
    S11_R = total_uwb(1:51,:);
    S11_I = total_uwb(52:102,:);
    S21_R = total_uwb(103:153,:);
    S21_I = total_uwb(154:204,:);
end

S11_R_table = array2table(S11_R'); S11_I_table = array2table(S11_I');
S21_R_table = array2table(S21_R'); S21_I_table = array2table(S21_I');
S11_R_table.Properties.VariableNames = strcat("S11_R_", string(1:51));
S11_I_table.Properties.VariableNames = strcat("S11_I_", string(1:51));
S21_R_table.Properties.VariableNames = strcat("S21_R_", string(1:51));
S21_I_table.Properties.VariableNames = strcat("S21_I_", string(1:51));

labels = {'PID', 'VL_FL', 'VL_FV', 'VL_EMG', 'VL_T'};
tbl1 = table(total_part', total_len', total_vel', total_emg', total_torque', 'VariableNames', labels);
tbl1 = [tbl1, S11_R_table, S11_I_table, S21_R_table, S21_I_table];

% Store effect size and CI for each coefficient across all frequencies
VL_FL_ES = zeros(51, 3, 4);
VL_FV_ES = zeros(51, 3, 4);
VL_EMG_ES = zeros(51, 3, 4); 
VL_T_ES = zeros(51, 3, 4);

for i = 1:51

    S11_R_i = strcat("S11_R_", string(i)); S11_I_i = strcat("S11_I_", string(i));
    S21_R_i = strcat("S21_R_", string(i)); S21_I_i = strcat("S21_I_", string(i));
    S22_R_i = strcat("S22_R_", string(i)); S22_I_i = strcat("S22_I_", string(i));

    % LME models for each reflection/transmission coefficient - uncomment
    % for fascicle strain (FL), fascicle pennation (FA), or both

    % ALL.mat
    modelsFL{1} = fitlme(tbl1, strcat(S11_R_i, " ~ VL_FL + VL_FV + VL_EMG + VL_T + (1|PID)"));
    modelsFL{2} = fitlme(tbl1, strcat(S11_I_i, " ~ VL_FL + VL_FV + VL_EMG + VL_T + (1|PID)"));
    modelsFL{3} = fitlme(tbl1, strcat(S21_R_i, " ~ VL_FL + VL_FV + VL_EMG + VL_T + (1|PID)"));
    modelsFL{4} = fitlme(tbl1, strcat(S21_I_i, " ~ VL_FL + VL_FV + VL_EMG + VL_T + (1|PID)"));

    % NoForce.mat
    % modelsFL{1} = fitlme(tbl1, strcat(S11_R_i, " ~ MG_FL + MG_FV + MG_EMG + (1|PID) + (COND|PID)"));
    % modelsFL{2} = fitlme(tbl1, strcat(S11_I_i, " ~ MG_FL + MG_FV + MG_EMG + (1|PID) + (COND|PID)"));
    % modelsFL{3} = fitlme(tbl1, strcat(S22_R_i, " ~ LG_EMG + (1|PID) + (COND|PID)"));
    % modelsFL{4} = fitlme(tbl1, strcat(S22_I_i, " ~ LG_EMG + (1|PID) + (COND|PID)"));
    % modelsFL{5} = fitlme(tbl1, strcat(S21_R_i, " ~ MG_FL + MG_FV + MG_EMG + LG_EMG + (1|PID) + (COND|PID)"));
    % modelsFL{6} = fitlme(tbl1, strcat(S21_I_i, " ~ MG_FL + MG_FV + MG_EMG + LG_EMG + (1|PID) + (COND|PID)"));
   
    % NoEMG.mat
    % modelsFL{1} = fitlme(tbl1, strcat(S11_R_i, " ~ MG_FL + MG_FV + MG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{2} = fitlme(tbl1, strcat(S11_I_i, " ~ MG_FL + MG_FV + MG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{3} = fitlme(tbl1, strcat(S22_R_i, " ~ LG_EMG + LG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{4} = fitlme(tbl1, strcat(S22_I_i, " ~ LG_EMG + LG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{5} = fitlme(tbl1, strcat(S21_R_i, " ~ MG_FL + MG_FV + MG_Force + LG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{6} = fitlme(tbl1, strcat(S21_I_i, " ~ MG_FL + MG_FV + MG_Force + LG_Force + (1|PID) + (COND|PID)"));

    % NoUS.mat
    % modelsFL{1} = fitlme(tbl1, strcat(S11_R_i, " ~ MG_EMG + MG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{2} = fitlme(tbl1, strcat(S11_I_i, " ~ MG_EMG + MG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{3} = fitlme(tbl1, strcat(S22_R_i, " ~ LG_EMG + LG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{4} = fitlme(tbl1, strcat(S22_I_i, " ~ LG_EMG + LG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{5} = fitlme(tbl1, strcat(S21_R_i, " ~ MG_EMG + LG_EMG + MG_Force + LG_Force + (1|PID) + (COND|PID)"));
    % modelsFL{6} = fitlme(tbl1, strcat(S21_I_i, " ~ MG_EMG + LG_EMG + MG_Force + LG_Force + (1|PID) + (COND|PID)"));
    

    for j = 1:4
        VL_FL_idx = find(strcmp(modelsFL{1, j}.CoefficientNames, 'VL_FL'));
        VL_FL_ES(i, 1, j) = modelsFL{1, j}.Coefficients.Estimate(VL_FL_idx);
        VL_FL_ES(i, 2, j) = modelsFL{1, j}.Coefficients.Lower(VL_FL_idx);
        VL_FL_ES(i, 3, j) = modelsFL{1, j}.Coefficients.Upper(VL_FL_idx);

        VL_FV_idx = find(strcmp(modelsFL{1, j}.Coefficients.Name, 'VL_FV'));
        VL_FV_ES(i, 1, j) = modelsFL{1, j}.Coefficients.Estimate(VL_FV_idx);
        VL_FV_ES(i, 2, j) = modelsFL{1, j}.Coefficients.Lower(VL_FV_idx);
        VL_FV_ES(i, 3, j) = modelsFL{1, j}.Coefficients.Upper(VL_FV_idx);
        
        VL_EMG_idx = find(strcmp(modelsFL{1, j}.Coefficients.Name, 'VL_EMG'));
        VL_EMG_ES(i, 1, j) = modelsFL{1, j}.Coefficients.Estimate(VL_EMG_idx);
        VL_EMG_ES(i, 2, j) = modelsFL{1, j}.Coefficients.Lower(VL_EMG_idx);
        VL_EMG_ES(i, 3, j) = modelsFL{1, j}.Coefficients.Upper(VL_EMG_idx);

        VL_T_idx = find(strcmp(modelsFL{1, j}.Coefficients.Name, 'VL_T'));
        VL_T_ES(i, 1, j) = modelsFL{1, j}.Coefficients.Estimate(VL_T_idx);
        VL_T_ES(i, 2, j) = modelsFL{1, j}.Coefficients.Lower(VL_T_idx);
        VL_T_ES(i, 3, j) = modelsFL{1, j}.Coefficients.Upper(VL_T_idx);
    end
end

%% Save Data

outLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\Effect Size\VL Data";
save(fullfile(outLoc, "ALL.mat"), "VL_FL_ES", "VL_FV_ES", "VL_EMG_ES", "VL_T_ES")
%% Resample to MG frequencies

f_VL = 0.1:0.056:2.9;
f_MG = 0.35:0.0358: 2.15;

for i = 1:4
    VL_FL_ES(:, 1, i) = interp1(f_VL, VL_FL_ES(:, 1, i), f_MG, 'nearest'); 
    VL_FV_ES(:, 1, i) = interp1(f_VL, VL_FV_ES(:, 1, i), f_MG, 'nearest'); 
    VL_EMG_ES(:, 1, i) = interp1(f_VL, VL_EMG_ES(:, 1, i), f_MG, 'nearest'); 
    VL_T_ES(:, 1, i) = interp1(f_VL, VL_T_ES(:, 1, i), f_MG, 'nearest'); 

    VL_FL_ES(:, 2, i) = VL_FL_ES(:, 1, i); 
    VL_FV_ES(:, 2, i) = VL_FV_ES(:, 1, i); 
    VL_EMG_ES(:, 2, i) = VL_EMG_ES(:, 1, i); 
    VL_T_ES(:, 2, i) = VL_T_ES(:, 1, i); 

    VL_FL_ES(:, 3, i) = VL_FL_ES(:, 1, i); 
    VL_FV_ES(:, 3, i) = VL_FV_ES(:, 1, i); 
    VL_EMG_ES(:, 3, i) = VL_EMG_ES(:, 1, i); 
    VL_T_ES(:, 3, i) = VL_T_ES(:, 1, i); 
end


%% Section 2: Fascicle Length Effect Size Plots
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; 
col2 = colset(4, :); 
col3 = colset(3, :); 
col4 = [0.5 0.5 0.5];

figure(1); clf
tiledlayout(3, 5);
freq = 1:51;

function maxlim = plotFormat()
    grid on

    ylimit = get(gca, 'YLim'); 
    maxlim = 1.1 * max(abs(ylimit)); set(gca, 'YLim', [-maxlim maxlim]);
    yticks([-maxlim -maxlim*0.5 0 maxlim*0.5 maxlim]);
    yticklabels([])
    yline(0, '--','Layer', 'bottom')

    xlim([0 52]); xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; 
    xticklabels([])

    text(-6, maxlim*0.85, '$+$'); text(-6, -maxlim*0.85, '$-$'); text(-6, 0, '0')
end

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(1); hold on; title('Re(S11)')
ylabel({'VL Fascicle Strain', 'Effect Size',''})
errorbar(freq, VL_FL_ES(freq,1,1), VL_FL_ES(freq,1,1)-VL_FL_ES(freq,2,1), VL_FL_ES(freq,3,1)-VL_FL_ES(freq,1,1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)
plotFormat()

nexttile(3); hold on; title('Re(S21)')
errorbar(freq, VL_FL_ES(freq,1,3), VL_FL_ES(freq,1,3)-VL_FL_ES(freq,2,3), VL_FL_ES(freq,3,3)-VL_FL_ES(freq,1,3), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)
plotFormat()

nexttile(2); hold on; title('Im(S11)'); 
errorbar(freq, VL_FL_ES(freq,1,2), VL_FL_ES(freq,1,2)-VL_FL_ES(freq,2,2), VL_FL_ES(freq,3,2)-VL_FL_ES(freq,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)
plotFormat()

nexttile(4); hold on; title('Im(S21)');
errorbar(freq, VL_FL_ES(freq,1,4), VL_FL_ES(freq,1,4)-VL_FL_ES(freq,2,4), VL_FL_ES(freq,3,4)-VL_FL_ES(freq,1,4), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col1, 'MarkerEdgeColor', col1)
plotFormat()

%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Rate Effects %%%%%%%%%%%%%%%%%%%%%%
nexttile(6); hold on
ylabel({'VL Fascicle Strain Rate', 'Effect Size',''}); 
errorbar(freq, VL_FV_ES(freq, 1, 1), VL_FV_ES(freq, 1, 1)-VL_FV_ES(freq, 2, 1), VL_FV_ES(freq, 3, 1)-VL_FV_ES(freq, 1, 1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)
plotFormat()

nexttile(8); hold on
errorbar(freq, VL_FV_ES(freq, 1, 3), VL_FV_ES(freq, 1, 3)-VL_FV_ES(freq, 2, 3), VL_FV_ES(freq, 3, 3)-VL_FV_ES(freq, 1, 3), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)
plotFormat()

nexttile(7); hold on
errorbar(freq, VL_FV_ES(freq, 1, 2), VL_FV_ES(freq, 1, 2)-VL_FV_ES(freq, 2, 2), VL_FV_ES(freq, 3, 2)-VL_FV_ES(freq, 1, 2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)
plotFormat()

nexttile(9); hold on
errorbar(freq, VL_FV_ES(freq, 1, 4), VL_FV_ES(freq, 1, 4)-VL_FV_ES(freq, 2, 4), VL_FV_ES(freq, 3, 4)-VL_FV_ES(freq, 1, 4), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col2, 'MarkerEdgeColor', col2)
plotFormat()

%%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(11); hold on
ylabel({'VL Activation', 'Effect Size',''})
errorbar(freq, VL_EMG_ES(freq, 1, 1), VL_EMG_ES(freq, 1, 1) - VL_EMG_ES(freq, 2, 1), VL_EMG_ES(freq, 3, 1) - VL_EMG_ES(freq, 1, 1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)
plotFormat()

nexttile(13); hold on
errorbar(freq, VL_EMG_ES(freq, 1, 3), VL_EMG_ES(freq, 1, 3) - VL_EMG_ES(freq, 2, 3), VL_EMG_ES(freq, 3, 3) - VL_EMG_ES(freq, 1, 3), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)
plotFormat()

nexttile(12); hold on
errorbar(freq, VL_EMG_ES(freq, 1, 2), VL_EMG_ES(freq, 1, 2)-VL_EMG_ES(freq,2,2), VL_EMG_ES(freq,3,2)-VL_EMG_ES(freq,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)
plotFormat()

nexttile(14); hold on
errorbar(freq, VL_EMG_ES(freq, 1, 4), VL_EMG_ES(freq, 1, 4)-VL_EMG_ES(freq,2,4), VL_EMG_ES(freq,3,4)-VL_EMG_ES(freq,1,4), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col3, 'MarkerEdgeColor', col3)
plotFormat()

%% Section 3: Ankle Torque Effects
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; col2 = colset(4, :); col3 = colset(3, :); 
col4 = [0.5 0.5 0.5]; col5 = colset(5, :);

figure(2); clf
tiledlayout(2, 4);

nexttile(1); hold on; title('Re(S11)')
ylabel({'MG Force', 'Effect Size',''});
errorbar(1:51, MG_Force_ES(:,1,1), MG_Force_ES(:,1,1)-MG_Force_ES(:,2,1), MG_Force_ES(:,3,1)-MG_Force_ES(:,1,1), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
plotFormat();

nexttile(2); hold on; title('Im(S11)')
errorbar(1:51, MG_Force_ES(:,1,2), MG_Force_ES(:,1,2)-MG_Force_ES(:,2,2), MG_Force_ES(:,3,2)-MG_Force_ES(:,1,2), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
plotFormat();

nexttile(3); hold on; title('Re(21)')
errorbar(1:51, MG_Force_ES(:,1,5), MG_Force_ES(:,1,5)-MG_Force_ES(:,2,5), MG_Force_ES(:,3,5)-MG_Force_ES(:,1,5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
plotFormat();

nexttile(4); hold on; title('Im(S21)')
errorbar(1:51, MG_Force_ES(:,1,6), MG_Force_ES(:,1,6)-MG_Force_ES(:,2,6), MG_Force_ES(:,3,6)-MG_Force_ES(:,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
plotFormat();

nexttile(5); hold on; title('Re(S22)')
ylabel({'LG Force', 'Effect Size',''});
errorbar(1:51, LG_Force_ES(:,1,3), LG_Force_ES(:,1,3)-LG_Force_ES(:,2,3), LG_Force_ES(:,3,3)-LG_Force_ES(:,1,3), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
maxlim = plotFormat();
text(0, -maxlim*1.1, '0.31', 'HorizontalAlignment', 'center'); text(52, -maxlim*1.1, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(6); hold on; title('Im(S22)')
errorbar(1:51, LG_Force_ES(:,1,4), LG_Force_ES(:,1,4)-LG_Force_ES(:,2,4), LG_Force_ES(:,3,4)-LG_Force_ES(:,1,4), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
maxlim = plotFormat();
text(0, -maxlim*1.1, '0.31', 'HorizontalAlignment', 'center'); text(52, -maxlim*1.1, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(7); hold on; title('Re(S21)')
errorbar(1:51, LG_Force_ES(:,1,5), LG_Force_ES(:,1,5)-LG_Force_ES(:,2,5), LG_Force_ES(:,3,5)-LG_Force_ES(:,1,5), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
maxlim = plotFormat();
text(0, -maxlim*1.1, '0.31', 'HorizontalAlignment', 'center'); text(52, -maxlim*1.1, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

nexttile(8); hold on; title('Im(S21)')
errorbar(1:51, LG_Force_ES(:,1,6), LG_Force_ES(:,1,6)-LG_Force_ES(:,2,6), LG_Force_ES(:,3,6)-LG_Force_ES(:,1,6), ...
         '.', 'Markersize', 12, 'CapSize', 3, 'Color', col4, 'MarkerFaceColor', col5, 'MarkerEdgeColor', col5);
maxlim = plotFormat();
text(0, -maxlim*1.1, '0.31', 'HorizontalAlignment', 'center'); text(52, -maxlim*1.1, '2.19', 'HorizontalAlignment', 'center')
xlabel({'', 'Frequency (GHz)'})

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
