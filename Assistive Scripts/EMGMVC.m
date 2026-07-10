%% Find maximum EMG signal for each participant from all MVC and walking trials to use as MVC reference

clear

[b_lp, a_lp] = butter(4, 10/(2000/2));
[b_bp, a_bp] = butter(4, [20/(2000/2), 400/(2000/2)]);

PID = "S01";
Muscle = "GM";

files = dir(fullfile("C:\Users\zheng\OneDrive\Desktop\ENGG7291 Data\EXO_UWB" + ...
    "\Data", "ExoUWB_" + PID, "*.mat"));

peaks = zeros(1, length(files));
peakidx = inf;
peakdata = [0];

% Files to ignore if identified max EMG signal is unreasonable/noisy
ignore = [4, 9, 7, 3];

for i = 1 : length(files)
    qtmFile = load( files(i).folder + "\" + files(i).name);

    field = fields(qtmFile);

    qtm_labels = qtmFile.(field{1}).Analog(2).Labels;
    qtm_data = qtmFile.(field{1}).Analog(2).Data';

    emg_idx = find(cellfun(@(x)isequal(x, Muscle), qtm_labels));
    emg_data = qtm_data(:, emg_idx);

    emg_bp = filtfilt(b_bp, a_bp, emg_data);
    emg_rect = abs(emg_bp);
    emg_filtered = filtfilt(b_lp, a_lp, emg_rect);

    emg_movav = movmean(emg_filtered,100); % 50ms = 100pts at 2 kHz

    if sum(i == ignore) == 0 && max(emg_movav) > max(peakdata)
        peakdata = emg_movav;
        peakidx = i;
    end
    peaks(i) = max(emg_movav);
end

figure(5); clf
plot(peakdata);

fprintf("Trial No: " + string(files(peakidx).name(end-5:end-4) + "\n"))
fprintf("Index: " + string(peakidx) + "\n")
fprintf("Max value: " + string(max(peakdata)) + "\n")
