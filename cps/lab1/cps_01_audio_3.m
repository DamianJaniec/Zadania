% cps_01_audio_3.m
%problem 1.12
%nałożenie dwóch dźwięków na jedną ścieżkę

clc;
clear all; 
close all;
% Akwizycja sygnalu audio
fpr = 22050;     % czestotliwosc probkowania (probki na sekunde):
                % 8000, 11025, 16000, 22050, 32000, 44100, 48000, 96000,
bits = 16;       % liczba bitow na probke: 8, 16, 24, 32
channels = 1;   % liczba kanalow: 1 albo 2 (mono/stereo)



[audio_wiatr, fpr_org] = audioread('wiatr001.mp3'); %pobranie ścieżkie do wektora
audio_wiatr = resample(audio_wiatr, fpr, fpr_org); %zmiana częstotliwości

if size(audio_wiatr, 2) == 2 %sprawdzenie czy ścieżka ma 1 czy 2 kanały
    audio_wiatr = mean(audio_wiatr, 2); % Uśrednienie kanałów do Mono
end


[audio_ptak, fpr_org] = audioread('ptak001.mp3'); 
audio_ptak = resample(audio_ptak, fpr, fpr_org);

if size(audio_ptak, 2) == 2 
    audio_ptak = mean(audio_ptak, 2); % Uśrednienie kanałów do Mono
end

audio_wiatr = audio_wiatr(:); %uswawienie wektora w kolumnę
audio_ptak = audio_ptak(:);   

nx1 = length(audio_ptak); %sprawdzanie który jest dłuższy
nx2 = length(audio_wiatr);
nx_max = max(nx1,nx2);

audio_wiatr = [audio_wiatr; zeros(nx_max-nx2,1)]; %wypełnianie zerami
audio_ptak = [audio_ptak; zeros(nx_max-nx1,1)];

audio=audio_ptak + audio_wiatr; %łączenie

figure(1);  %wyświetlania
subplot(3,1,1);
plot(audio_ptak,'bo-'); xlabel('numer probki n'); title('x(n)'); grid;
subplot(3,1,2);
plot(audio_wiatr,'bo-'); xlabel('numer probki n'); title('x(n)'); grid;
subplot(3,1,3);
plot(audio,'bo-'); xlabel('numer probki n'); title('x(n)'); grid;

fprintf("Wcisnij klawisz aby odsluchać");
pause();
sound(audio,fpr);

