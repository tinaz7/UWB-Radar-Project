%% Normalise VL and MG Data - Rect
clear
%test
VL_dat = load("VL Data\RectangularES_interpolatedSpline_LP.mat");
MG_dat = load("Walking Data\RectangularTorqueES_LP.mat");

MG_FL = normalise(MG_dat.MG_FL_ES, [1, 2, 5, 6]);
MG_FV = normalise(MG_dat.MG_FV_ES, [1, 2, 5, 6]);
MG_EMG = normalise(MG_dat.MG_EMG_ES, [1, 2, 5, 6]);
MG_Torque = normalise(MG_dat.Torque_ES, [1, 2, 5, 6]);

VL_FL = normalise(VL_dat.VL_FL_ES, [1, 2, 3, 4]);
VL_FV = normalise(VL_dat.VL_FV_ES, [1, 2, 3, 4]);
VL_EMG = normalise(VL_dat.VL_EMG_ES, [1, 2, 3, 4]);
VL_Torque = bestfit(MG_Torque, normalise(VL_dat.VL_T_ES, [1, 2, 3, 4]));

%% Fascicle Length Effect Size Plots - Rect
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

linestyle = '.';

figure(1); clf
tiledlayout(3, 5);
freq = 1:51;

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(1); hold on; title('Re(S11)')
ylabel({'Fascicle Strain', 'Effect Size',''})
[eVal, ~] = errorbarSeparate(freq, MG_FL(freq,1,1), MG_FL(freq,2,1));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FL(freq,1,1), VL_FL(freq,2,1));
errorbarFormat(eVal, 2, linestyle)
plotFormat(1, 0)

nexttile(2); hold on; title('Im(S11)')
[eVal, ~] = errorbarSeparate(freq, MG_FL(freq,1,2), MG_FL(freq,2,2));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FL(freq,1,2), VL_FL(freq,2,2));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 0)

nexttile(3); hold on; title('Re(S21)')
[eVal, ~] = errorbarSeparate(freq, MG_FL(freq,1,5), MG_FL(freq,2,5));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FL(freq,1,3), VL_FL(freq,2,3));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 0)

nexttile(4); hold on; title('Im(S21)')
[eVal, ~] = errorbarSeparate(freq, MG_FL(freq,1,6), MG_FL(freq,2,6));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FL(freq,1,4), VL_FL(freq,2,4));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 0)

%%%%%%%%%%%%%%%%%%%%%%% Fascicle Velocity Effects %%%%%%%%%%%%%%%%%%%%%%%%

nexttile(6); hold on;
ylabel({'MG Fascicle Velocity', 'Effect Size',''})
[eVal, ~] = errorbarSeparate(freq, MG_FV(freq,1,1), MG_FV(freq,2,1));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FV(freq,1,1), VL_FV(freq,2,1));
errorbarFormat(eVal, 2, linestyle)
plotFormat(1, 0)

nexttile(7); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_FV(freq,1,2), MG_FV(freq,2,2));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FV(freq,1,2), VL_FV(freq,2,2));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 0)

nexttile(8); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_FV(freq,1,5), MG_FV(freq,2,5));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FV(freq,1,3), VL_FV(freq,2,3));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 0)

nexttile(9); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_FV(freq,1,6), MG_FV(freq,2,6));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FV(freq,1,4), VL_FV(freq,2,4));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 0)

%%%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(11); hold on;
ylabel({'MG Activation', 'Effect Size',''})
[eVal, ~] = errorbarSeparate(freq, MG_EMG(freq,1,1), MG_EMG(freq,2,1));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_EMG(freq,1,1), VL_EMG(freq,2,1));
errorbarFormat(eVal, 2, linestyle)
plotFormat(1, 1)

nexttile(12); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_EMG(freq,1,2), MG_EMG(freq,2,2));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_EMG(freq,1,2), VL_EMG(freq,2,2));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 1)

nexttile(13); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_EMG(freq,1,5), MG_EMG(freq,2,5));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_EMG(freq,1,3), VL_EMG(freq,2,3));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 1)

nexttile(14); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_EMG(freq,1,6), MG_EMG(freq,2,6));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_EMG(freq,1,4), VL_EMG(freq,2,4));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0, 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Legend %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(15); hold on
e1 = errorbar(NaN, NaN, NaN);
errorbarFormat(e1, 1, linestyle)
e2 = errorbar(NaN, NaN, NaN);errorbarFormat(e2, 2, linestyle)
axis off
legend('MG', 'VL (Spline interpolated)')

