% cps06_problem_6_5.m
% STFT czyli spectrogram FFT sygnalow zmiennych w czasie
clear all; close all; clc;

%% parametry
fpr = 8000;              % czestotliwosc probkowania (Hz)
T = 3;                   % czas trwania sygnalu w sekundach
N = round(T*fpr);        % liczba probek
dt = 1/fpr; 
t = dt*(0:N-1);          % os czasu

%% generacja sygnalow
x1 = sin(2*pi*200*t) + sin(2*pi*800*t);                              % 2xSIN
x2 = sin(2*pi*(0*t + 0.5*((1/T)*fpr/4)*t.^2));                       % LFM
fm = 0.5; 
x3 = sin(2*pi*((fpr/4)*t - (fpr/8)/(2*pi*fm)*cos(2*pi*fm*t)));       % SFM

%% CZESC 1: analiza sygnalu LFM (x2)
fprintf('=== CZESC 1: sygnal LFM ===\n');
x = x2;

Mwind = 256; Mstep = 16; Mfft = 2*Mwind;
w = hamming(Mwind)';

[S, f_spec, t_spec] = myspectrogram(x, w, Mwind-Mstep, Mfft, fpr);

figure('Name', 'LFM - STFT', 'Position', [100 100 1200 500]);
subplot(1,2,1)
plot(t(1:1000), x(1:1000), 'b');
xlabel('t [s]'); ylabel('amplituda'); title('sygnal LFM x2(t)'); grid on;

