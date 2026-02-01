% cps06_problem_6_6.m
% czasowo-czestotliwosciowa reprezentacja Wignera dla sygnalow LFM i SFM
clear all; close all; clc;

%% parametry
N = 1000;
fpr = 1000;
dt = 1/fpr;
t = dt*(0:N-1);

%% CZESC 1: analiza jadra Wignera dla sygnalu LFM
fprintf('=== CZESC 1: jadro Wignera dla LFM ===\n\n');

% sygnal LFM zespolony
% x(t) = exp(j*2*pi*(f0*t + 0.5*k*t^2)) gdzie k = chirp rate
% tutaj f0=0, k = fpr/2 / T = 500 Hz/s (bo T=1s)
x = exp(1j*2*pi*(0*t + 0.5*(fpr/2)*t.^2));

% jadro Wignera: x(t) * conj(x(-t))
% dla sygnalu LFM: x(t) = exp(j*2*pi*(f0*t + 0.5*k*t^2))
% x(-t) = exp(j*2*pi*(-f0*t + 0.5*k*t^2))
% conj(x(-t)) = exp(-j*2*pi*(-f0*t + 0.5*k*t^2))
% = exp(j*2*pi*(f0*t - 0.5*k*t^2))
% x(t)*conj(x(-t)) = exp(j*2*pi*(f0*t + 0.5*k*t^2 + f0*t - 0.5*k*t^2))
% = exp(j*2*pi*2*f0*t)
% czyli jadro Wignera dla LFM to sygnal o stalej czestotliwosci 2*f0
% czlon kwadratowy t^2 sie kasuje!

xx = x .* conj(x(end:-1:1));
X = fft(xx)/N;

figure('Name', 'Jadro Wignera - caly sygnal LFM', 'Position', [100 100 1200 400]);
subplot(1,2,1)
plot(t, real(xx), 'b', t, imag(xx), 'r');
xlabel('t [s]'); ylabel('amplituda');
title('jadro Wignera xx(t) = x(t) * conj(x(-t))');
legend('real', 'imag'); grid on;

subplot(1,2,2)
f = fpr/N * (0:N-1);
stem(f, abs(X), 'b', 'MarkerSize', 2);
xlabel('f [Hz]'); ylabel('|X(f)|');
title('FFT jadra Wignera - jedna czestotliwosc');
grid on; xlim([0 fpr/2]);

% czestotliwosc w srodku sygnalu
% f_inst(t) = f0 + k*t, w srodku t=T/2=0.5s
% f_inst(0.5) = 0 + 500*0.5 = 250 Hz
% ale jadro Wignera podwaja czestotliwosc wiec widzimy 2*250 = 500 Hz
fprintf('czestotliwosc chwilowa w srodku sygnalu: f_inst(T/2) = %.0f Hz\n', (fpr/2)/2);
fprintf('w jadrze Wignera widzimy 2x wieksza: %.0f Hz\n\n', fpr/2);

%% CZESC 2: macierz Wignera dla sygnalu LFM (pociecie na fragmenty)
fprintf('=== CZESC 2: macierz Wignera dla LFM ===\n\n');

M = 128;           % dlugosc fragmentu
Mstep = 16;        % krok
Mfft = 2*M;        % dlugosc FFT
Many = floor((N - M) / Mstep) + 1;

% wektory czasu i czestotliwosci
t_wig = (M/2)*dt + Mstep*dt*(0:Many-1);
f_wig = fpr/Mfft * (0:Mfft-1);

% macierz Wignera
W_lfm = zeros(Mfft, Many);

for m = 1:Many
    idx_start = 1 + (m-1)*Mstep;
    idx_end = M + (m-1)*Mstep;
    
    % fragment sygnalu
    bx = x(idx_start:idx_end);
    
    % jadro Wignera dla fragmentu
    bxx = bx .* conj(bx(end:-1:1));
    
    % FFT
    BX = fft(bxx, Mfft) / M;
    
    W_lfm(:, m) = BX(:);
end

% skalowanie czestotliwosci - dzielimy przez 2 bo jadro podwaja czestotliwosc
f_wig_scaled = f_wig / 2;

