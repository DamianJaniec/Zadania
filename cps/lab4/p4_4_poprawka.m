% Problem 4.4 - Filtracja sygnałów za pomocą współczynników DFT
clear all; close all

% Parametry
N = 100;
k = (0:N-1); 
n = (0:N-1);

%% Macierze DFT
A = sqrt(1/N) * exp(-1j * 2*pi/N * (k.' * n));  % analiza DFT
S = A';                                          % synteza IDFT

%% Generowanie sygnałów bazowych
x1_complex = 10*S(:,5);   % sygnał zespolony, częstotliwość k=4
x2_complex = 10*S(:,10);  % sygnał zespolony, częstotliwość k=9

%% Suma sygnałów
x = real(x1_complex) + imag(x2_complex);


%% Wizualizacja sygnału wejściowego
figure('Name', 'Sygnał wejściowy x(n)');
subplot(3,1,1);
plot(real(x), 'bo-', 'LineWidth', 1.5);
title('Część rzeczywista: real(x)');
xlabel('n'); ylabel('Amplituda');
grid on;

subplot(3,1,2);
plot(imag(x), 'ro-', 'LineWidth', 1.5);
title('Część urojona: imag(x)');
xlabel('n'); ylabel('Amplituda');
grid on;

subplot(3,1,3);
plot(abs(x), 'mo-', 'LineWidth', 1.5);
title('Moduł |x(n)|');
xlabel('n'); ylabel('Amplituda');
grid on;

%% Analiza DFT - wyznaczenie współczynników
c = A*x;

fprintf('=== WIDMO DFT ===\n');
fprintf('Maksymalny moduł: %.4f\n', max(abs(c)));
[pks, locs] = findpeaks(abs(c), 'MinPeakHeight', 3);
fprintf('Piki w widmie na pozycjach k: ');
fprintf('%d ', locs-1);
fprintf('\n\n');

%% Wizualizacja widma
figure('Name', 'Widmo DFT');
subplot(2,1,1);
stem(0:N-1, abs(c), 'b', 'LineWidth', 1.5);
title('Moduł współczynników DFT');
xlabel('k (numer współczynnika)');
ylabel('|C(k)|');
grid on;
xlim([0 N-1]);

subplot(2,1,2);
stem(0:N-1, angle(c), 'r', 'LineWidth', 1.5);
title('Faza współczynników DFT');
xlabel('k (numer współczynnika)');
ylabel('Faza [rad]');
grid on;
xlim([0 N-1]);

%% Filtracja – usuwamy składowe x1 (k = 4 i 96)
c_filt = c;    % kopia widma
c_filt(5)  = 0;   % k = 4
c_filt(97) = 0;   % k = 96

%%Wizualizacja
figure('Name', 'Widmo DFT');
subplot(2,1,1);
stem(0:N-1, abs(c_filt), 'b', 'LineWidth', 1.5);
title('Moduł współczynników DFT');
xlabel('k (numer współczynnika)');
ylabel('|C(k)|');
grid on;
xlim([0 N-1]);

subplot(2,1,2);
stem(0:N-1, angle(c_filt), 'r', 'LineWidth', 1.5);
title('Faza współczynników DFT');
xlabel('k (numer współczynnika)');
ylabel('Faza [rad]');
grid on;
xlim([0 N-1]);

%% Synteza IDFT
x_rec = S * c_filt;

%% Porównanie sygnałów przed i po wycięciu 
figure('Name','Porównanie sygnałów Przed Wycięciem i Po');
plot(real(x), 'b', 'LineWidth', 1.5); hold on;
plot(real(x_rec), 'r--', 'LineWidth', 1.5);
legend('x(n) – oryginał', 'x(n) po usunięciu x1');
xlabel('n'); ylabel('Amplituda');
title('Usunięcie składowej x1 w dziedzinie DFT');
grid on;

%% Porównanie wyciętego z x2
figure('Name','Porównanie otrzymanego sygnału z x2');
plot(imag(x2_complex), 'b', 'LineWidth', 1.5); hold on;
plot(real(x_rec), 'r--');
legend('imag(x2)', 'sygnał po filtracji');
title('Porównanie z idealnym x2');
grid on;