clear all; close all; clc;

%% Parametry sygnału
N = 100; % N musi być podzielne przez 4 dla tego zadania
x = rand(1, N);

%% Wynik wzorcowy (do weryfikacji)
Xm = fft(x);

%% Podział próbek (Decomposition) ---

% Pierwszy podział
xe = x(1:2:end); % Próbki parzyste (indeksy 0, 2, 4...)
xo = x(2:2:end); % Próbki nieparzyste (indeksy 1, 3, 5...)

% Drugi podział
% Dzielimy 'xe' na jego parzyste/nieparzyste
xee = xe(1:2:end);
xeo = xe(2:2:end);

% Dzielimy 'xo' na jego parzyste/nieparzyste
xoe = xo(1:2:end);
xoo = xo(2:2:end);

%% Obliczenie widm najmniejszych części ---
% Obliczamy DFT czterech sygnałów o długości N/4
Xee = fft(xee);
Xeo = fft(xeo);
Xoe = fft(xoe);
Xoo = fft(xoo);

%% Rekonstrukcja (Synteza) ---

%% Odtworzenie widm Xe i Xo (z części 4-elementowych na 2-elementowe*)
% *w sensie blokowym, długość wektorów rośnie z N/4 do N/2

N_half = N/2;
k_half = 0 : N_half-1; 
W_half = exp(-1j * 2*pi / N_half * k_half);

Xe = [Xee, Xee] + W_half .* [Xeo, Xeo];
Xo = [Xoe, Xoe] + W_half .* [Xoo, Xoo];

%% Odtworzenie pełnego widma X (z Xe i Xo)

k_full = 0 : N-1;
W_full = exp(-1j * 2*pi / N * k_full);

X = [Xe, Xe] + W_full .* [Xo, Xo];

%% --- Weryfikacja błędu ---
error = max(abs(X - Xm));
disp(['Maksymalny błąd rekonstrukcji: ', num2str(error)]);