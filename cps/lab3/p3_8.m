% cps03_problem_3_8.m
clear all; close all; clc;

% macierz dct iv
N = 100;
k = (0:N-1);
n = (0:N-1);
S = sqrt(2/N)*cos(pi/N*(n'+1/2)*(k+1/2));
A = S';

% sygnal uzyteczny i szum
x1 = 10*S(:,5);        % sygnal uzyteczny
x5 = randn(N,1);       % szum losowy

% sygnal zaszumiony
x = x1 + x5;

% analiza dct
c = A*x;

% filtracja w dziedzinie dct pozostawiamy tylko skladowa x1
c_filt = zeros(size(c));
c_filt(5) = c(5);

% synteza sygnalu odszumionego
y = S*c_filt;

% obliczenie snr dla sygnalu zaszumionego
snr_x = 10*log10( sum(x1.^2) / sum((x - x1).^2) );

% obliczenie snr dla sygnalu odszumionego
snr_y = 10*log10( sum(x1.^2) / sum((y - x1).^2) );

% wyswietlenie wynikow
disp('snr dla sygnalu zaszumionego x = x1 + x5')
disp(snr_x)

disp('snr dla sygnalu odszumionego y')
disp(snr_y)

% wykresy
figure;
subplot(3,1,1)
plot(x,'bo-'); grid on
title('sygnal zaszumiony x')

subplot(3,1,2)
plot(y,'bo-'); grid on
title('sygnal odszumiony y')

subplot(3,1,3)
plot(x1,'ro-'); grid on
title('oryginalny sygnal x1')

% wnioski
%   snr dla sygnalu zaszumionego x = x1 + x5
%   jest niski poniewaz szum ma istotny wplyw
%   na calkowita energie sygnalu
%
%   po wykonaniu filtracji w dziedzinie dct iv
%   oraz pozostawieniu tylko wspolczynnika
%   odpowiadajacego skladowej x1
%   wartosc snr ulega wyraznej poprawie
%
%   wynika to z faktu ze energia sygnalu x1
%   jest skupiona w jednym wspolczynniku
%   natomiast szum x5 jest rozlozony
%   na wiele wspolczynnikow transformaty