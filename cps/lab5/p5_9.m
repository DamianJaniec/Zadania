clear all; close all; clc;

%% TEST 1: porownanie myRecIFFT z fft/ifft Matlaba
fprintf('=== TEST 1: porownanie z fft/ifft Matlaba ===\n');
N = 8;
x = 0:N-1;

X_my = myRecIFFT(x, -1);      % FFT (dir = -1)
x_back_my = myRecIFFT(X_my, +1);  % IFFT (dir = +1)

X_matlab = fft(x);
x_back_matlab = ifft(X_matlab);

fprintf('sygnal oryginalny x:     '); disp(x);
fprintf('myRecIFFT(x, -1) [FFT]:  '); disp(X_my);
fprintf('fft(x) Matlaba:          '); disp(X_matlab);
fprintf('\n');
fprintf('myRecIFFT(X, +1) [IFFT]: '); disp(real(x_back_my));
fprintf('ifft(X) Matlaba:         '); disp(real(x_back_matlab));

err_fft = max(abs(X_my - X_matlab));
err_ifft = max(abs(x_back_my - x_back_matlab));
fprintf('\nblad FFT:  %e\n', err_fft);
fprintf('blad IFFT: %e\n\n', err_ifft);

%% TEST 2: FFT -> IFFT powinno dac oryginalny sygnal
fprintf('=== TEST 2: FFT -> IFFT = oryginal ===\n');
N = 64;
x = randn(1, N);

X = myRecIFFT(x, -1);       
x_back = myRecIFFT(X, +1);  

err2 = max(abs(x - x_back));
fprintf('blad |x - IFFT(FFT(x))|: %e\n', err2);
fprintf('(powinien byc rzedu 1e-14 dla amplitudy 1)\n\n');

%% TEST 3: rozne wartosci N
fprintf('=== TEST 3: rozne wartosci N ===\n');
for p = 2:10
    N = 2^p;
    x = randn(1, N) + 1j*randn(1, N);  
    
    X_my = myRecIFFT(x, -1);
    x_back_my = myRecIFFT(X_my, +1);
    
    X_matlab = fft(x);
    
    err_fft = max(abs(X_my - X_matlab));
    err_roundtrip = max(abs(x_back_my - x));
    
    fprintf('N=%4d: err_FFT=%e, err_FFT->IFFT=%e\n', N, err_fft, err_roundtrip);
end

%% TEST 4: wizualizacja
fprintf('\n=== TEST 4: wizualizacja ===\n');
N = 128;
t = (0:N-1) / N;
f1 = 5; f2 = 13;
x = sin(2*pi*f1*t) + 0.5*cos(2*pi*f2*t);

X = myRecIFFT(x, -1);       
x_back = myRecIFFT(X, +1);  

figure('Name', 'FFT i IFFT', 'Position', [100 100 1200 600]);

subplot(2,2,1)
plot(t, x, 'b', 'LineWidth', 1.5);
title('sygnal oryginalny x(t)');
xlabel('czas'); ylabel('amplituda'); grid on;

subplot(2,2,2)
f = (0:N-1);
plot(f, abs(X), 'b', 'LineWidth', 1.5);
title('widmo |X(f)| = |FFT(x)|');
xlabel('czestotliwosc'); ylabel('|X|'); grid on;
xlim([0 N/2]);

subplot(2,2,3)
plot(t, real(x_back), 'r', 'LineWidth', 1.5);
title('sygnal po IFFT(FFT(x))');
xlabel('czas'); ylabel('amplituda'); grid on;

subplot(2,2,4)
plot(t, abs(x - x_back), 'k', 'LineWidth', 1.5);
title('blad |x - IFFT(FFT(x))|');
xlabel('czas'); ylabel('blad'); grid on;

err_max = max(abs(x - x_back));
fprintf('maksymalny blad: %e\n', err_max);

%% TEST 5: wlasnosc Parsevala
fprintf('\n=== TEST 5: wlasnosc Parsevala ===\n');
N = 256;
x = randn(1, N);
X = myRecIFFT(x, -1);

energia_czas = sum(abs(x).^2);
energia_czest = sum(abs(X).^2) / N;

fprintf('energia w dziedzinie czasu:          %.10f\n', energia_czas);
fprintf('energia w dziedzinie czestotliwosci: %.10f\n', energia_czest);
fprintf('roznica: %e\n', abs(energia_czas - energia_czest));

%% WNIOSKI
% funkcja myRecIFFT(x, dir) jest uniwersalna:
%    dir = -1 -> FFT  (exp(-j...))
%    dir = +1 -> IFFT (exp(+j...) i dzielenie przez N)
% po wykonaniu FFT -> IFFT otrzymujemy oryginalny sygnal
% blad jest rzedu 1e-14 (precyzja maszynowa double)
% jedyna roznica miedzy FFT a IFFT to znak i normalizacja