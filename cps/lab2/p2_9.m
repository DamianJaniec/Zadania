clear all; close all;
fpr = 8000;

cisza = 400;%liczba probek opoznienia sygnalow
            %400 z 8000 to 1/20 czyli 0,05 sekundy opoznienia
tlumenie = 2;

[audio_dworzec, fpr_org] = audioread('dworzec.mp3');
audio_dworzec = resample(audio_dworzec, fpr, fpr_org);

% cisza 400 próbek (stereo)
l = zeros(cisza, size(audio_dworzec,2));

x1 = [audio_dworzec; l; l];
x2 = [l; audio_dworzec; l];
x3 = [l; l; audio_dworzec];

x1 = x1 / tlumenie^1;
x2 = x2 / tlumenie^2;
x3 = x3 / tlumenie^3;

x = x1 + x2 + x3;

sound(x,fpr);


%wnioski:
%przy 400 próbkach opóźnienia można zrozumieć
%przy większej liczbie głoski bardziej się rozchodzą
%i na siebie "najeżdżają" (?) i ciężej coś zrozumieć

%jeżeli zwiększymy tłumienie, to faktycznie jest ciszej
%lecz w przypadku dużego echa to nawet lepiej bo nie
%słychać dwóch kolejnych sygnałów, to można cokowliek zrozumieć