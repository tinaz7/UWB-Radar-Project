% calculate MSE for each cycle for each factor
% calculate sum MSE for each cycle of all factors
% sort by MSE sum

function targDat_clean = ...
          GaitCycleRemoveSameOutliers_1D(targDat, refDat, nMin)
    
    numCycles = size(refDat, 2);

    refDat_mean = mean(refDat,'all');
    refDat_std = std(refDat,[],'all');
    refDat_norm = (refDat - refDat_mean) / refDat_std;
    refDat_median = median(refDat_norm, 2);

    for cycle = 1 : numCycles
        errors(:, cycle) = MSE(refDat_median, refDat_norm(:,cycle));
    end
    
    [~, sort_idx] = sort(errors);
    disp(sort_idx(1:nMin))

    targDat_clean = targDat(:, sort_idx(1:nMin));

end