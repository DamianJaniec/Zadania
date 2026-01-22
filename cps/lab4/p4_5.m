%problem 4_5
clc;
clear all; 
close all;

N=2^15;
fpr=8000;
dt = 1/fpr;  % okres próbkowania
t = (0:N-1)*dt;  % wektor czasu

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

%parametry sygnału
f0 = 2500;  % częstotliwość nośna [Hz]
df = 500;   % odchylenie częstotliwości [Hz]
fm = 0.25;  % częstotliwość modulacji [Hz]

% Sygnał z modulacją częstotliwości
fi = 2*pi*(f0*t + (df/fm)*sin(2*pi*fm*t));  % faza chwilowa
zaklocenie = 0.5*sin(fi)';

suma = zdanie + zaklocenie;

%obliczanie widma

DFT_mowa = fft(zdanie);
DFT_zaklocenie = fft(zaklocenie);
DFT_suma = fft(suma);

%oś częstotliwośći

f = (0:N-1)*(fpr/N);


figure();

subplot(3,1,1);
plot(f(1:N/2), abs(DFT_mowa(1:N/2)));
grid on;
title('Widmo amplitudowe DFT - Sygnał mowy');
xlabel('Częstotliwość [Hz]');
ylabel('|DFT|');
xlim([0 4000]);

subplot(3,1,2);
plot(f(1:N/2), abs(DFT_zaklocenie(1:N/2)));
grid on;
title('Widmo amplitudowe DFT - Zakłócenie (SFM)');
xlabel('Częstotliwość [Hz]');
ylabel('|DFT|');
xlim([0 4000]);

subplot(3,1,3);
plot(f(1:N/2), abs(DFT_suma(1:N/2)));
grid on;
title('Widmo amplitudowe DFT - Sygnał sumaryczny');
xlabel('Częstotliwość [Hz]');
ylabel('|DFT|');
xlim([0 4000]);

% 6. Identyfikacja i usunięcie zakłócenia
f_cutoff = 2000;  % Granica między mową a zakłóceniem [Hz]

% Indeksy do wyzerowania
idx_high = find(f > f_cutoff & f < (fpr - f_cutoff));

DFT_oczyszczone = DFT_suma;

% POPRAW TE DWIE LINIE:
DFT_oczyszczone(idx_high) = 0;  % Zamiast idx_positive i idx_negative


sygnal_oczyszczony = real(ifft(DFT_oczyszczone));

sygnal_oczyszczony = sygnal_oczyszczony(:);  % Wymuszenie kolumny

if length(sygnal_oczyszczony) < length(t)
    % Jeśli sygnał jest krótszy, dopełnij zerami
    sygnal_oczyszczony = [sygnal_oczyszczony; zeros(length(t) - length(sygnal_oczyszczony), 1)];
elseif length(sygnal_oczyszczony) > length(t)
    % Jeśli sygnał jest dłuższy, obetnij
    sygnal_oczyszczony = sygnal_oczyszczony(1:length(t));
end

% 8. Wyświetlenie sygnałów w dziedzinie czasu
figure();

subplot(4,1,1);
plot(t(:), zdanie(:));
grid on;
title('Sygnał oryginalny - mowa');
xlabel('Czas [s]');
ylabel('Amplituda');

subplot(4,1,2);
plot(t(:), zaklocenie(:));
grid on;
title('Zakłócenie - SFM');
xlabel('Czas [s]');
ylabel('Amplituda');

subplot(4,1,3);
plot(t(:), suma(:));
grid on;
title('Sygnał zakłócony (mowa + SFM)');
xlabel('Czas [s]');
ylabel('Amplituda');

subplot(4,1,4);
plot(t(:), sygnal_oczyszczony(:));
grid on;
title('Sygnał oczyszczony (po filtracji DFT)');
xlabel('Czas [s]');
ylabel('Amplituda');



disp('Odsłuchiwanie sygnałów...');
disp('1. Sygnał oryginalny (mowa)');
sound(zdanie, fpr);
pause(N/fpr + 1);

disp('2. Sygnał zakłócony (mowa + SFM)');
sound(suma, fpr);
pause(N/fpr + 1);

disp('3. Sygnał oczyszczony');
sound(sygnal_oczyszczony, fpr);
pause(N/fpr + 1);

