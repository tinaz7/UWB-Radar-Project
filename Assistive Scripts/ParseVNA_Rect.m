%% Parse VNA data from text file to matlab file by converting rectangular form to polar form

clear

files = dir("Z:\Data Collection 3\Raw Data\S02\UWB\VNA Data*.txt");
outLoc = "C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\UWB\S02\RawData_Rect";

for file_idx = 1 : length(files)
    file = files(file_idx);
    disp(file.name);
    
    lines = readlines(file.folder + "\" + file.name);

    uwb_times = zeros(51, 1);
    S11_R = zeros(51, 1);
    S11_I = zeros(51, 1);
    S22_R = zeros(51, 1);
    S22_I = zeros(51, 1);
    S21_R = zeros(51, 1);
    S21_I = zeros(51, 1);
    S12_R = zeros(51, 1);
    S12_I = zeros(51, 1);

    firstSweep = true;
    sweepCnt = 0;

    % Parse txt file

    uwb_time_beep_end = str2double(extractBefore(lines(3), " - "));

    for line_idx = 4 : size(lines,1) - 4
        line = lines(line_idx);
        [time, index, data] = processLine(line);

        % At start of a scan, no longer on first sweep
        if index == 1
            firstSweep = false;
            sweepCnt = sweepCnt + 1;
        end
        % If yet to reach start of scan, continue on
        if firstSweep == true
            continue
        end
        % Parse and save line
        uwb_times(index, sweepCnt) = time;
        S11_R(index, sweepCnt) = data(1);
        S11_I(index, sweepCnt) = data(2);
        S22_R(index, sweepCnt) = data(3);
        S22_I(index, sweepCnt) = data(4);
        S21_R(index, sweepCnt) = data(5);
        S21_I(index, sweepCnt) = data(6);
        S12_R(index, sweepCnt) = data(7);
        S12_I(index, sweepCnt) = data(8);
    end

    % Trim incomplete final scan
    uwb_times = uwb_times(:,1:end-1);
    S11_R = S11_R(:,1:end-1);
    S11_I = S11_I(:,1:end-1);
    S22_R = S22_R(:,1:end-1);
    S22_I = S22_I(:,1:end-1);
    S21_R = S21_R(:,1:end-1);
    S21_I = S21_I(:,1:end-1);
    S12_R = S12_R(:,1:end-1);
    S12_I = S12_I(:,1:end-1); 

    % Redefine correct sampling times for synchronisation
    % Sampling period as first derivative of sampling times
    sample_periods = diff(uwb_times(1,:));
    
    % To remove initial FIFO data dump on connection, and remove false sampling
    % rate fluctuations from data read/write delays
    
    % First data point where sampling period is at the expected ~15ms
    first_idx = find(sample_periods > 14.5 & sample_periods < 15.5, 1, "first");
    % Last data point where sampling period is at the expected ~15ms
    last_idx = find(sample_periods > 14.5 & sample_periods < 15.5, 1, "last");
    % Determine the average sampling period (using 350MHz) across this range
    average_sample_period = (uwb_times(1,last_idx) - uwb_times(1,first_idx)) / (last_idx - first_idx);
    
    uwb_time_since_beep_ms = zeros(51, last_idx - first_idx + 1);
    
    for freq = 1 : 51
        uwb_freqstarttime = uwb_times(freq,1);

        lm = fitlm(first_idx:last_idx, uwb_times(freq,first_idx:last_idx)-uwb_freqstarttime);
        
        % Time of first data point at expected sampling rate, plus offset for 
        % subsequent frequency samples, subtract time of beep (for 
        % synchronisation), subtract 20ms FIFO buffer delay (prev. measured)
        
        uwb_time_since_beep_ms(freq,:) = (first_idx:last_idx) * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1) + uwb_freqstarttime - uwb_time_beep_end - 20;

%         start_time = uwb_times(1,first_idx) + mean(uwb_times(freq,first_idx:end) - uwb_times(1,first_idx:end)) - uwb_time_beep_end - 20;       
%         uwb_time_since_beep_ms(freq, :) = start_time + (0 : (last_idx - first_idx)) * average_sample_period;
    end
    
    % Trim UWB data to match new times
    S11_R = S11_R(:, first_idx:last_idx);
    S11_I = S11_I(:, first_idx:last_idx);
    S22_R = S22_R(:, first_idx:last_idx);
    S22_I = S22_I(:, first_idx:last_idx);
    S21_R = S21_R(:, first_idx:last_idx);
    S21_I = S21_I(:, first_idx:last_idx);
    S12_R = S12_R(:, first_idx:last_idx);
    S12_I = S12_I(:, first_idx:last_idx);

    % Save output
    save(outLoc + "\" + file.name(1:end-4) + ".mat", ...
        "uwb_time_since_beep_ms", "S11_R", "S11_I", "S22_R", ...
        "S22_I", "S21_R", "S21_I", "S12_R", "S12_I");
end

function [time, index, data] = processLine(line)
    time = str2double(extractBefore(line, " - "));
    
    scan = jsondecode(extractAfter(line, " - "));
    
    index = scan.pointNum + 1;

    data = [scan.measurements.S11_real, ...
        scan.measurements.S11_imag, ...
        scan.measurements.S22_real, ...
        scan.measurements.S22_imag, ...
        scan.measurements.S21_real, ...
        scan.measurements.S21_imag, ...
        scan.measurements.S12_real, ...
        scan.measurements.S12_imag];
end