%% Torque Plots
linestyle = '.';
fig = figure(1); clf
fig.Units = 'inches';
fig.Position = [2, 2, 7.16, 2.5];

fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 7.16 2.5];
fig.PaperSize = [7.16 2.5];

tiledlayout(1, 3, 'TileSpacing','compact', 'Padding', 'compact');
freq = 1:51;

nexttile(1); hold on; % title('Re(S11)')
% ylabel({'Estimated Torque', 'Effect Size',''})
[eVal, ~] = errorbarSeparate(freq, MG_Torque(freq,1,1), MG_Torque(freq,2,1), 1);
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_Torque(freq,1,1), VL_Torque(freq,2,1), 2);
errorbarFormat(eVal, 2, linestyle)
maxlim = plotFormat(1, 0);
Rsquare(MG_Torque(freq,1,1), VL_Torque(freq,1,1), maxlim)
axis square

nexttile(2); hold on; % title('Im(S11)')
[eVal, ~] = errorbarSeparate(freq, MG_Torque(freq,1,2), MG_Torque(freq,2,2), 1);
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_Torque(freq,1,2), VL_Torque(freq,2,2), 2);
errorbarFormat(eVal, 2, linestyle)
maxlim = plotFormat(0, 0);
Rsquare(MG_Torque(freq,1,2), VL_Torque(freq,1,2), maxlim)
axis square

% nexttile(7, [2,1]); hold on; title('Re(S21)')
% [eVal, ~] = errorbarSeparate(freq, MG_Torque(freq,1,5), MG_Torque(freq,2,5));
% errorbarFormat(eVal, 1, linestyle)
% [eVal, ~] = errorbarSeparate(freq, VL_Torque(freq,1,3), VL_Torque(freq,2,3));
% errorbarFormat(eVal, 2, linestyle)
% maxlim = plotFormat(1, 1);
% Rsquare(MG_Torque(freq,1,5), VL_Torque(freq,1,3), maxlim)
% 
% nexttile(8, [2,1]); hold on; title('Im(S21)')
% [eVal, ~] = errorbarSeparate(freq, MG_Torque(freq,1,6), MG_Torque(freq,2,6));
% errorbarFormat(eVal, 1, linestyle)
% [eVal, ~] = errorbarSeparate(freq, VL_Torque(freq,1,4), VL_Torque(freq,2,4));
% errorbarFormat(eVal, 2, linestyle)
% maxlim = plotFormat(0, 1);
% Rsquare(MG_Torque(freq,1,6), VL_Torque(freq,1,4), maxlim)

colset = orderedcolors("gem12");
col1 = colset(9, :) .* 0.85; 
col3 = colset(3, :);
plot(NaN, 'o', 'Color', col1, MarkerSize=3, MarkerFaceColor=col1)
plot(NaN, 'o', 'Color', col3, MarkerSize=3, MarkerFaceColor=col3)
legend('','','','','', 'MG','VL')

outLoc = 'C:\Users\zheng\OneDrive\Desktop\ENGG7291 Assessment\Paper\Figures';
print(fig, [outLoc, '\Comparison.svg'], '-dsvg');
%% R2

figure(3); clf
tiledlayout(1,6);

load('C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\LME models\Effect Size\Walking Data\RectangularTorqueES_R2.mat')

nexttile(1)
plot(R2_tbl.R2_ReS11)
nexttile(2)
plot(R2_tbl.R2_ImS11)
nexttile(3)
plot(R2_tbl.R2_ReS21)
nexttile(4)
plot(R2_tbl.R2_ImS21)
nexttile(5)
plot(R2_tbl.R2_ReS22)
nexttile(6)
plot(R2_tbl.R2_ImS22)

%% Normalise VL and MG - Polar
clear

VL_dat = load("VL Data\PolarES_interpolatedSpline.mat");
MG_dat = load("Walking Data\PolarTorqueES.mat");

MG_FL = normalise(MG_dat.MG_FL_ES, [1, 2, 5, 6]);
MG_FV = normalise(MG_dat.MG_FV_ES, [1, 2, 5, 6]);
MG_EMG = normalise(MG_dat.MG_EMG_ES, [1, 2, 5, 6]);
MG_Torque = normalise(MG_dat.MG_EMG_ES, [1, 2, 5, 6]);
% MG_Force = normalise(MG_dat.MG_Force_ES, [1, 2, 5, 6]);

