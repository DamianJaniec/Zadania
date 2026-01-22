%problem 4_5
clear all; close all; clc;

%% Parametry

N = 2^15;        % liczba próbek
fpr = 8000;       % czestotliwosc probkowania [Hz]
dt = 1/fpr;
t = (0:N-1)*dt;

%% Plik Audio

[zdanie, fpr_org] = audioread('wiedzmin3Intro.mp3'); %pobranie ścieżkie do wektora
zdanie = resample(zdanie, fpr, fpr_org); %zmiana częstotliwości
%sound(zdanie,fpr);

if size(zdanie, 2) == 2 %sprawdzenie czy ścieżka ma 1 czy 2 kanały
    zdanie = mean(zdanie, 2); % Uśrednienie kanałów do Mono
end

%dostowsowanie długości
if length(zdanie) > N
    zdanie = zdanie(1:N);
else
    zdanie = [zdanie; zeros(N-length(zdanie), 1)];
end

%% Generacja Sygnału Zakłócenia 

f0 = 2500;   % czestotliwosc nosna [Hz]
df = 500;    % dewiacja czestotliwosci [Hz]
fm = 0.25;     % czestotliwosc modulujaca [Hz]

fi = zeros(1, N);
fi(1) = 0;

for n = 2:N
    fi(n) = fi(n-1) + 2*pi*( ...
        f0 + df*sin(2*pi*fm*(n-1)/fpr) ...
        )/fpr;
end

zaklocenie = 0.5*sin(fi)';

suma = zdanie + zaklocenie;

%% Obliczanie Widm

DFT_zdanie = fft(zdanie);
DFT_zakl = fft(zaklocenie);
DFT_suma = fft(suma);

f = (0:N-1)*(fpr/N);

%% Wizualizacja Widm

figure;

subplot(3,1,1);
plot(f(1:N/2), abs(DFT_zdanie(1:N/2)));
title('Widmo DFT – mowa');
xlabel('Hz'); grid on; xlim([0 4000]);

subplot(3,1,2);
plot(f(1:N/2), abs(DFT_zakl(1:N/2)));
title('Widmo DFT – zakłócenie FM');
xlabel('Hz'); grid on; xlim([0 4000]);

subplot(3,1,3);
plot(f(1:N/2), abs(DFT_suma(1:N/2)));
title('Widmo DFT – sygnał zakłócony');
xlabel('Hz'); grid on; xlim([0 4000]);

%% Filtracja 

f_cut = 2000;

DFT_filt = DFT_suma;
idx = (f > f_cut & f < fpr - f_cut);
DFT_filt(idx) = 0;

%% Synteza IDF

sygnal_czysty = real(ifft(DFT_filt));

%% Porównanie czasowe
figure;

subplot(4,1,1);
plot(t, zdanie); grid on;
title('Sygnał mowy');

subplot(4,1,2);
plot(t, zaklocenie); grid on;
title('Zakłócenie FM');

subplot(4,1,3);
plot(t, suma); grid on;
title('Sygnał zakłócony');

subplot(4,1,4);
plot(t, sygnal_czysty); grid on;
title('Sygnał po filtracji DFT');

%% Odsłuch

sound(zdanie, fpr);
pause(N/fpr + 1);

sound(suma, fpr);
pause(N/fpr + 1);

sound(sygnal_czysty, fpr);