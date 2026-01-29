clear all; close all; clc;
%% CZESC 1: dwa sygnaly -> jedno FFT
fprintf('=== CZESC 1: dwa sygnaly rzeczywiste -> jedno FFT ===\n\n');

N = 16;
x1 = randn(1, N);
x2 = randn(1, N);

X1 = fft(x1);
X2 = fft(x2);

x12 = x1 + 1j*x2;
X12 = fft(x12);

X12r = real(X12);
X12i = imag(X12);

% rekonstrukcja
X1r = zeros(1, N);
X1i = zeros(1, N);
X1r(2:N) = (X12r(2:N) + X12r(N:-1:2)) / 2;
X1i(2:N) = (X12i(2:N) - X12i(N:-1:2)) / 2;
X1r(1) = X12r(1);
X1i(1) = 0;
X1rec = X1r + 1j*X1i;

error_X1 = max(abs(X1 - X1rec));
fprintf('blad rekonstrukcji X1: %e\n', error_X1);

% X2(k) = (Im{X(k)+X(N-k)})/2 - j*(Re{X(k)-X(N-k)})/2
X2r = zeros(1, N);
X2i = zeros(1, N);
X2r(2:N) = (X12i(2:N) + X12i(N:-1:2)) / 2;
X2i(2:N) = -(X12r(2:N) - X12r(N:-1:2)) / 2;
X2r(1) = X12i(1);
X2i(1) = 0;
X2rec = X2r + 1j*X2i;

error_X2 = max(abs(X2 - X2rec));
fprintf('blad rekonstrukcji X2: %e\n\n', error_X2);

%% CZESC 2: sygnal 2N-punktowy -> widmo z N-punktowego FFT (dodatkowy punkt)
fprintf('=== CZESC 2: sygnal 2N-punktowy z N-punktowego FFT ===\n\n');

N = 16;
x3 = randn(1, 2*N);  % sygnal 2N-punktowy

% podzial
x1 = x3(1:2:2*N);  
x2 = x3(2:2:2*N);  

X3_ref = fft(x3);

x12 = x1 + 1j*x2;
X12 = fft(x12);

X12r = real(X12);
X12i = imag(X12);

% parzyste
X1r = zeros(1, N);
X1i = zeros(1, N);
X1r(2:N) = (X12r(2:N) + X12r(N:-1:2)) / 2;
X1i(2:N) = (X12i(2:N) - X12i(N:-1:2)) / 2;
X1r(1) = X12r(1);
X1i(1) = 0;
X1rec = X1r + 1j*X1i;

% nieparzyste
X2r = zeros(1, N);
X2i = zeros(1, N);
X2r(2:N) = (X12i(2:N) + X12i(N:-1:2)) / 2;
X2i(2:N) = -(X12r(2:N) - X12r(N:-1:2)) / 2;
X2r(1) = X12i(1);
X2i(1) = 0;
X2rec = X2r + 1j*X2i;

% rekonstrukcja widma X3 z widm X1 i X2
% X3(k) = X1(k) + W^k * X2(k)  dla k = 0,1,...,N-1
% X3(k+N) = X1(k) - W^k * X2(k)  dla k = 0,1,...,N-1
% gdzie W = exp(-j*2*pi/(2N))

W = exp(-1j * 2 * pi / (2*N) * (0:N-1));

X3rec = zeros(1, 2*N);
X3rec(1:N) = X1rec + W .* X2rec;      % pierwsza polowa widma
X3rec(N+1:2*N) = X1rec - W .* X2rec;  % druga polowa widma

error_X3 = max(abs(X3_ref - X3rec));
fprintf('blad rekonstrukcji X3 (2N-punktowe widmo): %e\n\n', error_X3);

