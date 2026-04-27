clc;
close all;
clear;
%% Loading Data
clc;
load('E:\6th Semester\MISP Lab\MyLab\LAB1\Lab 1_data\EMG_sig.mat');
%% 4.1 Time-Domain Signal Representation

clc;
figure('Position', [100 100 800 600]);
t1 = 0 : 1/fs : (length(emg_healthym)-1)/fs;
t2 = 0 : 1/fs : (length(emg_myopathym)-1)/fs;
t3 = 0 : 1/fs : (length(emg_neuropathym)-1)/fs;

subplot(3,1,1);
plot(t1, emg_healthym);
xlabel('Time (Seconds)', Interpreter = 'latex');
ylabel('Amplitude (a.u.)', Interpreter = 'latex');
title('Time-Domain EMG Representation for Healthy Subject', Interpreter='latex');
xlim([0 t1(end)]);
grid on;
zoom on;

subplot(3,1,2);
plot(t2, emg_myopathym);
xlabel('Time(Seconds)', Interpreter='latex');
ylabel('Amplitude (a.u.)', Interpreter ='latex');
title('Time-Domain EMG Representation for Myopathy Subject', Interpreter='latex');
xlim([0 t2(end)]);
grid on;
zoom on;

subplot(3,1,3);
plot(t3, emg_neuropathym);
xlabel('Time(Seconds)', Interpreter='latex');
ylabel('Amplitude (a.u.)', Interpreter ='latex');
title('Time-Domain EMG Representation for Neuropathy Subject', Interpreter='latex');
xlim([0 t3(end)]);
grid on;
zoom on;

sgtitle("Time-Domain EMG Representation for 3 Subjects")

%% 4.2 Plotting Frequency-Domain (PSD) and Time-Frequency-Domain Representations

[psd1, f1] = pwelch(emg_healthym, hamming(256), [], [], fs);
[psd2, f2] = pwelch(emg_myopathym, hamming(256),[],[],fs);
[psd3, f3] = pwelch(emg_neuropathym, hamming(256), [], [], fs);

% Extracting a more comprehensible plot by converting PSD's unit to dB/Hz
%first_subject_power = 10 * log10(psd1);
%second_subject_power = 10 * log10(psd2);
%third_subject_power = 10 * log10(psd3);

% Frequencu-Domain(PSD)
figure('Position', [100 100 800 600]);

subplot(3,1,1);
plot(f1, psd1);
xlabel('Frequency (Hz)', Interpreter='latex');
ylabel('Power/Frequency (dB/Hz)', Interpreter='latex');
title('PSD for Healthy Subject', Interpreter='latex');
grid on;

subplot(3,1,2);
plot(f1, psd2);
xlabel('Frequency (Hz)', Interpreter='latex');
ylabel('Power/Frequency (dB/Hz)', Interpreter='latex');
title('PSD for Myopath Subject', Interpreter='latex');
grid on;


subplot(3,1,3);
plot(f1, psd3);
xlabel('Frequency (Hz)', Interpreter='latex');
ylabel('Power/Frequency (dB/Hz)', Interpreter='latex');
title('PSD for Neuropath Subject', Interpreter='latex');
grid on;

sgtitle('PSD - All Subjects')

%Time-Frequency Domain (Spectogram)

figure('Position', [100 100 800 600]);

subplot(3,1,1);
spectrogram(emg_healthym, hamming(256), [], [], fs, 'yaxis');
xlabel('Time (Seconds)', Interpreter='latex');
ylabel('Frequency (Hz)', Interpreter='latex');
title('Spectogram for Healthy Subject', Interpreter='latex');
caxis([-50 50]);
colorbar;


subplot(3,1,2);
spectrogram(emg_myopathym, hamming(256), [], [], fs, 'yaxis');
xlabel('Time (Seconds)', Interpreter='latex');
ylabel('Frequency (Hz)', Interpreter='latex');
title('Spectogram for Myopath Subject', Interpreter='latex');
caxis([-50 50]);
colorbar;

subplot(3,1,3);
spectrogram(emg_neuropathym, hamming(256), [], [], fs, 'yaxis');
xlabel('Time (Seconds)', Interpreter='latex');
ylabel('Frequency (Hz)', Interpreter='latex');
title('Spectogram for Neuropath Subject', Interpreter='latex');
caxis([-50 50]);
colorbar;

sgtitle('EMG Spectograms - All Subjects')







