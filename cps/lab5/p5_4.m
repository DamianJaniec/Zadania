clear all; close all; clc;

% Parametry zadania
p = 8; 
N = 2^p; 

% 1. Szum gaussowski
x = randn(N, 1); 

% Obliczenie widma dwiema metodami
X1 = fft(x);           % Funkcja wbudowana
X2 = myRecFFT(x.');    % Nasza funkcja (transpozycja, by wymiary się zgadzały)

% Porównanie wyników
err = max(abs(X1 - X2.')); 
fprintf('Dla p=%d (N=%d), błąd wynosi: %e\n', p, N, err);

% 2. Zmiana sygnału na inny (np. sinusoida)
n = 0:N-1;
x_sin = sin(2*pi*0.1*n);
X1_sin = fft(x_sin);
X2_sin = myRecFFT(x_sin);
err_sin = max(abs(X1_sin - X2_sin));
fprintf('Dla sinusoidy błąd wynosi: %e\n', err_sin);

function X = myRecFFT(x)
    % Rekurencyjna funkcja algorytmu radix-2 DIT FFT
    N = length(x);
    
    if (N == 2)
        % Najniższy poziom: 2-punktowe DFT (wyprowadzone powyżej)
        X(1) = x(1) + x(2);
        X(2) = x(1) - x(2);
    else
        % Dzielenie na próbki parzyste i nieparzyste (Decimation in Time)
        X1 = myRecFFT(x(1:2:N)); % Rekurencja dla próbek parzystych
        X2 = myRecFFT(x(2:2:N)); % Rekurencja dla próbek nieparzystych
        
        % Składanie widm (Butterfly) przy użyciu twiddle factors
        % [X1 X1] wykorzystuje okresowość widma N/2
        W = exp(-j * 2 * pi / N * (0:N-1));
        X = [X1, X1] + W .* [X2, X2];
    end
end