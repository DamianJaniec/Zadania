clear all; close all; clc;

%% parametry dyskretyzacji
N = 2000;           % liczba probek
fpr = 2000;         % czestotliwosc probkowania
dt = 1/fpr;         % krok czasowy
t = dt*(0:N-1);     % wektor czasu [0, 1) sekundy
T = N*dt;           % calkowity czas obserwacji

% wektor czestotliwosci dla DFT
df = fpr/N;         % rozdzielczosc czestotliwosciowa
f = (0:N-1)*df;     % czestotliwosc od 0 do fpr
f_shifted = f - fpr/2;  % czestotliwosc wycentrowana

% wektor czasu wycentrowany (dla sygnalow symetrycznych)
t_centered = t - T/2;   % czas od -T/2 do T/2

%% SYGNAL 1: OKNO PROSTOKATNE
%  r_T(t) = 1 dla |t| <= T/2, 0 dla |t| > T/2
%  X(w) = 2*sin(w*T/2)/w = T*sinc(w*T/(2*pi))

% generacja sygnalu - uzywamy t_centered zeby miec symetrie
x1 = ones(1,N);  % caly sygnal to 1 bo jestesmy w przedziale [0,T)

% DFT za pomoca fft
X1_dft = fft(x1);
X1_dft_shifted = fftshift(X1_dft);

% DtFT reczne obliczenie dla dodatkowego punktu
f_dtft = linspace(-fpr/2, fpr/2, 4000);  % gestszy wektor czestotliwosci
X1_dtft = zeros(size(f_dtft));
for k = 1:length(f_dtft)
    X1_dtft(k) = sum(x1 .* exp(-1j*2*pi*f_dtft(k)*t)) * dt;
end

% wzor teoretyczny: X(f) = T * sinc(f*T) dla sygnalu od 0 do T
% dla sygnalu wycentrowanego byloby sinc(f*T)
X1_teoria = T * sinc(f_dtft * T);  % sinc matlabowy to sin(pi*x)/(pi*x)

figure('Name','Sygnal 1: Okno prostokatne','Position',[100 100 1200 800]);
subplot(2,2,1)
plot(t*1000, x1, 'b', 'LineWidth', 1.5);
xlabel('czas [ms]'); ylabel('amplituda');
title('sygnal x1(t) - okno prostokatne');
grid on;

