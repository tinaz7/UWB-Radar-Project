function [signal_split] = GaitCycleSplit(grf, signal, signal_times, numPoints)
%GAITCYCLESPLIT Splits and resamples signal based on gait-cycles from grf.
%               GRF is low-pass filtered with 12Hz zero-lag butterworth,
%               and gait-cycles detected. Each gait cycle of signal is 
%               resampled to 100 pts, and added as a row to signal_split.
%
%   INPUTS:
%   grf             Vertical ground reaction forces, from the same leg as
%                   signal. Should not be filtered.
%
%   signal          Signal to be split on gait-cycles, from the same leg as
%                   grf. Should be filtered before use.
%
%   signal_times    Timestamps in seconds for signal. Must be the same 
%                   length as signal, with '0' corresponding to beginning
%                   of grf signal.
%
%   num_points      Number of points to be resampled to. Default 100.
%
%   OUTPUTS:
%   signal_split    100xN array of split signal, with each row (N)
%                   corresponding to one gait-cycle, resampled to be from
%                   1-100%.
    arguments
        grf
        signal
        signal_times
        numPoints = 100
    end

    grf_threshold = 15;     % Threshold for detecting heel-strike
    Fs_grf = 1250;          % GRF sampling rate (fixed 1.25kHz)

    grf_times = (0 : (length(grf)-1)) / Fs_grf;

    [b,a] = butter(4, 12/(Fs_grf/2));
    grf_filt = filtfilt(b, a, grf);

    % Find each transition point rising through threshold. 
    % Treat the last sample below threshold as instant of heel-strike.
    heelStrike = [(grf_filt(1:end-1) < grf_threshold) & (grf_filt(2:end) >= grf_threshold),0];
    heelStrikeIdx = find(heelStrike);

    signal_split = zeros(numPoints, sum(heelStrike)-1);

    signal_times = signal_times(~isnan(signal));
    signal = signal(~isnan(signal));

    for cycle = 1 : (sum(heelStrike)-1)
        startTime = grf_times(heelStrikeIdx(cycle));
        endTime = grf_times(heelStrikeIdx(cycle+1));
        dt = (endTime - startTime) / numPoints;
        queryPoints = startTime : dt : endTime - dt;
        signal_split(:, cycle) = interp1(signal_times, signal, queryPoints, 'spline', nan);
    end
    signal_split = signal_split(:, sum(isnan(signal_split))==0);


end
