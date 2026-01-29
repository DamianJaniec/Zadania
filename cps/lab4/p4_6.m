% cps04_problem_4_6.m
clear all; close all; clc;

% macierze dft
N = 100;
k = (0:N-1);
n = (0:N-1);
A = exp(-j*2*pi/N*k'*n);    % macierz analizy dft
S = A';                    % macierz syntezy dft

% os czasu i czestotliwosci
fs = 1000;
dt = 1/fs;
t = dt*(0:N-1).';
T = N*dt;
f0 = 1/T;
fk = f0*(0:N-1);

% sygnaly
x1 = cos(2*pi*(10*f0)*t);
x2 = cos(2*pi*(10.5*f0)*t);
x3 = 0.001*cos(2*pi*(20*f0)*t);

% okna
w1 = boxcar(N);          % okno prostokatne
w2 = chebwin(N,100);     % okno czebyszewa

%% CZESC 1 okno prostokatne w1

w = w1;
scale = 1/sum(w);

Xs = {x1, x2, x3, x1+x3, x2+x3};
Xs_title = {'x1','x2','x3','x1+x3','x2+x3'};

figure;
for i = 1:length(Xs)

    x = Xs{i};
    xw = x .* w;

    % dft
    X1 = A*xw;
    X2 = fft(xw);

    error1 = max(abs(X1 - X2));

    X = scale*X2;

    subplot(length(Xs),2,2*i-1)
    plot(fk,20*log10(abs(X)),'o-'); grid on
    title(['abs(X) [dB] ', Xs_title{i}])

    subplot(length(Xs),2,2*i)
    plot(fk,angle(X),'o-'); grid on
    title(['angle(X) ', Xs_title{i}])

end

%% CZESC 2 okno czebyszewa w2

w = w2;
scale = 1/sum(w);

figure;
for i = 1:length(Xs)

    x = Xs{i};
    xw = x .* w;

    X = scale*fft(xw);

    subplot(length(Xs),2,2*i-1)
    plot(fk,20*log10(abs(X)),'o-'); grid on
    title(['abs(X) [dB] ', Xs_title{i},' w2'])

    subplot(length(Xs),2,2*i)
    plot(fk,angle(X),'o-'); grid on
    title(['angle(X) ', Xs_title{i},' w2'])

end

%% CZESC 3 rekonstrukcja i filtracja widma

x = x1 + x3;
w = w1;
scale = 1/sum(w);

xw = x .* w;
X = scale*fft(xw);

% rekonstrukcja bez zmian widma
y = S*X;
error2 = max(abs(xw - y))

figure;
subplot(2,1,1)
plot(xw,'bo-'); grid on
title('sygnal x = x1 + x3 po oknie w1')

subplot(2,1,2)
plot(real(y),'ro-'); grid on
title('zrekonstruowany sygnal y')

% usuniecie skladowej x1
X(1+10) = 0;
X(N-10+1) = 0;

y_filt = S*X;

figure;
subplot(2,1,1)
plot(real(y_filt),'bo-'); grid on
title('sygnal y po usunieciu skladowej x1')

subplot(2,1,2)
plot(x3,'ro-'); grid on
title('oryginalny sygnal x3 do porownania')

%   porownanie widm obliczonych przez A*x
%   oraz fft potwierdza ze funkcja fft
%   realizuje dyskretna transformacje fouriera
%
%   dla okna prostokatnego w1 widmo x1
%   jest skupione w jednym prazku
%   natomiast dla x2 pojawia sie przeciek widma
%   z powodu niedopasowania czestotliwosci
%
%   sygnal x3 przy w1 jest niewidoczny
%   poniewaz zostaje zamaskowany
%   przez listki boczne silnych skladowych
%
%   zastosowanie okna czebyszewa w2
%   zmniejsza listki boczne
%   dzieki czemu skladowa x3 staje sie widoczna
%
%   po usunieciu prazkow odpowiadajacych x1
%   zrekonstruowany sygnal y zawiera tylko x3