subplot(2,2,2)
plot(f_shifted, abs(X1_dft_shifted), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('widmo DFT - skala liniowa');
grid on; xlim([-100 100]);

subplot(2,2,3)
plot(f_shifted, 20*log10(abs(X1_dft_shifted)+eps), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)| [dB]');
title('widmo DFT - skala decybelowa');
grid on; xlim([-100 100]); ylim([-50 70]);

subplot(2,2,4)
plot(f_dtft, abs(X1_dtft), 'b', 'LineWidth', 1.5); hold on;
plot(f_dtft, abs(X1_teoria), 'r--', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('porownanie DtFT (niebieski) z teoria (czerwony)');
legend('DtFT reczne', 'wzor teoretyczny');
grid on; xlim([-100 100]);

% widmo prostokata to funkcja sinc, ma charakterystyczne listki boczne
% glowny listek ma szerokosc 2/T = 2 Hz (bo T=1s)
% DtFT pokrywa sie dobrze ze wzorem teoretycznym

%% SYGNAL 2: SYGNAL ZNAKU (signum)
%  sgn(t) = 1 dla t>0, -1 dla t<0
%  X(w) = 2/(j*w)

x2 = sign(t_centered);
x2(t_centered == 0) = 0;  % w zerze sgn(0) = 0

X2_dft = fft(x2);
X2_dft_shifted = fftshift(X2_dft);

% DtFT reczne
X2_dtft = zeros(size(f_dtft));
for k = 1:length(f_dtft)
    X2_dtft(k) = sum(x2 .* exp(-1j*2*pi*f_dtft(k)*t)) * dt;
end

% wzor teoretyczny: X(f) = 1/(j*pi*f) czyli |X(f)| = 1/(pi*|f|)
% ale to jest dla nieskonczonego sygnalu, nasz jest okienkowany
X2_teoria = 1./(1j*pi*f_dtft + eps);

figure('Name','Sygnal 2: Signum','Position',[100 100 1200 800]);
subplot(2,2,1)
plot(t_centered*1000, x2, 'b', 'LineWidth', 1.5);
xlabel('czas [ms]'); ylabel('amplituda');
title('sygnal x2(t) - signum');
grid on;

subplot(2,2,2)
plot(f_shifted, abs(X2_dft_shifted), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('widmo DFT - skala liniowa');
grid on; xlim([-100 100]);

subplot(2,2,3)
plot(f_shifted, 20*log10(abs(X2_dft_shifted)+eps), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)| [dB]');
title('widmo DFT - skala decybelowa');
grid on; xlim([-100 100]);

subplot(2,2,4)
plot(f_dtft, abs(X2_dtft), 'b', 'LineWidth', 1.5); hold on;
plot(f_dtft, abs(X2_teoria), 'r--', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('porownanie DtFT (niebieski) z teoria (czerwony)');
legend('DtFT reczne', 'wzor 1/(j*pi*f)');
grid on; xlim([-100 100]);

% widmo signum teoretycznie to 1/(j*pi*f) czyli spada jak 1/f
% w praktyce mamy okienkowanie wiec widac roznice
% faza jest czysto urojona (przesuniecie o 90 stopni)

%% SYGNAL 3: FUNKCJA GAUSSA
%  x(t) = exp(-a*t^2)
%  X(w) = sqrt(pi/a) * exp(-w^2/(4a))

a = 100;  % parametr gaussowski, im wiekszy tym wezsza funkcja
x3 = exp(-a * t_centered.^2);

X3_dft = fft(x3);
X3_dft_shifted = fftshift(X3_dft);

% DtFT reczne
X3_dtft = zeros(size(f_dtft));
for k = 1:length(f_dtft)
    X3_dtft(k) = sum(x3 .* exp(-1j*2*pi*f_dtft(k)*t)) * dt;
end

% wzor teoretyczny: X(f) = sqrt(pi/a) * exp(-(pi*f)^2/a)
% w dziedzinie f (nie omega)
X3_teoria = sqrt(pi/a) * exp(-(pi*f_dtft).^2 / a);

figure('Name','Sygnal 3: Gauss','Position',[100 100 1200 800]);
subplot(2,2,1)
plot(t_centered*1000, x3, 'b', 'LineWidth', 1.5);
xlabel('czas [ms]'); ylabel('amplituda');
title(sprintf('sygnal x3(t) - gauss, a=%d', a));
grid on;

subplot(2,2,2)
plot(f_shifted, abs(X3_dft_shifted), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('widmo DFT - skala liniowa');
grid on; xlim([-50 50]);

subplot(2,2,3)
plot(f_shifted, 20*log10(abs(X3_dft_shifted)+eps), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)| [dB]');
title('widmo DFT - skala decybelowa');
grid on; xlim([-50 50]);

subplot(2,2,4)
plot(f_dtft, abs(X3_dtft), 'b', 'LineWidth', 1.5); hold on;
plot(f_dtft, abs(X3_teoria), 'r--', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('porownanie DtFT (niebieski) z teoria (czerwony)');
legend('DtFT reczne', 'wzor teoretyczny');
grid on; xlim([-50 50]);

% transformata gaussa to tez gauss - jedyna funkcja z ta wlasnoscia
% im wezszy gauss w czasie tym szerszy w czestotliwosci i odwrotnie
% to wynika z zasady nieoznaczonosci

%% SYGNAL 4: JEDNOSTRONNA EKSPONENTA
%  x(t) = exp(-a*t) dla t>=0, 0 dla t<0
%  X(w) = 1/(a + j*w)

a = 5;  % stala czasowa
x4 = exp(-a * t) .* (t >= 0);  % eksponenta tylko dla t>=0

X4_dft = fft(x4);
X4_dft_shifted = fftshift(X4_dft);

% DtFT reczne
X4_dtft = zeros(size(f_dtft));
for k = 1:length(f_dtft)
    X4_dtft(k) = sum(x4 .* exp(-1j*2*pi*f_dtft(k)*t)) * dt;
end

% wzor teoretyczny: X(f) = 1/(a + j*2*pi*f)
X4_teoria = 1 ./ (a + 1j*2*pi*f_dtft);

figure('Name','Sygnal 4: Eksponenta jednostronna','Position',[100 100 1200 800]);
subplot(2,2,1)
plot(t*1000, x4, 'b', 'LineWidth', 1.5);
xlabel('czas [ms]'); ylabel('amplituda');
title(sprintf('sygnal x4(t) - eksponenta, a=%d', a));
grid on; xlim([0 500]);

subplot(2,2,2)
plot(f_shifted, abs(X4_dft_shifted), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('widmo DFT - skala liniowa');
grid on; xlim([-20 20]);

subplot(2,2,3)
plot(f_shifted, 20*log10(abs(X4_dft_shifted)+eps), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)| [dB]');
title('widmo DFT - skala decybelowa');
grid on; xlim([-20 20]);

subplot(2,2,4)
plot(f_dtft, abs(X4_dtft), 'b', 'LineWidth', 1.5); hold on;
plot(f_dtft, abs(X4_teoria), 'r--', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('porownanie DtFT (niebieski) z teoria (czerwony)');
legend('DtFT reczne', 'wzor 1/(a+j*2*pi*f)');
grid on; xlim([-20 20]);

% widmo eksponenty to filtr dolnoprzepustowy pierwszego rzedu
% czestotliwosc graniczna fc = a/(2*pi), tutaj fc = 5/(2*pi) = 0.8 Hz
% modul spada jak 1/sqrt(a^2 + w^2)

%% SYGNAL 5: TLUMIONY SINUS
%  x(t) = A*exp(-a*t)*sin(w0*t) dla t>=0
%  X(w) = A*w0 / ((a+jw)^2 + w0^2)

a = 3;        % wspolczynnik tlumienia
f0 = 10;      % czestotliwosc sinusa
w0 = 2*pi*f0;
A = 1;

x5 = A * exp(-a*t) .* sin(w0*t) .* (t >= 0);

X5_dft = fft(x5);
X5_dft_shifted = fftshift(X5_dft);

% DtFT reczne
X5_dtft = zeros(size(f_dtft));
for k = 1:length(f_dtft)
    X5_dtft(k) = sum(x5 .* exp(-1j*2*pi*f_dtft(k)*t)) * dt;
end

% wzor teoretyczny: X(f) = A*w0 / ((a + j*2*pi*f)^2 + w0^2)
w_dtft = 2*pi*f_dtft;
X5_teoria = A*w0 ./ ((a + 1j*w_dtft).^2 + w0^2);

figure('Name','Sygnal 5: Tlumiony sinus','Position',[100 100 1200 800]);
subplot(2,2,1)
plot(t*1000, x5, 'b', 'LineWidth', 1.5);
xlabel('czas [ms]'); ylabel('amplituda');
title(sprintf('sygnal x5(t) - tlumiony sinus, f0=%d Hz, a=%d', f0, a));
grid on; xlim([0 500]);

subplot(2,2,2)
plot(f_shifted, abs(X5_dft_shifted), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('widmo DFT - skala liniowa');
grid on; xlim([-30 30]);

subplot(2,2,3)
plot(f_shifted, 20*log10(abs(X5_dft_shifted)+eps), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)| [dB]');
title('widmo DFT - skala decybelowa');
grid on; xlim([-30 30]);

subplot(2,2,4)
plot(f_dtft, abs(X5_dtft), 'b', 'LineWidth', 1.5); hold on;
plot(f_dtft, abs(X5_teoria), 'r--', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('porownanie DtFT (niebieski) z teoria (czerwony)');
legend('DtFT reczne', 'wzor teoretyczny');
grid on; xlim([-30 30]);

% widmo tlumioncego sinusa ma piki przy +/-f0
% im mniejsze tlumienie a tym wezsze i wyzsze piki
% to jest odpowiedz impulsowa ukladu drugiego rzedu

%% SYGNAL 6: TLUMIONY KOSINUS
%  x(t) = A*exp(-a*t)*cos(w0*t) dla t>=0
%  X(w) = A*(a+jw) / ((a+jw)^2 + w0^2)

a = 3;        % wspolczynnik tlumienia
f0 = 10;      % czestotliwosc kosinusa
w0 = 2*pi*f0;
A = 1;

x6 = A * exp(-a*t) .* cos(w0*t) .* (t >= 0);

X6_dft = fft(x6);
X6_dft_shifted = fftshift(X6_dft);

% DtFT reczne
X6_dtft = zeros(size(f_dtft));
for k = 1:length(f_dtft)
    X6_dtft(k) = sum(x6 .* exp(-1j*2*pi*f_dtft(k)*t)) * dt;
end

% wzor teoretyczny: X(f) = A*(a + j*2*pi*f) / ((a + j*2*pi*f)^2 + w0^2)
X6_teoria = A*(a + 1j*w_dtft) ./ ((a + 1j*w_dtft).^2 + w0^2);

figure('Name','Sygnal 6: Tlumiony kosinus','Position',[100 100 1200 800]);
subplot(2,2,1)
plot(t*1000, x6, 'b', 'LineWidth', 1.5);
xlabel('czas [ms]'); ylabel('amplituda');
title(sprintf('sygnal x6(t) - tlumiony kosinus, f0=%d Hz, a=%d', f0, a));
grid on; xlim([0 500]);

subplot(2,2,2)
plot(f_shifted, abs(X6_dft_shifted), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('widmo DFT - skala liniowa');
grid on; xlim([-30 30]);

subplot(2,2,3)
plot(f_shifted, 20*log10(abs(X6_dft_shifted)+eps), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)| [dB]');
title('widmo DFT - skala decybelowa');
grid on; xlim([-30 30]);

subplot(2,2,4)
plot(f_dtft, abs(X6_dtft), 'b', 'LineWidth', 1.5); hold on;
plot(f_dtft, abs(X6_teoria), 'r--', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('porownanie DtFT (niebieski) z teoria (czerwony)');
legend('DtFT reczne', 'wzor teoretyczny');
grid on; xlim([-30 30]);

% roznica miedzy tlumiony sinus a kosinus - w liczniku transformaty
% kosinus ma (a+jw) a sinus ma w0
% przez to kosinus ma wieksza skladowa DC

%% SYGNAL 7: FRAGMENT KOSINUSA (okienkowany kosinus)
%  x(t) = cos(w0*t) * rect_T(t)
%  X(w) = T/2 * [sinc((w-w0)*T/(2pi)) + sinc((w+w0)*T/(2pi))]

f0 = 50;      % czestotliwosc kosinusa
w0 = 2*pi*f0;

x7 = cos(w0*t);  % kosinus w oknie [0,T]

X7_dft = fft(x7);
X7_dft_shifted = fftshift(X7_dft);

% DtFT reczne
X7_dtft = zeros(size(f_dtft));
for k = 1:length(f_dtft)
    X7_dtft(k) = sum(x7 .* exp(-1j*2*pi*f_dtft(k)*t)) * dt;
end

% wzor teoretyczny: splot delty z sinc
% X(f) = T/2 * [sinc((f-f0)*T) + sinc((f+f0)*T)]
X7_teoria = T/2 * (sinc((f_dtft - f0)*T) + sinc((f_dtft + f0)*T));

figure('Name','Sygnal 7: Fragment kosinusa','Position',[100 100 1200 800]);
subplot(2,2,1)
plot(t*1000, x7, 'b', 'LineWidth', 1);
xlabel('czas [ms]'); ylabel('amplituda');
title(sprintf('sygnal x7(t) - fragment kosinusa, f0=%d Hz', f0));
grid on; xlim([0 100]);

subplot(2,2,2)
plot(f_shifted, abs(X7_dft_shifted), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('widmo DFT - skala liniowa');
grid on; xlim([-100 100]);

subplot(2,2,3)
plot(f_shifted, 20*log10(abs(X7_dft_shifted)+eps), 'b', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)| [dB]');
title('widmo DFT - skala decybelowa');
grid on; xlim([-100 100]);

subplot(2,2,4)
plot(f_dtft, abs(X7_dtft), 'b', 'LineWidth', 1.5); hold on;
plot(f_dtft, abs(X7_teoria), 'r--', 'LineWidth', 1);
xlabel('czestotliwosc [Hz]'); ylabel('|X(f)|');
title('porownanie DtFT (niebieski) z teoria (czerwony)');
legend('DtFT reczne', 'wzor teoretyczny');
grid on; xlim([-100 100]);

% widmo fragmentu kosinusa to dwie funkcje sinc przesuniete do +/-f0
% to jest wynik splotu widma kosinusa (dwie delty) z widmem okna (sinc)
% im dluzszy fragment tym wezsze sinc-i czyli lepsza rozdzielczosc

%% PODSUMOWANIE - wszystkie sygnaly na jednym rysunku

figure('Name','Podsumowanie - wszystkie sygnaly','Position',[50 50 1400 900]);

% sygnaly w czasie
subplot(4,2,1)
plot(t_centered*1000, x1, 'b'); title('1. okno prostokatne'); 
xlabel('t [ms]'); grid on; xlim([-100 100]);

subplot(4,2,2)
plot(t_centered*1000, x2, 'b'); title('2. signum');
xlabel('t [ms]'); grid on; xlim([-100 100]);

subplot(4,2,3)
plot(t_centered*1000, x3, 'b'); title('3. gauss');
xlabel('t [ms]'); grid on; xlim([-100 100]);

subplot(4,2,4)
plot(t*1000, x4, 'b'); title('4. eksponenta');
xlabel('t [ms]'); grid on; xlim([0 500]);

subplot(4,2,5)
plot(t*1000, x5, 'b'); title('5. tlumiony sinus');
xlabel('t [ms]'); grid on; xlim([0 500]);

subplot(4,2,6)
plot(t*1000, x6, 'b'); title('6. tlumiony kosinus');
xlabel('t [ms]'); grid on; xlim([0 500]);

subplot(4,2,7)
plot(t*1000, x7, 'b'); title('7. fragment kosinusa');
xlabel('t [ms]'); grid on; xlim([0 100]);

% widma na jednym rysunku
figure('Name','Podsumowanie - wszystkie widma','Position',[50 50 1400 900]);

subplot(4,2,1)
plot(f_shifted, abs(X1_dft_shifted), 'b'); title('1. |X| okno prostokatne');
xlabel('f [Hz]'); grid on; xlim([-50 50]);

subplot(4,2,2)
plot(f_shifted, abs(X2_dft_shifted), 'b'); title('2. |X| signum');
xlabel('f [Hz]'); grid on; xlim([-50 50]);

subplot(4,2,3)
plot(f_shifted, abs(X3_dft_shifted), 'b'); title('3. |X| gauss');
xlabel('f [Hz]'); grid on; xlim([-30 30]);

subplot(4,2,4)
plot(f_shifted, abs(X4_dft_shifted), 'b'); title('4. |X| eksponenta');
xlabel('f [Hz]'); grid on; xlim([-20 20]);

subplot(4,2,5)
plot(f_shifted, abs(X5_dft_shifted), 'b'); title('5. |X| tlumiony sinus');
xlabel('f [Hz]'); grid on; xlim([-30 30]);

subplot(4,2,6)
plot(f_shifted, abs(X6_dft_shifted), 'b'); title('6. |X| tlumiony kosinus');
xlabel('f [Hz]'); grid on; xlim([-30 30]);

subplot(4,2,7)
plot(f_shifted, abs(X7_dft_shifted), 'b'); title('7. |X| fragment kosinusa');
xlabel('f [Hz]'); grid on; xlim([-100 100]);

%% WNIOSKI KONCOWE
% 1. okno prostokatne -> widmo sinc, listki boczne
% 2. signum -> widmo 1/(j*w), spada jak 1/f
% 3. gauss -> gauss w czestotliwosci, zasada nieoznaczonosci
% 4. eksponenta -> filtr dolnoprzepustowy 1-go rzedu
% 5. tlumiony sinus -> piki przy +/-f0, odpowiedz ukladu 2-go rzedu
% 6. tlumiony kosinus -> podobnie ale z wieksza skladowa DC
% 7. fragment kosinusa -> dwa sinc-e przy +/-f0, splot widm
%
% DtFT obliczone recznie pokrywa sie z wzorami teoretycznymi
% roznice wynikaja z dyskretyzacji i ograniczonego czasu obserwacji