VL_FL = normalise(VL_dat.VL_FL_ES, [1, 2, 3, 4]);
VL_FV = normalise(VL_dat.VL_FV_ES, [1, 2, 3, 4]);
VL_EMG = normalise(VL_dat.VL_EMG_ES, [1, 2, 3, 4]);
VL_Torque = bestfit(MG_Torque, normalise(VL_dat.VL_T_ES, [1, 2, 3, 4]));

function VL_new = bestfit(MG_Dat, VL_Dat)
    VL_new = VL_Dat;
    for i = 1
        m = lsqlin(VL_Dat(:,1,i), MG_Dat(:,1,i));
        VL_new(:,:,i) = VL_Dat(:,:,i) * m;
    end
end

%% Fascicle Length Effect Size Plots - Polar
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

linestyle = '.';

figure(3); clf
tiledlayout(3, 5);
freq = 1:51;

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(1); hold on; title('M(S11)')
ylabel({'Fascicle Strain', 'Effect Size',''})
[eVal, ~] = errorbarSeparate(freq, MG_FL(freq,1,1), MG_FL(freq,2,1));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FL(freq,1,1), VL_FL(freq,2,1));
errorbarFormat(eVal, 2, linestyle)
plotFormat(1)

nexttile(2); hold on; title('P(S11)')
[eVal, ~] = errorbarSeparate(freq, MG_FL(freq,1,2), MG_FL(freq,2,2));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FL(freq,1,2), VL_FL(freq,2,2));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

nexttile(3); hold on; title('M(S21)')
[eVal, ~] = errorbarSeparate(freq, MG_FL(freq,1,5), MG_FL(freq,2,5));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FL(freq,1,3), VL_FL(freq,2,3));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

nexttile(4); hold on; title('P(S21)')
[eVal, ~] = errorbarSeparate(freq, MG_FL(freq,1,6), MG_FL(freq,2,6));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FL(freq,1,4), VL_FL(freq,2,4));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

%%%%%%%%%%%%%%%%%%%%%%% Fascicle Velocity Effects %%%%%%%%%%%%%%%%%%%%%%%%

nexttile(6); hold on;
ylabel({'MG Fascicle Velocity', 'Effect Size',''})
[eVal, ~] = errorbarSeparate(freq, MG_FV(freq,1,1), MG_FV(freq,2,1));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FV(freq,1,1), VL_FV(freq,2,1));
errorbarFormat(eVal, 2, linestyle)
plotFormat(1)

nexttile(7); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_FV(freq,1,2), MG_FV(freq,2,2));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FV(freq,1,2), VL_FV(freq,2,2));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

nexttile(8); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_FV(freq,1,5), MG_FV(freq,2,5));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FV(freq,1,3), VL_FV(freq,2,3));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

nexttile(9); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_FV(freq,1,6), MG_FV(freq,2,6));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_FV(freq,1,4), VL_FV(freq,2,4));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

%%%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile(11); hold on;
ylabel({'MG Activation', 'Effect Size',''})
[eVal, ~] = errorbarSeparate(freq, MG_EMG(freq,1,1), MG_EMG(freq,2,1));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_EMG(freq,1,1), VL_EMG(freq,2,1));
errorbarFormat(eVal, 2, linestyle)
plotFormat(1)

nexttile(12); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_EMG(freq,1,2), MG_EMG(freq,2,2));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_EMG(freq,1,2), VL_EMG(freq,2,2));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

nexttile(13); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_EMG(freq,1,5), MG_EMG(freq,2,5));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_EMG(freq,1,3), VL_EMG(freq,2,3));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

nexttile(14); hold on;
[eVal, ~] = errorbarSeparate(freq, MG_EMG(freq,1,6), MG_EMG(freq,2,6));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_EMG(freq,1,4), VL_EMG(freq,2,4));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Legend %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(15); hold on
e1 = errorbar(NaN, NaN, NaN);
errorbarFormat(e1, 1, linestyle)
e2 = errorbar(NaN, NaN, NaN);errorbarFormat(e2, 2, linestyle)
axis off
legend('MG', 'VL (Spline interpolated)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Force %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4); clf
tiledlayout(3, 5);
freq = 1:51;

nexttile(1); hold on; title('M(S11)')
ylabel({'Estimated Force', 'Effect Size',''})
[eVal, ~] = errorbarSeparate(freq, MG_Torque(freq,1,1), MG_Torque(freq,2,1));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_Torque(freq,1,1), VL_Torque(freq,2,1));
errorbarFormat(eVal, 2, linestyle)
plotFormat(1)

