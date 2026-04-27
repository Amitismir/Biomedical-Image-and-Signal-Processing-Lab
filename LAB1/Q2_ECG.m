clc;
clear;

%% 2.1 Load data
clc;
load('E:\6th Semester\MISP Lab\MyLab\LAB1\Lab 1_data\ECG_sig.mat')

%% 2.1 Plotting channels time-domain
clc;
figure;

[numofsamples, numofchannels] = size(Sig);
t = (0: numofsamples - 1) / sfreq;

subplot(2, 1, 1);
plot(t, Sig(:, 1));
xlabel('Time(second)', Interpreter='latex');
ylabel('Amplitude (a.u.)', Interpreter='latex');
xlim([0, max(t)]);
title('ECG-Channel1 Time-Domain Representation', Interpreter='latex');
grid on;


subplot(2, 1, 2);
plot(t, Sig(:, 2));
xlabel('Time(second)', Interpreter= 'latex');
ylabel('Amplitude (a.u.)', Interpreter='latex');
xlim([0, max(t)]);
title('ECG-Channel2 Time-Domain Representation', Interpreter= 'latex');
grid on;

zoom on;
pan on;
%% 2.1 Better view for pqrst
figure;
subplot(2,1,1);
plot(t, Sig(:, 1));
xlabel('Time(second)', Interpreter= 'latex');
ylabel('Amplitude (a.u.)', Interpreter='latex');
xlim([0 10]);
title("Zoomed time-domain Representation ECG-Channel1", Interpreter='latex');
grid on;

subplot(2,1,2);
plot(t, Sig(:, 2));
xlabel('Time(second)', Interpreter= 'latex');
ylabel('Amplitude (a.u.)', Interpreter='latex');
xlim([0 10]);
title("Zoomed time-domain Representation ECG-Channel1", Interpreter= 'latex')
grid on;

zoom on;
pan on;

%% 2.2 Determining R-Peaks and labeling 
figure;
subplot(2,1,1);
plot(t, Sig(:, 1));
hold on;
xlabel('Time(second)', Interpreter= 'latex');
ylabel('Amplitude (a.u.)', Interpreter='latex');
xlim([800 805]);
grid on;

subplot(2,1,2);
plot(t, Sig(:, 2));
hold on;
xlabel('Time(second)', Interpreter= 'latex');
ylabel('Amplitude (a.u.)', Interpreter='latex');
xlim([20 25]);
grid on;


for i = 1:2039
    if ANNOTD(i, 1) == 1
        Type = "NORMAL";
    elseif ANNOTD(i,1) == 4
        Type = "ABERR";
    elseif ANNOTD(i, 1) == 5
        Type = "PVC";
    elseif ANNOTD(i, 1) == 8
        Type = "APC";
    elseif ANNOTD(i,1) == 11
        Type = "NESC";
    elseif ANNOTD(i,1) == 14 
        Type = "NOISE";
    elseif ANNOTD(i,1) == 28
        Type = "RHYTHM";
    elseif ANNOTD(i, 1) == 37
        Type = "NAPC";
    end
    xpos = ATRTIMED(i, 1);
    subplot(2,1,1);
    plot(xpos, -0.5, 'ro');
    text(xpos, -1, sprintf('%s', Type), Interpreter='latex');

    subplot(2,1,2);
    plot(xpos, -0.5, 'ro');
    text(xpos, -1, sprintf('%s', Type), Interpreter='latex');

end

zoom on;

%% 2.3 normal vs abnormal beat channel1

NORMAL_idx = find(ANNOTD == 1);
ABERR_idx = find(ANNOTD == 4);
PVC_idx = find(ANNOTD == 5);
APC_idx = find(ANNOTD == 8);

%Selecting one beat from each type
NORMAL_beat = NORMAL_idx(1);
ABERR_beat = ABERR_idx(1);
PVC_beat = PVC_idx(1);
APC_beat = APC_idx(1);

before = round(0.2 * sfreq);
after = round (0.4 * sfreq);
beat_time = (-before:after)/sfreq;

[~, idx_n] = min(abs(t - ATRTIMED(NORMAL_beat)));
[~, idx_p] = min(abs(t - ATRTIMED(PVC_beat)));
[~, idx_ab] = min(abs(t - ATRTIMED(ABERR_beat)));
[~, idx_ap] = min(abs(t - ATRTIMED(APC_beat)));