figure('Name', 'Macierz Wignera - LFM', 'Position', [100 100 1200 500]);
subplot(1,2,1)
imagesc(t_wig, f_wig, 20*log10(abs(W_lfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('Wigner LFM - bez korekcji skali f');
ylim([0 fpr/2]);

subplot(1,2,2)
imagesc(t_wig, f_wig_scaled, 20*log10(abs(W_lfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('Wigner LFM - po korekcji skali f (f/2)');
ylim([0 fpr/4]);

% sprawdzenie czy zmiana czestotliwosci jest poprawna
% sygnal LFM: f(t) = f0 + k*t = 0 + 500*t
% dla t=0: f=0 Hz, dla t=1: f=500 Hz
fprintf('zadana zmiana czestotliwosci LFM: 0 Hz -> %.0f Hz\n', fpr/2);
fprintf('po korekcji skali widac to samo na wykresie\n\n');

%% CZESC 3: porownanie z STFT (spectrogram)
fprintf('=== CZESC 3: porownanie Wigner vs STFT ===\n\n');

figure('Name', 'Porownanie Wigner vs STFT - LFM', 'Position', [100 100 1200 500]);

subplot(1,2,1)
imagesc(t_wig, f_wig_scaled, 20*log10(abs(W_lfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('Wigner - LFM');
ylim([0 fpr/4]);

subplot(1,2,2)
w = hamming(M)';
[S, f_stft, t_stft] = myspectrogram(x, w, M-Mstep, Mfft, fpr);
imagesc(t_stft, f_stft, 20*log10(abs(S)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('STFT (spectrogram) - LFM');
ylim([0 fpr/2]);

%% CZESC 4: sygnal SFM
fprintf('=== CZESC 4: sygnal SFM ===\n\n');

% sygnal SFM zespolony
% f_inst(t) = f_c + delta_f * sin(2*pi*fm*t)
% x(t) = exp(j*2*pi*integral(f_inst))
f_c = fpr/4;       % czestotliwosc srodkowa = 250 Hz
delta_f = fpr/8;   % glebokosc modulacji = 125 Hz
fm = 0.5;          % czestotliwosc modulacji = 0.5 Hz

x_sfm = exp(1j*2*pi*(f_c*t - delta_f/(2*pi*fm)*cos(2*pi*fm*t)));

% macierz Wignera dla SFM
W_sfm = zeros(Mfft, Many);

for m = 1:Many
    idx_start = 1 + (m-1)*Mstep;
    idx_end = M + (m-1)*Mstep;
    
    bx = x_sfm(idx_start:idx_end);
    bxx = bx .* conj(bx(end:-1:1));
    BX = fft(bxx, Mfft) / M;
    
    W_sfm(:, m) = BX(:);
end

figure('Name', 'Macierz Wignera - SFM', 'Position', [100 100 1200 500]);

subplot(1,2,1)
imagesc(t_wig, f_wig_scaled, 20*log10(abs(W_sfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('Wigner - SFM (po korekcji f/2)');
ylim([0 fpr/4]);

subplot(1,2,2)
[S_sfm, f_stft, t_stft] = myspectrogram(x_sfm, w, M-Mstep, Mfft, fpr);
imagesc(t_stft, f_stft, 20*log10(abs(S_sfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('STFT (spectrogram) - SFM');
ylim([0 fpr/2]);

fprintf('SFM: czestotliwosc srodkowa = %.0f Hz\n', f_c);
fprintf('SFM: glebokosc modulacji = %.0f Hz\n', delta_f);
fprintf('SFM: czestotliwosc zmienia sie sinusoidalnie od %.0f do %.0f Hz\n', f_c-delta_f, f_c+delta_f);

%% CZESC 5: porownanie wszystkich metod
fprintf('\n=== CZESC 5: podsumowanie ===\n\n');

figure('Name', 'Podsumowanie - LFM i SFM', 'Position', [100 100 1400 800]);

subplot(2,2,1)
imagesc(t_wig, f_wig_scaled, 20*log10(abs(W_lfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('Wigner - LFM'); ylim([0 fpr/4]);

subplot(2,2,2)
imagesc(t_wig, f_wig_scaled, 20*log10(abs(W_sfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('Wigner - SFM'); ylim([0 fpr/4]);

subplot(2,2,3)
[S_lfm, ~, ~] = myspectrogram(x, w, M-Mstep, Mfft, fpr);
imagesc(t_stft, f_stft, 20*log10(abs(S_lfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('STFT - LFM'); ylim([0 fpr/2]);

subplot(2,2,4)
imagesc(t_stft, f_stft, 20*log10(abs(S_sfm)+eps));
c = colorbar; c.Label.String = 'dB';
ax = gca; ax.YDir = 'normal';
xlabel('t [s]'); ylabel('f [Hz]');
title('STFT - SFM'); ylim([0 fpr/2]);

% jadro Wignera dla LFM daje stala czestotliwosc bo czlon t^2 sie kasuje
% reprezentacja Wignera ma lepsza rozdzielczosc niz STFT
% ale wymaga korekcji skali czestotliwosci (dzielenie przez 2)

%% FUNKCJA myspectrogram
function [S, f, t] = myspectrogram(x, window, noverlap, nfft, fs)
    N = length(x);
    
    if isscalar(window)
        Mwind = window;
        w = hamming(Mwind)';
    else
        w = window(:)';
        Mwind = length(w);
    end
    
    Mstep = Mwind - noverlap;
    Many = floor((N - Mwind) / Mstep) + 1;
    
    S = zeros(nfft, Many);
    
    for m = 1 : Many
        idx_start = 1 + (m-1)*Mstep;
        idx_end = Mwind + (m-1)*Mstep;
        bx = x(idx_start : idx_end);
        bx = bx .* w;
        X = fft(bx, nfft);
        S(:, m) = X(:);
    end
    
    f = fs/nfft * (0:nfft-1)';
    t = (Mwind/2) / fs + Mstep/fs * (0:Many-1);
end