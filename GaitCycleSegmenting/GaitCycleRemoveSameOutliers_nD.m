% calculate MSE for each cycle for each factor
% calculate sum MSE for each cycle of all factors
% sort by MSE sum

function [uwb1_clean, uwb2_clean, uwb3_clean, ...
          uwb4_clean, uwb5_clean, uwb6_clean, ...
          dat1_clean] = ...
          GaitCycleRemoveSameOutliers_nD(uwb1, uwb2, uwb3, ...
          uwb4, uwb5, uwb6, dat1, nMin)

    numCycles = size(uwb1, 2);
    numPages = size(uwb1, 3);
    
    uwb1_mean = zeros(100, numPages); uwb2_mean = zeros(100, numPages);
    uwb3_mean = zeros(100, numPages); uwb4_mean = zeros(100, numPages);
    uwb5_mean = zeros(100, numPages); uwb6_mean = zeros(100, numPages);

    uwb1_std = zeros(100, numPages); uwb2_std = zeros(100, numPages);
    uwb3_std = zeros(100, numPages); uwb4_std = zeros(100, numPages);
    uwb5_std = zeros(100, numPages); uwb6_std = zeros(100, numPages);

    for i = 1:numPages
        uwb1_mean(:, i) = mean(uwb1,'all'); uwb1_std(:, i) = std(uwb1,[],'all');
        uwb2_mean(:, i) = mean(uwb2,'all'); uwb2_std(:, i) = std(uwb2,[],'all');
        uwb3_mean(:, i) = mean(uwb3,'all'); uwb3_std(:, i) = std(uwb3,[],'all');
        uwb4_mean(:, i) = mean(uwb4,'all'); uwb4_std(:, i) = std(uwb4,[],'all');
        uwb5_mean(:, i) = mean(uwb5,'all'); uwb5_std(:, i) = std(uwb5,[],'all');
        uwb6_mean(:, i) = mean(uwb6,'all'); uwb6_std(:, i) = std(uwb6,[],'all');
    end
    dat1_mean = mean(dat1,'all'); dat1_std = std(dat1,[],'all');
    
    uwb1_norm = uwb1 .* 0; uwb2_norm = uwb2 .* 0; uwb3_norm = uwb3 .* 0;
    uwb4_norm = uwb4 .* 0; uwb5_norm = uwb5 .* 0; uwb6_norm = uwb1 .* 0;

    for i = 1 : numPages
        uwb1_norm(1:end, 1:end, i) = (uwb1(1:end, 1:end, i) - uwb1_mean(:, i)) ./ uwb1_std(:, i);
        uwb2_norm(1:end, 1:end, i) = (uwb2(1:end, 1:end, i) - uwb2_mean(:, i)) ./ uwb2_std(:, i);
        uwb3_norm(1:end, 1:end, i) = (uwb3(1:end, 1:end, i) - uwb3_mean(:, i)) ./ uwb3_std(:, i);
        uwb4_norm(1:end, 1:end, i) = (uwb4(1:end, 1:end, i) - uwb4_mean(:, i)) ./ uwb4_std(:, i);
        uwb5_norm(1:end, 1:end, i) = (uwb5(1:end, 1:end, i) - uwb5_mean(:, i)) ./ uwb5_std(:, i);
        uwb6_norm(1:end, 1:end, i) = (uwb6(1:end, 1:end, i) - uwb6_mean(:, i)) ./ uwb6_std(:, i);
    end
    dat1_norm = (dat1 - dat1_mean) / dat1_std;

    uwb1_median = zeros(100, numPages); uwb2_median = zeros(100, numPages);
    uwb3_median = zeros(100, numPages); uwb4_median = zeros(100, numPages);
    uwb5_median = zeros(100, numPages); uwb6_median = zeros(100, numPages);
    
    for i = 1:numPages
        uwb1_median(1:100, i) = median(uwb1_norm(1:end, 1:end, i), 2);
        uwb2_median(1:100, i) = median(uwb2_norm(1:end, 1:end, i), 2);
        uwb3_median(1:100, i) = median(uwb3_norm(1:end, 1:end, i), 2);
        uwb4_median(1:100, i) = median(uwb4_norm(1:end, 1:end, i), 2);
        uwb5_median(1:100, i) = median(uwb5_norm(1:end, 1:end, i), 2);
        uwb6_median(1:100, i) = median(uwb6_norm(1:end, 1:end, i), 2);
    end
    dat1_median = median(dat1_norm, 2);

    errors = zeros(6*numPages + 1, numCycles);
    for cycle = 1 : numCycles
        for i = 1:numPages
            errors((i-1)*6 + 1, cycle) = 0; %MSE(uwb1_median(100, i), uwb1_norm(1:end, cycle, i));
            errors((i-1)*6 + 2, cycle) = 0; %MSE(uwb2_median(100, i), uwb2_norm(1:end, cycle, i));
            errors((i-1)*6 + 3, cycle) = 0; %MSE(uwb3_median(100, i), uwb3_norm(1:end, cycle, i));
            errors((i-1)*6 + 4, cycle) = 0; %MSE(uwb4_median(100, i), uwb4_norm(1:end, cycle, i));
            errors((i-1)*6 + 5, cycle) = 0; %MSE(uwb5_median(100, i), uwb5_norm(1:end, cycle, i));
            errors((i-1)*6 + 6, cycle) = 0; %MSE(uwb6_median(100, i), uwb6_norm(1:end, cycle, i));
        end
        errors(6*numPages + 1, cycle) = MSE(dat1_median, dat1_norm(:,cycle));
    end
    
    errorSum = sum(errors);
    [~, sort_idx] = sort(errorSum);
    disp(sort_idx(1:nMin))

    uwb1_clean = zeros(100, nMin, numPages); uwb2_clean = zeros(100, nMin, numPages);
    uwb3_clean = zeros(100, nMin, numPages); uwb4_clean = zeros(100, nMin, numPages);
    uwb5_clean = zeros(100, nMin, numPages); uwb6_clean = zeros(100, nMin, numPages);

    for i = 1:numPages
        uwb1_clean(:, :, i) = uwb1(:, sort_idx(1:nMin), i);
        uwb2_clean(:, :, i) = uwb2(:, sort_idx(1:nMin), i);
        uwb3_clean(:, :, i) = uwb3(:, sort_idx(1:nMin), i);
        uwb4_clean(:, :, i) = uwb4(:, sort_idx(1:nMin), i);
        uwb5_clean(:, :, i) = uwb5(:, sort_idx(1:nMin), i);
        uwb6_clean(:, :, i) = uwb6(:, sort_idx(1:nMin), i);
    end
    dat1_clean = dat1(:, sort_idx(1:nMin));
end