% cps03_problem_3_7.m
clear all; close all; clc;

% macierz DCT-IV
N = 100;                                  % liczba probek
k = (0:N-1); 
n = (0:N-1);
S = sqrt(2/N)*cos(pi/N*(n'+1/2)*(k+1/2)); % macierz syntezy
A = S';                                  % macierz analizy

% definicja skladowych
x1 = 10*S(:,5);                                              % skladowa idealnie zgodna z baza
x2 = 20*S(:,10);                                             % druga skladowa zgodna z baza
x3 = 30*sqrt(2/N)*cos(pi/N*(n'+1/2)*(10.5+1/2));             % skladowa niezgodna z baza
x4 = 30*sqrt(2/N)*cos(pi/N*(n'+N/4+1/2)*(10+1/2));           % skladowa przesunieta w czasie
x5 = randn(N,1);                                             % szum losowy

%% przypadek 1 separacja skladowej x1 z sygnalu x1 + x2
x = x1 + x2;

figure;
subplot(3,1,1)
plot(x,'bo-'); grid on
title('sygnal wejsciowy x = x1 + x2')

c = A*x;

subplot(3,1,2)
stem(c); grid on
title('wspolczynniki DCT sygnalu x')

% opcja 1 usuniecie skladowej x1
c1 = c;
c1(5) = 0;

y1 = S*c1;

subplot(3,1,3)
plot(y1,'bo-'); grid on
title('sygnal po usunieciu skladowej x1')

%% opcja 2 pozostawienie tylko skladowej x1
c2 = zeros(size(c));
c2(5) = c(5);

y2 = S*c2;

figure;
subplot(2,1,1)
plot(y2,'bo-'); grid on
title('sygnal zawierajacy tylko skladowa x1')

subplot(2,1,2)
plot(x1,'ro-'); grid on
title('oryginalna skladowa x1 do porownania')

%% przypadek 2 odszumianie sygnalu x1 + x4
x = x1 + x4;

figure;
subplot(3,1,1)
plot(x,'bo-'); grid on
title('sygnal wejsciowy x = x1 + x4')

c = A*x;

subplot(3,1,2)
stem(c); grid on
title('wspolczynniki DCT sygnalu x')

% pozostawienie tylko wspolczynnika odpowiadajacego x1
c_denoise = zeros(size(c));
c_denoise(5) = c(5);

y_denoise = S*c_denoise;

subplot(3,1,3)
plot(y_denoise,'bo-'); grid on
title('sygnal odszumiony y')

%% bledy rekonstrukcji
err_x1x2 = max(abs((x1+x2) - (S*c)));
err_denoise = max(abs(x1 - y_denoise));

disp('blad rekonstrukcji x1+x2')
disp(err_x1x2)

disp('blad odszumiania x1')
disp(err_denoise)


%% wnioski
%   wyzerowanie jednego wspolczynnika c(5) powoduje usuniecie skladowej x1
%   z sygnalu sumarycznego poniewaz energia x1 jest skoncentrowana w jednym
%   wspolczynniku transformaty dct iv
%
%   pozostawienie tylko wspolczynnika c(5) prowadzi do odtworzenia
%   wyłącznie skladowej x1 co potwierdza poprawna separacje sygnalu
%
%   w przypadku sygnalu x1 + x4 pozostawienie tylko wspolczynnika c(5)
%   prowadzi do odszumienia sygnalu poniewaz skladowa x4 ma rozmyte widmo
%   i jej energia jest rozlozona na wiele wspolczynnikow
%
%   separacja skladowych x1 oraz x2 jest prosta i efektywna poniewaz
%   ich obrazy w dziedzinie dct sa skoncentrowane w pojedynczych
%   wspolczynnikach
%
%   separacja skladowych x3 oraz x4 jest trudna poniewaz ich widma
%   sa rozmyte co wynika z niedopasowania czestotliwosci lub fazy
%   do bazy dct iv
%   komentarz do bledow
%   niezerowy blad rekonstrukcji dla sygnalu x1+x2 wynika z faktu
%   ze wspolczynniki transformaty byly wczesniej modyfikowane
%   w celu separacji skladowych a nie do idealnej rekonstrukcji
%   przez co sygnal wynikowy rozni sie od oryginalu
%
%   blad odszumiania sygnalu x1 jest niewielki ale nie zerowy
%   poniewaz skladowa x4 posiada rozmyte widmo i czesc jej energii
%   naklada sie na wspolczynnik odpowiadajacy skladowej x1
%   dlatego nie da sie jej calkowicie usunąc
%
%   potwierdza to ze dct iv umozliwia skuteczna separacje skladowych
%   ktorych energia jest skupiona w bardzo malej liczbie
%   wspolczynnikow natomiast dla skladowych takich jak x3 oraz x4
%   proces separacji jest trudniejszy i mniej dokladny
%
%   im bardziej sygnal pasuje do bazy dct tym latwiej go
%   wydzielic lub usunąc z sygnalu sumarycznego
