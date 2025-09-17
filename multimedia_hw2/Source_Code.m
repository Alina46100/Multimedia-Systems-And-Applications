[audio_data, sample_rate] = audioread('H54101155_趙昱安audio.mp3');
time = (0:length(audio_data)-1) / sample_rate;
figure;
plot(time, audio_data);
xlabel('Time (s)');
ylabel('Amplitude');
title('Waveform');
%1

audio_length = length(audio_data);
window_length = sample_rate/1000*20;
window_function = rectwin(window_length);
energy_contour = zeros(1, length(audio_data) - window_length + 1);
for n = 1:length(audio_data) - window_length + 1
    windowed_signal = audio_data(n:n+window_length-1); 
    energy = 0;
    for m = 1:window_length
        energy = energy + (windowed_signal(m) * window_function(m))^2;
    end
    energy_contour(n) = energy;
end
time_axis = (0:length(energy_contour)-1) / sample_rate;
figure;
plot(time_axis, energy_contour);
xlabel('Time (s)');
ylabel('Energy');
title('Energy Contour');
%2



num_windows = floor(length(audio_data) / window_length);
zero_crossing_rate_feature = zeros(1, num_windows);
for i = 1:num_windows
    start_index = (i - 1) * window_length + 1;
    end_index = start_index + window_length - 1;
    window_signal = audio_data(start_index:end_index);
    zero_crossings = 0;
    for j = 2:length(window_signal)
        if (window_signal(j) >= 0 && window_signal(j - 1) < 0) || (window_signal(j) < 0 && window_signal(j - 1) >= 0)
            zero_crossings = zero_crossings + 1;
        end
    end
    zero_crossing_rate_feature(i) = zero_crossings / ( window_length);
end


time_axis_zcr = (0:num_windows-1) * window_length / sample_rate;
figure;
plot(time_axis_zcr, zero_crossing_rate_feature);
xlabel('Time (s)');
ylabel('Zero-Crossing Rate');
title('Zero-Crossing Rate Feature');
%3






mean_energy = mean(energy_contour);
energy_threshold = 3 * mean_energy;
audio_energy = sum(audio_data .^ 2) / length(audio_data);
start_index = 1;
end_index = length(audio_data);
for i = 1:length(audio_data)
    if (sum(audio_data(i:i+window_length-1) .^ 2) / window_length) > energy_threshold * audio_energy
        start_index = i;
        break;
    end
end
for i = length(audio_data):-1:1
    if (sum(audio_data(i-window_length+1:i) .^ 2) / window_length) > energy_threshold * audio_energy
        end_index = i;
        break;
    end
end
speech_segment = audio_data(start_index  :end_index);
time_axis1 = (0:length(speech_segment)-1) / sample_rate;
figure;
plot(time, audio_data);
xlabel('Time (s)');
ylabel('Amplitude');
title('Speech Segment');
hold on;

line([time_axis(start_index) time_axis(start_index)], [min(speech_segment) max(speech_segment)], 'Color', 'r', 'LineStyle', '--');
line([time_axis(end_index - 1) time_axis(end_index - 1)], [min(speech_segment) max(speech_segment)], 'Color', 'r', 'LineStyle', '--');

hold off;


time = mean(audio_data, 2);
figure
pitch(time,sample_rate)
title("Pitch contour")
%5


audio_channel = audio_data(:, 1);
overlap_length = 512;
[s, f, t] = spectrogram(audio_channel, window_length, overlap_length, overlap_length, sample_rate);
figure;

surf(t, f, 10*log10(abs(s)), 'EdgeColor', 'none');
axis xy; axis tight;
view(0,90);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Spectrogram');
colorbar;
%3 
