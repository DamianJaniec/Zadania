% cps_05_fft1.m
clear all; close all; clc;
N = 100; x = rand(1,N);
Xm = fft(x);
Xe = fft(x(1:2:N));
Xo = fft(x(2:2:N));
X = [ Xe, Xe ] + exp(-j*2*pi/N*(0:1:N-1)) .* [Xo, Xo ];
error1 = max( abs( X - Xm ) )

%sprawdziłem na mniejszych N, macierz można zrekostruować (a przynajmniej
%dla N=4)

xe = x(1:2:N);  
xo = x(2:2:N);  

M = N/2;
k = (0:M-1)';
n = 0:M-1;
DFT_matrix = exp(-j*2*pi*k*n/M);

Xe2 = (DFT_matrix * xe')';
Xo2 = (DFT_matrix * xo')';

X2 = [ Xe2, Xe2 ] + exp(-j*2*pi/N*(0:1:N-1)) .* [Xo2, Xo2 ];
error2 = max( abs( X2 - Xm ) )
%błędy wynikają z liczenia numerycznego komputera, wynik jest praktycznie 
%zerowy, dla kilku prób różnica również jest bliska zeru, można więc 
%zrekonstruwać sygnał na podstawie dwóch wektorów

%kod jednak działa tylko dla N=4
%przy innych N, błąd się znacząco zwiększał
%okazuje się że dla większych N, trzeba dzielić dodatkową ilość razy

fprintf('\n--- Test dla N=8 ---\n');
N = 8; x = rand(1,N);
Xm = fft(x);

xe = x(1:2:N);
xo = x(2:2:N);

xe_e = xe(1:2:end);
xe_o = xe(2:2:end);
xo_e = xo(1:2:end);
xo_o = xo(2:2:end);

DFT2 = exp(-j*2*pi*[0;1]*[0 1]/2);

Xe_e = (DFT2 * xe_e')';
Xe_o = (DFT2 * xe_o')';
Xe_full = [Xe_e, Xe_e] + exp(-j*2*pi*(0:3)/4) .* [Xe_o, Xe_o];

Xo_e = (DFT2 * xo_e')';
Xo_o = (DFT2 * xo_o')';
Xo_full = [Xo_e, Xo_e] + exp(-j*2*pi*(0:3)/4) .* [Xo_o, Xo_o];

X8 = [Xe_full, Xe_full] + exp(-j*2*pi*(0:7)/8) .* [Xo_full, Xo_full];

error_N8 = max(abs(X8 - Xm))