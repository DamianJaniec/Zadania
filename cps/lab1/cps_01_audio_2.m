% cps_01_audio_2.m
%problem 1.9
clc;
clear all; 
close all;
% Akwizycja sygnalu audio
fpr = 22050;     % czestotliwosc probkowania (probki na sekunde):
                % 8000, 11025, 16000, 22050, 32000, 44100, 48000, 96000,
bits = 8;       % liczba bitow na probke: 8, 16, 24, 32
channels = 1;   % liczba kanalow: 1 albo 2 (mono/stereo)



[audio, fpr_org] = audioread('zdanie001.mp3'); % Wczytanie danych (audio) i częstotliwości próbkowania (fpr_org)



audio = resample(audio, fpr, fpr_org); %zmiana częstotliwości próbkowania pliku audio na naszą
%inaczej plik zawsze się "odtworzy" z orginalnymi parametrami


% Weryfikacja - odsluch, rysunek
sound(audio,fpr);           % odtworz nagrany dzwiek
x = audio; clear audio;     % skopiuj audio, wyzeruj audio
Nx = length(x);             % pobierz liczbe probek
n= 0:Nx-1;                  % indeksy probek
dt = 1/fpr;                 % oblicz okres probkowania sygnalu
t = dt*n;                   % oblicz chwile probkowania

%fpr = 22050
% Indeksy próbek dla każdej części:
idx1_start = 1;
idx1_end   = 13250;

idx2_start = 13250 + 1;
idx2_end   = 24500;

idx3_start = 24500 + 1;
idx3_end   = Nx; % Trzecia część bierze WSZYSTKO, co zostało (włącznie z resztą)

% Wypisanie części do nowych wektorów:
x1 = x(idx1_start : idx1_end);      % Pierwsza część
x2 = x(idx2_start : idx2_end);      % Druga część
x3 = x(idx3_start : idx3_end);      % Trzecia część


x_mix = [x3; x2; x1]; 

figure(1); 
subplot(2,1,1);
plot(x,'bo-'); xlabel('numer probki n'); title('x(n)'); grid;
title("Przed zmiana");
subplot(2,1,2);
plot(x_mix,'bo-'); xlabel('numer probki n'); title('x(n)'); grid;
title("Po zmianie;")


figure(2);
subplot(2,1,1);
plot(t,x,'b.-'); xlabel('t (s)'); title('x(t)'); grid; 
title("Przed zmiana");
subplot(2,1,2);
plot(t,x_mix,'b.-'); xlabel('t (s)'); title('x(t)'); grid; 
title("po zmiana");
fprintf("Wcisniuj klawisz aby zobaczyć wykres...\n");
pause();


% Zapisz na dysk i odczytaj z dysku
audiowrite('speech.wav',x_mix,fpr,'BitsPerSample',bits);    % zapisz nagranie
[y,fpr] = audioread('speech.wav');                      % odczytaj je z dysku
sound(y,fpr);                                           % odtworz nagranie
fprintf("Wcisnij klawisz dopiero jak skonczysz nagranie");
pause();