%% TEST dla roznych N
fprintf('=== TEST dla roznych N ===\n');
for p = 3:10
    N = 2^p;
    x3 = randn(1, 2*N);
    
    x1 = x3(1:2:2*N);
    x2 = x3(2:2:2*N);
    
    X3_ref = fft(x3);
    
    x12 = x1 + 1j*x2;
    X12 = fft(x12);
    
    X12r = real(X12);
    X12i = imag(X12);
    
    X1r = zeros(1, N); X1i = zeros(1, N);
    X1r(2:N) = (X12r(2:N) + X12r(N:-1:2)) / 2;
    X1i(2:N) = (X12i(2:N) - X12i(N:-1:2)) / 2;
    X1r(1) = X12r(1); X1i(1) = 0;
    X1rec = X1r + 1j*X1i;
    
    X2r = zeros(1, N); X2i = zeros(1, N);
    X2r(2:N) = (X12i(2:N) + X12i(N:-1:2)) / 2;
    X2i(2:N) = -(X12r(2:N) - X12r(N:-1:2)) / 2;
    X2r(1) = X12i(1); X2i(1) = 0;
    X2rec = X2r + 1j*X2i;
    
    W = exp(-1j * 2 * pi / (2*N) * (0:N-1));
    X3rec = zeros(1, 2*N);
    X3rec(1:N) = X1rec + W .* X2rec;
    X3rec(N+1:2*N) = X1rec - W .* X2rec;
    
    err = max(abs(X3_ref - X3rec));
    fprintf('2N=%4d: blad = %e\n', 2*N, err);
end

%% WIZUALIZACJA
fprintf('\n=== WIZUALIZACJA ===\n');
N = 64;
t = (0:2*N-1) / (2*N);
x3 = sin(2*pi*5*t) + 0.5*cos(2*pi*13*t);

x1 = x3(1:2:2*N);
x2 = x3(2:2:2*N);

X3_ref = fft(x3);

x12 = x1 + 1j*x2;
X12 = fft(x12);
X12r = real(X12); X12i = imag(X12);

X1r = zeros(1,N); X1i = zeros(1,N);
X1r(2:N) = (X12r(2:N) + X12r(N:-1:2))/2;
X1i(2:N) = (X12i(2:N) - X12i(N:-1:2))/2;
X1r(1) = X12r(1); X1i(1) = 0;
X1rec = X1r + 1j*X1i;

X2r = zeros(1,N); X2i = zeros(1,N);
X2r(2:N) = (X12i(2:N) + X12i(N:-1:2))/2;
X2i(2:N) = -(X12r(2:N) - X12r(N:-1:2))/2;
X2r(1) = X12i(1); X2i(1) = 0;
X2rec = X2r + 1j*X2i;

W = exp(-1j*2*pi/(2*N)*(0:N-1));
X3rec = zeros(1,2*N);
X3rec(1:N) = X1rec + W.*X2rec;
X3rec(N+1:2*N) = X1rec - W.*X2rec;

figure('Name', 'Zadanie 5.10', 'Position', [100 100 1200 800]);

subplot(2,2,1)
plot(t, x3, 'b', 'LineWidth', 1.5);
title('sygnal x3 (2N probek)');
xlabel('czas'); ylabel('amplituda'); grid on;

subplot(2,2,2)
f = 0:2*N-1;
plot(f, abs(X3_ref), 'b', 'LineWidth', 1.5); hold on;
plot(f, abs(X3rec), 'r--', 'LineWidth', 1);
title('|X3| - referencja (niebieski) vs rekonstrukcja (czerwony)');
xlabel('k'); ylabel('|X|'); grid on;
legend('fft(x3)', 'rekonstrukcja');
xlim([0 2*N-1]);

subplot(2,2,3)
plot(f, abs(X3_ref - X3rec), 'k', 'LineWidth', 1.5);
title('blad |X3_{ref} - X3_{rec}|');
xlabel('k'); ylabel('blad'); grid on;

subplot(2,2,4)
bar([1 2], [2*N, N]);
set(gca, 'XTickLabel', {'normalne FFT', 'zoptymalizowane'});
ylabel('rozmiar FFT');
title('oszczednosc: 2N -> N punktowe FFT');
grid on;

%% WNIOSKI
% dla dwoch sygnalow rzeczywistych mozna obliczyc widma
% za pomoca jednego FFT sygnalu zespolonego x = x1 + j*x2
% wykorzystujemy symetrie hermitowska widma sygnalow rzeczywistych
% dla sygnalu 2N-punktowego mozemy uzyc N-punktowego FFT
% dzieki podzialowi na probki parzyste i nieparzyste
% rekonstrukcja widma 2N z widm N-punktowych uzywa wzoru motylka
% oszczednosc obliczeniowa: 2x mniej operacji FFT