% cps_05_fft1.m
clear all; close all; clc;
N = 100; %liczba próbek
x = rand(1,N); %sygnał
Xm = fft(x); %widmo sygnału
Xe = fft(x(1:2:N)); %widmo parzystych próbek sygnału
Xo = fft(x(2:2:N)); %widmo nie parzystych próbek syngału
X = [ Xe, Xe ] + exp(-j*2*pi/N*(0:1:N-1)) .* [Xo, Xo ]; %sklejamy całość za
%pomocą wzoru X[k] = Xe[k] + W_N^k * Xo[k]
error1 = max( abs( X - Xm ) ) %obliczamy błąd

%błędy wynikają z liczenia numerycznego komputera, wynik jest praktycznie 
%zerowy, dla kilku prób różnica również jest bliska zeru, można więc 
%w ten sposób zrekonstruwać widmo sygnału

%kod bez korzystania z fft

N = 100; %liczba próbek
x = rand(1,N); %sygnał

xe = x(1:2:end);
xo = x(2:2:end); %próbki

k = (0:N/2-1)';
n = 0:N/2-1;

W_half = exp(-1j*2*pi*k*n/(N/2)); % 50×50
Wk = exp(-1j*2*pi*k/N);

Ae = [ W_half;
       W_half ]; %100x50bez korekty

Ao = [  W_half .* Wk;
       -W_half .* Wk ]; % 100×50 z korektą

X = Ae*xe.' + Ao*xo.'; %skeljanie 
Xm = fft(x);

error = max(abs(X - Xm.')) %weryfikacja