nexttile(2); hold on; title('P(S11)')
[eVal, ~] = errorbarSeparate(freq, MG_Torque(freq,1,2), MG_Torque(freq,2,2));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_Torque(freq,1,2), VL_Torque(freq,2,2));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

nexttile(3); hold on; title('M(S21)')
[eVal, ~] = errorbarSeparate(freq, MG_Torque(freq,1,5), MG_Torque(freq,2,5));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_Torque(freq,1,3), VL_Torque(freq,2,3));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)

nexttile(4); hold on; title('P(S21)')
[eVal, ~] = errorbarSeparate(freq, MG_Torque(freq,1,6), MG_Torque(freq,2,6));
errorbarFormat(eVal, 1, linestyle)
[eVal, ~] = errorbarSeparate(freq, VL_Torque(freq,1,4), VL_Torque(freq,2,4));
errorbarFormat(eVal, 2, linestyle)
plotFormat(0)


%% Functions
function norm = normalise(data, include, freq)
    arguments
        data
        include
        freq = []
    end
    norm = zeros(51, 2, 6);
    for i = 1:6
        if ismember(i, include)
            if isempty(freq) || i ~= 2
                datMax = max(abs(data(:,1,i)));
            else
                datMax = max(abs(data(freq,1,i)));
            end
            norm(:,1,i) = data(:,1,i)/datMax;
            norm(:,2,i) = (abs(data(:,1,i) - data(:,2,i)))/datMax;
        end
    end
end

function maxlim = plotFormat(yLabel, xLabel)
    grid on

    ylimit = get(gca, 'YLim'); 
    maxlim = 1.1* max(abs(ylimit)); set(gca, 'YLim', [-maxlim maxlim]);
    yticks([-maxlim -maxlim*0.5 0 maxlim*0.5 maxlim]);
    yticklabels([])
    yline(0, '--','Layer', 'bottom')

    xlim([0 52]); xticks([0 52*0.25 52*0.5 52*0.75 52]); grid on; 
    xticklabels([])

    if yLabel == 1
        text(-3, maxlim*0.85, '$+$'); text(-3, -maxlim*0.85, '$-$'); text(-3, 0, '0')
    end
    if xLabel == 1
        text(0, -maxlim*1.15, '0.31', 'HorizontalAlignment', 'center'); 
        text(52, -maxlim*1.15, '2.19', 'HorizontalAlignment', 'center')
        xlabel({'', 'Frequency (GHz)'})
    end
end

function errorbarFormat(line, type, linestyle)

    colset = orderedcolors("gem12");
    col1 = colset(9, :) .* 0.85; 
    col3 = colset(3, :); 
    line.CapSize = 0;
    line.Marker = 'o';
    line.MarkerSize = 3;
    
    if type == 1 % MG Data
        if linestyle ~= '-'
            line.LineStyle = 'none';
            line.Color = col1;
            line.MarkerFaceColor = col1;
            line.MarkerEdgeColor = col1;
            line.LineWidth = 0.4;
        else
            line.Color = col1;
            line.LineWidth = 1.5;
        end
    elseif type == 2 % VL Data
        if linestyle ~= '-'
            line.LineStyle = 'none';
            line.Color = col3;
            line.MarkerFaceColor = col3;
            line.MarkerEdgeColor = col3;
            line.LineWidth = 0.4;
        else
            line.Color = col3;
            line.LineWidth = 1.5;
        end
    end
end

function [eVal, eErr] = errorbarSeparate(freq, values, errors, type)
    colset = orderedcolors("gem12");
    if type == 1
        col = colset(9, :) .* 0.85;
    else
        col = colset(3, :);
    end

    tempErr = zeros(size(errors));
    eErr = errorbar(freq, values, errors, errors, ...
                    'Marker', 'none', 'LineStyle', 'none', ...
                    'CapSize', 3, 'Color', col);
    eVal = errorbar(freq, values, tempErr, tempErr);
end

function R2 = Rsquare(dat1, dat2, maxlim)
    Pearsons = corr(dat1, dat2);
    R2 = Pearsons^2;
    text(37, maxlim*0.8, append('$R^2 = $ ', num2str(R2, '%.3f')));
end
