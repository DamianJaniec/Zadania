% cps05_problem_5_11.m
% DCT-II za pomoca FFT
clear all; close all; clc;

%% TEST 1: porownanie z funkcja Matlaba dct()
fprintf('=== TEST 1: porownanie z dct() Matlaba ===\n');
N = 8;
x = randn(1, N);

X_my_fft = myDCT2_FFT(x);
X_my_direct = myDCT2_direct(x);
X_matlab = dct(x);

fprintf('sygnal x:\n'); disp(x);
fprintf('myDCT2_FFT:\n'); disp(X_my_fft);
fprintf('myDCT2_direct:\n'); disp(X_my_direct);
fprintf('dct() Matlaba:\n'); disp(X_matlab);

err_fft = max(abs(X_my_fft - X_matlab));
err_direct = max(abs(X_my_direct - X_matlab));
err_fft_direct = max(abs(X_my_fft - X_my_direct));

fprintf('blad myDCT2_FFT vs dct():     %e\n', err_fft);
fprintf('blad myDCT2_direct vs dct(): %e\n', err_direct);
fprintf('blad myDCT2_FFT vs direct:   %e\n\n', err_fft_direct);

%% TEST 2: rozne wartosci N
fprintf('=== TEST 2: rozne wartosci N ===\n');
for p = 3:10
    N = 2^p;
    x = randn(1, N);
    
    X_my = myDCT2_FFT(x);
    X_matlab = dct(x);
    
    err = max(abs(X_my - X_matlab));
    fprintf('N=%4d: blad = %e\n', N, err);
end

%% TEST 3: wlasnosc energii (Parseval dla DCT)
fprintf('\n=== TEST 3: wlasnosc energii ===\n');
N = 256;
x = randn(1, N);
X_dct = myDCT2_FFT(x);

energia_czas = sum(x.^2);
energia_dct = sum(X_dct.^2);

fprintf('energia w dziedzinie czasu: %.10f\n', energia_czas);
fprintf('energia w dziedzinie DCT:   %.10f\n', energia_dct);
fprintf('roznica: %e\n', abs(energia_czas - energia_dct));

%% TEST 4: wizualizacja
fprintf('\n=== TEST 4: wizualizacja ===\n');
N = 64;
t = (0:N-1) / N;
x = sin(2*pi*3*t) + 0.5*cos(2*pi*7*t) + 0.3*sin(2*pi*15*t);

X_dct = myDCT2_FFT(x);
X_fft = fft(x);

figure('Name', 'DCT-II vs FFT', 'Position', [100 100 1200 600]);

subplot(2,2,1)
plot(t, x, 'b', 'LineWidth', 1.5);
title('sygnal x(t)');
xlabel('czas'); ylabel('amplituda'); grid on;

subplot(2,2,2)
stem(0:N-1, X_dct, 'b', 'LineWidth', 1);
title('widmo DCT-II (myDCT2\_FFT)');
xlabel('k'); ylabel('X_{DCT}(k)'); grid on;

subplot(2,2,3)
stem(0:N-1, abs(X_fft), 'r', 'LineWidth', 1);
title('widmo |FFT|');
xlabel('k'); ylabel('|X_{FFT}(k)|'); grid on;

subplot(2,2,4)
X_matlab = dct(x);
plot(0:N-1, X_dct, 'b', 'LineWidth', 1.5); hold on;
plot(0:N-1, X_matlab, 'r--', 'LineWidth', 1);
title('porownanie: myDCT2\_FFT (niebieski) vs dct() (czerwony)');
xlabel('k'); ylabel('X_{DCT}(k)'); grid on;
legend('myDCT2\_FFT', 'dct() Matlab');

% moja implementacja dct-II za pomoca fft daje identyczne wyniki jak dct() matlaba
% DCT zachowuje energie sygnalu

%% FUNKCJA DCT-II
function X_dct = myDCT2_FFT(x)
    N = length(x);
    
    x_tilde = zeros(1, N);
    for n = 0 : N/2 - 1
        x_tilde(n + 1) = x(2*n + 1);
        x_tilde(N - n) = x(2*n + 2);
    end
    
    X_fft = fft(x_tilde);
    
    % wspolczynniki c(k)
    c = sqrt(2/N) * ones(1, N);
    c(1) = sqrt(1/N);
    
    % DCT-II
    k = 0 : N-1;
    X_dct = real(c .* exp(-1j * pi * k / (2*N)) .* X_fft);
end

%% FUNKCJA DCT-II bezposrednio z definicji
function X_dct = myDCT2_direct(x)
    N = length(x);
    X_dct = zeros(1, N);
    
    c = sqrt(2/N) * ones(1, N);
    c(1) = sqrt(1/N);
    
    for k = 0 : N-1
        suma = 0;
        for n = 0 : N-1
            suma = suma + x(n+1) * cos(pi * (2*n + 1) * k / (2*N));
        end
        X_dct(k+1) = c(k+1) * suma;
    end
end