beat_normal_channel1 = Sig(idx_n - before: idx_n + after, 1);
beat_abnormal_pvc_channel1 = Sig(idx_p - before: idx_p + after, 1);
beat_abnormal_aberr_channel1 = Sig(idx_ab - before: idx_ab + after, 1);
beat_abnormal_apc_channel1 = Sig(idx_ap - before : idx_ap + after, 1);



figure;
plot(beat_time, beat_normal_channel1, 'b','LineWidth',2); hold on;
plot(beat_time, beat_abnormal_pvc_channel1,  'r','LineWidth',2); hold on;
plot(beat_time, beat_abnormal_aberr_channel1,  'g','LineWidth',2); hold on;
plot(beat_time, beat_abnormal_apc_channel1,  'y','LineWidth',2);


title('Normal Vs AbNormal Beat Morphology channel1', Interpreter = 'latex');
xlabel('Time(second)', Interpreter='latex');
ylabel('Amplitude (a.u.)', Interpreter='latex');
legend('Normal', 'PVC', 'ABERR', 'APC');
grid on;
hold off;
%% 2.3 channel2
beat_normal_channel2 = Sig(idx_n - before: idx_n + after, 2);
beat_abnormal_pvc_channel2 = Sig(idx_p - before: idx_p + after, 2);
beat_abnormal_aberr_channel2 = Sig(idx_ab - before: idx_ab + after, 2);
beat_abnormal_apc_channel2 = Sig(idx_ap - before : idx_ap + after, 2);


figure;
plot(beat_time, beat_normal_channel2, 'b','LineWidth',2); hold on;
plot(beat_time, beat_abnormal_pvc_channel2,  'r','LineWidth',2); hold on;
plot(beat_time, beat_abnormal_aberr_channel2,  'g','LineWidth',2); hold on;
plot(beat_time, beat_abnormal_apc_channel2,  'y','LineWidth',2);
title('Normal Vs AbNormal Beat Morphology channel2', Interpreter = 'latex');
xlabel('Time(second)', Interpreter='latex');
ylabel('Amplitude(a.u.)', Interpreter='latex');
legend('Normal', 'PVC', 'ABERR', 'APC');
grid on;
hold off;
%% 2.4
consecutive_normal = [];
consecutive_abnormal = [];
NORMAL_idx = find (ANNOTD == 1);
abnormal_idx = find(ANNOTD ~= 1);


for i = 1 : length(NORMAL_idx)-2
    if(NORMAL_idx(i+1) == NORMAL_idx(i)+1) && (NORMAL_idx(i+2) == NORMAL_idx(i)+2)
        consecutive_normal = NORMAL_idx(i : i+2);
        break;
    end
end

if isempty(consecutive_normal)
    fprintf('No consecutive normal beats found!\n');
end

for i = 1: length(abnormal_idx)-2
    if(abnormal_idx(i) + 1 == abnormal_idx(i+1)) && (abnormal_idx(i)+2 == abnormal_idx(i+2))
        consecutive_abnormal = abnormal_idx(i:i+2);
        break;
    end
end

if isempty(consecutive_abnormal)
    fprintf('No consecutive abnormal beats found!\n');
end

