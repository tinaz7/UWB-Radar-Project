function [signal_new] = GaitCycleReinterp(signal_cycle, grf, zeroPt)
%GAITCYCLEREINTERP  Applies gait-cycle averaged signal (heel-strike to
%                   heel-strike) to grf data.
%
%   INPUTS:
%   signal_cycle    Gait-cycle averaged signal, split using 
%                   GaitCycleSplit.m
%
%   grf             Ground reaction forces used to reapply signal_cycle
%                   to new gait cycle. Should not be filtered.
%
%   OUTPUTS:
%   signal_new      Reinterpreted signal, reapplied based on grf. Same 
%                   length as grf input. Value of zero for incomplete start
%                   and end gait cycles.

    grf_threshold = 15;     % Threshold for detecting heel-strike
    Fs_grf = 1250;          % GRF sampling rate (fixed 1.25kHz)

    grf_times = (0 : (length(grf)-1)) / Fs_grf;

    [b,a] = butter(4, 12/(Fs_grf/2));
    grf_filt = filtfilt(b, a, grf);

    % Find each transition point rising through threshold. 
    % Treat the last sample below threshold as instant of heel-strike.
    heelStrike = [(grf_filt(1:end-1) < grf_threshold) & (grf_filt(2:end) >= grf_threshold),0];
    heelStrikeIdx = find(heelStrike);

    numPoints = length(signal_cycle);
    numCycles = sum(heelStrike) - 1;
    signal_full = ones(1, numCycles * numPoints) * zeroPt;
    signal_timestamps = zeros(1, numCycles * numPoints);
    
    for cycle = 1 : (sum(heelStrike)-1)
        startTime = grf_times(heelStrikeIdx(cycle));
        endTime = grf_times(heelStrikeIdx(cycle+1));
        dt = (endTime - startTime) / numPoints;

        cycle_idx = (1:numPoints) + (cycle - 1) * numPoints;

        signal_full(cycle_idx) = signal_cycle;
        signal_timestamps(cycle_idx) = startTime : dt : endTime - dt;
    end

    signal_new = interp1(signal_timestamps, signal_full, grf_times, 'spline', zeroPt);

end
