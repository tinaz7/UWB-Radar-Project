%% Normalise VL and MG Data - Rect
clear

VL_dat = load("VL Data\RectangularES_interpolatedSpline.mat");
MG_dat = load("Walking Data\RectangularES.mat");

MG_FL = normalise(MG_dat.MG_FL_ES, [1, 2, 5, 6]);
MG_FV = normalise(MG_dat.MG_FV_ES, [1, 2, 5, 6]);
MG_EMG = normalise(MG_dat.MG_EMG_ES, [1, 2, 5, 6]);
MG_Force = normalise(MG_dat.MG_Force_ES, [1, 2, 5, 6]);

VL_FL = normalise(VL_dat.VL_FL_ES, [1, 2, 3, 4]);
VL_FV = normalise(VL_dat.VL_FV_ES, [1, 2, 3, 4]);
VL_EMG = normalise(VL_dat.VL_EMG_ES, [1, 2, 3, 4]);
VL_Torque = normalise(VL_dat.VL_T_ES, [1, 2, 3, 4]);

%% Normalise VL and MG - Polar
clear

VL_dat = load("VL Data\PolarES_interpolatedSpline.mat");
MG_dat = load("Walking Data\PolarES.mat");
freq = [1:21, 25:51];

MG_FL = normalise(MG_dat.MG_FL_ES, [1, 2, 5, 6], freq);
MG_FV = normalise(MG_dat.MG_FV_ES, [1, 2, 5, 6], freq);
MG_EMG = normalise(MG_dat.MG_EMG_ES, [1, 2, 5, 6], freq);
MG_Force = normalise(MG_dat.MG_Force_ES, [1, 2, 5, 6], freq);

VL_FL = normalise(VL_dat.VL_FL_ES, [1, 2, 3, 4]);
VL_FV = normalise(VL_dat.VL_FV_ES, [1, 2, 3, 4]);
VL_EMG = normalise(VL_dat.VL_EMG_ES, [1, 2, 3, 4]);
VL_Torque = normalise(VL_dat.VL_T_ES, [1, 2, 3, 4]);

%% 
figure(1);clf
tiledlayout('flow')

Rval = zeros(16,2);

freq = 1:51;
%%%%%%%%%%%%%%%%%%%%%%%% Fascicle Strain Effects %%%%%%%%%%%%%%%%%%%%%%%%%
nexttile
MG = abs(MG_FL(freq,1,1));
VL = abs(VL_FL(freq,1,1));
[R,P] = R2(MG, VL);
Rval(1,1) = R; Rval(1,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_FL(freq,1,2));
VL = abs(VL_FL(freq,1,2));
[R,P] = R2(MG, VL);
Rval(2,1) = R; Rval(2,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_FL(freq,1,5));
VL = abs(VL_FL(freq,1,3));
[R,P] = R2(MG, VL);
Rval(3,1) = R; Rval(3,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_FL(freq,1,6));
VL = abs(VL_FL(freq,1,4));
[R,P] = R2(MG, VL);
Rval(4,1) = R; Rval(4,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

%%%%%%%%%%%%%%%%%%%%%%% Fascicle Velocity Effects %%%%%%%%%%%%%%%%%%%%%%%%

nexttile
MG = abs(MG_FV(freq,1,1));
VL = abs(VL_FV(freq,1,1));
[R,P] = R2(MG, VL);
Rval(5,1) = R; Rval(5,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_FV(freq,1,2));
VL = abs(VL_FV(freq,1,2));
[R,P] = R2(MG, VL);
Rval(6,1) = R; Rval(6,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_FV(freq,1,5));
VL = abs(VL_FV(freq,1,3));
[R,P] = R2(MG, VL);
Rval(7,1) = R; Rval(6,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_FV(freq,1,6));
VL = abs(VL_FV(freq,1,4));
[R,P] = R2(MG, VL);
Rval(8,1) = R; Rval(8,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

%%%%%%%%%%%%%%%%%%%%%%%%%%% Activation Effects %%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile
MG = abs(MG_EMG(freq,1,1));
VL = abs(VL_EMG(freq,1,1));
[R,P] = R2(MG, VL);
Rval(9,1) = R; Rval(9,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_EMG(freq,1,2));
VL = abs(VL_EMG(freq,1,2));
[R,P] = R2(MG, VL);
Rval(10,1) = R; Rval(10,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_EMG(freq,1,5));
VL = abs(VL_EMG(freq,1,3));
[R,P] = R2(MG, VL);
Rval(11,1) = R; Rval(11,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_EMG(freq,1,6));
VL = abs(VL_EMG(freq,1,4));
[R,P] = R2(MG, VL);
Rval(12,1) = R; Rval(12,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Force %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile
MG = abs(MG_Force(freq,1,1));
VL = abs(VL_Torque(freq,1,1));
[R,P] = R2(MG, VL);
Rval(13,1) = R; Rval(13,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_Force(freq,1,2));
VL = abs(VL_Torque(freq,1,2));
[R,P] = R2(MG, VL);
Rval(14,1) = R; Rval(14,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_Force(freq,1,5));
VL = abs(VL_Torque(freq,1,3));
[R,P] = R2(MG, VL);
Rval(15,1) = R; Rval(15,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

nexttile
MG = abs(MG_Force(freq,1,6));
VL = abs(VL_Torque(freq,1,4));
[R,P] = R2(MG, VL);
Rval(16,1) = R; Rval(16,2) = P;
hold on; plot(freq, MG); plot(freq, VL)

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


function [R,P] = R2(MG_Dat, VL_Dat)
    [R,P] = corr(MG_Dat, VL_Dat, 'Type', 'Spearman');
    % R2 = R^2;
end