subplot(1,2,2)
imagesc(t_spec, f_spec, 20*log10(abs(S)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]'); title('STFT |X(t,f)| - sygnal LFM');
ylim([0 fpr/2]);

% odczyt z wykresu LFM:
% czestotliwosc startowa: 0 Hz
% czestotliwosc koncowa: fpr/4 = 2000 Hz
% sygnal zmienia czestotliwosc liniowo w czasie
fprintf('LFM: czestotliwosc od 0 Hz do %d Hz\n\n', fpr/4);

%% CZESC 2: analiza sygnalu SFM (x3)
fprintf('=== CZESC 2: sygnal SFM ===\n');
x = x3;
pause();
figure('Name', 'SFM - rozne dlugosci okna', 'Position', [100 100 1400 800]);

% krotkie okno - zla rozdzielczosc czestotliwosciowa
Mwind_short = 64;
w_short = hamming(Mwind_short)';
[S1, f1, t1] = myspectrogram(x, w_short, Mwind_short-16, 2*Mwind_short, fpr);

subplot(2,2,1)
imagesc(t1, f1, 20*log10(abs(S1)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]'); 
title(sprintf('SFM - krotkie okno Mwind=%d (rozmycie w osi f)', Mwind_short));
ylim([0 fpr/2]);

% srednie okno
Mwind_med = 256;
w_med = hamming(Mwind_med)';
[S2, f2, t2] = myspectrogram(x, w_med, Mwind_med-16, 2*Mwind_med, fpr);

subplot(2,2,2)
imagesc(t2, f2, 20*log10(abs(S2)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]'); 
title(sprintf('SFM - srednie okno Mwind=%d', Mwind_med));
ylim([0 fpr/2]);

% dlugie okno - zla rozdzielczosc czasowa
Mwind_long = 1024;
w_long = hamming(Mwind_long)';
[S3, f3, t3] = myspectrogram(x, w_long, Mwind_long-16, 2*Mwind_long, fpr);

subplot(2,2,3)
imagesc(t3, f3, 20*log10(abs(S3)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]'); 
title(sprintf('SFM - dlugie okno Mwind=%d (rozmycie w osi t)', Mwind_long));
ylim([0 fpr/2]);

% bardzo dlugie okno
Mwind_vlong = 2048;
w_vlong = hamming(Mwind_vlong)';
[S4, f4, t4] = myspectrogram(x, w_vlong, Mwind_vlong-16, 2*Mwind_vlong, fpr);

subplot(2,2,4)
imagesc(t4, f4, 20*log10(abs(S4)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]'); 
title(sprintf('SFM - bardzo dlugie okno Mwind=%d', Mwind_vlong));
ylim([0 fpr/2]);

% odczyt z wykresu SFM:
% czestotliwosc srodkowa: fpr/4 = 2000 Hz
% glebokosc modulacji: fpr/8 = 1000 Hz (odchylenie od srodka)
% czestotliwosc modulacji: fm = 0.5 Hz
fprintf('SFM: czestotliwosc srodkowa = %d Hz\n', fpr/4);
fprintf('SFM: glebokosc modulacji = %d Hz\n', fpr/8);
fprintf('SFM: czestotliwosc modulacji fm = %.1f Hz\n\n', fm);

%% CZESC 3: porownanie z funkcja Matlaba spectrogram()
fprintf('=== CZESC 3: porownanie z spectrogram() Matlaba ===\n');
x = x2;
Mwind = 256; Mstep = 16; Mfft = 2*Mwind;
w = hamming(Mwind);

[S_my, f_my, t_my] = myspectrogram(x, w', Mwind-Mstep, Mfft, fpr);
[S_mat, f_mat, t_mat] = spectrogram(x, w, Mwind-Mstep, Mfft, fpr);

% matlab spectrogram zwraca tylko polowe widma (do fs/2)
% wiec porownujemy tylko te same czesci
Nhalf = size(S_mat, 1);
err = max(max(abs(abs(S_my(1:Nhalf, :)) - abs(S_mat))));
fprintf('blad miedzy myspectrogram a spectrogram: %e\n', err);

pause();
figure('Name', 'Porownanie z Matlabem', 'Position', [100 100 1200 500]);
subplot(1,2,1)
imagesc(t_my, f_my, 20*log10(abs(S_my)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]'); title('myspectrogram()');
ylim([0 fpr/2]);

subplot(1,2,2)
imagesc(t_mat, f_mat, 20*log10(abs(S_mat)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]'); title('spectrogram() Matlab');
ylim([0 fpr/2]);

%% CZESC 4: sygnal 2xSIN z szumem
fprintf('\n=== CZESC 4: sygnal 2xSIN + szum ===\n');
x = x1 + 0.5*randn(1,N);

Mwind = 256;
w = hamming(Mwind)';
[S, f_spec, t_spec] = myspectrogram(x, w, Mwind-16, 2*Mwind, fpr);
pause();
figure('Name', '2xSIN + szum', 'Position', [100 100 1200 500]);
subplot(1,2,1)
plot(t(1:1000), x(1:1000), 'b');
xlabel('t [s]'); ylabel('amplituda'); title('sygnal 2xSIN + szum'); grid on;

subplot(1,2,2)
imagesc(t_spec, f_spec, 20*log10(abs(S)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]'); title('STFT - widoczne 2 skladowe: 200 Hz i 800 Hz');
ylim([0 fpr/2]);

% krotkie okno -dobra rozdzielczosc czasowa, zla czestotliwosciowa
% dlugie okno -dobra rozdzielczosc czestotliwosciowa, zla czasowa

%% FUNKCJA myspectrogram - takie same parametry jak spectrogram() Matlaba
function [S, f, t] = myspectrogram(x, window, noverlap, nfft, fs)
    % x       - sygnal wejsciowy
    % window  - okno (wektor) lub dlugosc okna (skalar)
    % noverlap - liczba probek zachodzacych na siebie
    % nfft    - dlugosc FFT
    % fs      - czestotliwosc probkowania
    % S - macierz STFT (nfft x liczba_ramek)
    % f - wektor czestotliwosci
    % t - wektor czasu (srodki ramek)
    
    N = length(x);
    
    % obsluga okna
    if isscalar(window)
        Mwind = window;
        w = hamming(Mwind)';
    else
        w = window(:)';
        Mwind = length(w);
    end
    
    % krok miedzy ramkami
    Mstep = Mwind - noverlap;
    
    % liczba ramek
    Many = floor((N - Mwind) / Mstep) + 1;
    
    % inicjalizacja macierzy STFT
    S = zeros(nfft, Many);
    
    % petla analizy
    for m = 1 : Many
        % wycinamy fragment sygnalu
        idx_start = 1 + (m-1)*Mstep;
        idx_end = Mwind + (m-1)*Mstep;
        bx = x(idx_start : idx_end);
        
        % okienkowanie
        bx = bx .* w;
        
        % FFT
        X = fft(bx, nfft);
        
        % zapisujemy do macierzy STFT
        S(:, m) = X(:);
    end
    
    % wektor czestotliwosci
    f = fs/nfft * (0:nfft-1)';
    
    % wektor czasu (srodki ramek)
    t = (Mwind/2) / fs + Mstep/fs * (0:Many-1);
end