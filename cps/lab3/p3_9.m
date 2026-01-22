%źródło samogłosek: https://www.youtube.com/watch?v=3erfycMFKQw
clear all; close all; clc;

% Lista plików MP3
files = {'a.mp3','e.mp3','i.mp3','o.mp3','u.mp3'};
labels = {'a','e','i','o','u'};
f_max = {2270,1623, 412, 1659,596};
f_fpr = {166.7, 142.9, 166.7, 142.9, 200};

fpr = 8000;  % nowe fs po resamplingu
Ndct = 2^13; % długość fragmentu do DCT

figure;
set(gcf, 'Position', [100 100 1200 900]); % duże okno, znalazłem te linijkę w internecie

for m = 1:length(files)
    [x, fs] = audioread(files{m});

    if size(x,2)==2
        x = mean(x,2);     % mono
    end

    x = resample(x, fpr, fs);   % resampling
    fs = fpr;                   % aktualizacja fs
    N = length(x);

    
    

    N = length(x);
    
    % Wybór fragmentu stacjonarnego (środek sygnału)
    n1 = max(1, round(N/2 - Ndct/2));
    
    % Sprawdzenie czy mamy wystarczająco próbek
    if n1 + Ndct - 1 > N
        n1 = max(1, N - Ndct + 1);
    end
    
    % Fragment do analizy
    x_segment = x(n1 : min(n1 + Ndct - 1, N));
    
    % Jeśli za krótki fragment, dopełnij zerami
    if length(x_segment) < Ndct
        x_segment = [x_segment; zeros(Ndct - length(x_segment), 1)];
    end
    
    % DCT-IV
    c = dct(x_segment, 'Type', 4);
    c_abs = abs(c);

    % Obliczenie osi częstotliwości dla DCT-IV
    % W DCT-IV częstotliwość k-tego współczynnika to: f = (k + 0.5) * fs / (2*Ndct)
    k_indices = 0:(Ndct-1);
    freqs = (k_indices + 0.5) * fpr / (2 * Ndct);

   % Znalezienie pierwszego dużego maksimum (pomiń DC, szukaj od ~80 Hz)
    start_idx = find(freqs >= 80, 1);
    end_idx = find(freqs <= 500, 1, 'last'); % maksymalnie 500 Hz dla f0

    [max_val, idx_local] = max(c_abs(start_idx:end_idx));
    idx_max = start_idx + idx_local - 1;
    f0_est = freqs(idx_max)

    subplot(length(files), 3, (m-1)*3 + 1);
    t = (0:length(x_segment)-1) / fpr * 1000; % czas w ms
    plot(t, x_segment, 'b-', 'LineWidth', 1);
    grid on;
    xlabel('Czas [ms]');
    ylabel('Amplituda');
    title(sprintf('Samogłoska "%s" - sygnał', labels{m}));

    T_ms = 1000 / f0_est;
    xlim([650 700]); %wykres w "przybliżeniu"

    subplot(length(files), 3, (m-1)*3 + 2);
    plot(freqs, c_abs, '.-', 'MarkerSize', 4);
    grid on;
    xlabel('Częstotliwość [Hz]');
    ylabel('|DCT|');
    title(sprintf('Widmo DCT-IV - f0 ≈ %.1f Hz (T ≈ %.1f ms)', f0_est, T_ms));
    xlim([0 2000]);
    
    % Zaznaczenie f0 i harmonicznych
    hold on;
    for k_harm = 1:5
        f_harm = k_harm * f0_est;
        if f_harm <= 2000
            plot([f_harm f_harm], ylim, 'r--', 'LineWidth', 1);
            text(f_harm, max(ylim)*0.9, sprintf('%d×f0', k_harm), ...
                'HorizontalAlignment', 'center', 'Color', 'r', 'FontSize', 8);
        end
    end
    hold off;

    % Wykres przybliżony - fragment sygnału z zaznaczonym okresem
    subplot(length(files), 3, (m-1)*3 + 3);
    zoom_samples = 100; % 50 próbek (~12ms)
    start_zoom = round(length(x_segment)/2); % zacznij od środka
    t_zoom = t(start_zoom:start_zoom + zoom_samples);
    x_zoom = x_segment(start_zoom:start_zoom + zoom_samples);
    plot(t_zoom, x_zoom, 'b-', 'LineWidth', 1.5);
    grid on;
    xlabel('Czas [ms]');
    ylabel('Amplituda');
    title(sprintf('Powiększenie - widoczny okres T ≈ %.1f ms', T_ms));

    hold on;
    t_start = t_zoom(1);
    plot([t_start t_start+T_ms], [0 0], 'r-', 'LineWidth', 2);
    text(t_start + T_ms/2, min(ylim)*0.8, sprintf('T≈%.1fms', T_ms), 'Color', 'r', 'FontWeight', 'bold');
    hold off;

    fprintf('Samogłoska "%s":\n', labels{m});
    fprintf('  - Częstotliwość podstawowa f0 ≈ %.1f Hz\n', f0_est);
    fprintf('  - Okres T ≈ %.2f ms\n', T_ms);
    fprintf('  - Indeks maksimum w DCT: %d\n', idx_max);
    fprintf('  - Harmoniczne: %.1f, %.1f, %.1f Hz...\n\n', ...
        2*f0_est, 3*f0_est, 4*f0_est);

end

sgtitle('Analiza częstotliwości podstawowej samogłosek (f0 i harmoniczne)', ...
    'FontSize', 14, 'FontWeight', 'bold');


