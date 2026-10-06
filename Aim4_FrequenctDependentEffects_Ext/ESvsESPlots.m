%% Run ESvsFrequencyPlots for normalised values
%% Fascicle Length Effect Size Plots - Rect
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultAxesFontSize',12);
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultTextFontSize', 12);

linestyle = '-';

figure(1); clf
tiledlayout(3,5)
freq = 1:51;

function maskedData = mask(data_toMask, data_masking, num)
    freq = 1:51;
    mask = data_masking(freq,2,num) < data_masking(freq,1,num);
    maskedData = data_toMask(mask);
end

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(1); hold on; grid on
x = mask(MG_FL(freq,1,1), MG_FL, 1); y = mask(VL_FL(freq,1,1), MG_FL, 1);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Fascicle Length Effect Size', 'Re(S11)')
xlabel('MG'), ylabel('VL')

nexttile(2); hold on; grid on
x = mask(MG_FL(freq,1,2), MG_FL, 2); y = mask(VL_FL(freq,1,2), MG_FL, 2);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Fascicle Length Effect Size', 'Im(S11)')
xlabel('MG'), ylabel('VL')

nexttile(3); hold on; grid on
x = mask(MG_FL(freq,1,5), MG_FL, 5); y = mask(VL_FL(freq,1,3), MG_FL, 5);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Fascicle Length Effect Size', 'Re(S21)')
xlabel('MG'), ylabel('VL')

nexttile(4); hold on; grid on
x = mask(MG_FL(freq,1,6), MG_FL, 6); y = mask(VL_FL(freq,1,4), MG_FL, 6);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Fascicle Length Effect Size', 'Im(S211)')
xlabel('MG'), ylabel('VL')

%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Velocity Effects %%%%%%%%%%%%%%%%%%%%%%%
nexttile(6); hold on; grid on
x = mask(MG_FV(freq,1,1), MG_FV, 1); y = mask(VL_FV(freq,1,1), MG_FV, 1);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Fascicle Velocity Effect Size', 'Re(S11)')
xlabel('MG'), ylabel('VL')

nexttile(7); hold on; grid on;
x = mask(MG_FV(freq,1,2), MG_FV, 2); y = mask(VL_FV(freq,1,2), MG_FV, 2);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Fascicle Velocity Effect Size', 'Im(S11)')
xlabel('MG'), ylabel('VL')

nexttile(8); hold on; grid on
x = mask(MG_FV(freq,1,5), MG_FV, 5); y = mask(VL_FV(freq,1,3), MG_FV, 5);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Fascicle Velocity Effect Size', 'Re(S21)')
xlabel('MG'), ylabel('VL')

nexttile(9); hold on; grid on
x = mask(MG_FV(freq,1,6), MG_FV, 6); y = mask(VL_FV(freq,1,4), MG_FV, 6);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Fascicle Velocity Effect Size', 'Im(S21)')
xlabel('MG'), ylabel('VL')

%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile(11); hold on; grid on
x = mask(MG_EMG(freq,1,1), MG_EMG, 1); y = mask(VL_EMG(freq,1,1), MG_EMG, 1);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Activation Effect Size', 'Re(S11)')
xlabel('MG'), ylabel('VL')

nexttile(12); hold on; grid on
x = mask(MG_EMG(freq,1,2), MG_EMG, 2); y = mask(VL_EMG(freq,1,2), MG_EMG, 2);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Activation Effect Size', 'Im(S11)')
xlabel('MG'), ylabel('VL')

nexttile(13); hold on; grid on
x = mask(MG_EMG(freq,1,5), MG_EMG, 5); y = mask(VL_EMG(freq,1,3), MG_EMG, 5);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Activation Effect Size', 'Re(S21)')
xlabel('MG'), ylabel('VL')

nexttile(14); hold on; grid on
x = mask(MG_EMG(freq,1,6), MG_EMG, 6); y = mask(VL_EMG(freq,1,4), MG_EMG, 6);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Activation Effect Size', 'Im(S21)')
xlabel('MG'), ylabel('VL')
%% Torque - masked

figure(2); clf
tiledlayout(3,5)
freq = 1:51;

nexttile(1); hold on; grid on
x = mask(MG_Torque(freq,1,1), MG_Torque, 1); y = mask(VL_Torque(freq,1,1), MG_Torque, 1);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Torque and Force Effect Sizes', 'Re(S11)')
xlabel('MG'), ylabel('VL')

nexttile(2); hold on; grid on
x = mask(MG_Torque(freq,1,2), MG_Torque, 2); y = mask(VL_Torque(freq,1,2), MG_Torque, 2);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Torque and Force Effect Sizes', 'Im(S11)')
xlabel('MG'), ylabel('VL')

nexttile(3); hold on; grid on
x = mask(MG_Torque(freq,1,5), MG_Torque, 5); y = mask(VL_Torque(freq,1,3), MG_Torque, 5);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Torque and Force Effect Sizes', 'Re(S21)')
xlabel('MG'), ylabel('VL')

nexttile(4); hold on; grid on
x = mask(MG_Torque(freq,1,6), MG_Torque, 6); y = mask(VL_Torque(freq,1,4), MG_Torque, 6);
plot(x,y, '.')
line = fitlm(x,y); text(0, 0, string(line.Rsquared.Adjusted));
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
% R2 = (corr(y, line))^2; text(0,0, string(R2))
title('Torque and Force Effect Sizes', 'Im(S211)')
xlabel('MG'), ylabel('VL')
%% Torque - unmasked

figure(2); clf
tiledlayout(3,5)
freq = 1:51;

nexttile(1); hold on; grid on
x = MG_Torque(freq,1,1); y = VL_Torque(freq,1,1);
plot(x,y, '.')
line = fitlm(x,y); 
text(0, 0, [string(line.Rsquared.Adjusted),string(line.Coefficients.pValue(2))]);
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
title('Torque and Force Effect Sizes', 'Re(S11)')
xlabel('MG'), ylabel('VL')

nexttile(2); hold on; grid on
x = MG_Torque(freq,1,2); y = VL_Torque(freq,1,2);
plot(x,y, '.')
line = fitlm(x,y);
text(0, 0, [string(line.Rsquared.Adjusted),string(line.Coefficients.pValue(2))]);
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
title('Torque and Force Effect Sizes', 'Im(S11)')
xlabel('MG'), ylabel('VL')

nexttile(3); hold on; grid on
x = MG_Torque(freq,1,5); y = VL_Torque(freq,1,3);
plot(x,y, '.')
line = fitlm(x,y);
text(0, 0, [string(line.Rsquared.Adjusted),string(line.Coefficients.pValue(2))]);
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
title('Torque and Force Effect Sizes', 'Re(S21)')
xlabel('MG'), ylabel('VL')

nexttile(4); hold on; grid on
x = MG_Torque(freq,1,6); y = VL_Torque(freq,1,4);
plot(x,y, '.')
line = fitlm(x,y);
text(0, 0, [string(line.Rsquared.Adjusted),string(line.Coefficients.pValue(2))]);
plot(x, line.Coefficients.Estimate(2).*x + line.Coefficients.Estimate(1))
% line = x; plot(x, line)
% RMSE = sqrt(mean(y - line).^2); text(0,0, string(RMSE))
title('Torque and Force Effect Sizes', 'Im(S211)')
xlabel('MG'), ylabel('VL')