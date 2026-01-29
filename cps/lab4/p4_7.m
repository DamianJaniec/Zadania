% cps04_problem_4_7.m
clear all; close all; clc;

% parametry sygnalu
fs = 1000;           % czestotliwosc probkowania
fx1 = 100;           % czestotliwosc sygnalu
N = 100;             % liczba probek
dt = 1/fs;
t = (0:N-1).' * dt;  % wektor czasu

% generacja sygnalu kosinusoidalnego
x1 = cos(2*pi*fx1*t);

%% CZESC 1 - okno prostokatne, szeroki zakres DtFT


w = boxcar(N);       % okno prostokatne
xw = x1 .* w;

fmax = 2.5*fs;       % maksymalna czestotliwosc w DtFT
df = 10;             % krok czestotliwosciowy
f = -fmax:df:fmax;   % wektor czestotliwosci

% DtFT
Xf = zeros(size(f));
for k = 1:length(f)
    Xf(k) = sum(xw .* exp(-1j*2*pi*f(k)*t));
end

figure;
subplot(2,1,1)
plot(f,abs(Xf),'b'); grid on
title('modul DtFT sygnalu x1 * rect window, df=10Hz')

subplot(2,1,2)
plot(f,angle(Xf),'r'); grid on
title('faza DtFT sygnalu x1 * rect window')

% w szerokim zakresie widzimy wiele kopii widma kosinusa
% bo DtFT jest okresowy z okres fs, natomiast DFT widzi tylko jedna "gorke"

%% CZESC 2 - zwiekszenie gestosci próbkowania DtFT

df = 1;                   % krok 1 Hz
f = -fmax:df:fmax;

Xf = zeros(size(f));
for k = 1:length(f)
    Xf(k) = sum(xw .* exp(-1j*2*pi*f(k)*t));
end

figure;
plot(f,abs(Xf),'b'); grid on
title('modul DtFT sygnalu x1 * rect window, df=1Hz')
xlabel('czestotliwosc [Hz]')

% teraz widzimy oscylacje widma okna prostokatnego
% widmo jest splotem kosinusa z widmem okna


%% CZESC 3 - dodanie slabej skladowej


fx2 = 250;   % druga czestotliwosc
A2 = 0.001;  % bardzo mala amplituda
x2 = A2*cos(2*pi*fx2*t);

xw2 = (x1 + x2).*w;

Xf2 = zeros(size(f));
for k = 1:length(f)
    Xf2(k) = sum(xw2 .* exp(-1j*2*pi*f(k)*t));
end

figure;
plot(f,abs(Xf2),'b'); grid on
title('DtFT x1 + slaba x2 * rect window')
xlabel('czestotliwosc [Hz]')

% bardzo slaba skladowa fx2 nie jest widoczna
% bo oscylacje boczne okna maskuja maly sygnal


%% CZESC 4 - uzycie okna Hanning

w = hanning(N);
xw3 = (x1 + x2).*w;

Xf3 = zeros(size(f));
for k = 1:length(f)
    Xf3(k) = sum(xw3 .* exp(-1j*2*pi*f(k)*t));
end

figure;
plot(f,abs(Xf3),'b'); grid on
title('DtFT x1 + slaba x2 * Hanning window')
xlabel('czestotliwosc [Hz]')

% okno Hanninga ma nizsze listki boczne
% teraz slaba skladowa fx2 staje sie widoczna
% kosztem poszerzenia glownego "patyka" widma

%% CZESC 5 - okno Czebyszewa

w = chebwin(N,140);  % bardzo niskie listki boczne
xw4 = (x1 + x2).*w;

Xf4 = zeros(size(f));
for k = 1:length(f)
    Xf4(k) = sum(xw4 .* exp(-1j*2*pi*f(k)*t));
end

figure;
plot(f,abs(Xf4),'b'); grid on
title('DtFT x1 + slaba x2 * Chebwin(140 dB)')
xlabel('czestotliwosc [Hz]')

% teraz slaba skladowa jest widoczna nawet przy silnym x1
% ale "gorka" jest szeroka i jesli skladowe sa blisko siebie
% moga sie laczyc i byc trudne do rozroznienia