if ~isempty(consecutive_normal) && ~isempty(consecutive_abnormal)
    normal_start_time = ATRTIMED(consecutive_normal(1));
    normal_end_time = ATRTIMED(consecutive_normal(3));

    abnormal_start_time = ATRTIMED(consecutive_abnormal(1));
    abnormal_end_time = ATRTIMED(consecutive_abnormal(3));


    normal_start_sample = max(1, round(normal_start_time * sfreq));
    normal_end_sample = min(length(t),round(normal_end_time * sfreq));
    abnormal_start_sample = max(1, round(abnormal_start_time * sfreq));
    abnormal_end_sample = min(length(t), round(abnormal_end_time * sfreq));

    normal_segment_ch1 = Sig(normal_start_sample:normal_end_sample, 1);
    normal_segment_ch2 = Sig(normal_start_sample:normal_end_sample, 2);
    normal_segment_time = t(normal_start_sample:normal_end_sample);

    abnormal_segment_ch1 = Sig(abnormal_start_sample:abnormal_end_sample, 1);
    abnormal_segment_ch2 = Sig(abnormal_start_sample:abnormal_end_sample, 2);
    abnormal_segment_time = t(abnormal_start_sample:abnormal_end_sample);

    %Frequency Spectrum
    figure('Position', [100, 100, 1400, 800]);

    N_normal = length(normal_segment_ch1);
    freq_resolution = sfreq / N_normal;
    f_normal = (0:N_normal/2-1) * freq_resolution;

    fft_normal_ch1 = abs(fft(normal_segment_ch1) / N_normal);
    fft_normal_ch1 = fft_normal_ch1(1:N_normal/2);

    fft_normal_ch2 = abs(fft(normal_segment_ch2) / N_normal);
    fft_normal_ch2 = fft_normal_ch2(1:N_normal/2);

    subplot(2,2,1);
    plot(f_normal, fft_normal_ch1, 'b','Linewidth',2);
    xlabel('Frequency (Hz)', Interpreter='latex');
    ylabel('Magnitude', Interpreter='latex');
    title('Normal Frequency Spectrum- Channel 1', Interpreter='latex');
    xlim([0 100]);
    grid on;

    subplot(2,2,2);
    plot(f_normal, fft_normal_ch2, 'b','Linewidth',2);
    xlabel('Frequency (Hz)', Interpreter='latex');
    ylabel('Magnitude', Interpreter='latex');
    title('Normal Frequency Spectrum - Channel 2', Interpreter='latex');
    xlim([0 100]);
    grid on;
    

    N_abnormal = length(abnormal_segment_ch1);
    freq_resolution = sfreq / N_abnormal;
    f_abnormal = (0:N_abnormal/2-1) * freq_resolution;

    fft_abnormal_ch1 = abs(fft(abnormal_segment_ch1) / N_abnormal);
    fft_abnormal_ch1 = fft_abnormal_ch1(1:N_abnormal/2);

    fft_abnormal_ch2 = abs(fft(abnormal_segment_ch2) / N_abnormal);
    fft_abnormal_ch2 = fft_abnormal_ch2(1:N_abnormal/2);


    subplot(2,2,3);
    plot(f_abnormal, fft_abnormal_ch1, 'b', 'LineWidth',2);
    xlabel('Frequency (Hz)', Interpreter='latex');
    ylabel('Magnitude', Interpreter='latex');
    title('Abnormal Frequency Spectrum - Channel 1', Interpreter='latex');
    xlim([0 100]);
    grid on;

    subplot(2,2,4);
    plot(f_abnormal, fft_abnormal_ch2, 'b', 'LineWidth',2);
    xlabel('Frequency (Hz)', Interpreter='latex');
    ylabel('Magnitude', Interpreter='latex');
    title('Abnormal Frequency Spectrum - Channel 2', Interpreter='latex');
    xlim([0 100]);
    grid on;


    sgtitle('Frequency Spectrum: 3 consecutive Beats (Normal vs Abnormal)', Interpreter = 'latex');


    figure('Position', [100, 100, 1400, 800]);
    window_length = 128;
    noverlap = round(0.95 * window_length);
    nfft = 1024;
    hamming_window = hamming(window_length);

    

    subplot(2,2,1);
    spectrogram(normal_segment_ch1, hamming_window, noverlap, nfft, sfreq, 'yaxis');
    title('Normal Segment - Channel1 (Spectogram)', Interpreter = 'latex');
    ylabel('Frequency (Hz)', Interpreter = 'latex');
    ylim([0 60]);
    
    %colormap("jet");

    subplot(2,2,2);
    spectrogram(normal_segment_ch2, hamming_window, noverlap, nfft, sfreq, 'yaxis');
    title('Normal Segment - Channel2(Spectogram)', Interpreter = 'latex');
    ylabel('Frequency (Hz)', Interpreter = 'latex');
    ylim([0 60]);
    %colormap("jet");
    
    subplot(2,2,3);
    spectrogram(abnormal_segment_ch1, hamming_window, noverlap, nfft, sfreq, 'yaxis');
    title('Abnormal Segment - Channel1 (Spectogram)', Interpreter = 'latex');
    ylabel('Frequency (Hz)', Interpreter = 'latex');
    ylim([0 60]);
    %colormap("jet");

    subplot(2,2,4);
    spectrogram(abnormal_segment_ch2, hamming_window, noverlap, nfft, sfreq, 'yaxis');
    title('Abnormal Segment - Channel2 (Spectogram)', Interpreter = 'latex');
    ylabel('Frequency (Hz)', Interpreter = 'latex');
    xlabel('Time (Second)', Interpreter='latex');
    ylim([0 60]);
    %colormap("jet");

    sgtitle('Time-Frequency Spectogram: 3 Consecutive Beats (Normal vs Abnormal)', Interpreter = 'latex');

end


















