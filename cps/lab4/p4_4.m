% cps03_trans.m
clear all; close all

% Orthogonal matrix for DCT-IV orthogonal transform
N = 100;                                    % wymiar macierzy kwadratowej, 25, 100
k =(0:N-1); n=(0:N-1);                      % k-kolumny/funkcje, n-wiersze/probki
A = sqrt(1/N) * exp(-1j * 2*pi/N * (k.' * n));   % analiza DFT
S = A';                                     % macierz analizy: transpozycja i sprzezenie S

x1_complex = 10*S(:,5);
x2_complex = 10*S(:,10);

x = real(x1_complex) + 1i*imag(x2_complex);

figure('Name', 'Sygnał wejściowy x(n)');
subplot(3,1,1);
plot(real(x), 'bo-', 'LineWidth', 1.5); 
title('Część rzeczywista: real(x1)'); 
xlabel('n'); ylabel('Amplituda');
grid on;

subplot(3,1,2);
plot(imag(x), 'ro-', 'LineWidth', 1.5); 
title('Część urojona: imag(x2)'); 
xlabel('n'); ylabel('Amplituda');
grid on;

subplot(3,1,3);
plot(abs(x), 'mo-', 'LineWidth', 1.5); 
title('Moduł |x(n)|'); 
xlabel('n'); ylabel('Amplituda');
grid on;

% analiza dft - wyznaczenie współczynników
c = A*x;

% Wizualizacja widma
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

%wyzerowanie skladowej zwiazanej z x1
c1 = c;  % kopia współczynników
nr = 5 - 1;
c1(nr) = 0;      % wyzeruj 5-ty współczynnik (x1 to 4-ta kolumna)
c1(N-nr+2) = 0;  % wyzeruj symetryczny (dla N=100: 96)

fprintf('Wyzerowano współczynniki: k=4 i k=96');

y1 = S*c1;

figure('Name', 'OPCJA 1: Usunięcie x1 (real)', 'Position', [100 100 1400 600]);

subplot(2,3,1);
plot(real(x), 'b-', 'LineWidth', 2); hold on;
plot(real(y1), 'r--', 'LineWidth', 2);
title('Część rzeczywista'); 
xlabel('n'); ylabel('Amplituda');
legend('Oryginał real(x)', 'Po usunięciu real(y1)', 'Location', 'best');
grid on;

subplot(2,3,2);
plot(imag(x), 'b-', 'LineWidth', 2); hold on;
plot(imag(y1), 'r--', 'LineWidth', 2);
title('Część urojona'); 
xlabel('n'); ylabel('Amplituda');
legend('Oryginał imag(x)', 'Po usunięciu imag(y1)', 'Location', 'best');
grid on;

subplot(2,3,3);
plot(real(x) - real(y1), 'g-', 'LineWidth', 2);
title('Różnica real(x) - real(y1)'); 
xlabel('n'); ylabel('Amplituda');
grid on;

subplot(2,3,4);
plot(real(x1_complex), 'b-', 'LineWidth', 2); hold on;
plot(real(x) - real(y1), 'r--', 'LineWidth', 2);
title('Porównanie: Usunięta składowa vs real(x1)'); 
xlabel('n'); ylabel('Amplituda');
legend('real(x1) - oryginalny', 'Usunięta składowa', 'Location', 'best');
grid on;

subplot(2,3,5);
error1_real = max(abs(real(x) - real(y1) - real(x1_complex)));
error1_imag = max(abs(imag(x) - imag(y1)));
text(0.1, 0.6, sprintf('Błąd real: %.2e', error1_real), 'FontSize', 12);
text(0.1, 0.4, sprintf('Błąd imag: %.2e', error1_imag), 'FontSize', 12);
text(0.1, 0.2, 'Wniosek: Usunięto składową', 'FontSize', 11, 'Color', 'red');
text(0.1, 0.1, 'związaną z real(x1)', 'FontSize', 11, 'Color', 'red');
axis off;

subplot(2,3,6);
stem(0:N-1, abs(c1), 'r', 'LineWidth', 1.5);
title('Widmo po wyzerowaniu'); 
xlabel('k'); ylabel('|C(k)|');
grid on;
xlim([0 N-1]);

fprintf('Błąd odtworzenia real: %.2e\n', error1_real);
fprintf('Błąd odtworzenia imag: %.2e\n\n', error1_imag);