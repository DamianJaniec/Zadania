% cps_06_fftapp1_start.m
clear all; close all; clc;      % "mycie rak"

fpr = 1000;                 % czestotliwosc probkowania (Hz)
N = 100;                    % liczba probek sygnalu, 100 lub 1000
dt=1/fpr; t=dt*(0:N-1);     % chwile probkowania sygnalu, os czasu

% Signal
f0=200;
A = 1;
x = A*sin(2*pi*f0*t);  % sygnal o czestotliwosciach f0 = 50,100,125,200 Hz
figure; plot(t,x,'bo-'); xlabel('t [s]'); title('x(t)'); grid; pause

% FFT spectrum
X = fft(x);                 % FFT
f = fpr/N *(0:N-1);         % os czestotliwosci
figure; plot(f,1/N*abs(X),'bo-'); xlabel('f [Hz]'); title('|X(k)|'); grid; pause

%Sprawd´z warto´sci amplitudy i cz˛estotliwo´sci sygnału wygenerowanego w
%programie i spróbuj je odczyta´c z rysunku widma FFT sygnału 
%(znale´z´c je na nim)

%Piki w x= {50;950}
%Wysokość pików 0.5 
% Symetria hermitowska: sinus to suma dwoch skladowych e^(+jw) i e^(-jw),
% czestotliwosc ujemna -50Hz "zawija sie" na 1000-50=950Hz, dlatego dwa piki.

%Zmien´ amplitude˛ sygnału na 10, 100, 1000 oraz obserwuj wartos´ci modułu 
%widma. Dlaczego wartos´ci maksimów widma sa˛ dwa razy niz˙sze niz˙ 
%spodziewałe´s si˛e? (Przypomnij sobie równo´s´c: cos(α) = 0.5e jα +0.5e−jα.
%Jaki wzór jest dla sinusa?

%Zmie´n warto´s´c cze˛stotliwos´ci sygnału f0 na 50, 100, 125, 200 Hz oraz 
%obserwuj wartos´ci argumentów maksimów widma. Czy to sa˛ te same warto´sci?
%Wytłumacz pochodzenie rozmycia widma dla sygnału o cz˛estotliwo´sci f0=125 
%(przypomnij sobie znaczenie funkcji okien: jakiego okna teraz u˙zywamy?).

%Dla częstotliwości 50, 100, 200, piki są 2 w spodziewanych miejscach
%Natoamist przy częstotliwość 125 widmo się rozmywa ponieważ ta częstliwość
%nie znajduje się bezpośrednio w naszej bazie (nie jest wielkrotnością 10)
%ale Najwyższe Piki, są w okolicach spodziewanego miejsca

%% 1.
%pokaz˙ tylko pierwsza˛ połowe˛ (1/2) widma i poprawnie wyskaluj jego moduł (*2/N):
k = 1:N/2+1;
figure; plot(f(k), 2/N*abs(X(k)), 'bo-'); xlabel('f [Hz]'); title('|X(k)|'); grid;
pause();
%% 2.
%zmie´n warto´s´c N z 100 na 1000: obejrzyj widma FFT dla f0 = 50,100,125,200 Hz;

% dla N=1000 rozdzielczosc df=fpr/N=1Hz (zamiast 10Hz) teraz f0=125Hz daje ostry pik,
% bo 125 jest wielokrotnoscia 1Hz - sygnal znajduje się w naszej bazie

%% 3.

X = fft(x);                 % FFT
k = 1:N/2+1;
X_dB = 20*log10(2/N*abs(X(k)));
figure; plot(f(k), X_dB, 'bo-'); xlabel('f [Hz]'); title('|X(k)| [dB]'); grid;
pause();
% skala dB pokazuje ogromna roznice miedzy pikiem (0dB) a szumem numerycznym (-300dB)
% -300dB to bledy zaokraglen komputera, w praktyce oznacza "zero".

%% 4.

w = ones(1,N);
x = w;
X = fft(x);
k = 1:N/2+1;
X_dB = 20*log10(2/N*abs(X(k)));
figure; plot(f(k), X_dB, 'bo-'); xlabel('f [Hz]'); title('|X(k)| [dB]'); grid;
pause();
% czy takiego wyniku sie˛ spodziewałes´ (tylko wartos´c´ s´rednia)?

%nie

% sygnal stalych jedynek ma tylko skladowa DC (f=0Hz)DFT probkuje widmo w punktach
% wiec nie widac listkow bocznych funkcji sinc - one sa "miedzy" probkami
% dft


%% 5.

w = ones(1,N);
x = w.*(sin(2*pi*50*t) + sin(2*pi*125*t));
X = fft(x);
k = 1:N/2+1;
X_dB = 20*log10(2/N*abs(X(k)));
figure; plot(f(k), X_dB, 'bo-'); xlabel('f [Hz]'); title('|X(k)| [dB]'); grid;
pause();
% dla N=100 (df=10Hz) 50Hz jest wielokrotnoscia bazy - ostry pik; 125Hz nie jest - rozmycie
% dla N=1000 (df=1Hz) oba sa wielokrotnoscia bazy, oba piki ostre, brak rozmycia

%% 6.

w = chebwin(N, 100)';
x = w;
X = fft(x);
k = 1:N/2+1;
X_dB = 20*log10(2/N*abs(X(k)));
figure; plot(f(k), X_dB, 'bo-'); xlabel('f [Hz]'); title('Okno Czebyszewa [dB]'); grid;
pause();
% widmo samego okna Czebyszewa listek glowny przy 0Hz, listki boczne rowne -100dB
% Okno "wyglusza" rozmycie widma kosztem szerszego listka glownego


%% 7.

w = chebwin(N, 100)';
x = w .* (sin(2*pi*50*t) + sin(2*pi*125*t));   % bez apostrof przy w!
X = fft(x);
k = 1:N/2+1;
X_dB = 20*log10(2/sum(w)*abs(X(k))); 
figure; plot(f(k), X_dB, 'bo-'); xlabel('f [Hz]'); title('Sinusy z oknem Czebyszewa [dB]'); grid;
pause();
% Okno czebyszewa: piki szersze ale listki boczne na -100dB mniejsze rozmycia niz
% okno prostokatne lepsza separacja skladowych kosztem rozdzielczosci

%% 8.

w = ones(1,N);
x = w .* (sin(2*pi*50*t) + 0.001*sin(2*pi*125*t));
X = fft(x);
k = 1:N/2+1;
X_dB = 20*log10(2/N*abs(X(k)));
figure; plot(f(k), X_dB, 'bo-'); xlabel('f [Hz]'); title('Silny + slaby sinus BEZ okna [dB]'); grid;
pause();
% Slaba skladowa 125Hz (-60dB ponizej 50Hz) jest niewidoczna - "tonie" w rozmyciu
% (listkach bocznych) silniejszej skladowej 50Hz. Okno prostokatne nie wystarcza

%przy N=1000 jednak widać obie składowe wyraźnie

%% 9.
w = chebwin(N, 100)';
x = w .* (sin(2*pi*50*t) + 0.001*sin(2*pi*125*t));
X = fft(x);
k = 1:N/2+1;
X_dB = 20*log10(2/sum(w)*abs(X(k)));
figure; plot(f(k), X_dB, 'bo-'); xlabel('f [Hz]'); title('Silny + slaby sinus Z oknem Czebyszewa [dB]'); grid;
pause();
% Okno Czebyszewa tlumi listki boczne do -100dB, wiec slaba skladowa 125Hz (-60dB)
% jest teraz widoczna - "wystaje" ponad poziom listkow bocznych silniejszego 50Hz.