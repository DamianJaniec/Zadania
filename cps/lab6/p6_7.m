% cps06_problem_6_7.m
% splot liniowy, splot kolowy, szybki splot z uzyciem FFT
clear all; close all; clc;

%% wybor sygnalu
sig = 1;  % 1=krotki, 2=dlugi, 3=moje wlasne

if sig == 1
    N = 5; M = 3;
    x = ones(1, N);      % 5 jedynek
    h = ones(1, M);      % 3 jedynki
elseif sig == 2
    N = 256; M = 32;
    x = randn(1, N);     % losowy sygnal
    h = randn(1, M);     % losowa odpowiedz impulsowa
elseif sig == 3
    % moje wlasne sygnaly
    N = 8; M = 4;
    x = [1 2 3 4 5 4 3 2];           % sygnal trojkatny
    h = [1 -1 1 -1];                  % filtr rozniczkujacy
end

n = 1:N+M-1;   % indeksy dla pelnego splotu
nn = 1:N;      % indeksy dla splotu kolowego

%% wyswietlenie sygnalow wejsciowych
figure(1);
subplot(211); stem(x, 'filled', 'b'); 
title(['sygnal x(n), N=' num2str(N)]); grid on;
subplot(212); stem(h, 'filled', 'r'); 
title(['odpowiedz impulsowa h(n), M=' num2str(M)]); grid on;
pause

%% 1. Splot liniowy - funkcja conv() Matlaba
% metoda: przesun, mnoz, dodawaj
% wynik ma dlugosc N+M-1
y1 = conv(x, h);

figure(2);
stem(n, y1, 'filled', 'b');
title(['y1 = conv(x,h) - splot liniowy, dlugosc = ' num2str(length(y1))]);
xlabel('n'); grid on;
pause

%% 2. Szybki splot - NIEPOPRAWNY poczatek wyniku
% dodajemy N-M zer tylko do krotszego sygnalu
% wynik ma dlugosc N (splot kolowy)
hz = [h zeros(1, N-M)];  % h uzupelnione zerami do dlugosci N

y2 = ifft(fft(x) .* fft(hz));  % splot kolowy przez FFT

% pierwsze M-1 probek jest ZLYCH (aliasing czasowy)
error2 = max(abs(y1(M:N) - y2(M:N)));
fprintf('=== SPLOT KOLOWY (N-punktowy) ===\n');
fprintf('error2 (probki M:N): %e\n', error2);
fprintf('probki 1:%d sa NIEPOPRAWNE (aliasing)\n\n', M-1);

figure(3);
stem(nn, y1(nn), 'ro', 'LineWidth', 1.5); hold on;
stem(nn, real(y2(nn)), 'bx', 'LineWidth', 1.5); hold off;
title('y1 (czerwone o) vs y2 (niebieskie x) - splot kolowy N-punktowy');
xlabel('n'); legend('y1 (liniowy)', 'y2 (kolowy N-pkt)'); grid on;
pause

%% 3. Szybki splot - WSZYSTKIE probki poprawne
% uzupelniamy oba sygnaly zerami do dlugosci N+M-1
hzz = [h zeros(1, N-M) zeros(1, M-1)];  % h uzupelnione do N+M-1
xz = [x zeros(1, M-1)];                  % x uzupelnione do N+M-1

y3 = ifft(fft(xz) .* fft(hzz));  % splot kolowy = liniowy dla N+M-1 punktow

error3 = max(abs(y1 - y3));
fprintf('=== SPLOT KOLOWY (N+M-1 punktowy) ===\n');
fprintf('error3 (wszystkie probki): %e\n', error3);
fprintf('WSZYSTKIE probki sa POPRAWNE\n\n');

figure(4);
stem(n, y1, 'ro', 'LineWidth', 1.5); hold on;
stem(n, real(y3), 'bx', 'LineWidth', 1.5); hold off;
title('y1 (czerwone o) vs y3 (niebieskie x) - splot kolowy (N+M-1)-punktowy');
xlabel('n'); legend('y1 (liniowy)', 'y3 (kolowy N+M-1)'); grid on;
pause

%% 4. Szybki splot z podzialem na czesci - metoda OVERLAP-ADD
if sig >= 2  % tylko dla dluzszych sygnalow
    L = M;              % dlugosc fragmentu sygnalu
    K = N/L;            % liczba fragmentow
    
    hzz = [h zeros(1, L-M) zeros(1, M-1)];  % uzupelnienie zerami
    Hzz = fft(hzz);     % FFT odpowiedzi impulsowej
    
    y4 = zeros(1, M-1); % inicjalizacja
    
    for k = 1:K
        m = 1 + (k-1)*L : L + (k-1)*L;      % indeksy fragmentu
        xz = [x(m) zeros(1, M-1)];           % fragment + zera
        YY = fft(xz) .* Hzz;                 % szybki splot - iloczyn widm
        yy = ifft(YY);                       % odwrotne FFT
        y4(end-(M-2):end) = y4(end-(M-2):end) + yy(1:M-1);  % overlap-add
        y4 = [y4, yy(M:L+M-1)];              % uzupelnienie
    end
    
    error4 = max(abs(y1 - y4));
    fprintf('=== OVERLAP-ADD ===\n');
    fprintf('error4: %e\n\n', error4);
    
    figure(5);
    stem(n, y1, 'ro', 'LineWidth', 1.5); hold on;
    stem(n, real(y4), 'bx', 'LineWidth', 1.5); hold off;
    title('y1 (czerwone o) vs y4 (niebieskie x) - metoda overlap-add');
    xlabel('n'); legend('y1 (liniowy)', 'y4 (overlap-add)'); grid on;
    pause
end

%% podsumowanie
fprintf('=== PODSUMOWANIE ===\n');
fprintf('sygnal x: N = %d probek\n', N);
fprintf('filtr h:  M = %d probek\n', M);
fprintf('splot liniowy y1: %d probek (N+M-1)\n', length(y1));
fprintf('splot kolowy y2:  %d probek (N) - pierwsze %d NIEPOPRAWNE\n', length(y2), M-1);
fprintf('splot kolowy y3:  %d probek (N+M-1) - wszystkie POPRAWNE\n', length(y3));

% splot kolowy daje wynik identyczny ze splotem liniowym
% tylko gdy uzupelnimy oba sygnaly zerami do dlugosci N+M-1
% w przeciwnym razie wystepuje aliasing czasowy (zawijanie)