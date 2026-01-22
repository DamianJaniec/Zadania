% cps_01_audio.m
%problem 1.4
clc;
clear all; 
close all;
% Akwizycja sygnalu audio
fpr = 44100;     % czestotliwosc probkowania (probki na sekunde):
                % 8000, 11025, 16000, 22050, 32000, 44100, 48000, 96000,
bits = 8;       % liczba bitow na probke: 8, 16, 24, 32
channels = 1;   % liczba kanalow: 1 albo 2 (mono/stereo)

%{
input_device_id = 1;                            % Ustawiamy ID Mojego mikrofonu
    %u mnie ustawienie mikrofonu okazało się ważne (mikrofon możemy ustalić za
    %pomocą audiodevinfo().input()
recorder = audiorecorder(fpr, bits, channels, input_device_id);  % tworzenie obiektu
disp('Nacisnij klawisz i nagraj audio'); pause  % pauza przed nagraniem
record(recorder);                               % start nagrania
pause(2);                                       % nagranie 2 sekund
stop(recorder);                                 % stop nagrania
play(recorder);                                 % odsluch
audio = getaudiodata( recorder, 'single' );     % import danych
%}

%do problemu 1.4
%[audio, fpr_org] = audioread('test001.mp3'); % Wczytanie danych (audio) i częstotliwości próbkowania (fpr_org)

%do problemu 1.5
[audio, fpr_org] = audioread('kot001.mp3'); 
audio = audio*20;

% pogłaśniamy dźwięk sztucznie, zwiększając amplitudę

%problem 1.5
%matlab nie przycina amplitudy przy wartościać powyżej 1 i poniżej -1
%dlatego żeby zasymulować przetwornik przytniemy sztucznie
audio(audio > 1.0) = 1.0;
audio(audio < -1.0) = -1.0; 

audio = resample(audio, fpr, fpr_org); %zmiana częstotliwości próbkowania pliku audio na naszą
%inaczej plik zawsze się "odtworzy" z orginalnymi parametrami


% Weryfikacja - odsluch, rysunek
%sound(audio,fpr);           % odtworz nagrany dzwiek
x = audio; clear audio;     % skopiuj audio, wyzeruj audio
Nx = length(x);             % pobierz liczbe probek
n= 0:Nx-1;                  % indeksy probek
dt = 1/fpr;                 % oblicz okres probkowania sygnalu
t = dt*n;                   % oblicz chwile probkowania

figure; plot(x,'bo-'); xlabel('numer probki n'); title('x(n)'); grid;
figure; plot(t,x,'b.-'); xlabel('t (s)'); title('x(t)'); grid; 
fprintf("Wcisniuj klawisz aby zobaczyć wykres...\n");
pause();


% Zapisz na dysk i odczytaj z dysku
audiowrite('speech.wav',x,fpr,'BitsPerSample',bits);    % zapisz nagranie
[y,fpr] = audioread('speech.wav');                      % odczytaj je z dysku
sound(y,fpr);                                           % odtworz nagranie
fprintf("Wcisnij klawisz dopiero jak skonczysz nagranie");
pause();

%Wnioski
%Zmieniając częstotliwość próbkowania, zmieniamy "prędkość" odtwarzanego
%dźwięku (w tak samo w przypadku nagywania)
%(osobiście nagrywanie mikrofonu miałem ustawionę na jakość DVD czyli
%48000Hz
%16 Bitów
%2 kanały)
%co za tym idzie gdy w matlabie ustawiliśmy na 8000Hz
%mowa była tak spowolniona że nie sposób było co kolwiek zrozumieć

%samo ustawienie bitów zmienia coś co określiłbym jako "jakość" nagrania
%przy 8 bitach było słychać wyraźny szum (zakłócenie?)
%przy 16 bitach dźwięk był wyraźnie czystszy
%niestety nie jestem audiofilem więc powyżej 16 bitów już nie słyszę różnicy

%Kanały w tym przypadku możemy mieć 1 lub 2, przetestowałem za pomocą
%mikrofonu
%w przypadku jednego kanału, gdy przestawie mikrofon zmienia się tylko
%głośność
%w przypadku dwóch z kolei zmienia się głośćność na każdej ze słuchawek
%co daje wrażenie "przestrzeni" - efekt zauważalny jeżeli mikrofon stoi z
%boku

%Problem 1.5
%W przypadku cichych dźwięków, nie ma większego problemu
%w przypadku głośniejszych dźwięków matlab na wykresie pokazuje wykres
%normalnie, ale wartości są odpowiednio przeskalowane
%natomiast nawet jeżeli nie zastosowaliśmy 
%"audio(audio < -1.0) = -1.0;"
%to mimo że wykres na pierwszy rzut oka wygląda normalnie, słychać
%że dźwięk jest poszarpany
%filtru użyłem po to aby lepiej pokazać badany problem na wylkresie

%problem 1.7
% Prędkość odtwarzania jest bezpośrednio związana z podaną wartością fpr, 
% ponieważ określa ona liczbę próbek, które mają być odtworzone w ciągu sekundy.
% Odtwarzanie z wyższą niż oryginalna fpr sprawia, że dźwięk jest szybszy i ma 
% wyższą tonację, a z niższą fpr jest wolniejszy i ma niższą tonację.