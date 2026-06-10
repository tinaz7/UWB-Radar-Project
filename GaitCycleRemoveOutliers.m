function [signal_clean] = GaitCycleRemoveOutliers(signal_split, nMin)
%GAITCYCLEREMOVEOUTLIERS    Removes outlier columns of signalSplit
%
%   INPUTS:
%   signal_split    PxN array of signal, split into N gait cycles. Can be
%                   the output of 'GaitCycleSplit.m'
%
%   nMin            Minimum number of gait cycles to retain in output
%
%   OUTPUTS:
%   signal_clean    'nMin'xM array of signal, with (N-M) outlier columns
%                   removed

    numCycles = size(signal_split, 2);

    errors = zeros(1, numCycles);
    signal_median = median(signal_split, 2);

    for cycle = 1 : numCycles
        errors(cycle) = MSE(signal_median, signal_split(:,cycle));
    end
    
    [~, sort_idx] = sort(errors);
    signal_clean = signal_split(:, sort_idx(1:nMin));

end