clc; clear all; close all;

%% Parametry zadania
p = 8;
N = 2^p;

%% szum gaussowski
x = randn(N, 1);

%% FFT (dir=-1)
X = myRecIFFT(x.', -1).';

%% IFFT (dir=+1) - automatycznie już dzieli przez n
xr = myRecIFFT(X.', +1).';

%% błąd rekonstrukcji
err = max(abs(x - xr));
fprintf('Maksymalny błąd rekonstrukcji: %e\n', err);

%% Porównanie FFT z fft()
X_matlab = fft(x);
err_fft = max(abs(X - X_matlab));
fprintf('Różnica FFT z fft(): %e\n', err_fft);

%% Porównanie IFFT z ifft()
xr_matlab = ifft(X);
err_ifft = max(abs(xr - xr_matlab));
fprintf('Różnica IFFT z ifft(): %e\n', err_ifft);